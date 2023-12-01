local IsPalindrome(word) =
    local chars = std.stringChars(word);
    local reversedChars = std.reverse(chars);
    chars == reversedChars;

{
    level: IsPalindrome("level"),
    prometheus: IsPalindrome("prometheus"),
    racecar: IsPalindrome("racecar"),
    thanos: IsPalindrome("thanos"),
    // In-Line function example
    // Must be a hidden field since a function
    // cannot be manifested as JSON
    square:: function(x) x*x,
    foo: self.square(7)
}
