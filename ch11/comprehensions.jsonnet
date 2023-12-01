{
    foods:: [
        {name: "apple", kind: "fruit"},
        {name: "broccoli", kind: "vegetable"},
        {name: "banana", kind: "fruit"},
        {name: "carrot", kind: "vegetable"},
    ],
    
    fruits: [f.name for f in self.foods if f.kind != "vegetable"],
    groceryList: {
        [f.name]: {qty: if f.kind == "fruit" then 5 else 1}
        for f in self.foods
    },
    local x = -1,
    sign: if x > 0 then "positive" else if x < 0 then "negative" else "zero"
}
