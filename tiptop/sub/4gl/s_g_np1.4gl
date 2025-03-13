# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_g_np1.4gl    
# Descriptions...: 取得未沖金額
# Date & Author..: 02/03/09 By Danny
# Modify.........: No.FUN-4C0031 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改 
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.FUN-680022 06/10/13 By cl   多帳期處理
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6C0044 06/12/22 By Smapmin 修改回寫待抵已付金額
# Modify.........: No.FUN-720003 07/02/5 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-7B0005 07/11/01 By chenl   l_tmp定義錯誤，修正該錯誤。
# Modify.........: No.TQC-7B0035 07/11/07 By wujie   g_azi04是系統全局變量，不該在這里再次定義 
# Modify.........: No.FUN-7B0055 07/11/13 By Carrier 加入傳入參數p_seq1(多帳期項次)
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-990080 09/09/09 By mike p_sw = '1'段,計算未衝金額=本幣應收金額-本幣已衝金額+or-匯差,其中本幣已衝金額l_amt2
#                                                 當為大陸版時,需再扣去發票待扺的金額!請增加一l_amt3變數,抓取oot_file資料,LET l_np_a
# Modify.........: No:MOD-9C0107 09/12/14 By Sarah p_sw='2'段,沖暫估會寫入apg_file,故p_sw2='2'段也要計算apg_file
# Modify.........: No:MOD-AC0397 10/12/30 By wujie 按ooz62的取值来区分计算金额
# Modify.........: No:TQC-B80093 11/08/09 By Carrier AP且多帐期时oox10计算错误

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#modify 030213 NO.A048
FUNCTION s_g_np1(p_sw,p_sw2,p_no,p_seq,p_seq1)  #No.FUN-7B0055
  DEFINE p_sw    LIKE type_file.chr1         #No.FUN-680147 VARCHAR(1)    #1.AR  2.AP  3.NM
  DEFINE p_sw2   LIKE aba_file.aba18         #No.FUN-680147 VARCHAR(2)    #類別  AR/AP時, 1*:立帳  2*:待抵 
                                             # NM   時, 1:銀行存款  2:匯款入帳
                                             # NR   時, 1:收票             NO.A058
                                             # NP   時, 1:開票             NO.A058
  DEFINE p_no    LIKE oox_file.oox03         #No.FUN-680147 VARCHAR(16)  #單號         --No.FUN-560002
  DEFINE p_seq   LIKE type_file.num5         #No.FUN-680147 SMALLINT  #項次
  DEFINE p_seq1  LIKE type_file.num5         #No.FUN-7B0055
  DEFINE l_oox00 LIKE oox_file.oox00
  DEFINE l_oox01 LIKE oox_file.oox01
  DEFINE l_oox02 LIKE oox_file.oox02
  DEFINE l_oox10 LIKE oox_file.oox10
  DEFINE l_oox   RECORD LIKE oox_file.*
  DEFINE l_amt1,l_amt2,l_np_amt LIKE oma_file.oma56 #FUN-4C0031
  DEFINE l_amt3  LIKE nmg_file.nmg25 #FUN-4C0031
  DEFINE l_sql   LIKE type_file.chr1000      #No.FUN-680147 VARCHAR(1000)
# DEFINE g_azi04 LIKE azi_file.azi04         #No.CHI-6A0004    #No.TQC-7B0035
  #add 030306 NO.A048
 #DEFINE l_tmp   LIKE abh_file.abh05         #No.FUN-680147 DEC(15,3)  #No.TQC-7B0005 mark
  DEFINE l_tmp   LIKE aph_file.aph05         #No.TQC-7B0005
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF cl_null(p_no) THEN RETURN 0 END IF
  IF cl_null(p_seq) THEN LET p_seq = 0 END IF 
  IF cl_null(p_seq1) THEN LET p_seq1 = 0 END IF   #No.FUN-7B0055
#  SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17   #No.CHI-6A0004
 
  CASE p_sw
    WHEN '1'  LET l_oox00 = 'AR'     #應收帳款
    WHEN '2'  LET l_oox00 = 'AP'     #應付帳款
    WHEN '3'  LET l_oox00 = 'NM'     #銀行存款
    WHEN '4'  LET l_oox00 = 'NR'     #應收票據       NO.A058
    WHEN '5'  LET l_oox00 = 'NP'     #應付票據       NO.A058
  END CASE
