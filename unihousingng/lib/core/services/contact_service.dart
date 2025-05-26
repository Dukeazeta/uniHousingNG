import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ContactService {
  // Singleton pattern
  static final ContactService _instance = ContactService._internal();
  factory ContactService() => _instance;
  ContactService._internal();

  // Make a phone call
  static Future<bool> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        return await launchUrl(phoneUri);
      } else {
        debugPrint('Could not launch phone call to $phoneNumber');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching phone call: $e');
      return false;
    }
  }

  // Send WhatsApp message
  static Future<bool> sendWhatsAppMessage(String phoneNumber, {String? message}) async {
    // Remove any non-digit characters and ensure it starts with country code
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    // If number starts with 0, replace with 234 (Nigeria country code)
    if (cleanNumber.startsWith('0')) {
      cleanNumber = '234${cleanNumber.substring(1)}';
    }
    
    // Default message for property inquiry
    final String defaultMessage = message ?? 
        'Hello! I\'m interested in your property listing on UniHousingNG. Could you please provide more details?';
    
    final String encodedMessage = Uri.encodeComponent(defaultMessage);
    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanNumber?text=$encodedMessage');
    
    try {
      if (await canLaunchUrl(whatsappUri)) {
        return await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch WhatsApp to $cleanNumber');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
      return false;
    }
  }

  // Send email
  static Future<bool> sendEmail(String email, {String? subject, String? body}) async {
    final String defaultSubject = subject ?? 'Property Inquiry from UniHousingNG';
    final String defaultBody = body ?? 
        'Hello,\n\nI am interested in your property listing on UniHousingNG. Could you please provide more information?\n\nThank you.';
    
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent(defaultSubject)}&body=${Uri.encodeComponent(defaultBody)}',
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        return await launchUrl(emailUri);
      } else {
        debugPrint('Could not launch email to $email');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching email: $e');
      return false;
    }
  }

  // Send SMS
  static Future<bool> sendSMS(String phoneNumber, {String? message}) async {
    final String defaultMessage = message ?? 
        'Hello! I\'m interested in your property listing on UniHousingNG.';
    
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      query: 'body=${Uri.encodeComponent(defaultMessage)}',
    );
    
    try {
      if (await canLaunchUrl(smsUri)) {
        return await launchUrl(smsUri);
      } else {
        debugPrint('Could not launch SMS to $phoneNumber');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching SMS: $e');
      return false;
    }
  }

  // Open website/URL
  static Future<bool> openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch URL: $url');
        return false;
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      return false;
    }
  }

  // Show contact options bottom sheet
  static void showContactOptions(
    BuildContext context, {
    String? phone,
    String? whatsapp,
    String? email,
    String? propertyTitle,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Landlord',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            if (propertyTitle != null) ...[
              const SizedBox(height: 8),
              Text(
                'About: $propertyTitle',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 20),
            
            // Phone call option
            if (phone != null && phone.isNotEmpty)
              _buildContactOption(
                context,
                icon: Icons.phone,
                title: 'Call',
                subtitle: phone,
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  makePhoneCall(phone);
                },
              ),
            
            // WhatsApp option
            if (whatsapp != null && whatsapp.isNotEmpty)
              _buildContactOption(
                context,
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: whatsapp,
                color: Colors.green[600]!,
                onTap: () {
                  Navigator.pop(context);
                  sendWhatsAppMessage(whatsapp, message: propertyTitle != null 
                      ? 'Hello! I\'m interested in your property "$propertyTitle" on UniHousingNG.'
                      : null);
                },
              ),
            
            // Email option
            if (email != null && email.isNotEmpty)
              _buildContactOption(
                context,
                icon: Icons.email,
                title: 'Email',
                subtitle: email,
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  sendEmail(email, subject: propertyTitle != null 
                      ? 'Inquiry about $propertyTitle'
                      : null);
                },
              ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  static Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
