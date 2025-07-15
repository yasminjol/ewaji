import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/service_detail.dart';
import '../../../booking/bloc/booking_bloc.dart';
import '../../../booking/bloc/booking_event.dart';
import '../../../booking/bloc/booking_state.dart';
import '../../../booking/models/booking.dart';
import '../../../booking/repository/booking_repository.dart';
import '../../../booking/services/payment_service.dart';

class BookingSheetWidget extends StatefulWidget {
  const BookingSheetWidget({
    super.key,
    required this.serviceDetail,
    required this.selectedTimeSlot,
    required this.onBookingConfirmed,
  });

  final ServiceDetail serviceDetail;
  final TimeSlot selectedTimeSlot;
  final Function(String providerId, TimeSlot slot, Map<String, dynamic> bookingData) onBookingConfirmed;

  @override
  State<BookingSheetWidget> createState() => _BookingSheetWidgetState();
}

class _BookingSheetWidgetState extends State<BookingSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  final _depositPercentage = 0.25; // 25% deposit
  
  bool _useSplitPay = false;
  bool _isApplePaySupported = false;
  bool _isGooglePaySupported = false;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;
  
  @override
  void initState() {
    super.initState();
    _checkPaymentMethods();
    // Initialize split pay eligibility check after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BookingBloc>().add(CheckSplitPayEligibility('customer_demo'));
      }
    });
  }
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _checkPaymentMethods() async {
    final paymentService = PaymentService.instance;
    final isApplePaySupported = await paymentService.isApplePaySupported();
    final isGooglePaySupported = await paymentService.isGooglePaySupported();
    
    if (mounted) {
      setState(() {
        _isApplePaySupported = isApplePaySupported;
        _isGooglePaySupported = isGooglePaySupported;
      });
    }
  }

  double _getBasePrice() {
    return widget.selectedTimeSlot.price ?? widget.serviceDetail.price;
  }

  double _getDiscount() {
    final discount = widget.selectedTimeSlot.discountPercent ?? 0;
    return _getBasePrice() * (discount / 100);
  }

  double _getFinalPrice() {
    return _getBasePrice() - _getDiscount();
  }

  double _getDepositAmount() {
    return _getFinalPrice() * _depositPercentage;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocProvider(
      create: (context) => BookingBloc(
        bookingRepository: BookingRepositoryImpl(),
      ),
      child: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state.status == BookingStateStatus.success) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking confirmed successfully! 🎉'),
                backgroundColor: Colors.green,
              ),
            );
            widget.onBookingConfirmed(
              widget.serviceDetail.providerId,
              widget.selectedTimeSlot,
              {
                'bookingId': state.booking?.id ?? '',
                'notes': _notesController.text.trim(),
                'paymentMethod': _selectedPaymentMethod.toString(),
                'splitPayment': _useSplitPay,
              },
            );
          } else if (state.status == BookingStateStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking failed: ${state.errorMessage ?? 'Unknown error'}'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () => _handleBooking(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book Service',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.serviceDetail.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Service Summary
                          _buildServiceSummary(),
                          const SizedBox(height: 24),
                          
                          // Selected Time
                          _buildSelectedTime(),
                          const SizedBox(height: 24),
                          
                          // Pricing
                          _buildPricing(),
                          const SizedBox(height: 24),
                          
                          // Split Payment Option
                          if (state.isSplitPayEligible)
                            _buildSplitPayOption(),
                          const SizedBox(height: 24),
                          
                          // Payment Methods
                          _buildPaymentMethods(),
                          const SizedBox(height: 24),
                          
                          // Additional Notes
                          _buildNotesSection(),
                          const SizedBox(height: 24),
                          
                          // Terms and conditions
                          _buildTermsSection(),
                          const SizedBox(height: 100), // Space for fixed bottom section
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Fixed bottom section with booking button
                _buildBottomSection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceSummary() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.serviceDetail.mediaItems.isNotEmpty
                      ? Image.network(
                          widget.serviceDetail.mediaItems.first.url,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        )
                      : Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.serviceDetail.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.serviceDetail.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDuration(widget.serviceDetail.duration),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTime() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(widget.selectedTimeSlot.startTime),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_formatTime(widget.selectedTimeSlot.startTime)} - ${_formatTime(widget.selectedTimeSlot.endTime)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Change'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricing() {
    final basePrice = widget.selectedTimeSlot.price ?? widget.serviceDetail.price;
    final discount = widget.selectedTimeSlot.discountPercent ?? 0;
    final discountAmount = basePrice * (discount / 100);
    final finalPrice = basePrice - discountAmount;
    
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Service Fee'),
                Text('\$${basePrice.toStringAsFixed(2)}'),
              ],
            ),
            if (discount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discount (${discount.toStringAsFixed(0)}%)',
                    style: TextStyle(color: Colors.green[600]),
                  ),
                  Text(
                    '-\$${discountAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green[600]),
                  ),
                ],
              ),
            ],
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${finalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitPayOption() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.payment,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pay in 4 installments',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Split your payment into 4 equal payments with no interest',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _useSplitPay,
                  onChanged: (value) {
                    setState(() {
                      _useSplitPay = value;
                    });
                  },
                ),
              ],
            ),
            if (_useSplitPay) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Today (Deposit)'),
                        Text('\$${_getDepositAmount().toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(3, (index) {
                      final remainingAmount = _getFinalPrice() - _getDepositAmount();
                      final installmentAmount = remainingAmount / 3;
                      final dueDate = DateTime.now().add(Duration(days: (index + 1) * 14));
                      
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDate(dueDate)),
                            Text('\$${installmentAmount.toStringAsFixed(2)}'),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Card Payment
            RadioListTile<PaymentMethod>(
              value: PaymentMethod.card,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              title: Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  const Text('Credit/Debit Card'),
                ],
              ),
              contentPadding: EdgeInsets.zero,
            ),
            
            // Apple Pay
            if (_isApplePaySupported)
              RadioListTile<PaymentMethod>(
                value: PaymentMethod.applePay,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                title: Row(
                  children: [
                    Icon(Icons.apple, color: Colors.grey[800], size: 20),
                    const SizedBox(width: 8),
                    const Text('Apple Pay'),
                  ],
                ),
                contentPadding: EdgeInsets.zero,
              ),
            
            // Google Pay
            if (_isGooglePaySupported)
              RadioListTile<PaymentMethod>(
                value: PaymentMethod.googlePay,
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
                title: Row(
                  children: [
                    Icon(Icons.payment, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    const Text('Google Pay'),
                  ],
                ),
                contentPadding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Notes',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add any special requests or information for the service provider.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Enter any special requests or notes...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Terms & Conditions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '• Cancellation must be made at least 24 hours in advance\n'
          '• Service provider will arrive within the scheduled time window\n'
          '• Payment will be processed after service completion\n'
          '• Additional charges may apply for extra services',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(BookingState state) {
    final isLoading = state.isLoading;
    final depositAmount = _getDepositAmount();
    final finalPrice = _getFinalPrice();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Payment summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _useSplitPay ? 'Due Today (Deposit)' : 'Total Amount',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${(_useSplitPay ? depositAmount : finalPrice).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  if (_useSplitPay) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remaining (3 payments)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '\$${(finalPrice - depositAmount).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Booking button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleBooking,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        _getBookingButtonText(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBookingButtonText() {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.applePay:
        return 'Pay with Apple Pay';
      case PaymentMethod.googlePay:
        return 'Pay with Google Pay';
      case PaymentMethod.card:
      default:
        return 'Confirm Booking';
    }
  }

  Future<void> _handleBooking() async {
    if (!_formKey.currentState!.validate()) return;
    
    final bookingBloc = context.read<BookingBloc>();
    
    try {
      // First, check split pay eligibility if needed
      if (_useSplitPay) {
        bookingBloc.add(CheckSplitPayEligibility('customer_demo'));
        
        // Wait for eligibility check
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      // Create payment intent
      final amount = _useSplitPay ? _getDepositAmount() : _getFinalPrice();
      bookingBloc.add(CreatePaymentIntent(
        amount: amount,
        currency: 'USD',
        customerId: 'customer_demo', // Replace with actual customer ID
        isSplitPayment: _useSplitPay,
      ));
      
      // Wait for payment intent creation
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Create the booking
      bookingBloc.add(CreateBooking(
        serviceId: widget.serviceDetail.id,
        providerId: widget.serviceDetail.providerId,
        clientId: 'customer_demo', // Replace with actual customer ID
        timeSlotId: widget.selectedTimeSlot.id,
        serviceTitle: widget.serviceDetail.title,
        totalAmount: _getFinalPrice(),
        depositAmount: _getDepositAmount(),
        depositPercent: _depositPercentage * 100,
        paymentMethod: _selectedPaymentMethod,
        paymentIntentId: 'pi_${DateTime.now().millisecondsSinceEpoch}',
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        isSplitPayment: _useSplitPay,
      ));
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _handleBooking(),
            ),
          ),
        );
      }
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    
    return '$weekday, $month ${date.day}, ${date.year}';
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}
