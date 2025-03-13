# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: sapcp200_oha.4gl
# Description....: 提供sapcp200.4gl使用的sub routine/sapcp200_oha.4gl
# Date & Author..: 10/10/13 by suncx (FUN-A90040)
# Modify.........: No.FUN-AB0061 10/11/18 By chenying 修改分攤折價
# Modify.........: No.FUN-AC0002 10/11/20 By suncx 增加參數fno 
# Modify.........: No:TQC-B10099 11/01/12 By shiwuying 重新过单
# Modify.........: No:TQC-B20181 11/03/08 By wangxin 將上傳不成功的資料匯入log查詢檔
# Modify.........: No:FUN-B40017 11/04/08 By wangxin sapcp200_oha調整
# Modify.........: No:FUN-B40017 11/04/12 By wangxin POS單項售調整
# Modify.........: No:TQC-B40145 11/04/19 By wangxin POS會員銷售調整
# Modify.........: No:TQC-B40174 11/04/22 By wangxin 聯營及非企業料號不異動img及tlf
# Modify.........: No:FUN-B40084 11/04/26 By wangxin 聯營及非企業料號傳參調整
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No.FUN-B70101 11/07/25 By huangtao img資料抓取改為跨庫方式
# Modify.........: No.MOD-B80035 11/08/03 By huangtao 異動數量取絕對值
# Modify.........: No.TQC-B80005 11/08/03 By jason s_icdpost函數傳入參數
# Modify.........: No.FUN-B80115 11/08/17 By huangtao 程式調整
# Modify.........: No.FUN-B80131 11/08/19 By huangtao 庫存明細庫img_file無資料會lock失敗而發生錯誤
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.TQC-B90236 11/10/26 By zhuhao  程式中，rvbs09=-1改為rvbs09=1
# Modify.........: No.FUN-BA0051 12/01/02 By jason mark多餘程式碼
# Modify.........: No.FUN-BA0023 12/01/10 By pauline 上傳的銷售/銷退單, 加入代銷功能
# Modify.........: No.FUN-BB0120 12/01/10 By pauline g_errno=SQLCA.sqlcode 調整
# Modify.........: No.FUN-BB0130 12/01/10 By pauline ohb.ohb31沒值時,直接給tlf20/41/42/43 預設值
# Modify.........: No.FUN-910088 12/01/16 By chenjing  增加數量欄位小數取位
# Modify.........: No:FUN-BB0086 12/01/16 By tanxc 增加數量欄位小數取位
# Modify.........: No:CHI-C30064 12/03/15 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapcp200.global"          #TQC-B20181 add

DEFINE g_sql    STRING
DEFINE l_msg1,l_msg2,l_msg3    LIKE type_file.chr1000
#DEFINE g_msg           LIKE type_file.chr1000,   #TQC-B20181 mark
#       g_msg1          LIKE type_file.chr1000    #TQC-B20181 mark
DEFINE l_ohb12         LIKE ohb_file.ohb12,
       l_ogb12         LIKE ogb_file.ogb12,
       l_ogb14t        LIKE ogb_file.ogb14t,
       l_ogb14         LIKE ogb_file.ogb14,
       l_ohb14         LIKE ohb_file.ohb14,
       l_ohb14t        LIKE ohb_file.ohb14t,
       g_oha   RECORD  LIKE oha_file.*,
       g_oga   RECORD  LIKE oga_file.*,
       l_oga   RECORD  LIKE oga_file.*
DEFINE b_ohb    RECORD LIKE ohb_file.*
DEFINE g_azw01         LIKE azw_file.azw01
DEFINE g_forupd_sql    STRING
DEFINE tot1,tot2       LIKE ohb_file.ohb12
DEFINE g_ima918        LIKE ima_file.ima918,
       g_ima921        LIKE ima_file.ima921,
       g_ima906        LIKE ima_file.ima906,
       g_ima907        LIKE ima_file.ima907,
       g_ima86         LIKE ima_file.ima86
DEFINE g_cmd           LIKE type_file.chr1000
DEFINE g_chr           LIKE type_file.chr1
DEFINE g_argv0         LIKE type_file.chr1
DEFINE p_plant         LIKE azw_file.azw01   
DEFINE p_legal         LIKE oga_file.ogalegal 
DEFINE g_fno           LIKE oga_file.oga16     #FUN-AC0002 add by suncx 

#l_plant :營運中心 門店機構  #Using for multi-DB 
#-----------------------------------------------------------------
#作用:銷退確認前的檢查
#l_oha01:本筆銷退的單號
#l_plant:營運中心、機構門店
#p_fno:POS銷退的單號
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,
#IF g_success='Y' THEN 檢查成功 ; IF g_success='N' THEN 檢查有錯誤
#----------------------------------------------------------------
FUNCTION p200_oha_confirm(l_oha01,l_plant,p_fno)
DEFINE l_oha01       LIKE oha_file.oha01
DEFINE l_plant       LIKE azw_file.azw01 
DEFINE l_legal       LIKE oga_file.ogalegal
DEFINE p_fno         LIKE oga_file.oga16     #FUN-AC0002 add by suncx
  LET p_plant=l_plant  
  LET g_plant_new = p_plant
  LET g_fno = p_fno       #FUN-AC0002 add by suncx
  LET g_azw01 = p_plant 
  CALL s_getlegal(p_plant) RETURNING l_legal
  LET p_legal = l_legal
  
  IF g_success = "Y" THEN
    LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                      " WHERE oha01 ='",l_oha01,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102                  
    PREPARE p200_oha_pre FROM g_sql
    EXECUTE p200_oha_pre INTO g_oha.*
    
    CALL p200_oha_chk()      
    IF g_success = "Y" THEN
       CALL p200_oha_upd()  
       CALL p200_oha_s('1')
    ELSE
      RETURN
    END IF
  END IF
END FUNCTION

FUNCTION p200_oha_chk()
   DEFINE l_yy,l_mm   LIKE type_file.num5      
   DEFINE l_cnt       LIKE type_file.num5     
   DEFINE l_ohb12     LIKE ohb_file.ohb12 
   DEFINE l_ohb       RECORD LIKE ohb_file.*  
   DEFINE l_rvbs06    LIKE rvbs_file.rvbs06  
   DEFINE l_rxx04     LIKE rxx_file.rxx04    
   DEFINE l_ohb14t    LIKE ohb_file.ohb14t   
   DEFINE l_ohb13     LIKE ohb_file.ohb13
   DEFINE l_ohb03     LIKE ohb_file.ohb03
   DEFINE l_ohb33     LIKE ohb_file.ohb33 
   DEFINE l_ohb34     LIKE ohb_file.ohb34 
   DEFINE g_sql       STRING 
   DEFINE l_img09     LIKE img_file.img09     #CHI-C30064 add
   DEFINE l_ohb05_fac LIKE ohb_file.ohb05_fac #CHI-C30064 add
   DEFINE g_cnt       LIKE type_file.num10    #CHI-C30064 add

   LET g_success = 'Y'
   IF g_oha.oha09 = '6' THEN
    LET g_sql ="SELECT ohb33,ohb34 FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                      " WHERE ohb01 ='",g_oha.oha01,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102                    
    PREPARE oha09_cs_pre FROM g_sql
    DECLARE oha09_cs CURSOR FOR oha09_cs_pre

      FOREACH oha09_cs INTO l_ohb33,l_ohb34
        IF cl_null(l_ohb33) OR cl_null(l_ohb34) THEN
           CALL cl_err('','abx-070',1)
           LET g_success = 'N'
           RETURN
        END IF
      END FOREACH
   END IF
   IF g_azw.azw04='2' THEN
      IF g_oha.oha85='1' THEN
         #LET g_sql ="SELECT SUM(ohb14t) FROM ",g_dbs,"ohb_file ",
         LET g_sql ="SELECT SUM(ohb14t) FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                      " WHERE ohb01 ='",g_oha.oha01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102              
         PREPARE ohb14t_sum_pre FROM g_sql
         EXECUTE ohb14t_sum_pre INTO l_ohb14t
         IF cl_null(l_ohb14t) THEN LET l_ohb14t=0 END IF
#FUN-AB0061----mod---------------str-----------------------
#        #LET g_sql ="SELECT SUM(ohb67) FROM ",g_dbs,"ohb_file ",
#        LET g_sql ="SELECT SUM(ohb67) FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
#                     " WHERE ohb01 ='",g_oha.oha01,"' "
#        CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
#        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
#        PREPARE ohb67_sum_pre FROM g_sql
#        EXECUTE ohb67_sum_pre INTO l_ohb67
#        IF cl_null(l_ohb67) THEN LET l_ohb67=0 END IF
#        IF g_oha.oha213='N' THEN
#           LET l_ohb67=l_ohb67*(1+g_oha.oha211/100)
#           CALL cl_digcut(l_ohb67,t_azi04) RETURNING l_ohb67
#        END IF
#        LET l_ohb14t=l_ohb14t-l_ohb67
         LET l_ohb14t=l_ohb14t
#FUN-AB0061 --------mod----------------------end----------------
         CALL cl_digcut(l_ohb14t,t_azi04) RETURNING l_ohb14t
         #LET g_sql ="SELECT SUM(rxx04) FROM ",g_dbs,"rxx_file ",
         LET g_sql ="SELECT SUM(rxx04) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), #FUN-A50102
                      " WHERE rxx00='03' AND rxx01 ='",g_oha.oha01,"' ",
                      " AND rxx03='-1' AND rxxplant='",g_oha.ohaplant,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102              
         PREPARE rxx04_sum_pre FROM g_sql
         EXECUTE rxx04_sum_pre INTO l_rxx04

