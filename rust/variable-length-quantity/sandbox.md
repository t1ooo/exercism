var dec_to_bin = (num) => {
    const res = [];
    while(true)  {
        res.push(num % 2);
        num = Math.trunc(num / 2);
        if (num <= 0) {break;}
    }
    return res.reverse();
}

var dec_to_128 = (num) => {
    const res = [];
    while(true)  {
        res.push(num % 128);
        num = Math.trunc(num / 128);
        if (num <= 0) {break;}
    }
    return res.reverse();
}

var dec_to_base = (num, base) => {
    const res = [];
    while(true)  {
        res.push(num % base);
        num = Math.trunc(num / base);
        if (num <= 0) {break;}
    }
    return res.reverse();
}

var split = (bits, limit) => {
    const slices = [];
    const rbits = bits.reverse();
    for (let i=0; i<bits.length; i+=limit) {
        let slice = rbits.slice(i, i+limit).reverse();
        //console.log(slice);
        slice = [...Array(limit-slice.length).fill(0), ...slice];
        slices.push(slice);
    }
    return slices;
}

/*var prepend = (split) => {
    const res = []
    for (let i=0; i<split.length; i++) {
        if (i === split.length - 1 && split.length !== 1) {
            res.push([1, ...split[i]]);
        } else {
            res.push([0, ...split[i]]);
        }
    }
    return res;
}*/
var prepend = (split) => {
    const res = []
    for (let i=0; i<split.length; i++) {
        if (i === 0) {
            res.push([0, ...split[i]]);
        } else {
            res.push([1, ...split[i]]);
        }
    }
    return res;
}

var encodeNum = (num_b16) => {
    var num_b10 = parseInt(num_b16, 16);
    var bits = dec_to_base(num_b10, 2);
    var split_bits = split(bits, 7);
    var prep_bits = prepend(split_bits);
    console.log("prep_bits", prep_bits);
    //var encode = prep_bits.map(x => x.join("")).join("");
    return prep_bits.map(x => parseInt(x.join(""), 2).toString(16)).reverse();
}

var encode = (nums_b16) => {
    //return nums_b16.flatMap(x => encodeNum(x));
    const res = [];
    nums_b16.forEach(x => res.push(...encodeNum(x)));
    return res;
}

var decode = (encoded_nums_b16) => {
    const res = [];
    const limit = 8;
    let buff = [];
    for (let i=0; i<encoded_nums_b16.length; i++) {
        const e_num_b16 = encoded_nums_b16[i];
        const e_num_b10 = parseInt(e_num_b16, 16);
        const bits = dec_to_base(e_num_b10, 2);
        const bits_filled = [...Array(limit-bits.length).fill(0), ...bits];
        //console.log(bits_filled);
        buff.push(bits_filled);
        if (bits_filled[0] === 0) {
            //console.log(buff);
            const num_b2 = buff.map(x => x.slice(1).join("")).join("");
            //console.log(parseInt(num_base2, 2));
            const num_base10 = parseInt(num_b2, 2);
            const num_base16 = num_base10.toString(16)
            res.push(num_base16);
            buff = [];
        }
    }
    if (res.length === 0) {
        throw new Error("incomplete_number");
    }
    return res;
}

console.log(encode(["4000"]));
//console.log(decode(encode(["4000"])));