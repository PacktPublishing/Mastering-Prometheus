{
    local parentObject = {
        parentField:: "Hello, from the parent!"
    },

    topField:: "Hello, from the top!",
    
    child: parentObject + {
        childField:: "Hello from the child!",
        a: $.topField,
        b: super.parentField,
        c: self.childField
    }
}