#No.MOD-AC0397 --begin                                                          
#  LET l_sql = "SELECT SUM(oox10) FROM oox_file ",                              
#              " WHERE oox00 = '",l_oox00,"'",                                  
#              "   AND oox041 = ",p_seq1,                                       
#              "   AND oox03 = '",p_no,"' AND oox04 = ",p_seq                   
  IF l_oox00 = 'AR' THEN  #No.TQC-B80093 add
     IF g_ooz.ooz62 ='N' THEN                                                      
        LET l_sql = "SELECT SUM(oox10) FROM oox_file ",                            
                    " WHERE oox00 = '",l_oox00,"'",                                
                    "   AND oox041 = ",p_seq1,                                     
                    "   AND oox03 = '",p_no,"'"                                    
     ELSE                                                                          
        LET l_sql = "SELECT SUM(oox10) FROM oox_file ",                            
                    " WHERE oox00 = '",l_oox00,"'",                                
                    "   AND oox04 = ",p_seq,                                       
                    "   AND oox03 = '",p_no,"'"                                    
     END IF                                                                        
  #No.TQC-B80093  --Begin
  ELSE
     LET l_sql = "SELECT SUM(oox10) FROM oox_file ",
                 " WHERE oox00 = '",l_oox00,"'",
                 "   AND oox041 = ",p_seq1,
                 "   AND oox03 = '",p_no,"' AND oox04 = ",p_seq
  END IF
  #No.TQC-B80093  --End
#No.MOD-AC0397 --end 
  PREPARE s_g_np1_p1 FROM l_sql
  IF STATUS THEN 
