require 'csv'

maxA = 40 # numero massimo armate in Attacco
maxD = 40 # numero massimo armate in Difesa
results = Array.new(maxA+1) { Array.new(maxD+1) }
# @n esprime il numero di iterazioni per calcolare probabilità
# più alto è @n, più è precisa la stima, più lento è il calcolo
@n = 10000 # 1000000

def ld # lancio dado
  rand(1..6)
end

def lancia_dadi_per(armate)
  a = (armate <= 3 ? armate : 3)
  dadi = []
  armate.times do |i|
    dadi[i] = ld
  end
  dadi
end

# Date le configurazioni dei dadi in attacco `dadiA` e dei dati in difesa `dadiD`,
# restituisce le armate perse in un hash
# armate_perse[:A] => armate perse dall'attacco
# armate_perse[:d] => armate perse dalla difesa
def calcola_perdite(dadiA, dadiD)
  dadiA.sort!; dadiD.sort! # ordino i dadi lanciati da difesa e attacco per valore
  armate_perse = { A: 0, D: 0 }
  # confronto i dadi uno a uno partendo dai maggiori e li elimino
  # finché ci sono dadi da confrontare
  while dadiA.length > 0 && dadiD.length > 0
    if dadiA.pop > dadiD.pop
      armate_perse[:D] += 1
    else
      armate_perse[:A] += 1
    end
  end
  return armate_perse
end

maxA.times do |a|
  maxD.times do |d|
    vA = 0 # contatore vittorie A
    @n.times do |n|
      armateA = a + 1
      armateD = d + 1
      while (armateA > 0 && armateD > 0) do
        dadiA = lancia_dadi_per(armateA)
        dadiD = lancia_dadi_per(armateD)
        armate_perse = calcola_perdite(dadiA, dadiD)
        armateA = armateA - armate_perse[:A]
        armateD = armateD - armate_perse[:D]
      end
      vA += 1 if armateA > 0
      # saves time on almost deterministic games
      if n > 1000 && vA <= 10 || n < 1000 && vA >= 990
        results[d][a] = (vA/(n+1).to_f)
        break
      end
    end
    results[d][a] = (vA/@n.to_f) unless results[d][a]
    puts "[#{d}][#{a}] => #{results[d][a]}"
  end
end

CSV.open("results.csv", "w") do |csv|
  maxA.times do |i|
    csv << results [i]
  end
end
