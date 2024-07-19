# HW1 Report

##### r12921059 鄧雅文

## 1A

* 使用TerraER進行繪製

* 結果如圖:

  ![](C:\Users\betty\OneDrive\Desktop\graduate\course\SQL\hw1\1A.png)

## 1B

* 結果如圖:

  ![](C:\Users\betty\OneDrive\Desktop\graduate\course\SQL\hw1\1B.png)

## 1C

* **Basic:**
  1. Database name: Palworld Database
  2. Entity type: ```Pal```(帕魯), ```Element```(屬性), ```Fire```, ```Water```, ```Electro```, ```Ground```, ```Grass```, ```Skill```(技能), ```Passive```, ```Active```, ```Material```(素材), ```Infrastructure```(基礎設施), ```SAN```, ```Healing```
  3. Relationship names: ```Obtain```, ```Belong``` *2, ```Use```, ```Built_by```, ```Composite```, ```Supress``` *5
  4. Attribute names: (太多了... 直接看diagram比較快，都寫在裡面了)

* **Description:**
  1. Pals can "OBTAIN" some Skills.
  2. Pals can "BELONG" to some Elements.
  3. Every Skill must "BELONG" to  an element.
  4. Pals may "USE" one or more Infrastructures.
  5. All Infrastructure must be "BUILT_BY" some materials.
  6.  Materials also can be "COMPOSITED" by some other Materials.
  7. All Water can "SUPRESS" All Fire.
  8. All Fire can "SUPRESS" All Grass.
  9. All Grass can "SUPRESS" All Ground.
  10. All Ground can "SUPRESS" All Electro.
  11. All Electro can "SUPRESS" All Water.

* 結果如圖:

  ![](C:\Users\betty\OneDrive\Desktop\graduate\course\SQL\hw1\1C.png)



## Reference

[1] https://paldb.cc/en/

[2] https://palworld.fandom.com/wiki/Elements