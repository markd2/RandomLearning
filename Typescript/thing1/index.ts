import * as _ from 'lodash'

console.log("Snorgle")

async function hello() {
    return "snorgle"
}


let lucky = 23;
// lucky = '23'; // error

let unlucky: any = 23;
unlucky = '23';

// let blah: number = 'string';  // annotation

type TypeName = string;
let blargh: TypeName;

// union type

type Style = 'bold' | 'italic' | 23;
let font2: Style;

// enforce shapes with interface

interface Person {
    first: string;
    last: string;
    [key: string]: any;  // allow things like "cute" below
}

const person: Person = {
    first: 'Bob',
    last: 'Cat'
}

const person2: Person = {
    first: "Hoover",
    last: "Cat",
    cute: true
}