#         IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF  #huangrh  mark
#         IF l_ohb14t != l_rxx04 THEN
#            CALL cl_err('','art-336',0)
#            LET g_success = 'N'
#            RETURN
#         END IF                                         #huangrh  mark
      END IF
   END IF
   #無單身資料不可確認
   LET l_cnt=0
    #LET g_sql ="SELECT COUNT(*) FROM ",g_dbs,"ohb_file ",
    LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                      " WHERE ohb01 ='",g_oha.oha01,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102                   
    PREPARE oha_count_pre FROM g_sql
    EXECUTE oha_count_pre INTO l_cnt
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      LET g_success = 'N'  
      RETURN
   END IF

    #LET g_sql ="SELECT * FROM ",g_dbs,"ohb_file ",
    LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                      " WHERE ohb01 ='",g_oha.oha01,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102                   
    PREPARE p200sub_ohbrvbs_pre FROM g_sql
    DECLARE p200sub_ohbrvbs CURSOR FOR p200sub_ohbrvbs_pre

   FOREACH p200sub_ohbrvbs INTO l_ohb.*
         #LET g_sql ="SELECT ima918,ima921 FROM ",g_dbs,"ima_file ",
         LET g_sql ="SELECT ima918,ima921 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                      " WHERE imaacti = 'Y' AND ima01 ='",l_ohb.ohb04,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
         PREPARE ima918_ima921_pre FROM g_sql
         EXECUTE ima918_ima921_pre INTO g_ima918,g_ima921

         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            #LET g_sql ="SELECT SUM(rvbs06) FROM ",g_dbs,"rvbs_file ",
            LET g_sql ="SELECT SUM(rvbs06) FROM ",cl_get_target_table(g_plant_new,'rvbs_file'), #FUN-A50102
                      # " WHERE rvbs13 = 0 AND rvbs09 = -1 ",           #TQC-B90235 mark
                       " WHERE rvbs13 = 0 AND rvbs09 = 1 ",             #TQC-B90236 add
                       " AND rvbs00 ='",g_prog,"' ",
                       " AND rvbs01 ='",l_ohb.ohb01,"' ",
                       " AND rvbs02 ='",l_ohb.ohb03,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102              
            PREPARE rvbs06_sum_pre FROM g_sql
            EXECUTE rvbs06_sum_pre INTO l_rvbs06

            IF cl_null(l_rvbs06) THEN
               LET l_rvbs06 = 0
            END IF

           #CHI-C30064---Start---add
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01= l_ohb.ohb04  AND img02= l_ohb.ohb09
               AND img03= l_ohb.ohb091 AND img04= l_ohb.ohb092
            CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_img09) RETURNING g_cnt,l_ohb05_fac
            IF g_cnt = '1' THEN
               LET l_ohb05_fac = 1
            END IF             
           #CHI-C30064---End---add  
           #IF (l_ohb.ohb12 * l_ohb.ohb05_fac) <> l_rvbs06 THEN
            IF (l_ohb.ohb12 * l_ohb05_fac) <> l_rvbs06 THEN #CHI-C30064  
               LET g_success = "N"
               CALL cl_err(l_ohb.ohb04,"aim-011",1)
               RETURN
            END IF
         END IF
      IF g_oha.oha09 = '4' AND cl_null(l_ohb.ohb31) THEN
         LET g_success = 'N'
         CALL cl_err('','axm-889',1)
         RETURN
      END IF
      LET l_cnt=0
      IF g_aza.aza50='Y' THEN

         #LET g_sql ="SELECT COUNT(*) FROM ",g_dbs,"azf_file ",
         LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'azf_file'), #FUN-A50102
                      " WHERE azf01 ='",l_ohb.ohb50,"' ",
                      " AND azf02='2' AND azfacti='Y' AND azf09='2' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
         PREPARE azf_sum_pre FROM g_sql
         EXECUTE azf_sum_pre INTO l_cnt

      ELSE
         #LET g_sql ="SELECT COUNT(*) FROM ",g_dbs,"azf_file ",
         LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'azf_file'), #FUN-A50102
                      " WHERE azf01 ='",l_ohb.ohb50,"' ",
                      " AND azf02='2' AND azfacti='Y' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102               
         PREPARE azf_sum_pre2 FROM g_sql
         EXECUTE azf_sum_pre2 INTO l_cnt

      END IF
#      IF l_cnt=0 THEN                         #huangrh  mark
#         LET g_success = 'N'
#         CALL cl_err('ohb50','axm-777',0)
#         RETURN
#      END IF                                  #huagnrh  mark
   END FOREACH

   IF g_oaz.oaz03 = 'Y' AND g_sma.sma53 IS NOT NULL
      AND g_oha.oha02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      LET g_success = 'N'  
      RETURN
   END IF

   IF g_oha.oha01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N' 
      RETURN
   END IF

   # ---若現行年月大於出貨單/銷退單之年月--不允許確認-----
   CALL s_yp(g_oha.oha02) RETURNING l_yy,l_mm
   IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
       CALL cl_err('','mfg6090',0) 
       LET g_success = 'N' 
       RETURN
   END IF
   IF g_oha.ohaconf = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N' 
      RETURN
   END IF

  IF g_oha.oha09 = '1' OR g_oha.oha09 = '4' OR g_oha.oha09 = '5' THEN
     #LET g_sql ="SELECT ohb03,ohb13 FROM ",g_dbs,"ohb_file ",
     LET g_sql ="SELECT ohb03,ohb13 FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                " WHERE ohb01 ='",g_oha.oha01,"' "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
     PREPARE p200_y_price_pre FROM g_sql
     DECLARE p200_y_price CURSOR FOR p200_y_price_pre

      FOREACH p200_y_price INTO l_ohb03,l_ohb13
        IF l_ohb13 = 0 THEN
           CALL cl_err(l_ohb03,'axm-534',0)
           LET g_success = 'N'
           RETURN
        END IF
      END FOREACH
  END IF

END FUNCTION 

FUNCTION p200_oha_upd()
 DEFINE   l_sql         STRING                  #FUN-B40017 ADD
   LET g_success = 'Y'
   IF g_oha.ohamksg='Y'   THEN
     IF g_oha.oha55 != '1' THEN
        CALL cl_err('','aws-078',1)
        LET g_success = 'N'
        RETURN
     END IF
   END IF

   LET g_success = 'Y'
   CALL p200_oha_y1()

   IF g_success = 'Y' THEN

      LET g_oha.oha55='1'           #執行成功, 狀態值顯示為 '1' 已核准
      #UPDATE oha_file SET oha55 = g_oha.oha55 WHERE oha01=g_oha.oha01  #FUN-B40017 mark
      #FUN-B40017 add begin-------------
      LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), 
               "   SET oha55 = '",g_oha.oha55,"' WHERE oha01='",g_oha.oha01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql           						
	    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  
      PREPARE upd_oha55_pre FROM l_sql
      EXECUTE upd_oha55_pre
      #FUN-B40017 add end---------------
      IF SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
      END IF

      IF g_oha.ohamksg = 'Y' AND g_oha.oha55 = 'N' THEN
         IF g_success = 'N' THEN
            RETURN
         END IF
      END IF
      CALL p200_oha_chstatus('Y')
      CALL s_showmsg() 
       IF g_success = 'N' THEN
          RETURN
       END IF
      CALL cl_flow_notify(g_oha.oha01,'Y')

      IF g_oha.oha09 <> '5' THEN
         IF g_oaz.oaz61 MATCHES "[12]" THEN
            CALL p200_oha_s(g_oaz.oaz61)
         END IF
      END IF
   ELSE
      LET g_oha.ohaconf='N'
      IF g_azw.azw04='2' THEN
         LET g_oha.ohaconu=''
         LET g_oha.ohacond=''
         LET g_oha.ohacont='' #20110425 wangxin add
      END IF
      CALL s_showmsg() 
   END IF

   IF g_success = 'Y' AND g_oaz.oaz63='Y' AND
     (g_oha.oha09 MATCHES '[1,4,5]') THEN
      CALL p200_oha_CN()
   END IF

END FUNCTION


FUNCTION p200_oha_CN()      # 產生待抵帳款 (Credit Note)
   IF g_oha.ohaconf='N' THEN CALL cl_err('conf=N','aap-717',0) RETURN END IF
   IF g_oha.ohapost='N' THEN CALL cl_err('post=N','aim-206',0) RETURN END IF
   IF g_oha.oha10 IS NOT NULL THEN RETURN END IF
   IF cl_null(g_oha.oha09) OR g_oha.oha09 NOT MATCHES '[145]' THEN
      CALL cl_err(g_oha.oha09,'axr-063',0)
      RETURN
   END IF
   LET g_msg="axrp304 '",g_oha.oha01,"' '",g_oha.oha09,"' '",g_oha.ohaplant,"' "   #FUN-A60056 add plant
   CALL cl_cmdrun_wait(g_msg)
END FUNCTION


FUNCTION p200_oha_s(p_cmd)                  # when g_oha.ohapost='N' (Turn to 'Y')
   DEFINE p_cmd           LIKE type_file.chr1  # 1.不詢問 2.要詢問       
   DEFINE l_sum007  LIKE tsa_file.tsa07,
          l_sum005  LIKE tsa_file.tsa05,
          l_ohb04   LIKE ohb_file.ohb04,
          l_ohb1002 LIKE ohb_file.ohb1002,
          l_ohb12   LIKE ohb_file.ohb12,
          l_ohb14   LIKE ohb_file.ohb14,
          l_ohb14t  LIKE ohb_file.ohb14t,
          l_tqy02   LIKE tqy_file.tqy02,
          l_oay11   LIKE oay_file.oay11,
          l_tqz02   LIKE tqz_file.tqz02
DEFINE l_imm03       LIKE imm_file.imm03   
DEFINE m_ohb12       LIKE ohb_file.ohb12  
DEFINE m_ohb61       LIKE ohb_file.ohb61 
DEFINE m_ohb04       LIKE ohb_file.ohb04
DEFINE m_ohb01       LIKE ohb_file.ohb01 
DEFINE m_ohb03       LIKE ohb_file.ohb03 
DEFINE m_ohb31       LIKE ohb_file.ohb31 
DEFINE m_ohb32       LIKE ohb_file.ohb32 
DEFINE m_qcs091c     LIKE qcs_file.qcs091 
DEFINE g_sql         STRING               
#DEFINE l_imaicd04    LIKE imaicd_file.imaicd04   #FUN-BA0051 mark 
#DEFINE l_imaicd08    LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
DEFINE l_flag        LIKE type_file.num10      
DEFINE l_ohb  RECORD LIKE ohb_file.*
DEFINE l_tot         LIKE oeb_file.oeb25
DEFINE l_tot1        LIKE oeb_file.oeb26   
DEFINE l_ocn03       LIKE ocn_file.ocn03
DEFINE l_ocn04       LIKE ocn_file.ocn04
DEFINE lj_result     LIKE type_file.chr1  

   IF g_oha.oha01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_oha.ohaconf='N' THEN CALL cl_err('conf=N','axm-154',0) RETURN END IF
   IF g_oha.ohaconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF

    #LET g_sql ="SELECT * FROM ",g_dbs,"ohb_file ",
    LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                      " WHERE ohb01 ='",g_oha.oha01,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102                   
    PREPARE ohb_s_c_pre FROM g_sql
    DECLARE ohb_s_c CURSOR FOR ohb_s_c_pre
   CALL s_showmsg_init()

   FOREACH ohb_s_c INTO l_ohb.*
      IF g_argv0 = '1' THEN
         CALL s_incchk(l_ohb.ohb09,l_ohb.ohb091,g_user)
              RETURNING lj_result
         IF NOT lj_result THEN
            LET g_success = 'N'
            LET g_showmsg = g_plant_new,"/",g_fno,"/",l_ohb.ohb03,"/",l_ohb.ohb09,"/",l_ohb.ohb091,"/",g_user
            CALL s_errmsg('shop,fno,ohb03,ohb09,ohb091,inc03',g_showmsg,'','asf-888',1)
            #TQC-B20181 add begin-----------  
            LET g_errno='asf-888'                           
	    LET g_msg1='ohb_file'||'sel'||g_plant_new||g_fno
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            #TQC-B20181 add end-------------   
         END IF
      END IF
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      RETURN
   END IF

   IF g_oha.oha02 <= g_oaz.oaz09 THEN
      CALL cl_err('','axm-273',1) RETURN
   END IF
   IF g_oaz.oaz03 = 'Y' AND
      g_sma.sma53 IS NOT NULL AND g_oha.oha02 <= g_sma.sma53 THEN
      CALL cl_err('','axm-273',1) RETURN
   END IF

   #LET g_sql = " SELECT ohb12,ohb61,ohb04,ohb01,ohb31,ohb32 FROM ",g_dbs,"ohb_file ", 
   LET g_sql = " SELECT ohb12,ohb61,ohb04,ohb01,ohb31,ohb32 FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102 
               "  WHERE ohb01 = '",g_oha.oha01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102
   PREPARE p200_curs1 FROM g_sql
   DECLARE p200_pre1 CURSOR FOR p200_curs1

   FOREACH p200_pre1 INTO m_ohb12,m_ohb61,m_ohb04,m_ohb01,m_ohb31,m_ohb32      
      IF m_ohb61 = 'Y' THEN
         LET m_qcs091c = 0
         #LET g_sql ="SELECT SUM(qcs091) FROM ",g_dbs,"qcs_file ",
         LET g_sql ="SELECT SUM(qcs091) FROM ",cl_get_target_table(g_plant_new,'qcs_file'), #FUN-A50102
                      " WHERE qcs01 ='",m_ohb31,"' AND  qcs02=",m_ohb32," AND qcs14 = 'Y' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
         PREPARE qcs091_sum_pre FROM g_sql
         EXECUTE qcs091_sum_pre INTO m_qcs091c

         IF m_qcs091c IS NULL THEN
            LET m_qcs091c = 0
         END IF

         IF m_ohb12 > m_qcs091c THEN
            CALL cl_err(m_ohb04,'mfg3558',1)
            RETURN
         END IF
      END IF
   END FOREACH

   LET g_success = 'Y'

   #LET g_sql ="UPDATE ",g_dbs,"oha_file SET ohapost='Y' ",
   LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
              " SET ohapost='Y' ",
              " WHERE oha01 ='",g_oha.oha01,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
   PREPARE ohapost_pre FROM g_sql
   EXECUTE ohapost_pre

   CALL p200_oha_s1()

   IF sqlca.sqlcode THEN LET g_success='N' END IF

  #FUN-BA0023 Begin---
   IF g_success = 'Y' AND g_azw.azw04 = '2' THEN
      CALL t620sub1_post('2',g_oha.oha01)
   END IF
  #FUN-BA0023 End-----

   CALL s_showmsg() 
   IF g_success = 'Y' THEN
      LET g_oha.ohapost='Y'
         IF g_oha.oha05='4'  THEN
            CALL cl_err(g_oga.oga01,'atm-262',1)
            #LET g_sql ="SELECT oha1015,oha1018 FROM",g_dbs,"oha_file ",
            LET g_sql ="SELECT oha1015,oha1018 FROM ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                       " WHERE oha01 ='",g_oha.oha01,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
            PREPARE oha1015_pre FROM g_sql
            EXECUTE oha1015_pre INTO g_oha.oha1015,g_oha.oha1018

         END IF
      CALL cl_flow_notify(g_oha.oha01,'S')
   ELSE
      LET g_oha.ohapost='N'
   END IF
   IF g_aza.aza50='Y' THEN
      IF g_success='Y' AND g_oaz.oaz62='Y' THEn
         #LET g_sql ="SELECT oay11 FROM",g_dbs,"oay_file ",
         LET g_sql ="SELECT oay11 FROM ",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
                    " WHERE oay01 ='",l_oga.oga01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
         PREPARE oay11_pre FROM g_sql
         EXECUTE oay11_pre INTO l_oay11

         IF l_oay11='Y' THEN
            CALL p200_ar()
         END IF
      END IF
   END IF

