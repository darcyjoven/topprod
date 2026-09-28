# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Library name...: s_ogc_amt
# Descriptions...: 計算成品替代分攤後的金額
# Date & Author..: 13/01/30 By Alberti #CHI-A70023
# Modify.........: No:MOD-C60176 13/01/30 By Alberti 新增s_ogc_amt_2，除l_amt抓取ogb14*oga24外，其餘處理皆與s_ogc_amt_1相同

DATABASE ds        

FUNCTION s_ogc_amt(p_ima01,p_tlf026,p_tlf027,p_dbs)
 DEFINE p_ima01        LIKE ima_file.ima01
 DEFINE p_tlf026       LIKE tlf_file.tlf026
 DEFINE p_tlf027       LIKE tlf_file.tlf027
 DEFINE p_dbs          LIKE azp_file.azp03              
 DEFINE l_ogb12        LIKE ogb_file.ogb12 
 DEFINE l_ogc12        LIKE ogc_file.ogc12 
 DEFINE l_ogc17        LIKE ogc_file.ogc17 
 DEFINE l_qty          LIKE ima_file.ima26           
 DEFINE l_amt          LIKE type_file.num20_6               
 DEFINE l_amt1         LIKE type_file.num20_6               
 DEFINE l_amt2         LIKE type_file.num20_6               
 DEFINE l_unit         LIKE azj_file.azj03          
 DEFINE l_ogb917       LIKE ogb_file.ogb917          
 DEFINE l_sql          STRING
    
    IF cl_null(p_dbs) THEN
       LET l_sql = " SELECT ogc12,ogc17 FROM ogc_file WHERE ogc01 = '",p_tlf026,"' ",
                   " AND ogc03 = ",p_tlf027 ,
                   " ORDER BY ogc12,ogc17 "
    ELSE
       LET l_sql = " SELECT ogc12,ogc17 FROM ",p_dbs CLIPPED,"ogc_file WHERE ogc01 = '",p_tlf026,"' ",
                   " AND ogc03 = ",p_tlf027 ,
                   " ORDER BY ogc12,ogc17 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    END IF

   PREPARE ogc_p FROM l_sql
   DECLARE ogc_c CURSOR WITH HOLD FOR ogc_p

    SELECT SUM(omb12),SUM(omb16) INTO l_qty,l_amt FROM omb_file,oma_file
            WHERE omb31=p_tlf026 AND omb32=p_tlf027 AND oma00 MATCHES '1*'
            AND oma01 = omb01 AND omaconf='Y'
    
    SELECT ogb12,ogb917 INTO l_ogb12,l_ogb917 FROM ogb_file,oga_file 
           WHERE ogb01 = p_tlf026 AND ogb03 = p_tlf027
             AND ogb01=oga01 AND ogapost = 'Y'
    
    IF l_qty IS NULL THEN LET l_qty=0 END IF
    IF l_amt IS NULL THEN LET l_amt=0 END IF
    IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF
    IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF

    IF l_qty<l_ogb917 THEN  
       SELECT ogb13*oga24 INTO l_unit FROM oga_file,ogb_file #原出貨單本幣單價
        WHERE oga01=ogb01 AND oga01=p_tlf026 AND ogb03=p_tlf027
    
       IF cl_null(l_unit) THEN LET l_unit = 0 END IF
       LET l_amt = l_amt + (l_ogb917-l_qty)*l_unit   
    END IF
    LET l_amt1 = 0 
    LET l_amt2 = 0 
    LET l_ogc12 = 0 
    LET l_ogc17 = NULL  
    FOREACH ogc_c INTO l_ogc12,l_ogc17
       LET l_amt1 = l_amt1 + (l_amt * l_ogc12 / l_ogb12)
       IF l_ogc17 = p_ima01 THEN
          LET l_amt2 = l_amt * l_ogc12 / l_ogb12
       END IF
    END FOREACH
   #將尾差調整到數量最大的那一筆
    IF l_amt1 != l_amt THEN
       IF l_ogc17 = p_ima01 THEN
          LET l_amt2 = l_amt2 + (l_amt - l_amt1)
       END IF
    END IF
    RETURN l_amt2
END FUNCTION

