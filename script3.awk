BEGIN {
        no = 0
        avgSum = 0
        print "Imie\tNazwisko\tEmail\tLiczba Wyników\tSuma\tŚrednia\tŚrednia bez min i max"
}
{
        if (NF > 1) {
                no += 1
                suma=0
                for (i = NF; i > 3; i--) {
                        suma += $i
                }
                nOcen = NF-3
                srednia = suma / nOcen
                avgSum += srednia
                nMax = 0
                max = -inf
                nMin = 0
                min = inf
                for (i = NF; i > 3; i--) {
                        if ($i > max) {
                                if (max == $i) {
                                        nMax += 1
                                } else {
                                        max = $i
                                        nMax = 1
                                }
                        }
                        if ($i < min) {
                                if (min == $i) {
                                        nMin += 1
                                } else {
                                        min = $i
                                        nMin = 1
                                }
                        }
                }

                sredniaBezMinMax = (suma - (min * nMin) - (max * nMax)) / (nOcen - nMin - nMax)
                print $1 "\t" $2 "\t" $3 "\t" nOcen "\t" suma "\t" srednia "\t" sredniaBezMinMax
        }
}
END {
        print "Średnia średnich: " avgSum / no
}
