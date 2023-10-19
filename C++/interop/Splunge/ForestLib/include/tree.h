enum class TreeKind {
    Oak,
    Redwood,
    Willow
};

class Tree {
public:
    Tree(TreeKind kind);
private:
    TreeKind kind;
};


template<class T, class U>
class Fraction {
public:
  T numerator;
  U denominator;

  Fraction(const T &num, const U &denom) {
    numerator = num;
    denominator = denom;
  }
};

Fraction<int, float> getMagicNumber();

using CharCharFraction = Fraction<char, char>;