FUNCTION s_ogc_amt_1(p_ima01,p_tlf026,p_tlf027,p_tlf902,p_tlf903,p_tlf904,p_dbs)
 DEFINE p_ima01        LIKE ima_file.ima01
 DEFINE p_tlf026       LIKE tlf_file.tlf026
 DEFINE p_tlf027       LIKE tlf_file.tlf027
 DEFINE p_tlf902       LIKE tlf_file.tlf902   
 DEFINE p_tlf903       LIKE tlf_file.tlf903   
 DEFINE p_tlf904       LIKE tlf_file.tlf904   
 DEFINE p_dbs          LIKE azp_file.azp03              
 DEFINE l_ogb12        LIKE ogb_file.ogb12 
 DEFINE l_ogc12        LIKE ogc_file.ogc12 
 DEFINE l_ogc17        LIKE ogc_file.ogc17 
 DEFINE l_ogc09        LIKE ogc_file.ogc09
 DEFINE l_ogc091       LIKE ogc_file.ogc091
 DEFINE l_ogc092       LIKE ogc_file.ogc092
 DEFINE l_qty          LIKE ima_file.ima26           
 DEFINE l_amt          LIKE type_file.num20_6               
 DEFINE l_amt1         LIKE type_file.num20_6               
 DEFINE l_amt2         LIKE type_file.num20_6               
 DEFINE l_unit         LIKE azj_file.azj03          
 DEFINE l_ogb917       LIKE ogb_file.ogb917          
 DEFINE l_sql          STRING
    
    IF cl_null(p_dbs) THEN
       LET l_sql = " SELECT ogc12,ogc17,ogc09,ogc091,ogc092 FROM ogc_file WHERE ogc01 = '",p_tlf026,"' ",
                   " AND ogc03 = ",p_tlf027 ,
                   " ORDER BY ogc12,ogc17 "
    ELSE
       LET l_sql = " SELECT ogc12,ogc17,ogc09,ogc091,ogc092 FROM ",p_dbs CLIPPED,"ogc_file WHERE ogc01 = '",p_tlf026,"' ",
                   " AND ogc03 = ",p_tlf027 ,
                   " ORDER BY ogc12,ogc17 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    END IF

   PREPARE ogc_p_1 FROM l_sql
   DECLARE ogc_c_1 CURSOR WITH HOLD FOR ogc_p_1

    SELECT SUM(omb12),SUM(omb16) INTO l_qty,l_amt FROM omb_file,oma_file
            WHERE omb31=p_tlf026 AND omb32=p_tlf027 AND oma00 MATCHES '1*'
            AND oma01 = omb01 AND omaconf='Y'
    
    SELECT ogb12,ogb917 INTO l_ogb12,l_ogb917 FROM ogb_file,oga_file 
           WHERE ogb01 = p_tlf026 AND ogb03 = p_tlf027
             AND ogb01=oga01 AND ogapost = 'Y'
    
    IF l_qty IS NULL THEN LET l_qty=0 END IF
    IF l_amt IS NULL THEN LET l_amt=0 END IF
    IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF
    IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF

    IF l_qty<l_ogb917 THEN  
       SELECT ogb13*oga24 INTO l_unit FROM oga_file,ogb_file #原出貨單本幣單價
        WHERE oga01=ogb01 AND oga01=p_tlf026 AND ogb03=p_tlf027
    
       IF cl_null(l_unit) THEN LET l_unit = 0 END IF
       LET l_amt = l_amt + (l_ogb917-l_qty)*l_unit   
    END IF
    LET l_amt1 = 0 
    LET l_amt2 = 0 
    LET l_ogc12 = 0 
    LET l_ogc17 = NULL  
    LET l_ogc09 = NULL
    LET l_ogc091 = NULL
    LET l_ogc092 = NULL
    FOREACH ogc_c_1 INTO l_ogc12,l_ogc17,l_ogc09,l_ogc091,l_ogc092
       LET l_amt1 = l_amt1 + (l_amt * l_ogc12 / l_ogb12)
       IF l_ogc17 = p_ima01 AND l_ogc09 = p_tlf902 AND
          l_ogc091 = p_tlf903 AND l_ogc092 = p_tlf904 THEN
          LET l_amt2 = l_amt * l_ogc12 / l_ogb12
       END IF
    END FOREACH
   #將尾差調整到數量最大的那一筆
    IF l_amt1 != l_amt THEN
       IF l_ogc17 = p_ima01 AND l_ogc09 = p_tlf902 AND
          l_ogc091 = p_tlf903 AND l_ogc092 = p_tlf904 THEN
          LET l_amt2 = l_amt2 + (l_amt - l_amt1)
       END IF
    END IF
    RETURN l_amt2
END FUNCTION