END FUNCTION

#此FUN僅DIS使用,因在過帳段使用,所以納入Global
FUNCTION p200_ar()

   IF l_oga.ogaconf='N' THEN
      CALL cl_err('conf=N','aap-717',0) RETURN
   END IF
   IF l_oga.ogapost='N' THEN
      CALL cl_err('post=N','aim-206',0) RETURN
   END IF
   IF l_oga.oga10 IS NOT NULL THEN RETURN END IF
   #IF l_oga.oga00 MATCHES '[23]'THEN
   IF l_oga.oga00= '2' THEN      #FUN-AC0002 add
      CALL cl_err(g_oha.oha09,'axr-063',0)
      RETURN
   END IF
   LET g_msg="axrp310 ",
             " '",l_oga.oga01,"'",
             " '",l_oga.oga02,"'",
             " '",l_oga.oga05,"' '",
                  l_oga.oga212,"'"
   CALL cl_cmdrun_wait(g_msg)
END FUNCTION


FUNCTION p200_oha_s1()
DEFINE  g_oha53 LIKE oha_file.oha53
DEFINE  g_msg   STRING    #TQC-7C0045
DEFINE  l_oayauno      LIKE oay_file.oayauno,
        l_oay16        LIKE oay_file.oay16,
        l_oay19        LIKE oay_file.oay19,
        l_oay20        LIKE oay_file.oay20,
        l_tqk04        LIKE tqk_file.tqk04,
        l_occ02        LIKE occ_file.occ02,
        l_occ11        LIKE occ_file.occ11,
        l_occ07        LIKE occ_file.occ07,
        l_occ08        LIKE occ_file.occ08,
        l_occ09        LIKE occ_file.occ09,
        l_occ1023      LIKE occ_file.occ1023,
        l_occ1024      LIKE occ_file.occ1024,
        l_occ1022      LIKE occ_file.occ1022,
        l_occ1005      LIKE occ_file.occ1005,
        l_occ1006      LIKE occ_file.occ1006,
        l_oaytype      LIKE oay_file.oaytype,
        l_occ1027      LIKE occ_file.occ1027