# CALL cl_err('s_g_np1_p1',STATUS,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         LET g_showmsg = l_oox00,"/",p_no,"/",p_seq      
         CALL s_errmsg('oox00,oox03,oox04',g_showmsg,'s_g_np1_p1',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('s_g_np1_p1',STATUS,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
  RETURN 0 END IF
  DECLARE s_g_np1_c1 CURSOR FOR s_g_np1_p1
 
  OPEN s_g_np1_c1 
  IF STATUS THEN 
# CALL cl_err('s_g_np1_c1',STATUS,1) 
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','s_g_np1_c1',STATUS,1)                                                                                  
      ELSE                                                                                                                          
         CALL cl_err('s_g_np1_c1',STATUS,1)                                                                                          
      END IF                                                                                                                        
#No.FUN-720003--end           
  RETURN 0 END IF
  FETCH s_g_np1_c1 INTO l_oox10
  IF cl_null(l_oox10) THEN LET l_oox10 = 0 END IF
 
  LET l_np_amt = 0
 
  #modify 030213 NO.A048
  IF p_sw = '1' THEN   #AR
     IF p_sw2 MATCHES '1*' THEN
        IF p_seq = 0 THEN
           #No.FUN-7B0055  --Begin
           #p_seq = 0 代表不用omb單身衝帳,用omc_file
           #SELECT oma56t INTO l_amt1 FROM oma_file
           # WHERE oma01 = p_no 
           SELECT omc09 INTO l_amt1 FROM omc_file
            WHERE omc01 = p_no AND omc02 = p_seq1
           SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
            WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '2' 
              AND oob04 = '1' AND oob06 = p_no
              AND oob19 = p_seq1  #No.FUN-7B0055
           #No.FUN-7B0055  --End  
        ELSE
          #不使用omb項次衝,用omc多帳期衝
          #No.FUN-7B0055  --Begin
          ##No.FUN-680022--begin-- mark
          SELECT omb16t INTO l_amt1 FROM omb_file
           WHERE omb01 = p_no AND omb03 = p_seq
          SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
           WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '2' 
             AND oob04 = '1' AND oob06 = p_no AND oob15 = p_seq
          ##No.FUN-580022--end-- mark
          ##No.FUN-680022--begin-- add
          # SELECT omc09 INTO l_amt1 FROM omc_file
          #  WHERE omc01 = p_no AND omc02 = p_seq
          # SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
          #  WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '2' 
          #    AND oob04 = '1' AND oob06 = p_no AND oob19 = p_seq
          ##No.FUN-680022--end-- add
          #No.FUN-7B0055  --End 
        END IF
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        #MOD-990080   ---start                                                                                                       
        LET l_amt3=0                                                                                                                
        IF g_aza.aza26 = '2' THEN                                                                                                   
           SELECT SUM(oot05t) INTO l_amt3 FROM oot_file WHERE oot03 = p_no                                                          
           IF cl_null(l_amt3) THEN LET l_amt3=0 END IF                                                                              
        END IF                                                                                                                      
       ##未衝金額 = 本幣應收金額-本幣已衝金額+匯差                                                                                  
       #LET l_np_amt = l_amt1 - l_amt2 + l_oox10                                                                                    
        #未衝金額 = 本幣應收金額-本幣已衝金額-發票待扺金額+匯差                                                                     
         LET l_np_amt = l_amt1 - l_amt2 -l_amt3+ l_oox10                                                                            
       #MOD-990080   ---end             
        IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
     ELSE
        #待扺不會衝到omb項次,直接找omc就好了
        #No.FUN-7B0055  --Begin
        #SELECT oma56t INTO l_amt1 FROM oma_file
        # WHERE oma01 = p_no 
        SELECT omc09 INTO l_amt1 FROM omc_file
         WHERE omc01 = p_no AND omc02 = p_seq1
        SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
         WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' 
           AND oob04 = '3' AND oob06 = p_no
           AND oob19 = p_seq1
        #No.FUN-7B0055  --End  
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        #MOD-990080   ---start                                                                                                       
        LET l_amt3=0                                                                                                                
        IF g_aza.aza26 = '2' THEN                                                                                                   
           SELECT SUM(oot05t) INTO l_amt3 FROM oot_file WHERE oot03 = p_no                                                          
           IF cl_null(l_amt3) THEN LET l_amt3=0 END IF                                                                              
        END IF                                                                                                                      
       ##未衝金額 = 本幣應收金額-本幣已衝金額-匯差                                                                                  
       #LET l_np_amt = l_amt1 - l_amt2 - l_oox10                                                                                    
        #未衝金額 = 本幣應收金額-本幣已衝金額-發票呆待金額-匯差                                                                     
        LET l_np_amt = l_amt1 - l_amt2 - l_amt3 - l_oox10                                                                           
       #MOD-990080   ---end           
        IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
     END IF
  END IF
 
  #modify 030306 NO.A048
  IF p_sw = '2' THEN   #AP
     #No.FUN-7B0055  --Begin
     #SELECT apa34 INTO l_amt1 FROM apa_file WHERE apa01 = p_no 
     SELECT apc09-apc15 INTO l_amt1 FROM apc_file WHERE apc01 = p_no   #yinhy130508
        AND apc02 = p_seq1
     #No.FUN-7B0055  --End  
     LET l_amt2 = 0
     IF p_sw2 MATCHES '1*' THEN
        #付款沖帳
        SELECT SUM(apg05) INTO l_tmp FROM apg_file,apf_file
         WHERE apf01 = apg01 AND apf41 = 'Y' AND apg04 = p_no 
           AND apg06 = p_seq1  #No.FUN-7B0055
           AND apf01 NOT IN (SELECT ooa01 FROM ooa_file)
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
        #應收沖應付
        SELECT SUM(oob10) INTO l_tmp FROM oob_file,ooa_file
         WHERE oob01 = ooa01 AND ooaconf = 'Y' AND oob06 = p_no 
           AND oob19 = p_seq1  #No.FUN-7B0055
           AND oob03 = '1' AND oob04 = '9'
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
 
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1      #No.CHI-6A0004
        #未付金額 = 本幣應付金額-本幣已付金額-匯差
        LET l_np_amt = l_amt1 - l_amt2 - l_oox10
        IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
     ELSE
        #請款沖帳
        SELECT SUM(apv04) INTO l_tmp FROM apv_file,apa_file
         WHERE apv01 = apa01 AND apa41 = 'Y' AND apv03 = p_no 
           AND apv05 = p_seq1  #No.FUN-7B0055
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
       #str MOD-9C0107 add
        #沖暫估
        SELECT SUM(apg05) INTO l_tmp FROM apg_file,apf_file
         WHERE apg01 = apf01 AND apf41 = 'Y' AND apg04 = p_no
           AND apg06 = p_seq1
           AND apf01 NOT IN (SELECT ooa01 FROM ooa_file)
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
       #end MOD-9C0107 add
        #付款沖帳
        SELECT SUM(aph05) INTO l_tmp FROM aph_file,apf_file
         WHERE aph01 = apf01 AND apf41 = 'Y' AND aph04 = p_no 
           AND aph17 = p_seq1  #No.FUN-7B0055
           AND apf01 NOT IN (SELECT ooa01 FROM ooa_file)
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
        #應收沖應付
        SELECT SUM(oob10) INTO l_tmp FROM oob_file,ooa_file
         WHERE oob01 = ooa01 AND ooaconf = 'Y' AND oob06 = p_no 
           AND oob03 = '2' AND oob04 = '9'
           AND oob19 = p_seq1  #No.FUN-7B0055
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
        #-----TQC-6C0044---------
        #成本分攤
        SELECT SUM(aqb04) INTO l_tmp FROM aqa_file,aqb_file
         WHERE aqa01 = aqb01 AND aqa04='Y' AND aqaconf = 'Y'
           AND aqb02=p_no
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
        #-----END TQC-6C0044-----
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1       #No.CHI-6A0004
        #未付金額 = 本幣應付金額-本幣已付金額+匯差
        LET l_np_amt = l_amt1 - l_amt2 + l_oox10
        IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
     END IF
  END IF
 
  IF p_sw = '3' THEN    #NM
     SELECT nmg25 INTO l_amt1 FROM nmg_file WHERE nmg00 = p_no 
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
     CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1                 #No.CHI-6A0004
     #收款沖帳
     SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
      WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' AND oob04 = '2'
        AND oob06 = p_no
     IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#modify 030312 NO.A048
{
     #直接轉暫收款
     SELECT nmg25 INTO l_amt3 FROM nmg_file 
      WHERE nmg00 = p_no AND nmg29 ="Y" AND nmgconf = 'Y'
     IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
     LET l_amt2 = l_amt2 + l_amt3
}
     #未沖金額 = 本幣入帳金額-本幣已沖金額+匯差
     LET l_np_amt = l_amt1 - l_amt2 + l_oox10
     IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
  END IF
 
  #add 030421 NO.A058
  IF p_sw = '4' THEN    #NR
     SELECT nmh32 INTO l_amt1 FROM nmh_file WHERE nmh01 = p_no 
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
     CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1      #No.CHI-6A0004
     #收款沖帳
     SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
      WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' AND oob04 = '1'
        AND oob06 = p_no
     IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
 
     #未沖金額 = 本幣入帳金額-本幣已沖金額+匯差
     LET l_np_amt = l_amt1 - l_amt2 + l_oox10
     IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
  END IF
 
  #add 030421 NO.A058
  IF p_sw = '5' THEN    #NP
     SELECT nmd26 INTO l_amt1 FROM nmd_file WHERE nmd01 = p_no 
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
     CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1     #No.CHI-6A0004
 
     #未沖金額 = 本幣入帳金額-匯差
     LET l_np_amt = l_amt1 - l_oox10
     IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
  END IF
 
  RETURN l_np_amt
END FUNCTION

#str------ add by dengsy170326
FUNCTION s_g_np2(p_sw,p_sw2,p_no,p_seq,p_seq1,p_yy,p_mm)  #No.FUN-7B0055
  DEFINE p_sw    LIKE type_file.chr1         #No.FUN-680147 VARCHAR(1)    #1.AR  2.AP  3.NM
  DEFINE p_sw2   LIKE aba_file.aba18         #No.FUN-680147 VARCHAR(2)    #類別  AR/AP時, 1*:立帳  2*:待抵 
                                             # NM   時, 1:銀行存款  2:匯款入帳
                                             # NR   時, 1:收票             NO.A058
                                             # NP   時, 1:開票             NO.A058
  DEFINE p_no    LIKE oox_file.oox03         #No.FUN-680147 VARCHAR(16)  #單號         --No.FUN-560002
  DEFINE p_seq   LIKE type_file.num5         #No.FUN-680147 SMALLINT  #項次
  DEFINE p_seq1  LIKE type_file.num5         #No.FUN-7B0055
  DEFINE p_yy,p_mm	LIKE type_file.num5     #add by dengsy170326
  DEFINE l_oox00 LIKE oox_file.oox00
  DEFINE l_oox01 LIKE oox_file.oox01
  DEFINE l_oox02 LIKE oox_file.oox02
  DEFINE l_oox10 LIKE oox_file.oox10
  DEFINE l_oox   RECORD LIKE oox_file.*
  DEFINE l_amt1,l_amt2,l_np_amt LIKE oma_file.oma56 #FUN-4C0031
  DEFINE l_amt3  LIKE nmg_file.nmg25 #FUN-4C0031
  DEFINE l_sql   LIKE type_file.chr1000      #No.FUN-680147 VARCHAR(1000)
  DEFINE l_tmp   LIKE aph_file.aph05         #No.TQC-7B0005
  DEFINE l_year         LIKE type_file.num10  #add by dengsy170326
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF cl_null(p_no) THEN RETURN 0 END IF
  IF cl_null(p_seq) THEN LET p_seq = 0 END IF 
  IF cl_null(p_seq1) THEN LET p_seq1 = 0 END IF   #No.FUN-7B0055
 
  CASE p_sw
    WHEN '1'  LET l_oox00 = 'AR'     #應收帳款
    WHEN '2'  LET l_oox00 = 'AP'     #應付帳款
    WHEN '3'  LET l_oox00 = 'NM'     #銀行存款
    WHEN '4'  LET l_oox00 = 'NR'     #應收票據       NO.A058
    WHEN '5'  LET l_oox00 = 'NP'     #應付票據       NO.A058
  END CASE
                 
  IF l_oox00 = 'AR' THEN  #No.TQC-B80093 add
     IF g_ooz.ooz62 ='N' THEN                                                      
        LET l_sql = "SELECT SUM(oox10) FROM oox_file ",                            
                    " WHERE oox00 = '",l_oox00,"'",                                
                    "   AND oox041 = ",p_seq1,                                     
                    "   AND oox03 = '",p_no,"'" 
                    ," and oox01*12+oox02<=",p_yy,"*12+",p_mm #add by dengsy170326
     ELSE                                                                          
        LET l_sql = "SELECT SUM(oox10) FROM oox_file ",                            
                    " WHERE oox00 = '",l_oox00,"'",                                
                    "   AND oox04 = ",p_seq,                                       
                    "   AND oox03 = '",p_no,"'"  
                    ," and oox01*12+oox02<=",p_yy,"*12+",p_mm #add by dengsy170326
     END IF                                                                        
  #No.TQC-B80093  --Begin
  ELSE
     LET l_sql = "SELECT SUM(oox10) FROM oox_file ",
                 " WHERE oox00 = '",l_oox00,"'",
                 "   AND oox041 = ",p_seq1,
                 "   AND oox03 = '",p_no,"' AND oox04 = ",p_seq
                 ," and oox01*12+oox02<=",p_yy,"*12+",p_mm #add by dengsy170326
  END IF

  PREPARE s_g_np1_p12 FROM l_sql
  IF STATUS THEN 
                                                                                                              
      IF g_bgerr THEN                                                                                                               
         LET g_showmsg = l_oox00,"/",p_no,"/",p_seq      
         CALL s_errmsg('oox00,oox03,oox04',g_showmsg,'s_g_np1_p1',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('s_g_np1_p1',STATUS,1)                                                                             
      END IF                                                                                                                        
  RETURN 0 END IF
  DECLARE s_g_np1_c12 CURSOR FOR s_g_np1_p12
 
  OPEN s_g_np1_c12 
  IF STATUS THEN 
                                                                                                            
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','s_g_np1_c1',STATUS,1)                                                                                  
      ELSE                                                                                                                          
         CALL cl_err('s_g_np1_c1',STATUS,1)                                                                                          
      END IF                                                                                                                        
#No.FUN-720003--end           
  RETURN 0 END IF
  FETCH s_g_np1_c12 INTO l_oox10
  IF cl_null(l_oox10) THEN LET l_oox10 = 0 END IF
 
  LET l_np_amt = 0

  LET l_year=p_yy*12 +p_mm #add by dengsy170326
  IF p_sw = '1' THEN   #AR
     IF p_sw2 MATCHES '1*' THEN
        IF p_seq = 0 THEN
           SELECT omc09 INTO l_amt1 FROM omc_file
            WHERE omc01 = p_no AND omc02 = p_seq1
           SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
            WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '2' 
              AND oob04 = '1' AND oob06 = p_no
              AND oob19 = p_seq1  #No.FUN-7B0055
              AND year(ooa02)*12 + month(ooa02)<=l_year #add by dengsy170326
        ELSE
          SELECT omb16t INTO l_amt1 FROM omb_file
           WHERE omb01 = p_no AND omb03 = p_seq
          SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
           WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '2' 
             AND oob04 = '1' AND oob06 = p_no AND oob15 = p_seq
             AND year(ooa02)*12 + month(ooa02)<=l_year #add by dengsy170326
        END IF
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        #MOD-990080   ---start                                                                                                       
        LET l_amt3=0                                                                                                                
        IF g_aza.aza26 = '2' THEN                                                                                                   
           SELECT SUM(oot05t) INTO l_amt3 FROM oot_file WHERE oot03 = p_no                                                          
           IF cl_null(l_amt3) THEN LET l_amt3=0 END IF                                                                              
        END IF                                                                                                                      
       ##未衝金額 = 本幣應收金額-本幣已衝金額+匯差                                                                                  
       #LET l_np_amt = l_amt1 - l_amt2 + l_oox10                                                                                    
        #未衝金額 = 本幣應收金額-本幣已衝金額-發票待扺金額+匯差                                                                     
         LET l_np_amt = l_amt1 - l_amt2 -l_amt3+ l_oox10                                                                            
       #MOD-990080   ---end             
        IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
     ELSE
        #待扺不會衝到omb項次,直接找omc就好了
        #No.FUN-7B0055  --Begin
        #SELECT oma56t INTO l_amt1 FROM oma_file
        # WHERE oma01 = p_no 
        SELECT omc09 INTO l_amt1 FROM omc_file
         WHERE omc01 = p_no AND omc02 = p_seq1
        SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
         WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' 
           AND oob04 = '3' AND oob06 = p_no
           AND oob19 = p_seq1
           AND year(ooa02)*12 + month(ooa02)<=l_year #add by dengsy170326
        #No.FUN-7B0055  --End  
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        #MOD-990080   ---start                                                                                                       
        LET l_amt3=0                                                                                                                
        IF g_aza.aza26 = '2' THEN                                                                                                   
           SELECT SUM(oot05t) INTO l_amt3 FROM oot_file WHERE oot03 = p_no                                                          
           IF cl_null(l_amt3) THEN LET l_amt3=0 END IF                                                                              
        END IF                                                                                                                      
       ##未衝金額 = 本幣應收金額-本幣已衝金額-匯差                                                                                  
       #LET l_np_amt = l_amt1 - l_amt2 - l_oox10                                                                                    
        #未衝金額 = 本幣應收金額-本幣已衝金額-發票呆待金額-匯差                                                                     
        LET l_np_amt = l_amt1 - l_amt2 - l_amt3 - l_oox10                                                                           
       #MOD-990080   ---end           
        IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
     END IF
  END IF
 
  #modify 030306 NO.A048
  IF p_sw = '2' THEN   #AP
     #No.FUN-7B0055  --Begin
     #SELECT apa34 INTO l_amt1 FROM apa_file WHERE apa01 = p_no 
     SELECT apc09-apc15 INTO l_amt1 FROM apc_file WHERE apc01 = p_no   #yinhy130508
        AND apc02 = p_seq1
     #No.FUN-7B0055  --End  
     LET l_amt2 = 0
     IF p_sw2 MATCHES '1*' THEN
        #付款沖帳
        SELECT SUM(apg05) INTO l_tmp FROM apg_file,apf_file
         WHERE apf01 = apg01 AND apf41 = 'Y' AND apg04 = p_no 
           AND apg06 = p_seq1  #No.FUN-7B0055
           AND apf01 NOT IN (SELECT ooa01 FROM ooa_file)
           AND year(apf02)*12 + month(apf02)<=l_year #add by dengsy170326
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
        #應收沖應付
        SELECT SUM(oob10) INTO l_tmp FROM oob_file,ooa_file
         WHERE oob01 = ooa01 AND ooaconf = 'Y' AND oob06 = p_no 
           AND oob19 = p_seq1  #No.FUN-7B0055
           AND oob03 = '1' AND oob04 = '9'
           AND year(ooa02)*12 + month(ooa02)<=l_year #add by dengsy170326
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
 
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1      #No.CHI-6A0004
        #未付金額 = 本幣應付金額-本幣已付金額-匯差
        LET l_np_amt = l_amt1 - l_amt2 - l_oox10
        IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
     ELSE
        #請款沖帳
        SELECT SUM(apv04) INTO l_tmp FROM apv_file,apa_file
         WHERE apv01 = apa01 AND apa41 = 'Y' AND apv03 = p_no 
           AND apv05 = p_seq1  #No.FUN-7B0055
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
       #str MOD-9C0107 add
        #沖暫估
        SELECT SUM(apg05) INTO l_tmp FROM apg_file,apf_file
         WHERE apg01 = apf01 AND apf41 = 'Y' AND apg04 = p_no
           AND apg06 = p_seq1
           AND apf01 NOT IN (SELECT ooa01 FROM ooa_file)
           AND year(apf02)*12 + month(apf02)<=l_year #add by dengsy170326
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
       #end MOD-9C0107 add
        #付款沖帳
        SELECT SUM(aph05) INTO l_tmp FROM aph_file,apf_file
         WHERE aph01 = apf01 AND apf41 = 'Y' AND aph04 = p_no 
           AND aph17 = p_seq1  #No.FUN-7B0055
           AND apf01 NOT IN (SELECT ooa01 FROM ooa_file)
           AND year(apf02)*12 + month(apf02)<=l_year #add by dengsy170326
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
        #應收沖應付
        SELECT SUM(oob10) INTO l_tmp FROM oob_file,ooa_file
         WHERE oob01 = ooa01 AND ooaconf = 'Y' AND oob06 = p_no 
           AND oob03 = '2' AND oob04 = '9'
           AND oob19 = p_seq1  #No.FUN-7B0055
           AND year(ooa02)*12 + month(ooa02)<=l_year #add by dengsy170326
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
        #-----TQC-6C0044---------
        #成本分攤
        SELECT SUM(aqb04) INTO l_tmp FROM aqa_file,aqb_file
         WHERE aqa01 = aqb01 AND aqa04='Y' AND aqaconf = 'Y'
           AND aqb02=p_no
           AND year(aqa02)*12 + month(aqa02)<=l_year #add by dengsy170326
        IF cl_null(l_tmp) THEN LET l_tmp = 0 END IF
        LET l_amt2 = l_amt2 + l_tmp
        #-----END TQC-6C0044-----
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1       #No.CHI-6A0004
        #未付金額 = 本幣應付金額-本幣已付金額+匯差
        LET l_np_amt = l_amt1 - l_amt2 + l_oox10
        IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
     END IF
  END IF
 
  IF p_sw = '3' THEN    #NM
     SELECT nmg25 INTO l_amt1 FROM nmg_file WHERE nmg00 = p_no 
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
     CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1                 #No.CHI-6A0004
     #收款沖帳
     SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
      WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' AND oob04 = '2'
        AND oob06 = p_no
        AND year(ooa02)*12 + month(ooa02)<=l_year #add by dengsy170326
     IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#modify 030312 NO.A048
{
     #直接轉暫收款
     SELECT nmg25 INTO l_amt3 FROM nmg_file 
      WHERE nmg00 = p_no AND nmg29 ="Y" AND nmgconf = 'Y'
     IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
     LET l_amt2 = l_amt2 + l_amt3
}
     #未沖金額 = 本幣入帳金額-本幣已沖金額+匯差
     LET l_np_amt = l_amt1 - l_amt2 + l_oox10
     IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
  END IF
 
  #add 030421 NO.A058
  IF p_sw = '4' THEN    #NR
     SELECT nmh32 INTO l_amt1 FROM nmh_file WHERE nmh01 = p_no 
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
     CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1      #No.CHI-6A0004
     #收款沖帳
     SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file
      WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' AND oob04 = '1'
        AND oob06 = p_no
        AND year(ooa02)*12 + month(ooa02)<=l_year #add by dengsy170326
     IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
 
     #未沖金額 = 本幣入帳金額-本幣已沖金額+匯差
     LET l_np_amt = l_amt1 - l_amt2 + l_oox10
     IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
  END IF
 
  #add 030421 NO.A058
  IF p_sw = '5' THEN    #NP
     SELECT nmd26 INTO l_amt1 FROM nmd_file WHERE nmd01 = p_no 
     IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
     CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1     #No.CHI-6A0004
 
     #未沖金額 = 本幣入帳金額-匯差
     LET l_np_amt = l_amt1 - l_oox10
     IF cl_null(l_np_amt) THEN LET l_np_amt = 0 END IF
  END IF
 
  RETURN l_np_amt
END FUNCTION
#end------ add by dengsy170326