# frozen_string_literal: true

class MetrojobbCategories
  TOP_CATEGORY_NAMES = {
    'Administration' => '1',
    'Bygg & Anläggning' => '2',
    'Byggnad / konstruktion' => '214',
    'Målare / Golvläggare' => '208',
    'Data / IT' => '3',
    'ITkonsult' => '300',
    'Utvecklare / Programmerare' => '305',
    'Drift & Underhåll' => '4',
    'Ekonomi & Finans' => '5',
    'Forskning / R&D / Vetenskap' => '6',
    'Försäljning / Affärsutveckling' => '7',
    'Säljare / Account manager' => '700',
    'Försäkringar' => '509',
    'Hotell / Restaurang / Turism' => '8',
    'HR & Personal' => '9',
    'Juridik' => '10',
    'Kreativitet / Design' => '11',
    'Webbdesigner / Grafisk designer' => '310',
    'Kundsupport & Service' => '12',
    'Säkerhet & Kontroll' => '13',
    'Ledning / Chefer' => '14',
    'Logistik / Transport' => '15',
    'Marknadsföring / Produkt' => '16',
    'Projektledning' => '17',
    'Trainee' => '18',
    'Sjukvård & Hälsa' => '19',
    'Skribenter / publishing' => '20',
    'Teknik' => '21',
    'Industri / Produktion' => '22',
    'Lärare / Utbildning' => '23',
    'Övrigt' => '24',
    'Artister / Skådespelare' => '25',
    'Franchisetagare' => '26',
    'Trädgårdsarbetare' => '410'
  }.freeze

  def self.to_form_array
    TOP_CATEGORY_NAMES.keys.zip(TOP_CATEGORY_NAMES.keys)
  end
end