DEFINE l_ogb930        LIKE ogb_file.ogb930    
DEFINE l_ogbi          RECORD LIKE ogbi_file.* 
#DEFINE l_imaicd04      LIKE imaicd_file.imaicd04   #FUN-BA0051 mark   
#DEFINE l_imaicd08      LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
DEFINE l_flag          LIKE type_file.num5     
DEFINE l_ohbi RECORD   LIKE ohbi_file.* #TQC-B80005   

  LET l_ogb930=s_costcenter(l_oga.oga15)
  #LET g_sql ="SELECT * FROM ",g_dbs,"ohb_file ",
  LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
             " WHERE ohb01 ='",g_oha.oha01,"' "
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
  PREPARE p200_s1_c_pre FROM g_sql
  DECLARE p200_s1_c CURSOR FOR p200_s1_c_pre

  CALL s_showmsg_init() 
  FOREACH p200_s1_c INTO b_ohb.*
    IF g_success='N' THEN
       LET g_totsuccess='N'
       LET g_success="Y"
    END IF
    IF STATUS THEN EXIT FOREACH END IF
    LET g_cmd= '_s1() read ohb:',b_ohb.ohb03
    CALL cl_msg(g_cmd)

   IF g_oha.oha09 <> '5' THEN
    IF g_oha.oha09 != '5' THEN
       CALL p200_bu1()     #更新出貨單銷退量
       IF g_success = 'N' THEN
          CONTINUE FOREACH   
       END IF
    END IF                  

    IF cl_null(b_ohb.ohb04) THEN CONTINUE FOREACH END IF
    IF cl_null(b_ohb.ohb09) THEN LET b_ohb.ohb09=' ' END IF
    IF cl_null(b_ohb.ohb091) THEN LET b_ohb.ohb091=' ' END IF
    IF cl_null(b_ohb.ohb092)  THEN LET b_ohb.ohb092=' ' END IF
    IF cl_null(b_ohb.ohb16)  THEN LET b_ohb.ohb16=0 END IF
    IF g_aza.aza50='Y' THEN
       IF b_ohb.ohb1005='2' THEN
          IF b_ohb.ohb1010='Y' THEN
             #LET g_sql ="UPDATE ",g_dbs,"tqw_file ",
             LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'tqw_file'), #FUN-A50102
                        " SET tqw081=tqw081-",b_ohb.ohb14t,
                        " WHERE tqw01 ='",b_ohb.ohb1007,"' "
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
             CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
             PREPARE tqw_pre FROM g_sql
             EXECUTE tqw_pre
          ELSE
             #LET g_sql ="UPDATE ",g_dbs,"tqw_file ",
             LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'tqw_file'), #FUN-A50102
                        " SET tqw081=tqw081-",b_ohb.ohb14,
                        " WHERE tqw01 ='",b_ohb.ohb1007,"' "
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
             CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
             PREPARE tqw081_pre FROM g_sql
             EXECUTE tqw081_pre
          END IF
       END IF
    END IF

    # 非MISC的料件且銷退方式不為 5.折讓的才須異動庫存
    IF b_ohb.ohb04[1,4] != 'MISC' AND g_oha.oha09 != '5' THEN 
        IF s_industry('icd') THEN
          #TQC-B80005 --START--
          SELECT * INTO l_ohbi.* FROM ohbi_file
           WHERE ohbi01 = b_ohb.ohb01 AND ohbi03 = b_ohb.ohb03   
          #TQC-B80005 --END--
          CALL s_icdpost(1,b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,
                         b_ohb.ohb092,b_ohb.ohb05,b_ohb.ohb12,
                         b_ohb.ohb01,b_ohb.ohb03,g_oha.oha02,'Y',
                         b_ohb.ohb31,b_ohb.ohb32
                         ,l_ohbi.ohbiicd029,l_ohbi.ohbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
             RETURNING l_flag
          IF l_flag = 0 THEN
             LET g_success = 'N'
             RETURN
          END IF
       END IF
       CALL p200_update()
       IF g_success='N' THEN RETURN END IF
       IF g_sma.sma115 = 'Y' THEN
          CALL p200_update_du()
       END IF
       IF g_success='N' THEN RETURN END IF
    END IF
   END IF
  END FOREACH
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF

END FUNCTION
FUNCTION p200_update_du()
  DEFINE l_ima25   LIKE ima_file.ima25,
         u_type    LIKE type_file.num5      

   #LET g_sql ="SELECT ima906,ima907,ima25 FROM ",g_dbs,"ima_file ",
   LET g_sql ="SELECT ima906,ima907,ima25 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
              " WHERE ima01 ='",b_ohb.ohb04,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
   PREPARE ima_ima25_pre FROM g_sql
   EXECUTE ima_ima25_pre INTO g_ima906,g_ima907,l_ima25
#   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
#    WHERE ima01 = b_ohb.ohb04
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF cl_null(g_ima906) or g_ima906 = '1' THEN
      RETURN
   END IF

END FUNCTION

FUNCTION p200_oha_tlf(p_unit,p_img10)
   DEFINE
      p_unit     LIKE ima_file.ima25,       ##單位
      p_img10    LIKE img_file.img10,       #異動後數量
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,  
      g_cnt      LIKE type_file.num5   
#   IF b_ohb.ohb16 < 0 THEN  #FUN-B40017 add  #FUN-B80115 mark
   IF b_ohb.ohb16 > 0 THEN                    #FUN-B80115 add
      #----來源----
      LET g_tlf.tlf01=b_ohb.ohb04             #異動料件編號
      LET g_tlf.tlf02=731
      LET g_tlf.tlf020=' '
      LET g_tlf.tlf021=' '            #倉庫
      LET g_tlf.tlf022=' '            #儲位
      LET g_tlf.tlf023=' '            #批號
      LET g_tlf.tlf024=0              #異動後數量
      LET g_tlf.tlf025=' '            #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=g_oha.oha01    #銷退單號
      LET g_tlf.tlf027=b_ohb.ohb03    #銷退項次
      #---目的----
      LET g_tlf.tlf03=50
      LET g_tlf.tlf030=b_ohb.ohb08
      LET g_tlf.tlf031=b_ohb.ohb09    #倉庫
      LET g_tlf.tlf032=b_ohb.ohb091   #儲位
      LET g_tlf.tlf033=b_ohb.ohb092   #批號
      LET g_tlf.tlf034=p_img10        #異動後庫存數量
      LET g_tlf.tlf035=p_unit         #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=g_oha.oha01    #銷退單號
      LET g_tlf.tlf037=b_ohb.ohb03    #銷退項次
   #FUN-B40017 add --------------begin----------------   
   ELSE
      #----來源----
      LET g_tlf.tlf01=b_ohb.ohb04        #異動料件編號
      LET g_tlf.tlf02=50
      LET g_tlf.tlf020=b_ohb.ohb08
      LET g_tlf.tlf021=b_ohb.ohb09       #倉庫
      LET g_tlf.tlf022=b_ohb.ohb091      #儲位
      LET g_tlf.tlf023=b_ohb.ohb092      #批號
      LET g_tlf.tlf024=p_img10           #異動後數量
      LET g_tlf.tlf025=p_unit            #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=g_oha.oha01       #銷退單號
      LET g_tlf.tlf027=b_ohb.ohb03       #銷退項次
      #---目的----
      LET g_tlf.tlf03=724
      LET g_tlf.tlf030=' '
      LET g_tlf.tlf031=' '               #倉庫
      LET g_tlf.tlf032=' '               #儲位
      LET g_tlf.tlf033=' '               #批號
      LET g_tlf.tlf034=0                 #異動後庫存數量
      LET g_tlf.tlf035=' '               #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=g_oha.oha01       #銷退單號
      LET g_tlf.tlf037=b_ohb.ohb03       #銷退項次
   END IF	
   #FUN-B40017 add ---------------end-----------------
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=g_oha.oha02      #銷退日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
#  LET g_tlf.tlf10=b_ohb.ohb12      #異動數量         #MOD-B80035 mark
   LET g_tlf.tlf10=ABS(b_ohb.ohb12) #異動數量         #MOD-B80035 add
   LET g_tlf.tlf11=b_ohb.ohb05      #發料單位
   LET g_tlf.tlf12 =b_ohb.ohb15_fac #發料/庫存 換算率
   LET g_tlf.tlf13='aomt800'
   LET g_tlf.tlf14=b_ohb.ohb50      #異動原因  
   LET g_tlf.tlf025=' '            #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=g_oha.oha01    #銷退單號
   LET g_tlf.tlf027=b_ohb.ohb03    #銷退項次
#FUN-B40017 mark ----------begin------------   
#   #---目的----
#   LET g_tlf.tlf03=50
#   LET g_tlf.tlf030=b_ohb.ohb08
#   LET g_tlf.tlf031=b_ohb.ohb09    #倉庫
#   LET g_tlf.tlf032=b_ohb.ohb091   #儲位
#   LET g_tlf.tlf033=b_ohb.ohb092   #批號
#   LET g_tlf.tlf034=p_img10        #異動後庫存數量
#   LET g_tlf.tlf035=p_unit         #庫存單位(ima_file or img_file)
#   LET g_tlf.tlf036=g_oha.oha01    #銷退單號
#   LET g_tlf.tlf037=b_ohb.ohb03    #銷退項次
#   #-->異動數量
#   LET g_tlf.tlf04= ' '             #工作站
#   LET g_tlf.tlf05= ' '             #作業序號
#   LET g_tlf.tlf06=g_oha.oha02      #銷退日期
#   LET g_tlf.tlf07=g_today          #異動資料產生日期
#   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
#   LET g_tlf.tlf09=g_user           #產生人
#   LET g_tlf.tlf10=b_ohb.ohb12      #異動數量
#   LET g_tlf.tlf11=b_ohb.ohb05      #發料單位
#   LET g_tlf.tlf12 =b_ohb.ohb15_fac #發料/庫存 換算率
#   LET g_tlf.tlf13='aomt800'
#   LET g_tlf.tlf14=b_ohb.ohb50      #異動原因 
#FUN-B40017 mark -----------end------------  

   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(b_ohb.ohb04)
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=g_oha.oha03
  #LET g_sql ="SELECT oga46 FROM ",g_dbs,"oga_file ",
  LET g_sql ="SELECT oga46 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
             " WHERE oga01 ='",b_ohb.ohb31,"' "
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
  PREPARE oga46_pre2 FROM g_sql
  EXECUTE oga46_pre2 INTO g_tlff.tlff20

   LET g_tlf.tlf61= g_ima86
   LET g_tlf.tlf62=b_ohb.ohb33    #參考單號(訂單)
   LET g_tlf.tlf64=b_ohb.ohb52    #手冊編號 NO.A093
   LET g_tlf.tlf930=b_ohb.ohb930 


  #LET g_sql ="SELECT ogb41,ogb42,ogb43,ogb1001 FROM ",g_dbs,"ogb_file ",
  IF NOT cl_null(b_ohb.ohb31) THEN  #FUN-BB0130 add
     LET g_sql ="SELECT ogb41,ogb42,ogb43,ogb1001 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                " WHERE ogb01 ='",b_ohb.ohb31,"' AND ogb03 ='",b_ohb.ohb32,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102              
     PREPARE ogb41_pre2 FROM g_sql
     EXECUTE ogb41_pre2 INTO g_tlf.tlf20,g_tlf.tlf41,g_tlf.tlf42,g_tlf.tlf43

     IF SQLCA.sqlcode THEN
        LET g_tlf.tlf20 = ' '
        LET g_tlf.tlf41 = ' '
        LET g_tlf.tlf42 = ' '
        LET g_tlf.tlf43 = ' '
      END IF
  #FUN-BB0130 add START
  ELSE
     LET g_tlf.tlf20 = ' '
     LET g_tlf.tlf41 = ' '
     LET g_tlf.tlf42 = ' '
     LET g_tlf.tlf43 = ' '
  END IF
  #FUN-BB0130 add END
  #CALL p200_tlf(1,0,g_azw01)  #cockroach 0624
   CALL s_tlf2(1,0,g_azw01)    #cockroach 0624
END FUNCTION

FUNCTION p200_update()
  DEFINE l_qty    LIKE img_file.img10,
         l_ima01  LIKE ima_file.ima01,
         l_ima25  LIKE ima_file.ima25,
		 p_img record like img_file.*,
         l_img RECORD
               img01   LIKE img_file.img01,  
               img10   LIKE img_file.img10,
               img16   LIKE img_file.img16,
               img23   LIKE img_file.img23,
               img24   LIKE img_file.img24,
               img09   LIKE img_file.img09,
               img21   LIKE img_file.img21
               END RECORD,
         l_cnt  LIKE type_file.num5          
  DEFINE l_ima71  LIKE ima_file.ima71
  DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
  DEFINE l_occ31  LIKE occ_file.occ31
  DEFINE l_adq06  LIKE adq_file.adq06
  DEFINE l_adq09  LIKE adq_file.adq09
  DEFINE l_adp05  LIKE adp_file.adp05
  DEFINE l_adp06  LIKE adp_file.adp06
  DEFINE l_adq07  LIKE adq_file.adq07
  DEFINE li_adq07 LIKE adq_file.adq07
  DEFINE l_tuq06  LIKE tuq_file.tuq06                                           
  DEFINE l_tuq09  LIKE tuq_file.tuq09                                           
  DEFINE l_tup05  LIKE tup_file.tup05                                           
  DEFINE l_tup06  LIKE tup_file.tup06                                           
  DEFINE l_tup08  LIKE tup_file.tup08                                           
  DEFINE l_tuq07  LIKE tuq_file.tuq07                                           
  DEFINE li_tuq07 LIKE tuq_file.tuq07                                           
  DEFINE l_tuq11  LIKE tuq_file.tuq11                                           
  DEFINE l_tuq12  LIKE tuq_file.tuq12      
  DEFINE l_desc   LIKE type_file.chr1       
  DEFINE i        LIKE type_file.num5      
  DEFINE l_count  LIKE type_file.num5         #FUN-B80131 add    
  DEFINE l_tup05_1 LIKE tup_file.tup05        #FUN-910088--add--
  DEFINE l_tuq07_1 LIKE tuq_file.tuq07        #FUN-910088--add--
  DEFINE l_tuq09_1 LIKE tuq_file.tuq09        #FUN-910088--add--
  DEFINE l_adq07_1 LIKE adq_file.adq07        #No.FUN-BB0086
  DEFINE l_adq09_1 LIKE adq_file.adq09        #No.FUN-BB0086
    #TQC-B40174 add  ...begin
    IF s_joint_venture( b_ohb.ohb04,g_plant_new) OR NOT s_internal_item( b_ohb.ohb04,g_plant_new) THEN #FUN-B40084 mod g_plant---g_plant_new
       RETURN
    END IF
    #TQC-B40174 add  ...end
#FUN-B80131 ---------------STA
    LET g_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'img_file'),
                " WHERE img01= '",b_ohb.ohb04,"'",
                " AND img02 = '",b_ohb.ohb09,"'",
                " AND img03 = '",b_ohb.ohb091,"'",
                " AND img04 = '",b_ohb.ohb092,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    CALL cl_parse_qry_sql(g_sql ,g_plant_new) RETURNING g_sql
    PREPARE sel_img_cnt FROM g_sql
    EXECUTE sel_img_cnt INTO l_count
#   IF b_ohb.ohb15 IS NULL THEN
    IF l_count = 0 THEN
#FUN-B80131 ---------------END    
		INITIALIZE p_img.* TO NULL
		LET p_img.img01=b_ohb.ohb04
		LET p_img.img02=b_ohb.ohb09
		LET p_img.img03=b_ohb.ohb091
		LET p_img.img04=b_ohb.ohb092
		LET p_img.img09=b_ohb.ohb05
		LET p_img.img10=0
		LET p_img.img21=1
		LET p_img.img23='Y'
		LET p_img.img24='N'
		LET b_ohb.ohb15=b_ohb.ohb05
#FUN-B80131 ---------------STA
                LET p_img.imgplant = g_plant_new
                SELECT azw02 INTO p_img.imglegal FROM azw_file WHERE azw01 = g_plant_new
                IF cl_null(p_img.imglegal) THEN
                    LET  p_img.imglegal = ' '
                END IF
#FUN-B80131 ---------------END
		INSERT INTO img_file VALUES(p_img.*)
		IF STATUS THEN
                   LET g_showmsg = g_plant_new,"/",g_fno,"/",p_img.img01,"/",p_img.img02,"/",p_img.img03,"/",p_img.img04      
                   CALL s_errmsg('shop,fno,img01,img02,img03,img04',g_showmsg,'b_ohb.ohb15 null:','axm-186',1)
                   LET g_success = 'N'
                   #TQC-B20181 add begin-----------  
                   LET g_errno='axm-186'                           
	           LET g_msg1='img_file'||'ins'||g_plant_new||g_fno
	           CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	           LET g_msg=g_msg[1,255]
	           CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	           LET g_errno=''
	           LET g_msg=''
	           LET g_msg1=''
                   #TQC-B20181 add end-------------
                   RETURN
		END IF
    END IF
    
    
    IF cl_null(b_ohb.ohb09) THEN LET b_ohb.ohb09=' ' END IF
    IF cl_null(b_ohb.ohb091) THEN LET b_ohb.ohb091=' ' END IF
    IF cl_null(b_ohb.ohb092) THEN LET b_ohb.ohb092=' ' END IF

    LET g_forupd_sql = "SELECT img01,img10,img16,img23,img24,img09,img21",
      #                 " FROM img_file ",                                       #FUN-B70101  mark
                       " FROM ",cl_get_target_table(g_plant_new,'img_file'),     #FUN-B70101  add
                       " WHERE img01= ? AND img02= ? AND img03= ? ",
                       " AND img04= ?  FOR UPDATE "                    
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#FUN-B70101 --------------STA
    CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql                   							
    CALL cl_parse_qry_sql(g_forupd_sql ,g_plant_new) RETURNING g_forupd_sql
