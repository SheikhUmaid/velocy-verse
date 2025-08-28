import 'package:flutter/material.dart';

class DriverTnCScreen extends StatelessWidget {
  const DriverTnCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = _tncSections();

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Terms & Conditions')),
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
          'VelocyTaxzz Drivers – Terms and Conditions',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'THIS DOCUMENT IS AN ELECTRONIC RECORD IN TERMS OF THE INFORMATION TECHNOLOGY ACT, 2000 AND RULES MADE THEREUNDER AND DOES NOT REQUIRE ANY PHYSICAL OR DIGITAL SIGNATURE. PLEASE READ THESE TERMS AND CONDITIONS CAREFULLY BEFORE REGISTERING AS A DRIVER WITH VELOCYTAXZZ. These Terms constitute a legally binding agreement between VelocyVerse Private Limited ("Company") and any natural person registering as a Driver.',
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({required this.section});
  final _TnCSection section;

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
              'By registering as a Driver and using the VelocyTaxzz Platform, you agree and consent to these Terms and Conditions. Continued use constitutes acceptance of any modifications.',
            ),
          ),
        ],
      ),
    );
  }
}

class _TnCSection {
  final String title;
  final List<Widget> bodyWidgets;
  final bool initiallyExpanded;
  _TnCSection(this.title, this.bodyWidgets, {this.initiallyExpanded = false});
}

List<_TnCSection> _tncSections() {
  final b = <_TnCSection>[];

  b.add(
    _TnCSection('1. DEFINITIONS', const [
      _BulletList(
        items: [
          'Account: Registered profile created by the Driver on the Platform.',
          'Applicable Law: Includes Motor Vehicles Act, 1988, IT Act, 2000, Motor Vehicle Aggregator Guidelines, 2020, etc.',
          'Driver: Individual or entity registered with VelocyTaxzz for providing services.',
          'Platform: VelocyTaxzz mobile app, website, backend, and infrastructure.',
          'Services: Transportation/mobility services provided by the Driver.',
          'User/Rider: Any person availing Services through the Platform.',
        ],
      ),
    ], initiallyExpanded: true),
  );

  b.add(
    _TnCSection('2. ELIGIBILITY AND REPRESENTATIONS', const [
      _BulletList(
        items: [
          'Hold a valid commercial driving license and permits.',
          'Own or be authorized to operate registered vehicle(s).',
          'No conviction of serious criminal offences.',
          'Medically fit to operate motor vehicle.',
          'Comply with traffic rules, safety norms, and legal requirements.',
        ],
      ),
      _P(
        'Driver must notify the Company of any suspension, revocation, or expiry of licenses or permits.',
      ),
    ]),
  );

  b.add(
    _TnCSection('3. REGISTRATION AND DOCUMENTATION', const [
      _P(
        'To register as a Driver, you must upload and maintain valid documents:',
      ),
      _BulletList(
        items: [
          'Driving license',
          'Vehicle registration certificate (RC)',
          'Insurance policy',
          'Pollution under Control (PUC)',
          'Commercial permit(s)',
          'PAN, Aadhaar, and other KYC documents',
        ],
      ),
      _P(
        'The Company may verify documents, conduct checks, and approve/reject applications.',
      ),
    ]),
  );

  b.add(
    _TnCSection('4. NATURE OF RELATIONSHIP', const [
      _P('Driver is an independent contractor, not an employee or agent.'),
      _P(
        'Driver may accept/reject rides and is responsible for vehicle costs.',
      ),
    ]),
  );

  b.add(
    _TnCSection('5. DRIVER OBLIGATIONS', const [
      _BulletList(
        items: [
          'Operate safely, lawfully, courteously.',
          'Maintain vehicle in roadworthy condition.',
          'Do not allow unauthorized persons to access Account.',
          'No alcohol/drug use while on duty.',
          'Comply with transport, safety, labour, taxation, and anti-harassment laws.',
          'Display VelocyTaxzz ID card while on duty.',
        ],
      ),
      _Subheading('Prohibited actions:'),
      _BulletList(
        items: [
          'Overcharging or demanding excess tips.',
          'Refusing service without valid cause.',
          'Abuse, harassment, or unlawful conduct.',
          'Tampering with app, payment systems, or meters.',
          'Transporting prohibited or illegal goods.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('6. FARES AND PAYOUTS', const [
      _BulletList(
        items: [
          'Fares based on distance, time, demand, or bidding.',
          'Company deducts commission per trip.',
          'Balance paid to Driver bank/wallet as scheduled.',
          'Driver responsible for all taxes on earnings.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('7. CANCELLATIONS', const [
      _P(
        'Drivers should not cancel rides unreasonably. Repeated cancellations may result in penalties, suspension, or termination.',
      ),
    ]),
  );

  b.add(
    _TnCSection('8. RATINGS AND PERFORMANCE', const [
      _P(
        'Users may rate/review Drivers. Poor ratings or complaints may result in suspension or removal.',
      ),
    ]),
  );

  b.add(
    _TnCSection('9. INTELLECTUAL PROPERTY', const [
      _P(
        'All rights in Platform remain with Company. Drivers get a limited, revocable license to use Platform only for providing Services.',
      ),
    ]),
  );

  b.add(
    _TnCSection('10. LIABILITY AND DISCLAIMERS', const [
      _P(
        'Company does not provide transportation services and is not liable for Driver acts. Driver solely responsible for accidents, legal violations, misconduct, or property loss.',
      ),
    ]),
  );

  b.add(
    _TnCSection('11. INDEMNITY', const [
      _P(
        'Driver shall indemnify Company against claims, damages, costs arising from breach, law violation, negligence, or disputes.',
      ),
    ]),
  );

  b.add(
    _TnCSection('12. SUSPENSION AND TERMINATION', const [
      _BulletList(
        items: [
          'Company may suspend/terminate for false documents, misconduct, breaches, or poor ratings.',
          'Driver may terminate Account with prior notice.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('13. DATA PRIVACY', const [
      _P(
        'Driver data will be collected and processed per VelocyTaxzz Privacy Policy. May be disclosed to authorities as required.',
      ),
    ]),
  );

  b.add(
    _TnCSection('14. FORCE MAJEURE', const [
      _P(
        'Company not liable for delays due to events beyond control like natural disasters, internet failure, pandemics, government restrictions.',
      ),
    ]),
  );

  b.add(
    _TnCSection('15. GOVERNING LAW AND DISPUTE RESOLUTION', const [
      _P(
        'These Terms governed by Indian law. Disputes resolved by arbitration under Arbitration and Conciliation Act, 1996. Courts at [Insert City, India] have exclusive jurisdiction.',
      ),
    ]),
  );

  b.add(
    _TnCSection('16. AMENDMENTS', const [
      _P(
        'Company may modify Terms anytime. Updates notified on Platform. Continued use = acceptance.',
      ),
    ]),
  );

  b.add(
    _TnCSection('17. GRIEVANCE REDRESSAL', const [
      _CardBlock(
        children: [
          _Line('Grievance Officer'),
          _Line('VelocyVerse Private Limited'),
          _Line('Email: support@Velocytax.in'),
          _Line('Phone: +91 7092628017'),
          _Line(
            'Address: 1/6/1, VILL -DHANDUKARANAHALLI, Dandukaranahalli, Palacode, Dharmapuri- 636808',
          ),
        ],
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