#MOD-C60176 str add--------
FUNCTION s_ogc_amt_2(p_ima01,p_tlf026,p_tlf027,p_tlf902,p_tlf903,p_tlf904,p_dbs)
 DEFINE p_ima01        LIKE ima_file.ima01
 DEFINE p_tlf026       LIKE tlf_file.tlf026
 DEFINE p_tlf027       LIKE tlf_file.tlf027
 DEFINE p_tlf902       LIKE tlf_file.tlf902   
 DEFINE p_tlf903       LIKE tlf_file.tlf903   
 DEFINE p_tlf904       LIKE tlf_file.tlf904   
 DEFINE p_dbs          LIKE azp_file.azp03              
 DEFINE l_ogb12        LIKE ogb_file.ogb12 
 DEFINE l_ogc12        LIKE ogc_file.ogc12 
 DEFINE l_ogc17        LIKE ogc_file.ogc17 
 DEFINE l_ogc09        LIKE ogc_file.ogc09
 DEFINE l_ogc091       LIKE ogc_file.ogc091
 DEFINE l_ogc092       LIKE ogc_file.ogc092
 DEFINE l_qty          LIKE ima_file.ima26           
 DEFINE l_amt          LIKE type_file.num20_6               
 DEFINE l_amt1         LIKE type_file.num20_6               
 DEFINE l_amt2         LIKE type_file.num20_6               
 DEFINE l_unit         LIKE azj_file.azj03          
 DEFINE l_ogb917       LIKE ogb_file.ogb917          
 DEFINE l_sql          STRING
    
    IF cl_null(p_dbs) THEN
       LET l_sql = " SELECT ogc12,ogc17,ogc09,ogc091,ogc092 FROM ogc_file WHERE ogc01 = '",p_tlf026,"' ",
                   " AND ogc03 = ",p_tlf027 ,
                   " ORDER BY ogc12,ogc17 "
    ELSE
       LET l_sql = " SELECT ogc12,ogc17,ogc09,ogc091,ogc092 FROM ",p_dbs CLIPPED,"ogc_file WHERE ogc01 = '",p_tlf026,"' ",
                   " AND ogc03 = ",p_tlf027 ,
                   " ORDER BY ogc12,ogc17 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    END IF

   PREPARE ogc_p_2 FROM l_sql
   DECLARE ogc_c_2 CURSOR WITH HOLD FOR ogc_p_2

    SELECT SUM(omb12),SUM(ogb14*oga24) INTO l_qty,l_amt FROM omb_file,oma_file,oga_file,ogb_file
           WHERE omb31 = p_tlf026 AND omb32 = p_tlf027 AND oma00 MATCHES '1*'
             AND oma01 = omb01 AND omaconf = 'Y'
             AND ogb01 = omb31 AND ogb03 = omb32 
             AND oga01 = ogb01
    
    SELECT ogb12,ogb917 INTO l_ogb12,l_ogb917 FROM ogb_file,oga_file 
           WHERE ogb01 = p_tlf026 AND ogb03 = p_tlf027
             AND ogb01=oga01 AND ogapost = 'Y'
    
    IF l_qty IS NULL THEN LET l_qty=0 END IF
    IF l_amt IS NULL THEN LET l_amt=0 END IF
    IF cl_null(l_ogb917) THEN LET l_ogb917 = 0 END IF
    IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF

    IF l_qty<l_ogb917 THEN  
       SELECT ogb13*oga24 INTO l_unit FROM oga_file,ogb_file #原出貨單本幣單價
        WHERE oga01=ogb01 AND oga01=p_tlf026 AND ogb03=p_tlf027
    
       IF cl_null(l_unit) THEN LET l_unit = 0 END IF
       LET l_amt = l_amt + (l_ogb917-l_qty)*l_unit   
    END IF
    LET l_amt1 = 0 
    LET l_amt2 = 0 
    LET l_ogc12 = 0 
    LET l_ogc17 = NULL  
    LET l_ogc09 = NULL
    LET l_ogc091 = NULL
    LET l_ogc092 = NULL
    FOREACH ogc_c_2 INTO l_ogc12,l_ogc17,l_ogc09,l_ogc091,l_ogc092
       LET l_amt1 = l_amt1 + (l_amt * l_ogc12 / l_ogb12)
       IF l_ogc17 = p_ima01 AND l_ogc09 = p_tlf902 AND
          l_ogc091 = p_tlf903 AND l_ogc092 = p_tlf904 THEN
          LET l_amt2 = l_amt * l_ogc12 / l_ogb12
       END IF
    END FOREACH
   #將尾差調整到數量最大的那一筆
    IF l_amt1 != l_amt THEN
       IF l_ogc17 = p_ima01 AND l_ogc09 = p_tlf902 AND
          l_ogc091 = p_tlf903 AND l_ogc092 = p_tlf904 THEN
          LET l_amt2 = l_amt2 + (l_amt - l_amt1)
       END IF
    END IF
    RETURN l_amt2
END FUNCTION
#MOD-C60176 end add--------
#-----CHI-A70023-----

