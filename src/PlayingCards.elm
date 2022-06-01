module PlayingCards exposing (Card, Suit(..), deck)


type CardValue
    = Ace
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Jack
    | Queen
    | King


type Suit
    = Spades
    | Hearts
    | Diamonds
    | Clubs


type alias Card =
    { value : CardValue
    , suit : Suit
    , image : String
    }


deck : List Card
deck =
    [ { value = Ace, suit = Spades, image = "as" }
    , { value = Two, suit = Spades, image = "2s" }
    , { value = Three, suit = Spades, image = "3s" }
    , { value = Four, suit = Spades, image = "4s" }
    , { value = Five, suit = Spades, image = "5s" }
    , { value = Six, suit = Spades, image = "6s" }
    , { value = Seven, suit = Spades, image = "7s" }
    , { value = Eight, suit = Spades, image = "8s" }
    , { value = Nine, suit = Spades, image = "9s" }
    , { value = Ten, suit = Spades, image = "10s" }
    , { value = Jack, suit = Spades, image = "js" }
    , { value = Queen, suit = Spades, image = "qs" }
    , { value = King, suit = Spades, image = "ks" }
    , { value = Ace, suit = Hearts, image = "ah" }
    , { value = Two, suit = Hearts, image = "2h" }
    , { value = Three, suit = Hearts, image = "3h" }
    , { value = Four, suit = Hearts, image = "4h" }
    , { value = Five, suit = Hearts, image = "5h" }
    , { value = Six, suit = Hearts, image = "6h" }
    , { value = Seven, suit = Hearts, image = "7h" }
    , { value = Eight, suit = Hearts, image = "8h" }
    , { value = Nine, suit = Hearts, image = "9h" }
    , { value = Ten, suit = Hearts, image = "10h" }
    , { value = Jack, suit = Hearts, image = "jh" }
    , { value = Queen, suit = Hearts, image = "qh" }
    , { value = King, suit = Hearts, image = "kh" }
    , { value = Ace, suit = Clubs, image = "ac" }
    , { value = Two, suit = Clubs, image = "2c" }
    , { value = Three, suit = Clubs, image = "3c" }
    , { value = Four, suit = Clubs, image = "4c" }
    , { value = Five, suit = Clubs, image = "5c" }
    , { value = Six, suit = Clubs, image = "6c" }
    , { value = Seven, suit = Clubs, image = "7c" }
    , { value = Eight, suit = Clubs, image = "8c" }
    , { value = Nine, suit = Clubs, image = "9c" }
    , { value = Ten, suit = Clubs, image = "10c" }
    , { value = Jack, suit = Clubs, image = "jc" }
    , { value = Queen, suit = Clubs, image = "qc" }
    , { value = King, suit = Clubs, image = "kc" }
    , { value = Ace, suit = Diamonds, image = "ad" }
    , { value = Two, suit = Diamonds, image = "2d" }
    , { value = Three, suit = Diamonds, image = "3d" }
    , { value = Four, suit = Diamonds, image = "4d" }
    , { value = Five, suit = Diamonds, image = "5d" }
    , { value = Six, suit = Diamonds, image = "6d" }
    , { value = Seven, suit = Diamonds, image = "7d" }
    , { value = Eight, suit = Diamonds, image = "8d" }
    , { value = Nine, suit = Diamonds, image = "9d" }
    , { value = Ten, suit = Diamonds, image = "10d" }
    , { value = Jack, suit = Diamonds, image = "jd" }
    , { value = Queen, suit = Diamonds, image = "qd" }
    , { value = King, suit = Diamonds, image = "kd" }
    ]