#FUN-B70101 --------------END
    DECLARE img_lock_oha CURSOR FROM g_forupd_sql
    OPEN img_lock_oha USING b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092
    IF STATUS THEN
       LET g_showmsg = g_plant_new,"/",g_fno,"/",b_ohb.ohb04,"/",b_ohb.ohb09,"/",b_ohb.ohb091,"/",b_ohb.ohb092 
       CALL s_errmsg('shop,fno,img01,img02,img03,img04',g_showmsg,'lock img fail',STATUS,1)  
       LET g_success='N' 
       #TQC-B20181 add begin-----------  
       LET g_errno=STATUS                           
       LET g_msg1='img_file'||'lock img fail'||g_plant_new||g_fno
       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
       LET g_msg=g_msg[1,255]
       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
       LET g_errno=''
       LET g_msg=''
       LET g_msg1=''
       #TQC-B20181 add end-------------
       RETURN
    END IF
 
    FETCH img_lock_oha INTO l_img.*
    IF STATUS THEN
       LET g_showmsg = g_plant_new,"/",g_fno,"/",b_ohb.ohb04,"/",b_ohb.ohb09,"/",b_ohb.ohb091,"/",b_ohb.ohb092 
       CALL s_errmsg('shop,fno,img01,img02,img03,img04',g_showmsg,'lock img fail',STATUS,1)  
       LET g_success='N'
       #TQC-B20181 add begin-----------  
       LET g_errno=STATUS                           
       LET g_msg1='img_file'||'lock img fail'||g_plant_new||g_fno
       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
       LET g_msg=g_msg[1,255]
       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
       LET g_errno=''
       LET g_msg=''
       LET g_msg1=''
       #TQC-B20181 add end------------- 
       RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    LET l_qty= l_img.img10 + b_ohb.ohb16
    IF b_ohb.ohb16 < 0 THEN #FUN-B40017 add
       CALL s_mupimg('1',b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,b_ohb.ohb16,g_today,
             g_azw01,'',b_ohb.ohb01,b_ohb.ohb03) 
    #FUN-B40017 add ---------------begin-------------------         
    ELSE 
    	 CALL s_mupimg('-1',b_ohb.ohb04,b_ohb.ohb09,b_ohb.ohb091,b_ohb.ohb092,(-1)*b_ohb.ohb16,g_today,
             g_azw01,'',b_ohb.ohb01,b_ohb.ohb03)  
    END IF 	      
    #FUN-B40017 add -----------------end--------------------  
    IF g_success='N' THEN
       LET g_showmsg = g_plant_new,"/",g_fno
       CALL s_errmsg('shop,fno',g_showmsg,'s_upimg()','9050',0) RETURN  
    END IF

    LET g_forupd_sql ="SELECT ima25,ima86 FROM ima_file ",
                      " WHERE ima01= ?  FOR UPDATE"     
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock_oha CURSOR FROM g_forupd_sql
    OPEN ima_lock_oha USING b_ohb.ohb04
    IF STATUS THEN
       CALL s_errmsg('ima01',b_ohb.ohb04,'lock ima fail',STATUS,1)       
       LET g_success='N' 
       #TQC-B20181 add begin-----------  
       LET g_errno=STATUS                           
       LET g_msg1='ima_file'||'lock ima fail'||g_plant_new||g_fno
       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
       LET g_msg=g_msg[1,255]
       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
       LET g_errno=''
       LET g_msg=''
       LET g_msg1=''
       #TQC-B20181 add end-------------
       RETURN
    END IF
    FETCH ima_lock_oha INTO l_ima25,g_ima86
    IF STATUS THEN
       CALL s_errmsg('','','lock ima fail',STATUS,1) LET g_success='N' 
       #TQC-B20181 add begin-----------  
       LET g_errno=STATUS                           
       LET g_msg1='ima_file'||'lock ima fail'||g_plant_new||g_fno
       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
       LET g_msg=g_msg[1,255]
       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
       LET g_errno=''
       LET g_msg=''
       LET g_msg1=''
       #TQC-B20181 add end-------------
       RETURN    
    END IF
                  #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
    IF b_ohb.ohb16 < 0 THEN #FUN-B40017 add              
       CALL s_udima1(b_ohb.ohb04,l_img.img23,l_img.img24,b_ohb.ohb16*l_img.img21,
                    #g_today,+1)  RETURNING l_cnt   #MOD-920298
                    g_oha.oha02,+1,g_azw01)  RETURNING l_cnt   #MOD-920298
         #最近一次發料日期 表發料
    #FUN-B40017 add ---------------begin-------------------     
    ELSE
    	 CALL s_udima1(b_ohb.ohb04,l_img.img23,l_img.img24,(-1)*b_ohb.ohb16*l_img.img21,
                    g_oha.oha02,-1,g_azw01)  RETURNING l_cnt
    END IF 	
    #FUN-B40017 add ----------------end--------------------    
    IF l_cnt THEN
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
          CALL s_errmsg('','','Update Faile',SQLCA.SQLCODE,1) 
          LET g_success='N' 
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.SQLCODE    #FUN-BB0120 mark                      
	  LET g_msg1='ima_file'||'Update Faile'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
          RETURN
    END IF
    IF g_success='Y' THEN
       CALL p200_oha_tlf(l_ima25,l_qty)
    END IF
    IF g_success = 'N' THEN RETURN END IF
    #LET g_sql ="SELECT occ31 FROM ",g_dbs,"occ_file ",
    LET g_sql ="SELECT occ31 FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
               " WHERE occ01 ='",g_oha.oha03,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
    PREPARE occ31_pre FROM g_sql
    EXECUTE occ31_pre INTO l_occ31
    #LET g_sql ="SELECT ima25,ima71 FROM ",g_dbs,"ima_file ",
    LET g_sql ="SELECT ima25,ima71 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
               " WHERE ima01 ='",b_ohb.ohb04,"' "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
    PREPARE ima25_pre FROM g_sql
    EXECUTE ima25_pre INTO l_ima25,l_ima71

    IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
    IF g_aza.aza50='Y' THEN
       #FUN-AC0002 mark begin----
       #IF g_oga.oga00='7' THEN
       #   LET l_tuq11='2'
       #ELSE
       #   LET l_tuq11='1'
       #END IF
       #FUN-AC0002 mark end---
       LET l_tuq11='1'  #FUN-AC0002 add
    END IF
    IF g_aza.aza50='Y' THEN
       #LET g_sql ="SELECT COUNT(*) FROM ",g_dbs,"tuq_file ",
       LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'tuq_file'), #FUN-A50102
                  " WHERE tuq01 ='",g_oha.oha03,"' AND tuq02='",b_ohb.ohb04,"' ",
                  " AND tuq03='",b_ohb.ohb092,"' AND  tuq04='",g_oha.oha02,"' ",
                  " AND tuq11='",l_tuq11,"' AND tuq12='",g_oha.oha04,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
       PREPARE tuq_pre2 FROM g_sql
       EXECUTE tuq_pre2 INTO i

    ELSE
       #LET g_sql ="SELECT COUNT(*) FROM ",g_dbs,"adq_file ",
       LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'adq_file'), #FUN-A50102
                  " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
                  " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
       PREPARE adq_pre2 FROM g_sql
       EXECUTE adq_pre2 INTO i

    END IF 
    IF i=0 THEN
       LET l_fac1=1
       IF b_ohb.ohb05 <> l_ima25 THEN
          CALL s_umfchkm(b_ohb.ohb04,b_ohb.ohb05,l_ima25,g_azw01)
               RETURNING l_cnt,l_fac1
          IF l_cnt = '1'  THEN
             CALL s_errmsg('shop,fno',g_fno,b_ohb.ohb04,'abm-731',0)  
             LET l_fac1=1
          END IF
       END IF
     IF g_aza.aza50='Y' THEN
       LET l_tuq09=b_ohb.ohb12*l_fac1*-1
       LET li_tuq07=b_ohb.ohb12*-1
       LET l_tuq09 = s_digqty(l_tuq09,l_ima25)   #FUN-910088--add--
       LET li_tuq07 = s_digqty(li_tuq07,b_ohb.ohb05)  #FUN-910088--add--
       #LET g_sql ="INSERT INTO ",g_dbs,"tuq_file(",
       LET g_sql ="INSERT INTO ",cl_get_target_table(g_plant_new,'tuq_file'),"(", #FUN-A50102       
                  "tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,tuqplant,tuqlegal) ",
                  " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
       PREPARE tuq_pre FROM g_sql
       EXECUTE tuq_pre USING g_oha.oha03,b_ohb.ohb04,b_ohb.ohb092,g_oha.oha02,g_oha.oha01,
                              b_ohb.ohb03,b_ohb.ohb05,li_tuq07,l_fac1,l_tuq09,
                              '2',l_tuq11,g_oha.oha04,p_plant,p_legal

       IF SQLCA.sqlcode THEN                                                    
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
          LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02,"/",l_tuq11,"/",g_oha.oha04  
          CALL s_errmsg('shop,fno,tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'insert tuq_file',SQLCA.sqlcode,1)         
          LET g_success ='N'
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.SQLCODE    #FUN-BB0120 mark                      
	  LET g_msg1='tuq_file'||'insert tuq_file'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------                                                    
          RETURN                                                                
       END IF       
     ELSE
       LET l_adq09=b_ohb.ohb12*l_fac1*-1
       LET l_adq09 = s_digqty(l_adq09,l_ima25)   #No.FUN-BB0086
       LET li_adq07=b_ohb.ohb12*-1
       LET li_adq07 = s_digqty(li_adq07,b_ohb.ohb05)   #No.FUN-BB0086
       #LET g_sql ="INSERT INTO ",g_dbs,"adq_file(",
       LET g_sql ="INSERT INTO ",cl_get_target_table(g_plant_new,'adq_file'),"(", #FUN-A50102  
                  "adq01,adq02,adq03,adq04,adq05,adq06,adq07,adq08,adq09,adq10) ",
                  " VALUES(?,?,?,?,?,?,?,?,?,?) "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
       PREPARE adq_pre FROM g_sql
       EXECUTE adq_pre USING  g_oha.oha03,b_ohb.ohb04,b_ohb.ohb092,g_oha.oha02,g_oha.oha01,
                              b_ohb.ohb05,li_adq07,l_fac1,l_adq09,'2'

       IF SQLCA.sqlcode THEN
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
          LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02         
          CALL s_errmsg('shop,fno,adq01,adq02,adq03,adq04',g_showmsg,'insert adq_file',SQLCA.sqlcode,1)
          LET g_success ='N'
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.SQLCODE     #FUN-BB0120 mark                     
	  LET g_msg1='adq_file'||'insert adq_file'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
          RETURN
       END IF
     END IF  
    ELSE
    IF g_aza.aza50='Y' THEN
       #LET g_sql ="SELECT UNIQUE tuq06 FROM ",g_dbs,"tuq_file ",
       LET g_sql ="SELECT UNIQUE tuq06 FROM ",cl_get_target_table(g_plant_new,'tuq_file'),#FUN-A50102  
                  " WHERE tuq01 ='",g_oha.oha03,"' AND tuq02='",b_ohb.ohb04,"' ",
                  " AND tuq03='",b_ohb.ohb092,"' AND  tuq04='",g_oha.oha02,"' ",
                  " AND tuq11='",l_tuq11,"' AND  tuq12='",g_oha.oha04,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
       PREPARE tuq06_sel_pre FROM g_sql
       EXECUTE tuq06_sel_pre INTO l_tuq06

       IF SQLCA.sqlcode THEN                                                    
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
          LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02,"/",l_tuq11,"/",g_oha.oha04  
          CALL s_errmsg('shop,fno,tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'select tuq06',SQLCA.sqlcode,1)            
          LET g_success ='N'  
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.SQLCODE    #FUN-BB0120 mark                      
	  LET g_msg1='tuq_file'||'select tuq06'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------                                                  
          RETURN                                                                
       END IF        
     ELSE   
       #LET g_sql ="SELECT UNIQUE adq06 FROM ",g_dbs,"adq_file ",
       LET g_sql ="SELECT UNIQUE adq06 FROM ",cl_get_target_table(g_plant_new,'adq_file'),#FUN-A50102 
                  " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
                  " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
       PREPARE adq06_pre FROM g_sql
       EXECUTE adq06_pre INTO l_adq06

       IF SQLCA.sqlcode THEN
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
          CALL cl_err3("sel","adq_file",g_fno,g_plant_new,SQLCA.sqlcode,"","select adq06",1)  
          LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02      
          CALL s_errmsg('shop,fno,adq01,adq02,adq03,adq04',g_showmsg,'select adq06',SQLCA.sqlcode,1)
          LET g_success ='N'
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.SQLCODE     #FUN-BB0120 mark                     
	  LET g_msg1='adq_file'||'select adq06'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
          RETURN
       END IF
     END IF  
       LET l_fac1=1
    IF g_aza.aza50='Y' THEN
        IF b_ohb.ohb05 <> l_tuq06 THEN                                           
          CALL s_umfchkm(b_ohb.ohb04,b_ohb.ohb05,l_tuq06,g_azw01)                        
               RETURNING l_cnt,l_fac1                                           
           IF l_cnt = '1'  THEN            
             CALL s_errmsg('','',b_ohb.ohb04,'abm-731',0) 
             #TQC-B20181 add begin-----------  
             LET g_errno='abm-731'                          
	     LET g_msg1=''||b_ohb.ohb04||g_plant_new||b_ohb.ohb04
	     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	     LET g_msg=g_msg[1,255]
	     CALL p200_log(g_trans_no,g_plant_new,b_ohb.ohb04,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	     LET g_errno=''
	     LET g_msg=''
	     LET g_msg1=''
             #TQC-B20181 add end-------------
             LET l_fac1=1                                                       
           END IF                                                                
        END IF               
       LET g_sql ="SELECT tuq07 FROM ",cl_get_target_table(g_plant_new,'tuq_file'),#FUN-A50102
                  " WHERE tuq01 ='",g_oha.oha03,"' AND tuq02='",b_ohb.ohb04,"' ",
                  " AND tuq03='",b_ohb.ohb092,"' AND  tuq04='",g_oha.oha02,"' ",
                  " AND tuq11='",l_tuq11,"' AND  tuq12='",g_oha.oha04,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
       PREPARE tuq07_sel_pre FROM g_sql
       EXECUTE tuq07_sel_pre INTO l_tuq07

       IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF                            
       IF l_tuq07-b_ohb.ohb12*l_fac1<0 THEN                                     
          LET l_desc='2'                                                        
       ELSE                                                                     
          LET l_desc='1'                                                        
       END IF   
       IF l_tuq07=b_ohb.ohb12*l_fac1 THEN
          #LET g_sql ="DELETE FROM ",g_dbs,"tuq_file ",
          LET g_sql ="DELETE FROM ",cl_get_target_table(g_plant_new,'tuq_file'),#FUN-A50102
                     " WHERE tuq01 ='",g_oha.oha03,"' AND tuq02='",b_ohb.ohb04,"' ",
                     " AND tuq03='",b_ohb.ohb092,"' AND  tuq04='",g_oha.oha02,"' ",
                     " AND tuq11='",l_tuq11,"' AND  tuq12='",g_oha.oha04,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
          PREPARE tuq_del_pre FROM g_sql
          EXECUTE tuq_del_pre 
                                       
          IF SQLCA.sqlcode THEN                                                 
             LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
             LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02,"/",l_tuq11,"/",g_oha.oha04 
             CALL s_errmsg('shop,fno,tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'delete tuq_file',SQLCA.sqlcode,1)        
             LET g_success='N' 
             #TQC-B20181 add begin-----------  
            #LET g_errno=SQLCA.sqlcode     #FUN-BB0120 mark                    
	     LET g_msg1='tuq_file'||'delete tuq_file'||g_plant_new||g_fno
	     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	     LET g_msg=g_msg[1,255]
	     CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	     LET g_errno=''
	     LET g_msg=''
	     LET g_msg1=''
             #TQC-B20181 add end-------------                                                 
             RETURN                                                             
          END IF                         
       ELSE                                                                     
          LET l_fac2=1                                                          
          IF l_tuq06 <> l_ima25 THEN                                            
             CALL s_umfchkm(b_ohb.ohb04,l_tuq06,l_ima25,g_azw01)                         
                  RETURNING l_cnt,l_fac2                                        
             IF l_cnt = '1'  THEN                                               
                CALL s_errmsg('','',b_ohb.ohb04,'abm-731',0) 
                #TQC-B20181 add begin-----------  
                LET g_errno='abm-731'                         
	        LET g_msg1=''||b_ohb.ohb04||g_plant_new||g_fno
	        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	        LET g_msg=g_msg[1,255]
	        CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	        LET g_errno=''
	        LET g_msg=''
	        LET g_msg1=''
                #TQC-B20181 add end------------- 
                LET l_fac2=1                                                    
             END IF                                                             
          END IF  
          #LET g_sql ="UPDATE ",g_dbs,"tuq_file ",
       #FUN-910088--add--start--
          LET l_tuq07_1 = b_ohb.ohb12*l_fac1   
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)    
          LET l_tuq09_1 = b_ohb.ohb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
       #FUN-910088--add--end--
          LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'tuq_file'), #FUN-A50102
                   # " SET tuq07=tuq07-",b_ohb.ohb12*l_fac1,", ",           #FUN-910088--mark--
                   # " tuq09=tuq09-",b_ohb.ohb12*l_fac1*l_fac2,", ",        #FUN-910088--mark--
                     " SET tuq07=tuq07-",l_tuq07_1,", ",                    #FUN-910088--add--
                     " tuq09=tuq09-",l_tuq09_1,", ",                        #FUN-910088--add--
                     " tuq10='",l_desc,"' ",
                     " WHERE tuq01 ='",g_oha.oha03,"' AND tuq02='",b_ohb.ohb04,"' ",
                     " AND tuq03='",b_ohb.ohb092,"' AND  tuq04='",g_oha.oha02,"' ",
                     " AND tuq11='",l_tuq11,"' AND  tuq12='",g_oha.oha04,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
          PREPARE tuq_del_pre2 FROM g_sql
          EXECUTE tuq_del_pre2
                                                              
          IF SQLCA.sqlcode THEN                                                 
             LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
             LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02,"/",l_tuq11,"/",g_oha.oha04 
             CALL s_errmsg('shop,fno,tuq01,tuq02,tuq03,tuq04,tuq11,tuq12',g_showmsg,'update tuq_file',SQLCA.sqlcode,1)        
             LET g_success='N' 
             #TQC-B20181 add begin-----------  
            #LET g_errno=SQLCA.sqlcode    #FUN-BB0120 mark                   
	     LET g_msg1='tuq_file'||'update tuq_file'||g_plant_new||g_fno
	     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	     LET g_msg=g_msg[1,255]
	     CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	     LET g_errno=''
	     LET g_msg=''
	     LET g_msg1=''
             #TQC-B20181 add end-------------                                                  
             RETURN                                                             
          END IF                                                                
       END IF                    
     ELSE
       IF b_ohb.ohb05 <> l_adq06 THEN
          CALL s_umfchkm(b_ohb.ohb04,b_ohb.ohb05,l_adq06,g_azw01)
               RETURNING l_cnt,l_fac1
          IF l_cnt = '1'  THEN
             CALL s_errmsg('','',b_ohb.ohb04,'abm-731',0)  
             #TQC-B20181 add begin-----------  
             LET g_errno='abm-731'                      
	     LET g_msg1=''||b_ohb.ohb04||g_plant_new||g_fno
	     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	     LET g_msg=g_msg[1,255]
	     CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	     LET g_errno=''
	     LET g_msg=''
	     LET g_msg1=''
             #TQC-B20181 add end-------------
             LET l_fac1=1
          END IF
       END IF
       #LET g_sql ="SELECT adq07 FROM ",g_dbs,"adq_file ",
       LET g_sql ="SELECT adq07 FROM ",cl_get_target_table(g_plant_new,'adq_file'), #FUN-A50102
                  " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
                  " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
       PREPARE adq07_pre FROM g_sql
       EXECUTE adq07_pre INTO l_adq07

       IF cl_null(l_adq07) THEN LET l_adq07=0 END IF
       IF l_adq07-b_ohb.ohb12*l_fac1<0 THEN
          LET l_desc='2'
       ELSE
          LET l_desc='1'
       END IF
       IF l_adq07=b_ohb.ohb12*l_fac1 THEN
          #LET g_sql ="DELETE FROM ",g_dbs,"adq_file ",
          LET g_sql ="DELETE FROM ",cl_get_target_table(g_plant_new,'adq_file'), #FUN-A50102
                     " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
                     " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
          PREPARE adq_del_pre FROM g_sql
          EXECUTE adq_del_pre

          IF SQLCA.sqlcode THEN
             LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
             LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02           
             CALL s_errmsg('shop,fno,adq01,adq02,adq03,adq04',g_showmsg,'delete adq_file',SQLCA.sqlcode,1)  
             LET g_success='N'
             #TQC-B20181 add begin-----------  
            #LET g_errno=SQLCA.sqlcode    #FUN-BB0120 mark                
	     LET g_msg1='adq_file'||'delete adq_file'||g_plant_new||g_fno
	     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	     LET g_msg=g_msg[1,255]
	     CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	     LET g_errno=''
	     LET g_msg=''
	     LET g_msg1=''
             #TQC-B20181 add end-------------
             RETURN
          END IF
       ELSE
          LET l_fac2=1
          IF l_adq06 <> l_ima25 THEN
             CALL s_umfchkm(b_ohb.ohb04,l_adq06,l_ima25,g_azw01)
                  RETURNING l_cnt,l_fac2
             IF l_cnt = '1'  THEN
                CALL cl_err(b_ohb.ohb04,'abm-731',1)
                LET l_fac2=1
             END IF
          END IF
          #LET g_sql ="UPDATE ",g_dbs,"adq_file ",
          #No.FUN-BB0086--add--begin--
          LET l_adq07_1 = s_digqty(b_ohb.ohb12*l_fac1,l_ima25)
          LET l_adq09_1 = s_digqty(b_ohb.ohb12*l_fac1*l_fac2,l_adq06)
          #No.FUN-BB0086--add--end--
          LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'adq_file'), #FUN-A50102
                     " SET adq07=adq07-",l_adq07_1,", ",
                     " adq09=adq09-",l_adq09_1,", ",
                     " adq10='",l_desc,"' ",
                     " WHERE adq01 ='",g_oha.oha03,"' AND adq02='",b_ohb.ohb04,"' ",
                     " AND adq03='",b_ohb.ohb092,"' AND  adq04='",g_oha.oha02,"' "
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
          PREPARE adq_upd_pre FROM g_sql
          EXECUTE adq_upd_pre

          IF SQLCA.sqlcode THEN
             LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
             LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",g_oha.oha02         
             CALL s_errmsg('shop,fno,adq01,adq02,adq03,adq04',g_showmsg,'delete adq_file',SQLCA.sqlcode,1)
             LET g_success='N'
             #TQC-B20181 add begin-----------  
            #LET g_errno=SQLCA.sqlcode      #FUN-BB0120 mark              
	     LET g_msg1='adq_file'||'delete adq_file'||g_plant_new||g_fno
	     CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	     LET g_msg=g_msg[1,255]
	     CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	     LET g_errno=''
	     LET g_msg=''
	     LET g_msg1=''
             #TQC-B20181 add end-------------
             RETURN
          END IF
       END IF
     END IF  
    END IF
    LET l_fac1=1
    IF b_ohb.ohb05 <> l_ima25 THEN
       CALL s_umfchkm(b_ohb.ohb04,b_ohb.ohb05,l_ima25,g_azw01)
            RETURNING l_cnt,l_fac1
       IF l_cnt = '1'  THEN
          CALL s_errmsg('','',b_ohb.ohb04,'abm-731',0)  
          #TQC-B20181 add begin-----------  
          LET g_errno='abm-731'                      
	  LET g_msg1=''||b_ohb.ohb04||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
          LET l_fac1=1
       END IF
    END IF
   IF g_aza.aza50='Y' THEN
    #FUN-AC0002 mark begin----
    #IF g_oga.oga00='7' THEN
    #   LET l_tup08='2'
    #ELSE 
    #   LET l_tup08='1'
    #END IF
    #FUN-AC0002 mark end------
    LET l_tup08='1'   #FUN-AC0002 add

       #LET g_sql ="SELECT COUNT(*) FROM ",g_dbs,"tup_file ",
       LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'tup_file'), #FUN-A50102
                  " WHERE tup01 ='",g_oha.oha03,"' AND tup02='",b_ohb.ohb04,"' ",
