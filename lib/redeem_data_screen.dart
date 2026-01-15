import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phenoxx/models/data_reward_model.dart';
import 'package:phenoxx/services/data_reward_service.dart';

class RedeemDataScreen extends StatefulWidget {
  final DataBalance balance;

  const RedeemDataScreen({super.key, required this.balance});

  @override
  State<RedeemDataScreen> createState() => _RedeemDataScreenState();
}

class _RedeemDataScreenState extends State<RedeemDataScreen> {
  final DataRewardService _rewardService = DataRewardService();
  final _phoneController = TextEditingController();
  
  MobileCarrier? _selectedCarrier;
  DataPackage? _selectedPackage;
  bool _isRedeeming = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).colorScheme.onSurface;
    final carriers = _rewardService.getCarriers();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1419) : const Color(0xFFEAF2F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Redeem Data',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available balance
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text(
                    'Available: ${widget.balance.availableMB.toInt()} MB',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Select Carrier
            Text(
              'Select Your Carrier',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            ...carriers.map((carrier) => _CarrierTile(
                  carrier: carrier,
                  isSelected: _selectedCarrier?.id == carrier.id,
                  onTap: () => setState(() => {
                        _selectedCarrier = carrier,
                        _selectedPackage = null,
                      }),
                  isDark: isDark,
                )),

            if (_selectedCarrier != null) ...[
              const SizedBox(height: 24),
              Text(
                'Select Package',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              ..._selectedCarrier!.packages.map((pkg) => _PackageTile(
                    package: pkg,
                    isSelected: _selectedPackage?.id == pkg.id,
                    isAffordable: widget.balance.availableMB >= pkg.dataMB,
                    onTap: () => setState(() => _selectedPackage = pkg),
                    isDark: isDark,
                  )),

              const SizedBox(height: 24),
              // Phone number
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '080XXXXXXXX',
                  prefixIcon: const Icon(Icons.phone),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1A2332) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              // Redeem button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canRedeem() ? _redeemData : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isRedeeming
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Redeem ${_selectedPackage?.dataDisplay ?? ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _canRedeem() {
    return _selectedCarrier != null &&
        _selectedPackage != null &&
        _phoneController.text.length >= 11 &&
        widget.balance.availableMB >= (_selectedPackage?.dataMB ?? 0) &&
        !_isRedeeming;
  }

  Future<void> _redeemData() async {
    setState(() => _isRedeeming = true);

    final result = await _rewardService.redeemData(
      userId: 'current_user',
      dataMB: _selectedPackage!.dataMB,
      carrierId: _selectedCarrier!.id,
      phoneNumber: _phoneController.text,
    );

    setState(() => _isRedeeming = false);

    if (!mounted) return;

    if (result['success']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success!', style: GoogleFonts.poppins()),
          content: Text(
            result['message'],
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error'])),
      );
    }
  }
}

class _CarrierTile extends StatelessWidget {
  final MobileCarrier carrier;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _CarrierTile({
    required this.carrier,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2332) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.signal_cellular_alt, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                carrier.name,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

class _PackageTile extends StatelessWidget {
  final DataPackage package;
  final bool isSelected;
  final bool isAffordable;
  final VoidCallback onTap;
  final bool isDark;

  const _PackageTile({
    required this.package,
    required this.isSelected,
    required this.isAffordable,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAffordable ? onTap : null,
      child: Opacity(
        opacity: isAffordable ? 1.0 : 0.5,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2332) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.data_usage, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.dataDisplay,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Valid for ${package.validityDays} ${package.validityDays == 1 ? 'day' : 'days'}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Colors.blue)
              else if (!isAffordable)
                const Icon(Icons.lock, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
