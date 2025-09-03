import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = _policySections();

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Header(),
            const SizedBox(height: 16),
            ...sections.map((s) => _SectionTile(section: s)),
            const SizedBox(height: 24),
            // _FooterNote(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRIVACY POLICY',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            text: 'Your privacy matters to ',
            children: [
              TextSpan(
                text: 'VelocyVerse Private Limited ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text:
                    '(the “Company”, “we”, “VelocyTaxzz”, “us” or “our”).\nThis Privacy Policy (“Policy”) describes the policies and procedures on the collection, use, processing, storage, retrieval, disclosure, transfer and protection of your information, including personal information and sensitive personal data or information (“Information”), that VelocyTaxzz may receive through your access or use of the VelocyTaxzz mobile applications (“VelocyTaxzz App”) or our website located at www.VelocyTax.in (the “Website”), collectively referred to as the “VelocyTaxzz Platform”, or through your offline interaction with us including through emails, phones, in person, etc., or while availing our Services. The terms “you” and “your” refer to a Driver, a Rider, a Vendor Partner, or any other user of the VelocyTaxzz Platform and/or Services. The term “Services” refers to any transportation, pooling, rental, or related services offered by VelocyTaxzz in accordance with the terms and conditions applicable to you and available on the VelocyTaxzz Platform. This Policy is incorporated within and is to be read along with the Terms of Use applicable to you.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({required this.section});
  final _PolicySection section;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 0.2, spreadRadius: 0.2),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(
            section.title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          initiallyExpanded: section.initiallyExpanded,
          children: section.bodyWidgets,
        ),
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'By accessing or using the VelocyTaxzz Platform or the Services, you agree and consent to this Policy. If you do not agree, please do not use or access the VelocyTaxzz Platform.',
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicySection {
  final String title;
  final List<Widget> bodyWidgets;
  final bool initiallyExpanded;
  _PolicySection(
    this.title,
    this.bodyWidgets, {
    this.initiallyExpanded = false,
  });
}

List<_PolicySection> _policySections() {
  final b = <_PolicySection>[];

  b.add(
    _PolicySection('1. USER ACCEPTANCE', [
      const _P(
        'By accessing or using the VelocyTaxzz Platform or the Services, you agree and consent to this Policy, along with any amendments made by the Company at its sole discretion and posted on the VelocyTaxzz Platform from time to time. Any collection, processing, retrieval, transfer, use, storage, disclosure and protection of your Information will be in accordance with this Policy and applicable laws including but not limited to the Information Technology Act, 2000, the rules framed thereunder, and any other applicable data protection laws (“Applicable Laws”). If you do not agree with the Policy, please do not use or access the VelocyTaxzz Platform.',
      ),
      const SizedBox(height: 8),
      const _BulletList(
        items: [
          'The Information you provide to VelocyTaxzz from time to time is authentic, correct, current and updated.',
          'You have all rights, permissions and consents as may be required to provide such Information to VelocyTaxzz.',
          'Your providing of the Information, as well as VelocyTaxzz’s consequent storage, collection, usage, transfer, access, or processing of such Information, will not be in violation of any agreement, Applicable Laws, or court orders.',
          'If you disclose to us any Information relating to another person, you represent that you have the authority to do so and to permit us to use such Information in accordance with this Policy.',
        ],
      ),
    ], initiallyExpanded: true),
  );

  b.add(
    _PolicySection('2. DEFINITIONS', const [
      _BulletList(
        items: [
          'Driver: Independent third-party vehicle operators who offer services through the VelocyTaxzz Platform.',
          'Rider: A person who avails services of the Drivers or Vendor Partners through the VelocyTaxzz Platform.',
          'Vendor Partner: Third-party service providers who may offer car/bike rentals, delivery, or allied services.',
          'Device: Any computer, smartphone, or tablet used to access the Services.',
          'Device Identifier: IP address, IMEI, or any other unique identifier associated with the Device.',
          'Personal Information: Information that identifies you personally, such as name, contact details, profile photo, and payment details.',
          'Sensitive Personal Data: Passwords, financial information, health data, government-issued IDs, etc.',
          'Usage Information: Information collected automatically about how you use the VelocyTaxzz Platform, such as app activity, preferences, and interactions.',
          'TPSP: A third-party service provider engaged by VelocyTaxzz.',
          'Promotion: Any contest, referral scheme, or marketing campaign offered by us.',
        ],
      ),
    ]),
  );

  b.add(
    _PolicySection('3. INFORMATION WE COLLECT', const [
      _Subheading('A) Information You Provide Directly'),
      _BulletList(
        items: [
          'Account Information: name, email, mobile number, gender, date of birth, profile photo, password.',
          'Payment Information: UPI, wallet details, bank account information (as permitted by law).',
          'Verification Information: Aadhaar, PAN, driving license, RC book, insurance, permits, real-time selfies (for Driver verification), etc.',
          'Emergency Contacts: optional contacts you may provide for safety.',
          'Communications: support requests, complaints, reviews, or feedback submitted to us.',
        ],
      ),
      SizedBox(height: 12),
      _Subheading('B) Information We Collect Automatically'),
      _BulletList(
        items: [
          'Transaction Data: ride history, trip details, pickup/drop locations, invoices, receipts.',
          'Location Data: For Drivers – collected continuously when “On-Duty” is enabled (foreground and background). For Riders – collected from request to completion of ride (foreground only).',
          'Device Data: IP address, operating system, network provider, crash logs, performance analytics.',
          'Cookies & Tracking: identifiers for analytics, personalization, fraud detection.',
          'SMS & Call Data (with permissions): OTPs for verification, call masking for Rider-Driver safety.',
        ],
      ),
      SizedBox(height: 12),
      _Subheading('C) Information From Third Parties'),
      _BulletList(
        items: [
          'Background verification results (criminal history, driver history, etc.).',
          'Technical subcontractors, analytics providers, payment partners.',
          'Data from referral programs, marketing partners, or publicly available sources.',
        ],
      ),
    ]),
  );

  b.add(
    _PolicySection('4. USE OF INFORMATION', const [
      _BulletList(
        items: [
          'To enable you to access and use the VelocyTaxzz Platform.',
          'To match Riders with Drivers and provide Services.',
          'To verify your identity, perform KYC, and comply with legal obligations.',
          'To process transactions, generate invoices, and provide receipts.',
          'To send safety alerts, OTPs, trip updates, and service-related messages.',
          'To improve customer experience, optimize pickup points, and enhance features.',
          'To detect and prevent fraud, misuse, and unlawful activities.',
          'To provide customer support and resolve disputes.',
          'To comply with court orders, government directives, and regulatory obligations.',
          'To send promotions, rewards, referral offers, or marketing communications (where permitted).',
        ],
      ),
    ]),
  );

  b.add(
    _PolicySection('5. DISCLOSURE OF INFORMATION', const [
      _P(
        'We do not sell your Information. However, we may share Information in the following circumstances:',
      ),
      _NumberList(
        items: [
          'With Drivers and Riders: To facilitate services (e.g., sharing Rider name and contact with Driver, and vice versa).',
          'With TPSPs: Background verification agencies, payment gateways, hosting providers, fraud detection systems.',
          'For Co-branded Services: Partners offering corporate commute, rentals, or financial services (with your consent).',
          'For Promotions & Contests: Where required by law or campaign rules.',
          'For Legal & Administrative Purposes: To law enforcement, regulators, or courts when legally mandated.',
          'Business Transfers: In case of mergers, acquisitions, restructuring, or sale of assets.',
          'Research & Analytics: For market study, product improvement, and internal insights.',
        ],
      ),
    ]),
  );

  b.add(
    _PolicySection('6. DATA RETENTION', const [
      _BulletList(
        items: [
          'We retain Information as long as your account is active.',
          'Post account termination, certain data (trip history, payments, verification documents) may be retained for 180 days for compliance and fraud prevention.',
          'Thereafter, the data may be anonymized and used only for analytics.',
        ],
      ),
    ]),
  );

  b.add(
    _PolicySection('7. SECURITY', const [
      _P(
        'We use industry-standard measures including SSL encryption, firewalls, secure servers, and limited access controls to protect your Information. However, no system is 100% secure, and transmission of data is at your own risk.',
      ),
    ]),
  );

  b.add(
    _PolicySection('8. MINORS', const [
      _P(
        'The VelocyTaxzz Platform is not available for persons under the age of 18 years. We do not knowingly collect information from minors.',
      ),
    ]),
  );

  b.add(
    _PolicySection('9. YOUR RIGHTS', const [
      _P('Subject to Applicable Laws, you may:'),
      _BulletList(
        items: [
          'Access and review the Information we hold about you.',
          'Update or correct inaccurate details.',
          'Request deletion of your account and related data.',
          'Withdraw consent for non-essential processing.',
          'Modify notification and communication preferences.',
        ],
      ),
    ]),
  );

  b.add(
    _PolicySection('10. GRIEVANCE REDRESSAL', const [
      _P(
        'For questions, complaints, or grievances regarding this Policy, you may contact:',
      ),
      _CardBlock(
        children: [
          _Line('Grievance Officer'),
          _Line('Name: Suseandhiran Natarajan'),
          _Line('Email: support@VelocyTax.in'),
          _Line('Phone: +91 7092628017'),
          _Line(
            'The Grievance Officer shall respond to complaints within the time period prescribed under Applicable Laws.',
          ),
        ],
      ),
    ]),
  );

  b.add(
    _PolicySection('11. CHANGES TO THIS POLICY', const [
      _P(
        'We reserve the right to modify or update this Policy at any time. Updates will be posted on the VelocyTaxzz Platform.\nIf material changes are made, we may notify you via email or app notification. Continued use of the Platform after updates shall be deemed acceptance of the revised Policy.',
      ),
    ]),
  );

  return b;
}

class _P extends StatelessWidget {
  const _P(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(text, textAlign: TextAlign.start),
    );
  }
}

class _Subheading extends StatelessWidget {
  const _Subheading(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('•  '),
                Expanded(child: Text(item)),
              ],
            ),
          ),
      ],
    );
  }
}

class _NumberList extends StatelessWidget {
  const _NumberList({required this.items});
  final List<String> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${i + 1}.  '),
                Expanded(child: Text(items[i])),
              ],
            ),
          ),
      ],
    );
  }
}

class _CardBlock extends StatelessWidget {
  const _CardBlock({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children
            .map(
              (w) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: w,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