#MOD-B80035 -----------------STA
#                 " AND tup03='",b_ohb.ohb092,"' AND tup08='",l_tup08,"' ",
#                 " AND tup09='",g_oha.oha04,"' "
                  " AND tup03='",b_ohb.ohb092,"' AND tup11='",l_tup08,"' ",
                  " AND tup12='",g_oha.oha04,"' "
#MOD-B80035 -----------------END
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
       PREPARE tup_pre2 FROM g_sql
       EXECUTE tup_pre2 INTO i

    IF cl_null(b_ohb.ohb092) THEN LET b_ohb.ohb092=' ' END IF  
    IF i=0 THEN 
       LET l_tup05=b_ohb.ohb12*l_fac1*-1   
       LET l_tup05 = s_digqty(l_tup05,l_ima25)   #FUN-910088--add--
       LET l_tup06=l_ima71+g_oha.oha02
       #LET g_sql ="INSERT INTO ",g_dbs,"tup_file(",
       LET g_sql ="INSERT INTO ",cl_get_target_table(g_plant_new,'tup_file'), "(", #FUN-A50102      
                  "tup01,tup02,tup03,tup04,tup05,tup06,tup07,tup08,tup09,tup11,tup12,tupplant,tuplegal) ",    #MOD-B80035 add tup11,tup12
                  " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                       #MOD-B80035 add
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
       PREPARE tup_ins_pre FROM g_sql
       EXECUTE tup_ins_pre USING g_oha.oha03,b_ohb.ohb04,b_ohb.ohb092,l_ima25,l_tup05,
                                 l_tup06,g_oha.oha02,l_tup08,g_oha.oha04,l_tup08,g_oha.oha04,p_plant,p_legal  #MOD-B80035 add tup11,tup12
       IF SQLCA.sqlcode THEN                                                    
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add 
          LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092                     
          CALL s_errmsg('shop,fno,tup01,tup02,tup03',g_showmsg,'insert tup_file',SQLCA.sqlcode,1)  
          LET g_success='N' 
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.sqlcode   #FUN-BB0120 mark                 
	  LET g_msg1='tup_file'||'insert tup_file'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------                                                    
          RETURN                                                                
       END IF                                                                   
    ELSE             
       LET l_tup05_1 = b_ohb.ohb12*l_fac1     #FUN-910088--add--
       LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)   #FUN-910088--add--
       #LET g_sql ="UPDATE ",g_dbs,"tup_file ",
       LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'tup_file'), #FUN-A50102 
                 #" SET tup05=tup05-",b_ohb.ohb12*l_fac1,  #FUN-910088--mark--
                  " SET tup05 = tup05-",l_tup05_1," ",     #FUN-910088--add--
                  " WHERE tup01 ='",g_oha.oha03,"' AND tup02='",b_ohb.ohb04,"' ",
