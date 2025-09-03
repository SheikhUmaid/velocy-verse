import 'package:flutter/material.dart';

class UserTncScreen extends StatelessWidget {
  const UserTncScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = _tncSections();

    return Scaffold(
      appBar: AppBar(title: const Text('User Terms & Conditions')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _Header(),
            const SizedBox(height: 16),
            ...sections.map((s) => _SectionTile(section: s)),
            const SizedBox(height: 24),
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
          'VelocyTaxzz Users – Terms and Conditions',
          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          'THIS DOCUMENT IS AN ELECTRONIC RECORD IN TERMS OF THE INFORMATION TECHNOLOGY ACT, 2000 AND RULES MADE THEREUNDER AND DOES NOT REQUIRE ANY PHYSICAL OR DIGITAL SIGNATURE. PLEASE READ THESE TERMS AND CONDITIONS CAREFULLY BEFORE PROCEEDING.\n\nThese Terms and Conditions (“Terms”) constitute a legally binding agreement between VelocyVerse Private Limited, a company incorporated under the provisions of the Companies Act, 2013 and having its registered office at [●] (hereinafter referred to as the “Company”, “VelocyTaxzz”, “we”, “our” or “us”) of the FIRST PART, AND any natural person, being a user of the VelocyTaxzz mobile application, website and related services (hereinafter referred to as the “User”, “Rider”, “you” or “your”) of the SECOND PART.\nWHEREAS: \nA. The Company owns and operates a technology platform known as VelocyTaxzz, which inter alia enables registered users to request and obtain transportation services, ride pooling, rentals and other mobility-related solutions from independent third-party vehicle operators (“Captains”);\nB. The User desires to avail such services through the VelocyTaxzz Platform subject to compliance with these Terms; and\nC. The Company is willing to provide access to the Platform on the condition that the User accepts and complies with all obligations set forth herein.\n\nNOW THEREFORE, in consideration of the mutual covenants herein contained, the Parties hereby agree as follows: ',
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
      _P(
        'Unless the context otherwise requires, the following terms shall have the meanings assigned below:',
      ),
      _BulletList(
        items: [
          'Account: means the electronic account created by the User on the VelocyTaxzz Platform by providing Registration Data.',
          'Applicable Law: means all laws, statutes, ordinances, rules, regulations, guidelines, notifications, and orders of any governmental authority in India, including without limitation, the Motor Vehicles Act, 1988, the Information Technology Act, 2000, the Consumer Protection Act, 2019 and any amendments thereto.',
          'Caption: means an independent third-party motor vehicle operator registered with the VelocyTaxzz Platform who provides transportation services to Users.',
          'Platform:means the VelocyTaxzz mobile application, website, software, and associated technology infrastructure.',
          'Services: means the facilitation of transportation, pooling, rentals, and other mobility solutions through the Platform.',
          'Trip: means the transportation service requested by a User and provided by a Captain using the Platform.',
        ],
      ),
    ], initiallyExpanded: true),
  );

  b.add(
    _TnCSection('2. ELIGIBILITY', const [
      _P('The User hereby represents and warrants that he/she:'),
      _BulletList(
        items: [
          'Is at least 18 (eighteen) years of age and is competent to contract within the meaning of the Indian Contract Act, 1872.',
          'Has the authority and capacity to enter into and perform these Terms.',
          'Shall comply with all Applicable Laws while using the Platform and Services.',
        ],
      ),
      _P(
        'The Company reserves the sole and absolute discretion to deny access to or suspend the User’s Account if:',
      ),
      _BulletList(
        items: [
          'Any information provided by the User is false, misleading, inaccurate, or incomplete.',
          'The User is found to be in breach of any obligations set forth herein.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('3. REGISTRATION AND ACCOUNT SECURITY', const [
      _BulletList(
        items: [
          'The User shall register on the Platform by providing accurate, current and complete information including but not limited to name, contact details, age, payment details, and such other information as may be required (“Registration Data”).',
          'The User shall maintain the confidentiality of login credentials and shall not share, assign, or transfer the Account to any third party.',
          'The User shall be solely responsible for all activities carried out through his/her Account. The Company shall not be liable for any loss or damage arising out of unauthorized access to the Account.',
          'The Company reserves the right to suspend or terminate the Account in the event of suspected fraud, unauthorized activity or breach of these Terms.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('4. ROLE OF THE COMPANY', const [
      _BulletList(
        items: [
          'The User acknowledges that VelocyTaxzz is a technology facilitator that enables the connection between Users and Captains.',
          'The Company does not provide transportation services, does not own vehicles, and does not employ Captains. Captains act as independent contractors.',
          'The Company shall not be deemed to be responsible for the acts, omissions, misconduct, negligence, or default of any Captain or User.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('5. USER COVENANTS AND OBLIGATIONS', const [
      _P('The User agrees, undertakes and covenants:'),
      _BulletList(
        items: [
          'To provide accurate trip details including pickup and drop-off points;',
          'To pay applicable fares, fees, and surcharges promptly;',
          'To treat Captains with courtesy and respect;',
          'Not to damage or deface the vehicle or property of the Captain;',
          'Not to engage in unlawful, offensive, threatening, or abusive conduct during a Trip;',
          'Not to transport contraband, hazardous, prohibited, or illegal goods.',
        ],
      ),
      _P('The User further covenants that he/she shall not:'),
      _BulletList(
        items: [
          'Use the Platform for fraudulent purposes or unlawful activities;',
          'Impersonate another person or misrepresent identity;',
          'Interfere with, disrupt or damage the operation of the Platform or its systems;',
          'Create multiple Accounts or transfer Accounts without the consent of the Company;',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('6. BOOKINGS, CANCELLATIONS AND REFUNDS', const [
      _BulletList(
        items: [
          'All ride requests are subject to acceptance by an available Captain. The Company does not guarantee confirmation of every booking.',
          'The User may cancel a booking within such time as permitted by the Platform. Cancellations beyond such period shall attract a cancellation fee as determined by the Company.',
          'Frequent cancellations by the User may lead to suspension or termination of the Account.',
          'Refunds, if applicable, shall be processed to the original payment method within a reasonable time frame.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('7. FARES AND PAYMENTS', const [
      _BulletList(
        items: [
          '1 Fares shall be determined based on distance, duration, demand, bidding mechanism (if applicable), or such other parameters as may be notified by the Company from time to time.',
          'The User may make payment through in-app digital payment methods (UPI, wallet, credit/debit card, net banking) or cash, where permitted.',
          'The Company reserves the right to revise fare structures at its sole discretion.',
          'Taxes and government levies shall be payable by the User as per Applicable Law.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('8. RATINGS AND FEEDBACK', const [
      _BulletList(
        items: [
          'The User may rate Captains and provide feedback after each Trip.',
          'The User shall not post defamatory, abusive, false, or misleading reviews.',
          'The Company may, at its sole discretion, suspend or terminate the Account of Users who misuse the feedback mechanism.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('9. INTELLECTUAL PROPERTY', const [
      _BulletList(
        items: [
          'All intellectual property rights in the Platform including software, logos, trademarks, designs, and content are owned exclusively by the Company.',
          'The User is granted a limited, non-exclusive, revocable, non-transferable license to access and use the Platform for personal and lawful purposes only.',
          'The User shall not copy, modify, reverse engineer, decompile, distribute, or commercially exploit any part of the Platform.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('10. DISCLAIMERS AND LIMITATION OF LIABILITY', const [
      _P(
        'The Platform and Services are provided on an “as is” and “as available” basis. The Company disclaims all representations and warranties, whether express or implied.',
      ),
      _P('The Company shall not be liable for:'),
      _BulletList(
        items: [
          'Any personal injury, death, loss, or damage arising out of the Trip;',
          'Actions, omissions, negligence, misconduct, or default of any Captain or User;',
          'Delays, cancellations, unavailability, or disruption of Services;',
          'Loss of personal belongings of the User;',
          'Technical errors, interruptions, or system failures of the Platform.',
        ],
      ),
      _P(
        'To the maximum extent permitted by law, the aggregate liability of the Company shall in no event exceed the amount paid by the User for the Trip giving rise to such liability.',
      ),
    ]),
  );

  b.add(
    _TnCSection('11. INDEMNITY', const [
      _P(
        'The User hereby agrees to indemnify, defend, and hold harmless the Company, its affiliates, directors, officers, employees, and agents from any claims, demands, damages, liabilities, losses, costs, and expenses (including reasonable legal fees) arising out of or in connection with:',
      ),
      _BulletList(
        items: [
          'Breach of these Terms by the User',
          'Violation of Applicable Law by the User;',
          'Misuse of the Platform or Services; or',
          'Disputes between the User and any Captain.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('12. TERMINATION', const [
      _P(
        'The Company reserves the right to suspend, restrict, or terminate the Account of the User at its sole discretion without notice if:',
      ),
      _BulletList(
        items: [
          'The User violates these Terms or Applicable Law;',
          'Fraudulent, abusive, or harmful activity is detected; or',
          'The User’s rating falls below acceptable thresholds.',
        ],
      ),
      _P(
        'The User may terminate his/her Account by submitting a written request to the Company.',
      ),
    ]),
  );

  b.add(
    _TnCSection('13. DATA PROTECTION AND PRIVACY', const [
      _P(
        'The Company shall collect, process, store, and disclose personal information of the User in accordance with the VelocyTaxzz Privacy Policy, which forms an integral part of these Terms.',
      ),
      _P(
        'The Company may disclose User information to governmental authorities or courts where required by law.',
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
      _BulletList(
        items: [
          'These Terms shall be governed by and construed in accordance with the laws of India.',
          'The Parties shall first attempt to resolve disputes amicably through negotiations.',
          'Failing such resolution, disputes shall be referred to arbitration in accordance with the Arbitration and Conciliation Act, 1996. The seat and venue of arbitration shall be [Insert City, India] and proceedings shall be conducted in the English language.',
          'Subject to arbitration, the courts at [Insert City, India] shall have exclusive jurisdiction.',
        ],
      ),
    ]),
  );

  b.add(
    _TnCSection('16. AMENDMENTS', const [
      _P(
        'The Company reserves the absolute right to modify, amend, or update these Terms at any time. The revised Terms shall be posted on the Platform and shall be effective upon publication. Continued use of the Platform shall constitute acceptance of such amended Terms.',
      ),
    ]),
  );

  b.add(
    _TnCSection('17. GRIEVANCE REDRESSAL', const [
      _P(
        'In compliance with the Information Technology Act, 2000, the details of the Grievance Officer are as follows:',
      ),
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
      _P(
        'The Grievance Officer shall redress complaints in accordance with Applicable Law.',
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
