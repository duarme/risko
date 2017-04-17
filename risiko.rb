@a = 3 # numero armate in Attacco
@d = 1 # numero armate in Difesa

# @n esprime il numero di iterazioni per calcolare probabilità
# più alto è @n, più è precisa la stima, più lento è il calcolo
@n = 1000

def ld # lancio dado
  rand(1..6)
end

# Date le configurazioni dei dadi in attacco `dadiA` e dei dati in difesa `dadiD`,
# restituisce le armate perse in un hash
# armate_perse[:a] => armate perse dall'attacco
# armate_perse[:d] => armate perse dalla difesa
def calcola_perdite(dadiA, dadiD)
  dadiA.sort!; dadiD.sort! # ordino i dadi lanciati da difesa e attacco per valore
  armate_perse = {a: 0, d: 0}
  # confronto i dadi uno a uno partendo dai maggiori e li elimino
  # finché ci sono dadi da confrontare
  while dadiA.length > 0 && dadiD.length > 0
    if dadiA.pop > dadiD.pop
      armate_perse[:d] += 1
    else
      armate_perse[:a] += 1
    end
  end
  return armate_perse
end

def lanciatore_dadi_per(n_armate)
  raise "Massimo 3 dadi!" if n_armate > 3
  dadi = []
  index = 0
  n_armate.times do
    dadi[index] = ld
    index += 1
  end
  dadi
end

puts "Armate in Attacco = #{@a}"
puts "Armate in Difesa  = #{@d}"
print "Probabilità di vittoria attaccando con 3 dadi alla volta:"
p = 0 # probabilità vittoria
@n.times do
  dadiA = lanciatore_dadi_per(@a)
  dadiD = lanciatore_dadi_per(@d)
  armate_perse = calcola_perdite(dadiA, dadiD)
  if armate_perse[:d] == 1 # vittoria A
    p += 1
  end
end
p = (p/@n.to_f) * 100
puts "#{p.round(2)}%"

# TODO: casi in cui si tirano i dadi più volte