#MOD-B80035 -----------------STA
#                 " AND tup03='",b_ohb.ohb092,"' AND tup08='",l_tup08,"' ",
#                 " AND tup09='",g_oha.oha04,"' "
                  " AND tup03='",b_ohb.ohb092,"' AND tup11='",l_tup08,"' ",
                  " AND tup12='",g_oha.oha04,"' "
#MOD-B80035 -----------------END
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
       PREPARE tup_upd_pre FROM g_sql
       EXECUTE tup_upd_pre
                                                           
       IF SQLCA.sqlcode THEN                                                    
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
          LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092,"/",l_tup08,"/",g_oha.oha04    
          CALL s_errmsg('shop,fno,tup01,tup02,tup03,tup08,tup09',g_showmsg,'insert tup_file',SQLCA.sqlcode,1) 
          LET g_success='N'   
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.sqlcode    #FUN-BB0120 mark                
	  LET g_msg1='tup_file'||'insert tup_file'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------                                                  
          RETURN                                                                
       END IF           
    END IF
   ELSE
       #LET g_sql ="SELECT COUNT(*) FROM ",g_dbs,"adp_file ",
       LET g_sql ="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'adp_file'), #FUN-A50102 
                  " WHERE adp01 ='",g_oha.oha03,"' AND adp02='",b_ohb.ohb04,"' ",
                  " AND adp03='",b_ohb.ohb092,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102                
       PREPARE adp_sel_pre FROM g_sql
       EXECUTE adp_sel_pre INTO i

    IF i=0 THEN
       LET l_adp05=b_ohb.ohb12*l_fac1*-1
       LET l_adp06=l_ima71+g_oha.oha02
       #LET g_sql ="INSERT INTO ",g_dbs,"adp_file(",
       LET g_sql ="INSERT INTO ",cl_get_target_table(g_plant_new,'adp_file'), "(", #FUN-A50102 
                  "adp01,adp02,adp03,adp04,adp05,adp06,adp07) ",
                  " VALUES(?,?,?,?,?,?,?) "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102              
       PREPARE adp_pre FROM g_sql
       EXECUTE adp_pre USING g_oha.oha03,b_ohb.ohb04,b_ohb.ohb092,l_ima25,
                             l_adp05,l_adp06,g_oha.oha02
       IF SQLCA.sqlcode THEN
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add
          LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092                       
          CALL s_errmsg('shop,fno,adp01,adp02,adp03',g_showmsg,'insert adp_file',SQLCA.sqlcode,1)    
          LET g_success='N'
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.sqlcode     #FUN-BB0120 mark               
	  LET g_msg1='adp_file'||'insert adp_file'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
          RETURN
       END IF
    ELSE
       #LET g_sql ="UPDATE ",g_dbs,"adp_file ",
       LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'adp_file'), #FUN-A50102
                  " SET adp05=adp05-",b_ohb.ohb12*l_fac1,
                  " WHERE adp01 ='",g_oha.oha03,"' AND adp02='",b_ohb.ohb04,"' ",
                  " AND adp03='",b_ohb.ohb092,"' "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
       PREPARE adp_upd_pre FROM g_sql
       EXECUTE adp_upd_pre

       IF SQLCA.sqlcode THEN
          LET g_errno = SQLCA.SQLCODE  #FUN-BB0120 add 
          LET g_showmsg = g_plant_new,"/",g_fno,"/",g_oha.oha03,"/",b_ohb.ohb04,"/",b_ohb.ohb092                  
          CALL s_errmsg('shop,fno,adp01,adp02,adp03',g_showmsg,'update adp_file',SQLCA.sqlcode,1)
          LET g_success='N'
          #TQC-B20181 add begin-----------  
         #LET g_errno=SQLCA.sqlcode    #FUN-BB0120 mark                
	  LET g_msg1='adp_file'||'update adp_file'||g_plant_new||g_fno
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
          RETURN
       END IF
    END IF
   END IF 
END FUNCTION
FUNCTION p200_bu1()                             #更新出貨單銷退量 & 訂單銷退量
  DEFINE l_ogb04   LIKE ogb_file.ogb04
  DEFINE l_oeb25   LIKE oeb_file.oeb25
  DEFINE l_a       LIKE type_file.chr1   
   CALL cl_msg("bu!")
   IF g_oha.oha09 = '1' THEN RETURN END IF

   IF NOT cl_null(b_ohb.ohb31) THEN                     #更新出貨單銷退量
      #LET g_sql ="SELECT SUM(ohb12) FROM ",g_dbs,"ohb_file, ",g_dbs,"oha_file ",
      LET g_sql ="SELECT SUM(ohb12) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",", #FUN-A50102
                                           cl_get_target_table(g_plant_new,'oha_file'),     #FUN-A50102
                 " WHERE ohb31='",b_ohb.ohb31,"' AND ohb32=",b_ohb.ohb32,
                 " AND ohb01=oha01 AND ohapost='Y' AND oha09='2' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
      PREPARE ohb12_sum_pre2 FROM g_sql
      EXECUTE ohb12_sum_pre2 INTO tot1
      #LET g_sql ="SELECT SUM(ohb12) FROM ",g_dbs,"ohb_file, ",g_dbs,"oha_file ",
      LET g_sql ="SELECT SUM(ohb12) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",", #FUN-A50102
                                           cl_get_target_table(g_plant_new,'oha_file'),     #FUN-A50102
                 " WHERE ohb31='",b_ohb.ohb31,"' AND ohb32=",b_ohb.ohb32,
                 " AND ohb01=oha01 AND ohapost='Y' AND oha09='3' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
      PREPARE ohb12_sum_pre3 FROM g_sql
      EXECUTE ohb12_sum_pre3 INTO tot2

      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF

      LET g_chr='N'
      #LET g_sql ="SELECT ogb04 FROM ",g_dbs,"ogb_file ",
      LET g_sql ="SELECT ogb04 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                 " WHERE ogb01 ='",b_ohb.ohb31,"' AND ogb03=",b_ohb.ohb32
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
      PREPARE ogb04_pre2 FROM g_sql
      EXECUTE ogb04_pre2 INTO l_ogb04

      IF b_ohb.ohb04 = l_ogb04 THEN      #銷退品號與出貨品號相同才update
         #LET g_sql ="UPDATE ",g_dbs,"ogb_file ",
         LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                    " SET ogb63='",tot1,"' AND ogb64=",tot2,
                    " WHERE ogb01 ='",b_ohb.ohb31,"' AND ogb03=",b_ohb.ohb32
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
         PREPARE ogb63_pre2 FROM g_sql
         EXECUTE ogb63_pre2 

         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
            LET g_showmsg = g_plant_new,"/",g_fno,"/",b_ohb.ohb31,"/",b_ohb.ohb32                     
            CALL s_errmsg('shop.fno,ogb01,ogb03',g_showmsg,'upd ogb63,64',STATUS,1) 
            LET g_success = 'N' 
            #TQC-B20181 add begin-----------  
            LET g_errno=STATUS                   
	    LET g_msg1='ogb_file'||'upd ogb63,64'||g_plant_new||g_fno
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            #TQC-B20181 add end-------------
            RETURN
         END IF
      END IF
   END IF

   IF g_oha.oha09 != '4' THEN RETURN END IF     

END FUNCTION


FUNCTION p200_oha_chstatus(l_new)
DEFINE l_new  LIKE type_file.chr1       
#DEFINE l_imaicd04   LIKE imaicd_file.imaicd04   #FUN-BA0051 mark    
#DEFINE l_imaicd08   LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
#Y;N;X
 LET g_oha.ohaconf=l_new
 CASE l_new
      WHEN 'Y'  #確認
         #LET g_sql ="UPDATE ",g_dbs,"oha_file ",
         LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                    " SET oha55='1' ",
                    " WHERE oha01 ='",g_oha.oha01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
         PREPARE oha55_pre FROM g_sql
         EXECUTE oha55_pre 
          IF SQLCA.sqlcode THEN
             LET g_success='N'
             RETURN
          END IF
          LET g_oha.oha55='1'

 END CASE
END FUNCTION

FUNCTION p200_oha_y1()
   DEFINE s_ohb12 LIKE ohb_file.ohb12
   DEFINE l_slip   LIKE oay_file.oayslip
   DEFINE l_oay13  LIKE oay_file.oay13
   DEFINE l_oay14  LIKE oay_file.oay14
   DEFINE l_ohb14t LIKE ohb_file.ohb14t
   #TQC-B40145 mark -------begin--#積分部份的邏輯在POS段處理，所以這裡mark
   #IF NOT cl_null(g_oha.oha87) THEN
   #   #LET g_sql ="UPDATE ",g_dbs,"lpj_file ",
   #   LET g_sql ="UPDATE ",cl_get_target_table(g_plant_new,'lpj_file'), #FUN-A50102
   #              " SET lpj07=lpj07+1,","lpj08='",g_today,"', lpj12=lpj12+",g_oha.oha95,
   #              " WHERE lpj03 ='",g_oha.oha87,"' "
   #    CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
   #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
   #   PREPARE lpj_pre FROM g_sql
   #   EXECUTE lpj_pre
   #   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #      CALL cl_err3("upd","lpj_file",g_oha.oha87,"",SQLCA.sqlcode,"","upd lpj12",1)
   #      LET g_success = 'N'
   #      RETURN
   #   ELSE
   #      MESSAGE 'UPDATE lpj_file OK'
   #   END IF
   #   #LET g_sql ="INSERT INTO ",g_dbs,"lsm_file ",
   #   LET g_sql ="INSERT INTO ",cl_get_target_table(g_plant_new,'lsm_file'), #FUN-A50102
   #              " VALUES('",g_oha.oha87,"','8','",g_oha.oha01,"',",g_oha.oha95,",'",g_today,"','','",g_oha.ohaplant,"' ) "
   #   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
   #      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
   #   PREPARE lsm_pre FROM g_sql
   #   EXECUTE lsm_pre 
   #   IF STATUS OR SQLCA.SQLCODE THEN
   #      CALL cl_err3("ins","lsm_file",g_fno,"",SQLCA.sqlcode,"","ins lsm",1)
   #      LET g_success = 'N'
   #      RETURN
   #   ELSE
   #      MESSAGE 'UPDATE lsm_file OK'
   #   END IF
   #END IF
   #TQC-B40145 mark ---------end--#積分部份的邏輯在POS段處理，所以這裡mark
   LET l_slip = s_get_doc_no(g_oha.oha01)
   #LET g_sql ="SELECT oay13,oay14 FROM ",g_dbs,"oay_file ",
   LET g_sql ="SELECT oay13,oay14 FROM ",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
              " WHERE oayslip ='",l_slip,"' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102            
   PREPARE oay_pre FROM g_sql
   EXECUTE oay_pre INTO l_oay13,l_oay14
   IF l_oay13 = 'Y' AND g_oha.oha09 MATCHES '[145]' THEN

         #LET g_sql ="SELECT SUM(ohb14t) FROM ",g_dbs,"ohb_file ",
         LET g_sql ="SELECT SUM(ohb14t) FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                      " WHERE ohb01 ='",g_oha.oha01,"' "
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102             
         PREPARE ohb14t_sum_pre2 FROM g_sql
         EXECUTE ohb14t_sum_pre2 INTO l_ohb14t
      IF cl_null(l_ohb14t) THEN LET l_ohb14t = 0 END IF
      LET l_ohb14t = l_ohb14t * g_oha.oha24
      IF l_ohb14t > l_oay14 THEN
         CALL cl_err(l_oay14,'axm-700',1) LET g_success='N' RETURN
      END IF
   END IF
 # check 銷退量及出貨量的控管

   #LET g_sql ="SELECT * FROM ",g_dbs,"ohb_file ",
   LET g_sql ="SELECT * FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
              " WHERE ohb01 ='",g_oha.oha01,"' ",
              " AND (ohb1005='1' OR ohb1005 IS NULL) AND (ohb1004='N' OR ohb1004 IS NULL) ORDER BY ohb03 "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102           
   PREPARE p200_y1_c_pre FROM g_sql
   DECLARE p200_y1_c CURSOR FOR p200_y1_c_pre
   CALL s_showmsg_init() 
   FOREACH p200_y1_c INTO b_ohb.*
    IF g_success='N' THEN
       LET g_totsuccess='N'
       LET g_success="Y"
    END IF

    IF STATUS THEN
       CALL s_errmsg('ohb01',g_fno,'y1 foreach',STATUS,1)
       LET g_success = 'N' 
       #TQC-B20181 add begin-----------  
       LET g_errno=STATUS                   
       LET g_msg1='ohb_file'||'y1 foreach'||g_plant_new||g_fno
       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
       LET g_msg=g_msg[1,255]
       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
       LET g_errno=''
       LET g_msg=''
       LET g_msg1=''
       #TQC-B20181 add end-------------
       RETURN
    END IF
    LET g_cmd='_y1() read ohb:',b_ohb.ohb03
    CALL cl_msg(g_cmd)
    IF NOT cl_null(b_ohb.ohb31) THEN
         #LET g_sql ="SELECT SUM(ohb12),SUM(ohb14t),SUM(ohb14) FROM ",g_dbs,"ohb_file,",g_dbs,"oha_file ",
         LET g_sql ="SELECT SUM(ohb12),SUM(ohb14t),SUM(ohb14) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",", #FUN-A50102
                                                                     cl_get_target_table(g_plant_new,'oha_file'),     #FUN-A50102
                     # " WHERE oha01=ohb01 AND ohb31=b_ohb.ohb31 AND ohb32=b_ohb.ohb32 AND ohaconf='Y' "   #mark by suncx
                     " WHERE oha01=ohb01 AND ohb31='",b_ohb.ohb31,"' AND ohb32=",b_ohb.ohb32," AND ohaconf='Y' " #suncx
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102               
         PREPARE ohb12t_pre FROM g_sql
         EXECUTE ohb12t_pre INTO l_ohb12,l_ohb14t,l_ohb14
         #LET g_sql ="SELECT SUM(ogb12),SUM(ogb14t),SUM(ogb14) FROM ",g_dbs,"oga_file,",g_dbs,"ogb_file ",
         LET g_sql ="SELECT SUM(ogb12),SUM(ogb14t),SUM(ogb14) FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
                                                                     cl_get_target_table(g_plant_new,'ogb_file'),    
                     # " WHERE oga01=ogb01 AND ogb01=b_ohb.ohb31 AND ogb03=b_ohb.ohb32 "  #mark by suncx
                     " WHERE oga01=ogb01 AND ogb01='",b_ohb.ohb31,"' AND ogb03=",b_ohb.ohb32  #suncx  
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql                  #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql      #FUN-A50102               
         PREPARE ogb12t_pre FROM g_sql
         EXECUTE ogb12t_pre INTO l_ogb12,l_ogb14t,l_ogb14

      IF cl_null(l_ohb12 ) THEN LET l_ohb12 =0 END IF
      IF cl_null(l_ohb14t) THEN LET l_ohb14t=0 END IF
      IF cl_null(l_ohb14 ) THEN LET l_ohb14 =0 END IF
      IF cl_null(l_ogb12 ) THEN LET l_ogb12 =0 END IF
      IF cl_null(l_ogb14t) THEN LET l_ogb14t=0 END IF
      IF cl_null(l_ogb14 ) THEN LET l_ogb14 =0 END IF
      IF l_ogb12 - l_ohb12 <0 THEN
         LET s_ohb12=l_ohb12-b_ohb.ohb12
         IF cl_null(s_ohb12) THEN LET s_ohb12=0 END IF
         CALL cl_getmsg('axr-267',g_lang) RETURNING l_msg1
         CALL cl_getmsg('axr-274',g_lang) RETURNING l_msg2
         CALL cl_getmsg('axr-268',g_lang) RETURNING l_msg3
         LET g_msg1=l_msg1 CLIPPED,s_ohb12 USING '######&.##','+',
                    l_msg2 CLIPPED,b_ohb.ohb12 USING '######&.##',
                    l_msg3 CLIPPED
         CALL cl_getmsg('axr-266',g_lang) RETURNING l_msg1
         LET g_msg1=g_msg CLIPPED,
                    l_msg1 CLIPPED,l_ogb12 USING '######&.##'
         CALL s_errmsg('fno',g_fno,g_msg1,'aap-999',1) 
         LET g_success='N' 
         #TQC-B20181 add begin-----------  
         LET g_errno='aap-999'                   
	 LET g_msg1=''||g_msg1||g_plant_new||g_fno
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
         CONTINUE FOREACH     
      END IF
      IF l_ohb14 > l_ohb14t THEN
         #若超過金額只警告不拒絕
         IF l_ogb14 - l_ohb14 <0 THEN
           CALL cl_getmsg('axr-270',g_lang) RETURNING l_msg1
           CALL cl_getmsg('axr-275',g_lang) RETURNING l_msg2
           CALL cl_getmsg('axr-269',g_lang) RETURNING l_msg3
          LET g_msg1=l_msg1 CLIPPED,l_ohb14t-b_ohb.ohb14t USING '#####&.##','+',
                     l_msg2 CLIPPED,b_ohb.ohb14t USING '#####&.##','>',
                     l_msg3 CLIPPED,l_ogb14t USING '#####&.##'
         END IF
      ELSE
         IF l_ogb14t - l_ohb14t <0 THEN
           CALL cl_getmsg('axr-270',g_lang) RETURNING l_msg1
           CALL cl_getmsg('axr-275',g_lang) RETURNING l_msg2
           CALL cl_getmsg('axr-269',g_lang) RETURNING l_msg3
          LET g_msg1=l_msg1 CLIPPED,l_ohb14t-b_ohb.ohb14t USING '#####&.##','+',
                     l_msg2 CLIPPED,b_ohb.ohb14t USING '#####&.##','>',
                     l_msg3 CLIPPED,l_ogb14t USING '#####&.##'
           IF NOT cl_confirm2('axr-284',g_msg1) THEN
              LET g_success='N' CONTINUE FOREACH   
           END IF
        END IF
      END IF
    END IF
    IF g_success='N' THEN CONTINUE FOREACH END IF  
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF

END FUNCTION
#TQC-B10099
