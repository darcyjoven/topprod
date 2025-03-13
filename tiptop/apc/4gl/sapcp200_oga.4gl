# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: saxmt600_sub.4gl
# Description....: 提供saxmt600.4gl使用的sub routine/sapcp200_oga.4gl
# Date & Author..: 07/03/05 by kim (FUN-730012)

# Modify.........: No:FUN-A30116 10/04/17 By Cockroach 將SQL改成跨DB形式
# Modify.........: No.FUN-A60056 10/07/09 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A50102 10/07/15 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60044 10/07/21 By Cockroach  跨庫db!
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.FUN-AB0061 10/11/16 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AC0002 10/11/25 By vealxu,suncx 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No:TQC-B20181 11/03/08 By wangxin 將上傳不成功的資料匯入log查詢檔
# Modify.........: No:FUN-B40017 11/04/08 By wangxin POS單項退調整
# Modify.........: No:TQC-B40145 11/04/19 By wangxin POS會員銷售調整
# Modify.........: No:TQC-B40174 11/04/22 By wangxin 聯營及非企業料號不異動img及tlf
# Modify.........: No:FUN-B40084 11/04/26 By wangxin 聯營及非企業料號傳參調整
# Modify.........: No:FUN-B50055 11/05/11 By cockroach 拿掉相關比率的判斷
# Modify.........: No:TQC-B50134 11/05/24 By wangxin 報錯信息调整
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位
# Modify.........: No.TQC-B80005 11/08/03 By jason s_icdpost函數傳入參數
# Modify.........: No.FUN-B80115 11/08/17 By huangtao 程式調整
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-BA0023 11/11/29 By pauline 上傳的銷售/銷退單, 加入代銷功能
# Modify.........: No.FUN-BB0120 11/11/29 By pauline g_errno=SQLCA.sqlcode 調整
# Modify.........: No.FUN-BA0051 11/12/01 By jason mark多餘程式碼
# Modify.........: No.FUN-BB0084 11/12/22 By lixh1 增加數量欄位小數取位
# Modify.........: No.FUN-910088 11/12/26 By chenjing 增加數量欄位小數取位
# Modify.........: No:CHI-C30064 12/03/15 By Sakura 程式有用到"aim-011"訊息的地方，改用料倉儲批抓庫存單位(img09)換算
# Modify.........: No.TQC-C30337 12/04/03 By pauline 若是背景處理時, 固定將 g_sma.sma892 變數的第二碼設為 'N'
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sapcp200.global"          #TQC-B20181 add

DEFINE   g_bookno1     LIKE aza_file.aza81     #No.FUN-730057
DEFINE   g_bookno2     LIKE aza_file.aza82     #No.FUN-730057
DEFINE   g_flag        LIKE type_file.chr1     #No.FUN-730057
DEFINE   g_exdate      LIKE oga_file.oga021    #MOD-780068 add
DEFINE   p_success1    LIKE type_file.chr1     #No.TQC-7C0114
DEFINE   g_ina         RECORD LIKE ina_file.*  #No.FUN-7C0017
DEFINE   g_ica         RECORD LIKE ica_file.*  #No.FUN-7B0014
DEFINE   g_inb         RECORD LIKE inb_file.*  #No.FUN-7B0014
#DEFINE   g_msg         LIKE type_file.chr1000  #No.FUN-7B0014  #TQC-B20181 mark
#DEFINE   g_msg1        LIKE type_file.chr1000  #No.FUN-7B0014  #TQC-B20181 mark
DEFINE   g_msg2        LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_msg3        LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE   g_cnt         LIKE type_file.num5     #No.FUN-7B0014
DEFINE   g_ima918      LIKE ima_file.ima918    #No.FUN-810036
DEFINE   g_ima921      LIKE ima_file.ima921    #No.FUN-810036
DEFINE   g_forupd_sql  STRING
 
DEFINE   p_legal       LIKE oga_file.ogalegal  #FUN-A30116 ADD
DEFINE   l_sql         STRING                  #FUN-A30116 ADD

DEFINE   g_shop        LIKE azw_file.azw01,    #FUN-AC0002 add by suncx
         g_fno         LIKE oga_file.oga16     #FUN-AC0002 add by suncx  

#kim 注意 : 此sub routine中請勿宣告任何global或modual變數,若有需要,請用傳遞參數的方式來解決,
#因為此處的所有FUN應該可提供外部程式獨立呼叫
 
#{
#作用:出貨單確認前的檢查
#p_oga01:本筆出貨單的單號
#p_plant:營運中心、門店機構 用于跨db #FUN-A30116 
#回傳值:無
#注意:以g_success的值來判斷檢查結果是否成功,IF g_success='Y' THEN 檢查成功 ; IF g_success='N' THEN 檢查有錯誤
#}

FUNCTION t600sub_y_chk(p_oga01,p_plant,p_fno)    
 DEFINE p_oga01       LIKE oga_file.oga01
 DEFINE p_plant       LIKE azw_file.azw01       #FUN-A30116 ADD
 DEFINE l_legal       LIKE oga_file.ogalegal    #FUN-A30116 ADD
 DEFINE l_argv0       LIKE ogb_file.ogb09
 DEFINE l_ogb09       LIKE ogb_file.ogb09,      #No.9736
        l_cnt         LIKE type_file.num5,      #No.FUN-680137 SMALLINT
        l_yy,l_mm     LIKE type_file.num5,      #No.FUN-680137 SMALLINT
        l_oea161      LIKE oea_file.oea161,
        l_oea162      LIKE oea_file.oea162,
        l_oea163      LIKE oea_file.oea163
 DEFINE l_ogb19       LIKE ogb_file.ogb19,
        l_ogb11       LIKE ogb_file.ogb11,
        l_ogb12       LIKE ogb_file.ogb12,
        l_qcs01       LIKE qcs_file.qcs01,
        l_qcs02       LIKE qcs_file.qcs02,
        l_oga09       LIKE oga_file.oga09,
        l_qcs091c     LIKE qcs_file.qcs091
 DEFINE l_ogb910      LIKE ogb_file.ogb910,
        l_ogb912      LIKE ogb_file.ogb912,
        l_x1,l_x2     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
        l_msg,l_msg1,l_msg2,l_msg3  STRING    #No.TQC-7C0114
 DEFINE l_ogb1005     LIKE ogb_file.ogb1005     #No.FUN-610064
 DEFINE l_oma55       LIKE oma_file.oma55  #FUN-650105
 DEFINE l_oma54t      LIKE oma_file.oma54t #FUN-650105
 DEFINE l_oga         RECORD LIKE oga_file.*
 DEFINE l_ogb1007     LIKE ogb_file.ogb1007,
        l_ogb1010     LIKE ogb_file.ogb1010,
        l_ogb14       LIKE ogb_file.ogb14,
        l_ogb14t      LIKE ogb_file.ogb14t,
        l_n           LIKE type_file.num5,                    #No.FUN-680137 SMALLINT
        l_max         LIKE tqw_file.tqw08,
        l_tqw08       LIKE tqw_file.tqw08,
        l_tqw081      LIKE tqw_file.tqw081,
        l_ogb31       LIKE ogb_file.ogb31,    #No.FUN-670008
        l_ogb32       LIKE ogb_file.ogb32,    #No.FUN-670008
        l_retn_amt    LIKE ohb_file.ohb14     #No.FUN-670008
 DEFINE l_ogb         RECORD LIKE ogb_file.*
 DEFINE l_tmp         LIKE type_file.chr1000
 DEFINE l_flag        LIKE type_file.num5
 #DEFINE l_imaicd04    LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
 #DEFINE l_imaicd08    LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
 DEFINE l_rvbs06      LIKE rvbs_file.rvbs06
 DEFINE l_ogb14t_1    LIKE ogb_file.ogb14t   #No.FUN-870007
 DEFINE l_rxx04       LIKE rxx_file.rxx04    #No.FUN-870007
 DEFINE p_fno         LIKE oga_file.oga16
 DEFINE l_img09       LIKE img_file.img09     #CHI-C30064 add
 DEFINE l_ogb05_fac   LIKE ogb_file.ogb05_fac #CHI-C30064 add
 
 WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012

  #FUN-A30116 ADD---------------------
   LET g_fno = p_fno     #FUN-AC0002
   LET g_plant_new = p_plant
   CALL s_gettrandbs()
   LET g_dbs=s_dbstring(g_dbs_tra)    #by cock 0427
   CALL s_getlegal(p_plant) RETURNING l_legal
   LET p_legal = l_legal
  #FUN-A30116 END--------------------

 LET g_success = 'Y'
 

 IF cl_null(p_oga01) IS NULL THEN
    CALL cl_err('',-400,0)
    LET g_success = 'N'
    RETURN
 END IF
#FUN-A30116 ADD---------------------
#SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = p_oga01
 #LET l_sql="SELECT * FROM ",g_dbs,"oga_file WHERE oga01 = '",p_oga01,"'"
 LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
           " WHERE oga01 = '",p_oga01,"'"
 CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
 PREPARE sel_oga_pre FROM l_sql
 EXECUTE sel_oga_pre INTO l_oga.*
#FUN-A30116 END--------------------
 
 LET l_argv0=l_oga.oga09  #FUN-730012
 IF l_oga.oga01 IS NULL THEN
    CALL cl_err('',-400,0)
    LET g_success = 'N'   #FUN-580113
    RETURN
 END IF
#IF l_oga.ogaconf = 'X' THEN
#   CALL cl_err('',9024,0)
#   LET g_success = 'N'   #FUN-580113
#   RETURN
#END IF
#IF l_oga.ogaconf = 'Y' THEN
#   LET g_success = 'N'   #FUN-580113
#   CALL cl_err('','axm-101',0)  #TQC-7C0011
#   RETURN
#END IF
 
 IF g_azw.azw04='2' THEN
   IF l_oga.oga85='1' THEN
     #FUN-A30116 ADD----------------------------------
     #SELECT SUM(ogb14t) INTO l_ogb14t_1 FROM ogb_file
     # WHERE ogb01=l_oga.oga01
      #LET l_sql="SELECT SUM(ogb14t) FROM ",g_dbs,"ogb_file",
      LET l_sql="SELECT SUM(ogb14t) FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                " WHERE ogb01='",l_oga.oga01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102              
      PREPARE sel_ogb14t_pre FROM l_sql
      EXECUTE sel_ogb14t_pre INTO l_ogb14t_1
     #FUN-A30116 END----------------------------------
      IF SQLCA.sqlcode=100 THEN LET l_ogb14t_1=NULL END IF                                                                       
      IF cl_null(l_ogb14t_1) THEN LET l_ogb14t_1=0 END IF     
#FUN-AB0061 -----------mark start---------------- 
#    #FUN-A30116 ADD----------------------------------
#    #SELECT SUM(ogb47) INTO l_ogb47 FROM ogb_file                                                                           
#    # WHERE ogb01=l_oga.oga01
#     #LET l_sql="SELECT SUM(ABS(ogb47)) FROM ",g_dbs,"ogb_file ",
#     LET l_sql="SELECT SUM(ABS(ogb47)) FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102     
#               " WHERE ogb01='",l_oga.oga01,"'"
#     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
#     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
#     PREPARE sel_ogb47_pre FROM l_sql
#     EXECUTE sel_ogb47_pre INTO l_ogb47
#    #FUN-A30116 END----------------------------------
#     IF cl_null(l_ogb47) THEN LET l_ogb47=0 END IF
#FUN-AB0061 -----------mark end----------------
     #FUN-A30116 ADD----------------------------------
     #SELECT azi04 INTO t_azi04 FROM azi_file
     #  WHERE azi01=l_oga.oga23                                                                    
      #LET l_sql="SELECT azi04 FROM ",g_dbs,"azi_file",
      LET l_sql="SELECT azi04 FROM ",cl_get_target_table(g_plant_new,'azi_file'), #FUN-A50102 
                " WHERE azi01='",l_oga.oga23,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102             
      PREPARE sel_azi04_pre FROM l_sql
      EXECUTE sel_azi04_pre INTO t_azi04
     #FUN-A30116 END---------------------------------- 
#FUN-AB0061 -----------mark start----------------                                                                    
#      IF l_oga.oga213='N' THEN                                                                                                
#         LET l_ogb47=l_ogb47*(1+l_oga.oga211/100)                                                                             
#         CALL cl_digcut(l_ogb47,t_azi04) RETURNING l_ogb47                                                                   
#      END  IF                                                                                                                
#      LET l_ogb14t_1=l_ogb14t_1-l_ogb47         
#FUN-AB0061 -----------mark end----------------                                                                                  
     # CALL cl_digcut(l_ogb14t_1,t_azi04) RETURNING l_ogb14t_1     
     LET l_ogb14t_1=s_trunc(l_ogb14t_1,1)   #FUN-AC0002 add
     #FUN-A30116 ADD----------------------------------
     #SELECT SUM(rxx04) INTO l_rxx04 FROM rxx_file
     # WHERE rxx00='02' AND rxx01=l_oga.oga01
     #   AND rxx03='1' 
      #LET l_sql="SELECT SUM(rxx04) FROM ",g_dbs,"rxx_file",
      LET l_sql="SELECT SUM(rxx04) FROM ",cl_get_target_table(g_plant_new,'rxx_file'), #FUN-A50102
                " WHERE rxx00='02' AND rxx01='",l_oga.oga01,"'",
                "   AND rxx03='1' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
      PREPARE sel_rxx04_pre FROM l_sql
      EXECUTE sel_rxx04_pre INTO l_rxx04
     #FUN-A30116 END----------------------------------
      IF SQLCA.sqlcode THEN 
         CALL cl_err('sel SUM(RXX04)',STATUS,0)
         LET l_rxx04=NULL 
      END IF  
      IF cl_null(l_rxx04) THEN LET l_rxx04=0 END IF      
      IF l_rxx04<l_ogb14t_1 THEN
        #CALL cl_err('','art-308',0)
         CALL s_errmsg('rxx04<ogb14t',g_fno,g_plant_new,'art-308',1)  #by cock 0427
         LET g_success='N'
         #TQC-B20181 add begin-----------  
         LET g_errno='art-308'                          
	 LET g_msg1='rxx_file'||'rxx04<ogb14t'||g_plant_new||g_fno 
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDA',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
         RETURN
      END IF 
   END IF
 END IF
 
#無單身資料不可確認
 LET l_cnt=0
#FUN-A30116 ADD----------------------------------
#SELECT COUNT(*) INTO l_cnt
#  FROM ogb_file
# WHERE ogb01=l_oga.oga01
 #LET l_sql = "SELECT COUNT(*) FROM ",g_dbs,"ogb_file ",
 LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
             " WHERE ogb01='",l_oga.oga01,"'"
 CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102              
 PREPARE sel_cnt_pre FROM l_sql
 EXECUTE sel_cnt_pre INTO l_cnt
#FUN-A30116 END----------------------------------
 IF l_cnt=0 OR l_cnt IS NULL THEN
   #CALL cl_err('','mfg-009',0)
    CALL s_errmsg('ogb_file',g_fno,g_plant_new,'mfg-009',1) #cockroach 0427
    LET g_success = 'N'   #FUN-580113
    #TQC-B20181 add begin-----------  
    LET g_errno='mfg-009'                          
    LET g_msg1='ogb_file'||''||g_plant_new||g_fno 
    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
    LET g_msg=g_msg[1,255]
    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
    LET g_errno=''
    LET g_msg=''
    LET g_msg1=''
    #TQC-B20181 add end-------------
    RETURN
 END IF

#IF (l_oga.oga08='1' AND l_cnt > g_oaz.oaz691) OR
#   (l_oga.oga08 MATCHES '[23]' AND l_cnt > g_oaz.oaz692) THEN
#   CALL cl_err('','axm-158',0)
#   LET g_success = 'N'   #FUN-580113
#   RETURN
#END IF
 #除了簽收單之外,單身不可有數量為0者

#FUN-A30116 ADD----------------------------------
#SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file 
#  WHERE oga01 = ogb01 
#    AND oga01 = l_oga.oga01
#    AND (ogb12 IS NULL OR 
#         (oga09 = '8' AND ogb12 < 0) OR 
#         (oga09 <> '8' AND ogb12 <= 0))
#FUn-B40017 mark begin------------------#POS調整，單項退時ogb12可以為負數
# #LET l_cnt = 0  
# #LET l_sql="SELECT COUNT(*) FROM ",g_dbs,"oga_file,",g_dbs,"ogb_file", 
# LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
#                                   cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
#           " WHERE oga01 = ogb01 AND oga01 = '",l_oga.oga01,"'", 
#           " AND (ogb12 IS NULL OR              ",
#           "      (oga09 = '8' AND ogb12 < 0) OR",
#           "      (oga09 <> '8' AND ogb12 <= 0))"
# CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
# CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
# PREPARE sel_cnt1_pre FROM l_sql
# EXECUTE sel_cnt1_pre INTO l_cnt
# #FUN-A30116 END----------------------------------
# IF l_cnt > 0 THEN
#   #CALL cl_err('','mfg3348',0)
#    CALL s_errmsg('ogb12',g_fno,g_plant_new,'mfg3348',1) #cockroach 0427
#    LET g_success = 'N'
#    #TQC-B20181 add begin-----------  
#    LET g_errno='mfg3348'                          
#    LET g_msg1='ogb_file'||'ogb12'||g_plant_new||g_fno 
#    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
#    LET g_msg=g_msg[1,255]
#    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
#    LET g_errno=''
#    LET g_msg=''
#    LET g_msg1=''
#    #TQC-B20181 add end-------------
#    RETURN
# END IF
#FUn-B40017 mark end---------------------------------------------
 
IF g_azw.azw04<>'2' THEN #No.FUN-870007
 IF l_oga.oga161>0 THEN
  #FUN-A30116 ADD----------------------------------
  #DECLARE ogb_curs CURSOR FOR 
  #  SELECT ogb31 FROM ogb_file WHERE ogb01=l_oga.oga01
  #FOREACH ogb_curs INTO l_ogb31 
   #LET l_sql = "SELECT ogb31 FROM ",g_dbs,"ogb_file WHERE ogb01='",l_oga.oga01,"'"
   LET l_sql = "SELECT ogb31 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
               " WHERE ogb01='",l_oga.oga01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102 
   PREPARE sel_ogb31_pre FROM l_sql
   DECLARE sel_ogb31_curs CURSOR FOR sel_ogb31_pre
   FOREACH sel_ogb31_curs INTO l_ogb31 
  #FUN-A30116 END----------------------------------

     #FUN-A30116 ADD----------------------------------
     #SELECT SUM(oma55) INTO l_oma55
     #  FROM oma_file
     # WHERE oma16=l_ogb31   #MOD-850221   
     #   AND oma00='11'
     #   AND omaconf='Y'
      #LET l_sql="SELECT SUM(oma55) FROM ",g_dbs,"oma_file",
      LET l_sql="SELECT SUM(oma55) FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
                " WHERE oma16='",l_ogb31,"'",   #MOD-850221   
                "   AND oma00='11' AND omaconf='Y'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE sel_oma55_pre FROM l_sql
      EXECUTE sel_oma55_pre INTO l_oma55
     #FUN-A30116 END----------------------------------     
      IF SQLCA.sqlcode OR cl_null(l_oma55) THEN
         LET l_oma55=0
      END IF
     #FUN-A30116 ADD----------------------------------
     #SELECT SUM(oma54t) INTO l_oma54t
     #  FROM oma_file
     # WHERE oma16=l_ogb31   #MOD-850221   
     #   AND oma00='11'
     #   AND omaconf='Y'
      #LET l_sql="SELECT SUM(oma54t) FROM ",g_dbs,"oma_file",
      LET l_sql="SELECT SUM(oma54t) FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
                " WHERE oma16='",l_ogb31,"'",   #MOD-850221   
                "   AND oma00='11' AND omaconf='Y'" 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
      PREPARE sel_oma54t_pre FROM l_sql
      EXECUTE sel_oma54t_pre INTO l_oma54t
     #FUN-A30116 END----------------------------------
 
      IF SQLCA.sqlcode OR cl_null(l_oma54t) THEN
         LET l_oma54t=0
      END IF
      IF (l_oma55<l_oma54t) OR (l_oma54t=0) THEN
       #CALL cl_err('','axm-135',1) #MOD-780163
        CALL s_errmsg('oma55,oma54t',g_fno,g_plant_new,'axm-135',1) #cockroach 0427 
        LET g_success='N'
        #TQC-B20181 add begin-----------  
        LET g_errno='axm-135'                          
	LET g_msg1='oma_file'||'oma55,oma54t'||g_plant_new||g_fno 
	CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	LET g_msg=g_msg[1,255]
	CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDA',g_errno,g_msg,'0','N',g_msg1)
	LET g_errno=''
	LET g_msg=''
	LET g_msg1=''
        #TQC-B20181 add end-------------
        RETURN
      END IF
   END FOREACH   #MOD-850221
 END IF
END IF  #No.FUN-870007
#Check 倉是否為可用倉
#FUN-A30116 ADD----------------------------------
#DECLARE t600sub_ogb09_1 CURSOR FOR
#SELECT ogb09 FROM ogb_file
# WHERE ogb01=l_oga.oga01
 #LET l_sql="SELECT ogb09 FROM ",g_dbs,"ogb_file",
 LET l_sql="SELECT ogb09 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
           " WHERE ogb01='",l_oga.oga01,"'" 
 CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
 PREPARE sel_ogb09_pre FROM l_sql
 DECLARE t600sub_ogb09_1 CURSOR FOR sel_ogb09_pre
#FUN-A30116 END----------------------------------
 FOREACH t600sub_ogb09_1 INTO l_ogb09
    IF NOT cl_null(l_ogb09) THEN
       LET l_cnt=0
      #FUN-A30116 ADD----------------------------------
      #SELECT count(*) INTO l_cnt FROM imd_file
      # WHERE imd01=l_ogb09
      #   AND imd11='Y'
      #   AND imdacti='Y'
       #LET l_sql="SELECT count(*) FROM ",g_dbs,"imd_file",
       LET l_sql="SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'imd_file'), #FUN-A50102
                 " WHERE imd01='",l_ogb09,"'",
                 "   AND imd11='Y' AND imdacti='Y'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
       PREPARE sel_cnt2_pre FROM l_sql
       EXECUTE sel_cnt2_pre INTO l_cnt
      #FUN-A30116 END----------------------------------  
       IF l_cnt=0 THEN
         #CALL cl_err(l_ogb09,'axm-993',0)
          CALL s_errmsg(l_ogb09,g_fno,g_plant_new,'axm-993',1) #cockroach 0427
          LET g_success = 'N'   #FUN-580113
          #TQC-B20181 add begin-----------  
          LET g_errno='axm-993'                          
	  LET g_msg1='imd_file'||l_ogb09||g_plant_new||g_fno 
	  CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	  LET g_msg=g_msg[1,255]
	  CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDA',g_errno,g_msg,'0','N',g_msg1)
	  LET g_errno=''
	  LET g_msg=''
	  LET g_msg1=''
          #TQC-B20181 add end-------------
          RETURN
       END IF
    ELSE
       CONTINUE FOREACH
    END IF
 END FOREACH
 
  #FUN-A30116 ADD----------------------------------
  #DECLARE t600sub_ogbrvbs CURSOR FOR
  #SELECT * FROM ogb_file
  # WHERE ogb01=l_oga.oga01
   #LET l_sql="SELECT * FROM ",g_dbs,"ogb_file",
   LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
             " WHERE ogb01='",l_oga.oga01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
   PREPARE sel_ogb1_pre FROM l_sql
   DECLARE t600sub_ogbrvbs CURSOR FOR sel_ogb1_pre
  #FUN-A30116 END----------------------------------
   FOREACH t600sub_ogbrvbs INTO l_ogb.*
      LET g_ima918 = ''   #MOD-9C0055
      LET g_ima921 = ''   #MOD-9C0055
     #FUN-A30116 ADD----------------------------------
     #SELECT ima918,ima921 INTO g_ima918,g_ima921 
     #  FROM ima_file
     # WHERE ima01 = l_ogb.ogb04
     #   AND imaacti = "Y"
      #LET l_sql="SELECT ima918,ima921 FROM ",g_dbs,"ima_file ",
     LET l_sql="SELECT ima918,ima921 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                " WHERE ima01 = '",l_ogb.ogb04,"'",
                "   AND imaacti = 'Y' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE sel_ima918_pre FROM l_sql
      EXECUTE sel_ima918_pre INTO g_ima918,g_ima921
     #FUN-A30116 END---------------------------------- 
      IF NOT (l_oga.oga09='1' AND g_oaz.oaz81='N') THEN  ##FUN-850120  #出通單要判斷參數
         IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
           #FUN-A30116 ADD----------------------------------
           #SELECT SUM(rvbs06) INTO l_rvbs06
           #  FROM rvbs_file
           # WHERE rvbs00 = g_prog
           #   AND rvbs01 = l_ogb.ogb01
           #   AND rvbs02 = l_ogb.ogb03    #FUN-850120
           #   AND rvbs09 = -1
            #LET l_sql="SELECT SUM(rvbs06) FROM ",g_dbs,"rvbs_file",
            LET l_sql="SELECT SUM(rvbs06) FROM ",cl_get_target_table(g_plant_new,'rvbs_file'), #FUN-A50102
                      " WHERE rvbs00 = '",g_prog,"'",
                      "   AND rvbs01 = '",l_ogb.ogb01,"'",
                      "   AND rvbs02 = '",l_ogb.ogb03,"'",    #FUN-850120
                      "   AND rvbs09 = -1"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
            PREPARE sel_rvbs06_pre FROM l_sql
            EXECUTE sel_rvbs06_pre INTO l_rvbs06
           #FUN-A30116 END----------------------------------
            IF cl_null(l_rvbs06) THEN
               LET l_rvbs06 = 0
            END IF
             
           #CHI-C30064---Start---add
            SELECT img09 INTO l_img09 FROM img_file
             WHERE img01= l_ogb.ogb04 AND img02= l_ogb.ogb09
               AND img03= l_ogb.ogb091 AND img04= l_ogb.ogb092
            CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogb05_fac
            IF g_cnt = '1' THEN
               LET l_ogb05_fac = 1
            END IF             
           #CHI-C30064---End---add 
           #IF (l_ogb.ogb12 * l_ogb.ogb05_fac) <> l_rvbs06 THEN   #No.FUN-860045
            IF (l_ogb.ogb12 * l_ogb05_fac) <> l_rvbs06 THEN   #No.FUN-860045 #CHI-C30064
               LET g_success = "N"
              #CALL cl_err(l_ogb.ogb04,"aim-011",1)
               CALL s_errmsg(l_ogb.ogb04,g_fno,g_plant_new,"aim-011",1)
               #TQC-B20181 add begin-----------  
               LET g_errno='aim-011'                          
	       LET g_msg1='rvbs_file'||l_ogb.ogb04||g_plant_new||g_fno 
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
      END IF    ##FUN-850120
   END FOREACH
 
 #若現行年月大於出貨單/銷退單之年月--不允許確認
#IF l_argv0 NOT MATCHES '[15]' THEN    #No.MOD-880260   
#   CALL s_yp(l_oga.oga02) RETURNING l_yy,l_mm #No.TQC-7C0070
#   IF (l_yy > g_sma.sma51) OR (l_yy = g_sma.sma51 AND l_mm > g_sma.sma52) THEN
#       CALL cl_err('','mfg6090',0)  #MOD-790009
#       LET g_success = 'N'   #FUN-580113
#       RETURN
#   END IF
#END IF                                #No.MOD-880260 
 
 IF g_oaz.oaz03 = 'Y' AND
    g_sma.sma53 IS NOT NULL AND l_oga.oga02 <= g_sma.sma53 THEN
   #CALL cl_err('','mfg9999',0)
    CALL s_errmsg('',g_fno,g_plant_new,'mfg9999',1) #cockroach 0427
    LET g_success = 'N'   #FUN-580113
    #TQC-B20181 add begin-----------  
    LET g_errno='mfg9999'                          
    LET g_msg1=''||''||g_plant_new||g_fno 
    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
    LET g_msg=g_msg[1,255]
    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDA',g_errno,g_msg,'0','N',g_msg1)
    LET g_errno=''
    LET g_msg=''
    LET g_msg1=''
    #TQC-B20181 add end-------------
    RETURN
 END IF
 #No.7992  多角貿易單據
 IF l_oga.oga909 = 'Y' THEN
    IF l_oga.oga905= 'Y' THEN   #拋轉否
      #CALL cl_err(l_oga.oga905,'axm-307',0)
       CALL s_errmsg(l_oga.oga905,g_fno,g_plant_new,'axm-307',0)
       LET g_success = 'N'   #FUN-580113
       #TQC-B20181 add begin-----------  
       LET g_errno='axm-307'                           
       LET g_msg1=''||l_oga.oga906||g_plant_new||g_fno
       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
       LET g_msg=g_msg[1,255]
       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
       LET g_errno=''
       LET g_msg=''
       LET g_msg1=''
       #TQC-B20181 add end-------------
       RETURN
    END IF
 
 
    IF l_oga.oga906 <>'Y' THEN     #是否為來源出貨單
      #CALL cl_err(l_oga.oga906,'axm-402',0)         #No.MOD-660080 modify
       CALL s_errmsg(l_oga.oga906,g_fno,g_plant_new,'axm-402',1) #COCKROACH 0427
       LET g_success = 'N'   #FUN-580113
       #TQC-B20181 add begin-----------  
       LET g_errno='axm-402'                           
       LET g_msg1=''||l_oga.oga906||g_plant_new||g_fno
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
 #若採訂單匯率立帳則幣別匯率相同才可併單
 IF NOT t600sub_oea18_chk(0,l_oga.*,NULL,FALSE) THEN
    LET g_success = 'N'   #FUN-580113
    RETURN
 ELSE
   #FUN-A30116 ADD-----------------------------------------------------
   #SELECT oga24 INTO l_oga.oga24 FROM oga_file WHERE oga01=g_oga.oga01 #FUN-730012 add oga24的值可能被異動,必須重抓
    #LET l_sql="SELECT oga24 FROM ",g_dbs,"oga_file WHERE oga01='",l_oga.oga01,"' "
    LET l_sql="SELECT oga24 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
              " WHERE oga01='",l_oga.oga01,"' "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102 
    PREPARE sel_oga24_pre FROM l_sql
    EXECUTE sel_oga24_pre INTO l_oga.oga24
   #FUN-A30116 END-----------------------------------------------------
 END IF
#FUN-B50055 MARK BY COCKROACH -------------------------------------------------------
## 為防立應收不對,加上若單頭有輸入訂單號碼時,
##                       check 訂單的訂金,出貨比率有沒有一致
# IF NOT cl_null(l_oga.oga16) THEN
#   #FUN-A30116 ADD-----------------------------------------------------
#   #SELECT oea161,oea162,oea163 INTO l_oea161,l_oea162,l_oea163 FROM oea_file
#   # WHERE oea01=l_oga.oga16
#    #LET l_sql="SELECT oea161,oea162,oea163 FROM ",g_dbs,"oea_file WHERE oea01='",l_oga.oga16,"' "
#    LET l_sql="SELECT oea161,oea162,oea163 FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
#              " WHERE oea01='",l_oga.oga16,"' "
#    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
#    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
#    PREPARE sel_oea161_pre FROM l_sql
#    EXECUTE sel_oea161_pre INTO l_oea161,l_oea162,l_oea163
#   #FUN-A30116 END-----------------------------------------------------     
#    IF cl_null(l_oea161) THEN LET l_oea161=0   END IF
#    IF cl_null(l_oea162) THEN LET l_oea162=100 END IF #MODNO:5230
#    IF cl_null(l_oea163) THEN LET l_oea163=0   END IF
#    IF l_oea161 != l_oga.oga161 OR l_oea162 !=l_oga.oga162 OR
#       l_oea163 != l_oga.oga163 THEN
#      #CALL cl_err(l_oga.oga16,'mfg-010',1)
#       CALL s_errmsg(l_oga.oga16,g_fno,g_plant_new,'mfg-010',1) #cockroach 0427
#       LET g_success = 'N'   #FUN-580113
#       #TQC-B20181 add begin-----------  
#       LET g_errno='mfg-010'                           
#       LET g_msg1=''||l_oga.oga16||g_plant_new||g_fno
#       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
#       LET g_msg=g_msg[1,255]
#       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
#       LET g_errno=''
#       LET g_msg=''
#       LET g_msg1=''
#       #TQC-B20181 add end-------------
#       RETURN
#    END IF
# END IF
#FUN-B50055 MARK BY COCKROACH -------------------------------------------------------
 
  IF g_sma.sma115= 'Y' THEN   #TQC-620100
     LET l_x1 = "Y"
     LET l_x2 = "Y"
    #LET l_sql="SELECT ogb910,ogb912 FROM ogb_file ",     #No.FUN-610064  #FUN-A30116 MARK
     #LET l_sql="SELECT ogb910,ogb912 FROM ",g_dbs,"ogb_file ",
     LET l_sql="SELECT ogb910,ogb912 FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102    
               " WHERE ogb01='",l_oga.oga01,"'",
               "   AND ogb1005='1' "
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
     PREPARE pre_ogb3 FROM l_sql
     DECLARE ogb_curs3 CURSOR FOR pre_ogb3
     FOREACH ogb_curs3 INTO l_ogb910,l_ogb912
        IF cl_null(l_ogb910) THEN LET l_x1 = "N" END IF
        IF cl_null(l_ogb912) THEN LET l_x2 = "N" END IF
     END FOREACH
     IF l_x1 = "N" THEN
        #出貨單位欄位不可空白
        CALL cl_getmsg('asm-303',g_lang) RETURNING l_msg1
        CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2
        LET l_msg = l_msg1 CLIPPED,l_msg2
     END IF
     IF l_x2 = "N" THEN
        #出貨數量欄位不可空白
        CALL cl_getmsg('asm-307',g_lang) RETURNING l_msg1
        CALL cl_getmsg('mfg0037',g_lang) RETURNING l_msg2
        LET l_msg = l_msg CLIPPED,l_msg1 CLIPPED,l_msg2
     END IF
     IF NOT cl_null(l_msg) THEN
       #CALL cl_msgany(10,20,l_msg)
        CALL s_errmsg(l_msg,g_fno,g_plant_new,l_msg,1) #cockroach 0427 
        LET g_success = 'N'
        #TQC-B20181 add begin-----------  
        LET g_errno=l_msg                           
	LET g_msg1=l_msg||''||g_plant_new||g_fno
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
 

 
#FUN-A30116 MARK----------------------------------------------------------- 
# IF g_success = 'Y' THEN
#    CALL t600sub_hu1(l_oga.*)   #信用查核
#    IF g_success = 'N' THEN
#       LET g_success = 'N'   #FUN-580113
#    END IF
#
#    IF g_success='Y' THEN
#      #FUN-A30116 ADD------------------------------------------- 
#      #UPDATE oga_file SET oga902 = ' ' WHERE oga01=l_oga.oga01
#       LET l_sql="UPDATE ",g_dbs,"oga_file SET oga902 = ' ' WHERE oga01='",l_oga.oga01,"'"
#       PREPARE upd_oga92_pre FROM l_sql
#       EXECUTE upd_oga92_pre
#      #FUN-A30116 END-------------------------------------------
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#          LET g_success = 'N'
#       END IF
#    ELSE
#      #FUN-A30116 ADD-------------------------------------------
#      #UPDATE oga_file SET oga902 =g_oaz.oaz11 WHERE oga01=l_oga.oga01
#       LET l_sql="UPDATE ",g_dbs,"oga_file ",
#                 "   SET oga902 ='",g_oaz.oaz11,"'",
#                 " WHERE oga01='",l_oga.oga01,"' "
#       PREPARE upd_oga902_pre FROM l_sql
#       EXECUTE upd_oga902_pre
#      #FUN-A30116 END-------------------------------------------
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#           LET g_success = 'N'
#       END IF
#    END IF
# END IF
#FUN-A30116 MARK----------------------------------------------------------- 
 
  #LET l_sql = " SELECT oga09,ogb12,ogb19,ogb11,ogb01,ogb03 FROM oga_file,ogb_file ", #FUN-A30116 MARK
   #LET l_sql = " SELECT oga09,ogb12,ogb19,ogb11,ogb01,ogb03 FROM ",g_dbs,"oga_file,",g_dbs,"ogb_file ",
   LET l_sql = " SELECT oga09,ogb12,ogb19,ogb11,ogb01,ogb03 FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
                                                                   cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
               "  WHERE oga01 = ogb01 ",
               "    AND ogb01 = '",l_oga.oga01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102             
   PREPARE t600sub_pre2  FROM l_sql
   DECLARE t600sub_curs2 CURSOR FOR t600sub_pre2
   FOREACH t600sub_curs2 INTO l_oga09,l_ogb12,l_ogb19,l_ogb11,l_qcs01,l_qcs02
     IF l_ogb19 = 'Y' AND l_oga09<>"1" THEN                                               #No.FUN-840164
       #-----CHI-880006---------
       #確認段不做OQC的判斷
       #LET l_qcs091c = 0
       #SELECT SUM(qcs091) INTO l_qcs091c
       #  FROM qcs_file
       # WHERE qcs01 = l_qcs01
       #   AND qcs02 = l_qcs02
       #   AND qcs14 = 'Y'
       #
       #IF l_qcs091c IS NULL THEN
       #   LET l_qcs091c =0
       #END IF
       #IF l_argv0<>"8" OR cl_null(l_argv0) THEN #CHI-690055                               
       #   IF l_ogb12 > l_qcs091c THEN
       #      IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012                                                                           
       #         IF NOT cl_confirm('mfg3561') THEN   #CHI-830030 
       #            LET g_success = 'N'                
       #            RETURN                                                                                                                              
       #         END IF                              #CHI-830030 
       #      END IF
       #   END IF
       #END IF
       #------END CHI-880006-----
     END IF
   END FOREACH
 
  #以下的程式由upd()段移過來
      IF g_prog <> 'atmt248' AND g_prog <> 'axmt628' THEN  #No.MOD-670123  #No.TQC-6C0085 add axmt628
        #FUN-A30116 ADD------------------------------------------------
        #DECLARE l_ogb_conf CURSOR FOR                #No.FUN-670008
        # SELECT ogb31,ogb32,ogb1010,ogb14,ogb14t     #No.FUN-670008
        #   FROM ogb_file
        #  WHERE ogb01=l_oga.oga01
        #    AND ogb1005='2'
         #LET l_sql = "SELECT ogb31,ogb32,ogb1010,ogb14,ogb14t FROM ",g_dbs,"ogb_file ",
        LET l_sql = "SELECT ogb31,ogb32,ogb1010,ogb14,ogb14t FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                     " WHERE ogb01='",l_oga.oga01,"'",
                     "   AND ogb1005='2'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
         PREPARE l_ogb_pre FROM l_sql
         DECLARE l_ogb_conf CURSOR FOR l_ogb_pre
        #FUN-A30116 END------------------------------------------------
          FOREACH l_ogb_conf INTO l_ogb31,l_ogb32,l_ogb1010,l_ogb14,l_ogb14t  #No.FUN-670008
             IF l_ogb1010 ='Y' THEN
               #FUN-A30116 ADD------------------------------------------------ 
               #SELECT oeb14t INTO l_tqw08 FROM oeb_file
               # WHERE oeb01 =l_ogb31
               #   AND oeb03 =l_ogb32
                #LET l_sql ="SELECT oeb14t FROM ",g_dbs,"oeb_file",
                LET l_sql ="SELECT oeb14t FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                           " WHERE oeb01 ='",l_ogb31,"' AND oeb03 ='",l_ogb32,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
                PREPARE sel_oeb14t_pre FROM  l_sql
                EXECUTE sel_oeb14t_pre INTO l_tqw08  
               #SELECT SUM(ogb14t) INTO l_tqw081 FROM ogb_file,oga_file
               # WHERE ogb31 = l_ogb31
               #   AND ogb32 = l_ogb32
               #   AND oga01 = ogb01
               #   AND ogapost = 'Y'
               #   AND ogaconf !='X' #CHI-6B0036
                #LET l_sql="SELECT SUM(ogb14t) FROM ",g_dbs,"ogb_file,",g_dbs,"oga_file",
                LET l_sql="SELECT SUM(ogb14t) FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
                                                     cl_get_target_table(g_plant_new,'oga_file'),     #FUN-A50102
                          " WHERE ogb31 = '",l_ogb31,"'",
                          "   AND ogb32 = '",l_ogb32,"'",
                          "   AND oga01 = ogb01",
                          "   AND ogapost = 'Y'",
                          "   AND ogaconf !='X'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
                PREPARE sel_ogb14t_pre1 FROM l_sql
                EXECUTE sel_ogb14t_pre1 INTO l_tqw081
               #SELECT SUM(ohb14t) INTO l_retn_amt FROM ohb_file,oha_file
               # WHERE ohb33 =l_ogb31
               #   AND ohb34 =l_ogb32
               #   AND oha01 =ohb01
               #   AND ohapost ='Y'
                #LET l_sql="SELECT SUM(ohb14t) FROM ",g_dbs,"ohb_file,",g_dbs,"oha_file",
                LET l_sql="SELECT SUM(ohb14t) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",", #FUN-A50102
                                                     cl_get_target_table(g_plant_new,'oha_file'),     #FUN-A50102
                          " WHERE ohb33 ='",l_ogb31,"'",
                          "   AND ohb34 ='",l_ogb32,"'",
                          "   AND oha01 =ohb01",
                          "   AND ohapost ='Y'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
                PREPARE sel_ohb14t_pre FROM l_sql
                EXECUTE sel_ohb14t_pre INTO l_retn_amt
             ELSE
               #SELECT oeb14 INTO l_tqw08 FROM oeb_file
               # WHERE oeb01 =l_ogb31
               #   AND oeb03 =l_ogb32
                #LET l_sql ="SELECT oeb14 FROM ",g_dbs,"oeb_file",
                LET l_sql ="SELECT oeb14 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                           " WHERE oeb01 ='",l_ogb31,"' AND oeb03 ='",l_ogb32,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
                PREPARE sel_oeb14_pre FROM  l_sql
                EXECUTE sel_oeb14_pre INTO l_tqw08  
               #SELECT SUM(ogb14) INTO l_tqw081 FROM ogb_file,oga_file
               # WHERE ogb31 = l_ogb31
               #   AND ogb32 = l_ogb32
               #   AND oga01 = ogb01
               #   AND ogapost = 'Y'
               #   AND ogaconf !='X'  #CHI-6B0036
                #LET l_sql="SELECT SUM(ogb14) FROM ",g_dbs,"ogb_file,",g_dbs,"oga_file",
                LET l_sql="SELECT SUM(ogb14) FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
                                                    cl_get_target_table(g_plant_new,'oga_file'),     #FUN-A50102
                          " WHERE ogb31 = '",l_ogb31,"'",
                          "   AND ogb32 = '",l_ogb32,"'",
                          "   AND oga01 = ogb01",
                          "   AND ogapost = 'Y'",
                          "   AND ogaconf !='X'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
                PREPARE sel_ogb14_pre FROM l_sql
                EXECUTE sel_ogb14_pre INTO l_tqw081
               #SELECT SUM(ohb14) INTO l_retn_amt FROM ohb_file,oha_file
               # WHERE ohb33 =l_ogb31
               #   AND ohb34 =l_ogb32
               #   AND oha01 =ohb01
               #   AND ohapost ='Y'
                #LET l_sql="SELECT SUM(ohb14) FROM ",g_dbs,"ohb_file,",g_dbs,"oha_file",
                LET l_sql="SELECT SUM(ohb14) FROM ",cl_get_target_table(g_plant_new,'ohb_file'),",", #FUN-A50102
                                                    cl_get_target_table(g_plant_new,'oha_file'),     #FUN-A50102
                          " WHERE ohb33 ='",l_ogb31,"'",
                          "   AND ohb34 ='",l_ogb32,"'",
                          "   AND oha01 =ohb01",
                          "   AND ohapost ='Y'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
                CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
                PREPARE sel_ohb14_pre FROM l_sql
                EXECUTE sel_ohb14_pre INTO l_retn_amt
             END IF
             IF cl_null(l_tqw081) THEN
                LET l_tqw081 =0
             END IF
             IF cl_null(l_retn_amt) THEN
                LET l_retn_amt =0
             END IF
             LET l_tqw081 =l_tqw081-l_retn_amt
 
             LET l_max =l_tqw08 -l_tqw081
 
             IF l_ogb1010 ='Y' THEN
                IF l_max >= 0 THEN
                   IF l_ogb14t >l_max OR l_ogb14t <= 0 THEN
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                     #CALL cl_err(l_msg,'atm-526',1)  #No.FUn-670008
                      CALL s_errmsg(l_msg,g_fno,g_plant_new,'atm-526',1)  #COCKROACH 0427
                      LET g_success='N'
                      #TQC-B20181 add begin-----------  
                      LET g_errno='atm-526'                          
	              LET g_msg1=l_msg||''||g_plant_new||g_fno
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
                   IF l_ogb14t <l_max OR l_ogb14t <= 0 THEN
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                      CALL s_errmsg(l_msg,g_fno,g_plant_new,'atm-527',1)  #COCKROACH 0427
                     #CALL cl_err(l_msg,'atm-527',1)  #No.FUN-670008
                      LET g_success='N'
                      #TQC-B20181 add begin-----------  
                      LET g_errno='atm-527'                          
	              LET g_msg1=l_msg||''||g_plant_new||g_fno
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
                IF l_max >= 0 THEN
                   IF l_ogb14 >l_max OR l_ogb14 <= 0 THEN
                      LET l_msg =l_ogb32,l_ogb14     #No.FUN-670008
                     #CALL cl_err(l_msg,'atm-526',1) #No.FUN-670008
                      CALL s_errmsg(l_msg,g_fno,g_plant_new,'atm-526',1)  #COCKROACH 0427
                      LET g_success='N'
                      #TQC-B20181 add begin-----------  
                      LET g_errno='atm-526'                          
	              LET g_msg1=l_msg||''||g_plant_new||g_fno
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
                   IF l_ogb14 <l_max OR l_ogb14 <= 0 THEN
                      LET l_msg =l_ogb32,l_ogb14t     #No.FUN-670008
                     #CALL cl_err(l_msg,'atm-527',1)  #No.FUN-670008
                      CALL s_errmsg(l_msg,g_fno,g_plant_new,'atm-527',1)  #COCKROACH 0427
                      LET g_success='N'
                      #TQC-B20181 add begin-----------  
                      LET g_errno='atm-527'                          
	              LET g_msg1=l_msg||''||g_plant_new||g_fno
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
          END FOREACH
      END IF   #No.MOD-670123

  #  #FUN-970017---add----str---
  #   IF g_action_choice <> 'efconfirm' THEN
  #      IF l_argv0 = '2' AND l_oga.oga65='Y' AND g_success = 'Y' THEN
  #         CALL t600sub_on_check(l_oga.*)
  #              RETURNING l_oga.*  #FUN-730012 有部分的l_oga有異動,此處必須回傳
  #      END IF
  #   END IF
  #  #FUN-970017---add----end--- 

END FUNCTION
 
#{
#函數用途:檢查程序-若採訂單匯率立帳則幣別匯率相同才可併單
#參數:
#     p_ogb03:ogb03
#     l_oga:出貨單頭
#     p_ogb31:ogb31
#     p_fieldchk:欄位檢查時呼叫此函數傳TRUE,確認時呼叫此函數傳FALSE
#回傳值:TRUE-檢查無誤; FALSE- 檢查有誤
#注意:oga24的值可能被異動,呼叫此FUN後必須重抓
#}
FUNCTION t600sub_oea18_chk(p_ogb03,l_oga,p_ogb31,p_fieldchk)
   DEFINE p_ogb03   LIKE ogb_file.ogb03
   DEFINE l_oga     RECORD LIKE oga_file.* #FUN-730012
   DEFINE p_fieldchk LIKE type_file.num5   #FUN-730012
   DEFINE l_oea     RECORD LIKE oea_file.* #FUN-730012
   DEFINE p_ogb31   LIKE ogb_file.ogb31
   DEFINE l_oea18   LIKE oea_file.oea18,
          l_oea23   LIKE oea_file.oea23,
          l_oea24   LIKE oea_file.oea24,
          l_oea01   LIKE oea_file.oea01,
          o_oea18   LIKE oea_file.oea18,
          o_oea23   LIKE oea_file.oea23,
          o_oea24   LIKE oea_file.oea24,
          l_ogb03   LIKE ogb_file.ogb03,
          l_cnt     LIKE type_file.num5     #No.FUN-680137 SMALLINT
 
   IF p_fieldchk THEN
      #LET l_sql="SELECT * FROM ",g_dbs,"oea_file",
      LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                " WHERE oea01='",p_ogb31,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE sel_oea_pre2 FROM l_sql
      EXECUTE sel_oea_pre2 INTO l_oea.* 
      IF STATUS THEN
         CALL cl_err3("sel","oea_file",p_ogb31,"",SQLCA.sqlcode,"","sel oea",1)  #No.FUN-670008
         RETURN FALSE
      END IF
 
      IF l_oea.oea044 != l_oga.oga044 THEN
         CALL cl_err('axm-916',STATUS,0)
         RETURN FALSE
      END IF
   END IF
 
   LET l_cnt=0
   IF cl_null(p_ogb03) THEN LET p_ogb03 =0 END IF
   LET l_sql = "SELECT oea01,oea23,oea24,oea18 ,ogb03",
               #"  FROM ",g_dbs,"oea_file,",g_dbs,"ogb_file",
               "  FROM ",cl_get_target_table(g_plant_new,'oea_file'),",", #FUN-A50102
                         cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
               " WHERE oea01=ogb31",
               "   AND ogb01='",l_oga.oga01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
   PREPARE sel_oea01_pre FROM l_sql
   DECLARE oea18_chk CURSOR FOR sel_oea01_pre
   FOREACH oea18_chk INTO l_oea01,l_oea23,l_oea24,l_oea18,l_ogb03
        IF SQLCA.SQLCODE <> 0 THEN EXIT FOREACH END IF
        IF cl_null(l_oea18) THEN LET l_oea18='N' END IF
        IF p_ogb03 <> 0 AND l_ogb03=p_ogb03 THEN
           CONTINUE FOREACH
        END IF
        LET l_cnt = l_cnt+1
        IF l_cnt=1 THEN
           LET o_oea18=l_oea18
           LET o_oea23=l_oea23
           LET o_oea24=l_oea24
           IF l_oea18='Y' THEN
              LET l_oga.oga24 = l_oea24
              #LET l_sql="UPDATE ",g_dbs,"oga_file",
              LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                        "   SET oga24 = '",l_oga.oga24,"'",
                        " WHERE oga01 = '",l_oga.oga01,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
              PREPARE upd_oga24_pre FROM l_sql
              EXECUTE upd_oga24_pre
           END IF
        END IF
        IF l_oea18 <> o_oea18 OR
           (l_oea18='Y' AND (l_oea23 <> o_oea23 OR l_oea24 <>o_oea24)) THEN
            CALL cl_err(l_oea01,'axm-608',1)
            RETURN FALSE #FUN-730012
        END IF
   END FOREACH
   IF p_fieldchk THEN
      IF cl_null(l_oea.oea18) THEN LET l_oea.oea18='N' END IF
      #若是訂單匯率立帳, 則帶該訂單之匯率
      IF l_cnt=0 AND l_oea.oea18='Y' THEN
         LET l_oga.oga24 = l_oea.oea24
         #LET l_sql="UPDATE ",g_dbs,"oga_file SET oga24 = '",l_oga.oga24,"'",
         LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                   "   SET oga24 = '",l_oga.oga24,"'",
                   " WHERE oga01 = '",l_oga.oga01,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102             
         PREPARE upd_oga24_pre1 FROM l_sql
         EXECUTE upd_oga24_pre1
      END IF
      IF l_cnt > 0 AND (l_oea.oea18 <>l_oea18 OR
        (l_oea.oea18='Y' AND (l_oea23<> l_oea.oea23 OR
         l_oea24<> l_oea.oea24) )) THEN
         CALL cl_err('','axm-608',0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
#{
#客戶信用查核
#l_oga:出貨單頭
#回傳值: 無
#}
FUNCTION t600sub_hu1(l_oga)		#客戶信用查核
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_oea908  LIKE oea_file.oea908     #信用放行有效日期
   DEFINE l_oga903  LIKE oga_file.oga903
   DEFINE l_azp03   LIKE azp_file.azp03
   DEFINE l_oga03   LIKE oga_file.oga03     #No.TQC-640123
   DEFINE l_poy04   LIKE poy_file.poy04     #FUN-670007
   DEFINE l_argv0   LIKE oga_file.oga09     #FUN-730012
  #DEFINE l_sql     STRING
   DEFINE li_result LIKE type_file.num5
   DEFINE l_poz     RECORD LIKE poz_file.*
   DEFINE l_oea99   LIKE oea_file.oea99
   DEFINE l_flow    LIKE oea_file.oea904
   DEFINE p_dbs_tra LIKE azw_file.azw05    #FUN-980093 add
   DEFINE g_plant_new_new LIKE azp_file.azp01  #FUN-980093 add
 
   CALL cl_msg("hu1!")
   IF l_oga.oga903= 'Y' THEN RETURN END IF    #該單據信用已放行
   LET l_argv0=l_oga.oga09  #FUN-730012
   #-->若為出貨時判斷, 若出貨日期<=訂單之信用放行日(oea908)則不做信用查核
   IF l_argv0 MATCHES '[2468]' AND NOT cl_null(l_oga.oga16) THEN #No.7992  #No.FUN-630061
      LET l_oea908=''
      SELECT oea908 INTO l_oea908 FROM oea_file WHERE oea01=l_oga.oga16
      IF SQLCA.SQLCODE =0 AND l_oea908 IS NOT NULL AND
         l_oga.oga02 <= l_oea908 THEN
         RETURN
      END IF
   END IF
   #逆拋則要抓來源廠的客戶名稱(多角貿易) No.7992
   LET l_oga03 = l_oga.oga03     #No.TQC-640123
   IF l_oga.oga909 = 'Y' AND (l_oga.oga09 = '4' OR l_oga.oga09 = '5') THEN   #MOD-890252
      CALL t600sub_chkpoz(l_oga.*,NULL) RETURNING li_result,l_poz.*,l_oea99,l_flow  #FUN-730012 
      # kim:因為進去t600sub_chkpoz後,ogb31會再抓一次(確認段不會沒有單身資料),所以p_ogb31傳任何值都可
      IF NOT li_result THEN LET g_success = 'N' RETURN END IF  #FUN-730012
     IF l_poz.poz00 = '1' THEN       #MOD-890252 add  
      IF l_poz.poz011 = '2' THEN
#poz05在3.5x版己經移到poy04處理---
         SELECT poy04 INTO l_poy04
           FROM poy_file
          WHERE poy01 = l_poz.poz01
            AND poy02 = '0'   #起始站
         SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = l_poy04
 
      LET g_plant_new = l_poy04
      LET g_plant_new_new = g_plant_new
      CALL s_gettrandbs()
      LET p_dbs_tra = g_dbs_tra
 
         LET l_azp03 = s_dbstring(l_azp03 CLIPPED)  
         #LET l_sql = " SELECT oea03 FROM ",p_dbs_tra,"oea_file ", #No.TQC-640123 #FUN-980093 add
         LET l_sql = " SELECT oea03 FROM ",cl_get_target_table(g_plant_new_new,'oea_file'), #FUN-A50102
                     "  WHERE oea99 = '",l_oea99,"'"      #MOD-6C0118
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql #MOD-980195   
         CALL cl_parse_qry_sql(l_sql,g_plant_new_new) RETURNING l_sql #FUN-980093
         PREPARE oea03_pre FROM l_sql #No.TQC-640123
         DECLARE oea03_cs CURSOR FOR oea03_pre
         OPEN oea03_cs
         IF STATUS THEN
            CALL cl_err('open oea03',STATUS,1)
            LET g_success = 'N'
         END IF
         FETCH oea03_cs INTO l_oga03   #No.TQC-640123
         IF STATUS THEN
            CALL cl_err('fetch oea03',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
    END IF   #MOD-890252 add
   END IF
   #no.6145(end)No.7992
   IF (l_argv0 MATCHES '[15]'  AND g_oaz.oaz132 MATCHES "[12]") OR    #No.7992
      (l_argv0 MATCHES '[246]' AND g_oaz.oaz142 MATCHES "[123]") THEN #No.7992 #No.FUN-630061
      LET g_errno = 'Y'
      IF l_oga.ogamksg = 'Y' THEN
         CALL s_ccc_logerr()  
      END IF
      #IF l_oga.oga00 MATCHES '[13467]' THEN #出至境外也要作credit check   #CHI-9B0034
      IF l_oga.oga00 = '1' THEN        #FUN-AC0002 add
         IF l_oga.oga09 MATCHES '[15]' THEN                           #No.7992
            CALL s_ccc(l_oga03,'1',l_oga.oga01)  #No.TQC-640123
         ELSE
            # Customer Credit Check 客戶信核
            CALL s_ccc(l_oga03,'1','')           #No.TQC-640123       #No.7992  #No:MOD-8A0126 mark   #MOD-9B0195 取消mark
         END IF
      END IF
      IF g_errno = 'N' THEN
        IF (l_argv0 MATCHES '[15]' AND g_oaz.oaz132 = "1") OR         #No.7992
           (l_argv0 MATCHES '[246]' AND g_oaz.oaz142 = "1")           #No.7992  #No.FUN-630061
           THEN CALL cl_err('ccc','axm-104',1)
                IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012
                   IF NOT cl_confirm('axm-105') THEN LET g_success = 'N' RETURN
                   END IF
                END IF
           ELSE CALL cl_err('ccc','axm-106',0)
                LET g_success = 'N' RETURN
         END IF
      END IF
   END IF
END FUNCTION
 
#{
#檢查多角流程代碼資料
#l_oga:出貨單頭
#p_ogb31:第一筆單身資料的訂單單號,當新增第一筆單身資料的時候會用到
#回傳值:
#       TRUE   - 程序正常無誤完成 ; FALSE  - 程序有錯誤
#       l_poz  : poz_file (供後續三角流程所使用)
#
#}
FUNCTION t600sub_chkpoz(l_oga,p_ogb31)
DEFINE l_oga    RECORD LIKE oga_file.*
DEFINE p_ogb31  LIKE ogb_file.ogb31  #FUN-730012
DEFINE l_oea01  LIKE oea_file.oea01
DEFINE l_oea99  LIKE oea_file.oea99  #MOD-6C0118
#EFINE l_sql   STRING  #NO.TQC-630166
DEFINE l_poz    RECORD LIKE poz_file.*  #FUN-730012
DEFINE l_oea904 LIKE oea_file.oea904    #FUN-730012
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_argv0 LIKE ogb_file.ogb09
 
   LET l_argv0=l_oga.oga09  #FUN-730012
   IF cl_null(l_oga.oga16) THEN     #modi in 00/02/24 by kammy
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM ogb_file
       WHERE ogb01=l_oga.oga01
 
      #kim:當新增第一筆單身資料的時候會發生l_cnt=0的狀況,
      #AFTER FIELD ogb31和ogb16 會來呼叫此函數,
      #確認和過帳段因為會先檢查無單身資料不可確認,所以l_cnt=0的狀況不會發生在確認和過帳段
 
      IF l_cnt=0 THEN
         LET l_oea01 = p_ogb31
        #MOD-6C0118-begin-add
          SELECT oea99 INTO l_oea99 FROM oea_file  #TQC-730012 modify #MOD-850026 mark ogb_file
           WHERE oea01 = p_ogb31
        #MOD-6C0118-end-add
      ELSE
        #只讀取第一筆訂單之資料
        LET l_sql= " SELECT oea01,oea99 FROM oea_file,ogb_file ",  #MOD-6C0118 add oea99
                   "  WHERE oea01 = ogb31 ",
                   "    AND ogb01 = '",l_oga.oga01,"'",
                   "    AND oeaconf = 'Y' ",  #01/08/16 mandy
                   "  ORDER BY ogb03"  #No.MOD-570362
        PREPARE oea_pre FROM l_sql
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f
        IF SQLCA.sqlcode THEN
           RETURN FALSE,l_poz.*,l_oea99,l_oea904
        END IF
        FETCH oea_f INTO l_oea01,l_oea99  #MOD-6C0118 add oea99
        IF SQLCA.sqlcode THEN
           RETURN FALSE,l_poz.*,l_oea99,l_oea904
        END IF
      END IF
   ELSE
      #讀取該出貨單之訂單
      SELECT oea01,oea99 INTO l_oea01,l_oea99  #MOD-6C0118 add oea99
        FROM oea_file
       WHERE oea01 = l_oga.oga16
         AND oeaconf = 'Y' #01/08/16 mandy
   END IF
   SELECT oea904 INTO l_oea904 FROM oea_file WHERE oea99 = l_oea99  #MOD-6C0118
   SELECT * INTO l_poz.* FROM poz_file WHERE poz01 = l_oea904
   IF STATUS THEN
      CALL cl_err('','axm-318',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   IF l_argv0 = '4' AND l_poz.poz00='2' THEN
      CALL cl_err(l_oea904,'tri-008',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   IF l_argv0 = '6' AND l_poz.poz00='1' THEN
      CALL cl_err(l_oea904,'tri-008',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   RETURN TRUE,l_poz.*,l_oea99,l_oea904   #NO.TQC-740089
END FUNCTION
 
###以上是確認前的檢查###
 
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION t600sub_lock_cl()
   #LET g_forupd_sql = "SELECT * FROM ",g_dbs,"oga_file WHERE oga01 = ? FOR UPDATE"
   LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                      " WHERE oga01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600sub_cl CURSOR FROM g_forupd_sql
END FUNCTION
 
#----------------------------------------------------------------------------
#函數作用:執行"確認"的資料更新
#函數參數:p_oga01-出貨單頭的單號
#         p_action_choice-執行"確認"的按鈕的名稱,若外部呼叫可傳NULL
#         l_plant -using for multi-DB  #by cockroach
#回傳值:無
#注意  :需用g_success='Y'來判斷此函數是否成功執行,g_success='N'來判斷執行失敗
#       做完確認,需重新讀取oga_file,本FUN不重新讀取
#----------------------------------------------------------------------------
FUNCTION t600sub_y_upd(p_oga01,p_action_choice,l_plant)
   DEFINE p_oga01       LIKE oga_file.oga01
   DEFINE p_action_choice STRING
   DEFINE l_plant       LIKE azw_file.azw01    #FUN-A30116 ADD
   DEFINE l_legal       LIKE oga_file.ogalegal  #FUN-A30116
   DEFINE l_oea904      LIKE oea_file.oea904   #NO.FUN-670007
   DEFINE l_poz00       LIKE poz_file.poz00    #NO.FUN-6700007
   DEFINE l_chr         LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)  #NO.FUN-670007
   DEFINE l_oga     RECORD LIKE oga_file.*
   DEFINE l_argv0       LIKE ogb_file.ogb09
   DEFINE l_msg         LIKE type_file.chr1000
   DEFINE l_poz     RECORD LIKE poz_file.*
   DEFINE l_ogamksg     LIKE oga_file.ogamksg
   DEFINE l_oga55       LIKE oga_file.oga55
   DEFINE l_no1         LIKE ina_file.ina01
   DEFINE l_no2         LIKE ina_file.ina01
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_ina01_out   LIKE ina_file.ina01     #雜發單號
   DEFINE l_ogb31       LIKE ogb_file.ogb31     #MOD-870278 add
   DEFINE l_t1          LIKE oay_file.oayslip   #FUN-970017 add
   DEFINE l_change_bgjob LIKE type_file.chr1    #FUN-970017 add 

   WHENEVER ERROR CONTINUE                      #忽略一切錯誤  #FUN-730012
  #FUN-A30116 ADD---------------------   
   LET g_plant_new =l_plant
   LET g_plant_new = g_plant_new
   CALL s_gettrandbs()
  #LET g_dbs=g_dbs_tra
   LET g_dbs=s_dbstring(g_dbs_tra)  #by cock 0427
   CALL s_getlegal(g_plant_new) RETURNING l_legal
   LET p_legal = l_legal
  #FUN-A30116 END--------------------
 
  #FUN-970017---add----str----
   LET l_change_bgjob = 'N'
   IF p_action_choice CLIPPED = 'efconfirm' THEN  #由EasyFlow簽核,按下"准"
      LET l_t1=s_get_doc_no(p_oga01)
      SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=l_t1
     #同時具有自動確認和簽核的功能時,運作應同背景模式,不能開啟交談視窗
      IF g_oay.oayconf = 'Y' AND g_oay.oayapr = 'Y' THEN
         IF cl_null(g_bgjob) AND g_bgjob = 'N' THEN
            LET l_change_bgjob = 'Y'
            LET g_bgjob = 'Y'
         END IF
      END IF
   END IF
  #FUN-970017---add----end----

   LET g_success = 'Y'
 
  #IF p_action_choice CLIPPED = "confirm" THEN   #按「確認」時 #FUN-970017 mark
  #FUN-970017---add---str---
   IF p_action_choice CLIPPED = "confirm" OR
      g_action_choice CLIPPED = "insert" OR
      g_action_choice CLIPPED = "modify" THEN    #執行 "確認" 功能(非簽核模式呼叫)
  #FUN-970017---add---end---
      #LET l_sql="SELECT ogamksg,oga55 FROM ",g_dbs,"oga_file  ",
      LET l_sql="SELECT ogamksg,oga55 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                " WHERE oga01='",p_oga01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
      PREPARE sel_ogamksg_pre FROM l_sql
      EXECUTE sel_ogamksg_pre INTO l_ogamksg,l_oga55 
      IF l_ogamksg='Y'   THEN
         IF l_oga55 != '1' THEN
           #CALL cl_err('','aws-078',1)
            CALL s_errmsg('',p_oga01,g_plant_new,'aws-078',1) #cockroach 0427
            LET g_success = 'N'
            #TQC-B20181 add begin-----------  
            LET g_errno='aws-078'                          
	    LET g_msg1=''||p_oga01||g_plant_new||g_fno
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
     #IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-840012
     #   IF NOT cl_confirm('axm-108') THEN
     #      LET g_success='N'
     #      RETURN
     #   END IF
     #END IF
   END IF
 
  #BEGIN WORK
   CALL t600sub_lock_cl()
   OPEN t600sub_cl USING p_oga01
   IF STATUS THEN
     #CALL cl_err("OPEN t600sub_cl:", STATUS, 1)
      CALL s_errmsg("OPEN t600sub_cl:",p_oga01,g_plant_new,STATUS, 1) #cockroach 0427
      CLOSE t600sub_cl
      LET g_success='N'
      RETURN
   END IF
 
   FETCH t600sub_cl INTO l_oga.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      #CALL cl_err(l_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CALL s_errmsg(l_oga.oga01,g_fno,g_plant_new,SQLCA.sqlcode,1)  #COCKROACH  0427
       CLOSE t600sub_cl
       LET g_success='N'
       RETURN
   END IF
 
   LET l_argv0=l_oga.oga09  #FUN-730012
 
 #CALL s_get_bookno(YEAR(l_oga.oga02)) RETURNING g_flag,g_bookno1,g_bookno2
 #IF g_flag =  '1' THEN  #抓不到帳別
 #   CALL cl_err(l_oga.oga02,'aoo-081',1)
 #END IF
  IF g_success = 'Y' THEN
     CALL t600sub_y1(l_oga.*)
  END IF

  IF g_success= 'Y' AND
    (NOT cl_null(p_action_choice)) THEN  #FUN-730012 外部呼叫時,不使用"確認後立即扣帳"功能
     IF l_argv0='2'  THEN  #No.FUN-630061
      # IF g_oaz.oaz61 MATCHES "[12]"  THEN
           CALL t600sub_refresh(l_oga.oga01) RETURNING l_oga.* #FUN-730012 add 因為前面有些oga_file的值有異動,必須重新更新比較保險
           IF g_bgjob='N' THEN 
              CALL t600sub_s('1',TRUE,p_oga01,TRUE)
           ELSE 
              CALL t600sub_s('1',TRUE,p_oga01,FALSE) 
           END IF
      # END IF
     END IF
  END IF
 
  IF g_success = 'Y' THEN
    #IF l_oga.ogamksg = 'Y' THEN #簽核模式
    #   CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
    #       WHEN 0  #呼叫 EasyFlow 簽核失敗
    #            LET l_oga.ogaconf="N"
    #            LET l_oga.ogaconu=''  #No.FUN-870007
    #            LET l_oga.ogacond=''  #No.FUN-870007
    #            LET l_oga.ogacont=''  #No.FUN-A30063 
    #            LET g_success = "N"
    #            ROLLBACK WORK
    #            RETURN
    #       WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
    #            LET l_oga.ogaconf="N"
    #            LET l_oga.ogaconu=''  #No.FUN-870007
    #            LET l_oga.ogacond=''  #No.FUN-870007
    #            LET l_oga.ogacont=''  #No.FUN-A30063
    #            ROLLBACK WORK
    #            RETURN
    #   END CASE
    #END IF
 
     LET l_oga.ogaconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
     LET l_oga.oga55='1'             #執行成功, 狀態值顯示為 '1' 已核准
     #LET l_sql="UPDATE ",g_dbs,"oga_file SET oga55 = '",l_oga.oga55,"' WHERE oga01='",l_oga.oga01,"'"
     LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
               "   SET oga55 = '",l_oga.oga55,"' WHERE oga01='",l_oga.oga01,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	 CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102  
     PREPARE upd_oga55_pre FROM l_sql
     EXECUTE upd_oga55_pre
     IF SQLCA.sqlerrd[3]=0 THEN
        LET g_success='N'
     END IF
 
     CALL t600sub_chstatus('Y',l_oga.*) RETURNING l_oga.*
    #COMMIT WORK
     CALL cl_flow_notify(l_oga.oga01,'Y')
  ELSE
     LET l_oga.ogaconf='N'
#    ROLLBACK WORK
  END IF
 
  IF l_argv0 MATCHES '[246]' AND NOT cl_null(l_oga.oga011) THEN
     LET l_oga.oga011= l_oga.oga01  #FUN-730012 add
  END IF
 
END FUNCTION
 
FUNCTION t600sub_y1(l_oga)
   DEFINE l_slip   LIKE oay_file.oayslip
   DEFINE l_oay13  LIKE oay_file.oay13
   DEFINE l_oay14  LIKE oay_file.oay14
   DEFINE l_ogb14t LIKE ogb_file.ogb14t
   DEFINE l_oga    RECORD LIKE oga_file.*
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_oea    RECORD LIKE oea_file.*
 
   LET g_time = TIME    #FUN-A30063 ADD
   #TQC-B40145 mark ---------begin--#積分部份的邏輯在POS段處理，所以這裡mark
   ##FUN-A30116 ADD---------------------------------------
   #IF NOT cl_null(l_oga.oga87) THEN
   #   #LET l_sql="UPDATE ",g_dbs,"lpj_file SET lpj07=lpj07+1,",
   #   LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'lpj_file'), #FUN-A50102
   #             "   SET lpj07=lpj07+1,",
   #                       " lpj08='",g_today,"',",
   #                       " lpj12=lpj12+'",l_oga.oga95,"'",
   #             " WHERE lpj03='",l_oga.oga87,"'"
   #   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #     #CALL cl_err3("upd","lpj_file",l_oga.oga87,"",SQLCA.sqlcode,"","upd lpj12",1)
   #      CALL s_errmsg("upd lpj_file",l_oga.oga87,g_fno,SQLCA.sqlcode,1)  #cockroach 0427
   #      LET g_success = 'N'
   #      #TQC-B20181 add begin-----------  
   #      LET g_errno=SQLCA.sqlcode                           
   #      LET g_msg1='lpj_file'||'upd lpj_file'||g_plant_new||g_fno
   #      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
   #      LET g_msg=g_msg[1,255]
   #      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
   #      LET g_errno=''
   #      LET g_msg=''
   #      LET g_msg1=''
   #      #TQC-B20181 add end-------------
   #      RETURN
   #   ELSE 
   #      MESSAGE 'UPDATE lpj_file OK'
   #   END IF
   #   
   #   DELETE FROM lsm_temp 
   #   INSERT INTO lsm_temp VALUES( l_oga.oga87,'7',g_fno,l_oga.oga95,g_today,'',l_oga.ogaplant)    #7:Maintain Shipping Order:axmt620
   #   #LET l_sql=" INSERT INTO ",g_dbs,"lsm_file SELECT * FROM lsm_temp"
   #   LET l_sql=" INSERT INTO ",cl_get_target_table(g_plant_new,'lsm_file'), #FUN-A50102
   #             " SELECT * FROM lsm_temp"
   #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	 # CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
   #   PREPARE ins_lsm_pre FROM l_sql
   #   EXECUTE ins_lsm_pre
   #   IF STATUS OR SQLCA.SQLCODE THEN
   #     #CALL cl_err3("ins","lsm_file","","",SQLCA.sqlcode,"","ins lsm",1)
   #      CALL s_errmsg("ins lsm_file",l_oga.oga87,g_fno,SQLCA.sqlcode,1) #cockroach 0427
   #      LET g_success = 'N'
   #      #TQC-B20181 add begin-----------  
   #      LET g_errno=SQLCA.sqlcode                           
   #      LET g_msg1='lsm_file'||'ins lsm_file'||g_plant_new||g_fno
   #      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
   #      LET g_msg=g_msg[1,255]
   #      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
   #      LET g_errno=''
   #      LET g_msg=''
   #      LET g_msg1=''
   #      #TQC-B20181 add end-------------
   #      RETURN
   #   ELSE
   #      MESSAGE 'UPDATE lsm_file OK'
   #   END IF                             
   #END IF
   #TQC-B40145 mark ---------end--#積分部份的邏輯在POS段處理，所以這裡mark
   LET l_slip=s_get_doc_no(l_oga.oga01)       #No.FUN-550052
   #LET l_sql="SELECT oay13,oay14 FROM ",g_dbs,"oay_file WHERE oayslip = '",l_slip,"'"
   LET l_sql="SELECT oay13,oay14 FROM ",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
             " WHERE oayslip = '",l_slip,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
   PREPARE sel_oay_pre FROM l_sql 
   EXECUTE sel_oay_pre INTO l_oay13,l_oay14 
   IF l_oay13 = 'Y' THEN
      #LET l_sql="SELECT SUM(ogb14t) FROM ",g_dbs,"ogb_file WHERE ogb01 = '",l_oga.oga01,"'"
      LET l_sql="SELECT SUM(ogb14t) FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                " WHERE ogb01 = '",l_oga.oga01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102  
      PREPARE sel_ogb14t_pre2 FROM l_sql
      EXECUTE sel_ogb14t_pre2 INTO l_ogb14t
      IF cl_null(l_ogb14t) THEN LET l_ogb14t = 0 END IF
      LET l_ogb14t = l_ogb14t * l_oga.oga24
      IF l_ogb14t > l_oay14 THEN
        #CALL cl_err(l_oay14,'axm-700',1)
         CALL s_errmsg(l_oay14,g_fno,g_plant_new,'axm-700',1) #cockroach 0427
         LET g_success='N'
         #TQC-B20181 add begin-----------  
         LET g_errno='axm-700'                         
	 LET g_msg1='ogb_file'||l_oay14||g_plant_new||g_fno
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
   CALL t600sub_hu2(l_oga.*) IF g_success = 'N' THEN RETURN END IF	#最近交易
   #LET l_sql="SELECT * FROM ",g_dbs,"ogb_file WHERE ogb01='",l_oga.oga01,"'"
   LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
             " WHERE ogb01='",l_oga.oga01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102 
   PREPARE sel_ogb_pre FROM l_sql
   DECLARE t600_y1_c CURSOR FOR sel_ogb_pre
   FOREACH t600_y1_c INTO l_ogb.*
      IF NOT cl_null(l_oga.oga16)
         AND l_ogb.ogb31!=l_oga.oga16 THEN
        #CALL cl_err(l_ogb.ogb31,'axm-140',1)
         CALL s_errmsg(l_ogb.ogb31,g_fno,g_plant_new,'axm-140',1) #cockroach 0427
         LET g_success='N'
         #TQC-B20181 add begin-----------  
         LET g_errno='axm-140'                         
	 LET g_msg1='ogb_file'||l_ogb.ogb31||g_plant_new||g_fno
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
         RETURN
     #ELSE
     #   LET l_sql="SELECT * FROM ",g_dbs,"oea_file",
     #             " WHERE oea01='",l_ogb.ogb31,"'"
     #   PREPARE sel_oea_pre FROM l_sql
     #   EXECUTE sel_oea_pre INTO l_oea.* 

     #   IF l_oea.oea08 != l_oga.oga08 THEN        #國內外不符
     #       CALL cl_err(l_ogb.ogb31,'axm-125',0)
     #       LET g_success='N'
     #   END IF
     #   IF l_oea.oea03 != l_oga.oga03 THEN        #客戶不符 #No.TQC-640123
     #       CALL cl_err(l_ogb.ogb31,'axm-138',0)
     #       LET g_success='N'
     #    END IF
     #   IF l_oea.oea23 != l_oga.oga23 THEN        #幣別不符
     #       CALL cl_err(l_ogb.ogb31,'axm-144',0)
     #       LET g_success='N'
     #    END IF
     #   IF l_oea.oea21 != l_oga.oga21 THEN        #稅別不符
     #       CALL cl_err(l_ogb.ogb31,'axm-142',0)
     #       LET g_success='N'
     #    END IF
     #    IF g_success='N' THEN RETURN END IF
      END IF
#-----------------------------------------------#
      IF l_ogb.ogb04[1,4] != 'MISC' THEN
       ## IF l_oga.oga09 NOT MATCHES  '[159]' THEN #非出貨通知單 #No.7992  #No.FUN-630061
       ##    CALL t600sub_chk_img(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN END IF
       ## END IF
      END IF
      CALL t600sub_chk_oeb(l_ogb.*) IF g_success='N' THEN RETURN END IF
      CALL t600sub_bu1(l_oga.*,l_ogb.*)   #No.TQC-8C0027
      IF g_success='N' THEN RETURN END IF
   END FOREACH
END FUNCTION
 
FUNCTION t600sub_hu2(l_oga)		#最近交易日
   DEFINE l_oga RECORD LIKE oga_file.*
   DEFINE l_occ RECORD LIKE occ_file.*
   CALL cl_msg("hu2!")

   #LET l_sql="SELECT * FROM ",g_dbs,"occ_file WHERE occ01='",l_oga.oga03,"'"
   LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
             " WHERE occ01='",l_oga.oga03,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE sel_occ_pre FROM l_sql
   EXECUTE sel_occ_pre INTO l_occ.* 
   IF STATUS THEN
     #CALL cl_err3("sel","occ_file",l_oga.oga03,"",SQLCA.sqlcode,"","s ccc",1)  #No.FUN-670008
      LET g_errno = SQLCA.sqlcode  #FUN-BB0120 add 
      CALL s_errmsg("sel occ_file",l_oga.oga03,g_fno,SQLCA.sqlcode,1)  #COCKROACH 0427
      LET g_success='N'
      #TQC-B20181 add begin-----------  
     #LET g_errno=SQLCA.sqlcode    #FUN-BB0120 mark                    
      LET g_msg1='occ_file'||'sel occ_file'||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      #TQC-B20181 add end-------------
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=l_oga.oga02 END IF
   IF l_occ.occ173 IS NULL OR l_occ.occ173 < l_oga.oga02 THEN
      LET l_occ.occ173=l_oga.oga02
   END IF
   #LET l_sql="UPDATE ",g_dbs,"occ_file SET occ16='",l_occ.occ16,"', occ173='",l_occ.occ173,"'",
   LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'occ_file'), #FUN-A50102
             "   SET occ16='",l_occ.occ16,"', occ173='",l_occ.occ173,"'",
             " WHERE occ01='",l_oga.oga03,"'" 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
   PREPARE upd_occ_pre FROM l_sql
   EXECUTE upd_occ_pre 
   IF STATUS THEN
     #CALL cl_err3("upd","occ_file",l_oga.oga03,"",SQLCA.sqlcode,"","u ccc",1)  #No.FUN-670008
      LET g_errno = SQLCA.sqlcode    #FUN-BB0120 add
      CALL s_errmsg("upd occ_file",l_oga.oga03,g_fno,SQLCA.sqlcode,1)  #cockroach 0427
      LET g_success='N'
      #TQC-B20181 add begin-----------  
     #LET g_errno=SQLCA.sqlcode      #FUN-BB0120 mark 
      LET g_msg1='occ_file'||'upd occ_file'||g_plant_new||g_fno
      CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
      LET g_msg=g_msg[1,255]
      CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
      LET g_errno=''
      LET g_msg=''
      LET g_msg1=''
      #TQC-B20181 add end-------------
      RETURN
   END IF
END FUNCTION
 
FUNCTION t600sub_chk_oeb(l_ogb)
   DEFINE l_over LIKE oea_file.oea09
   DEFINE l_ogb  RECORD LIKE ogb_file.*
   DEFINE l_tot1 LIKE ogb_file.ogb12
   DEFINE l_tot2 LIKE oeb_file.oeb12
   DEFINE l_chr  LIKE type_file.chr1
   DEFINE l_buf  LIKE type_file.chr1000
   DEFINE l_argv0 LIKE oga_file.oga09   #MOD-830155
   DEFINE l_msg  STRING			#FUN-970093
 
   #LET l_sql="SELECT oga09 FROM ",g_dbs,"oga_file WHERE oga01 = '",l_ogb.ogb01,"'"
   LET l_sql="SELECT oga09 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
             " WHERE oga01 = '",l_ogb.ogb01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102  
   PREPARE sel_oga09_pre FROM l_sql
   EXECUTE sel_oga09_pre INTO l_argv0
   IF NOT cl_null(l_ogb.ogb31) AND l_ogb.ogb31[1,4] !='MISC' THEN
      # l_argv0 : 1.出貨通知單 2.出貨單 3.無訂單通知單

      #LET l_sql="SELECT SUM(ogb12) FROM ",g_dbs,"ogb_file,",g_dbs,"oga_file",
     LET l_sql="SELECT SUM(ogb12) FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
                                         cl_get_target_table(g_plant_new,'oga_file'),     #FUN-A50102
                " WHERE ogb31 ='",l_ogb.ogb31,"' AND ogb32='",l_ogb.ogb32,"'",
                "   AND ogb04 ='",l_ogb.ogb04,"'", 
                "   AND ogb01=oga01 AND ogaconf='Y' AND oga09='",l_argv0,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE sel_ogb12_pre FROM l_sql
      EXECUTE sel_ogb12_pre INTO l_tot1
      IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
      LET l_chr='N'
      LET l_sql="SELECT (oeb12*((100+oea09)/100)+oeb25),oeb70,oeahold,oea09",
                #"  FROM ",g_dbs,"oeb_file, ",g_dbs,"oea_file",
                "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'),",", #FUN-A50102
                          cl_get_target_table(g_plant_new,'oea_file'),     #FUN-A50102
                " WHERE oeb01 = '",l_ogb.ogb31,"' AND oeb03 = '",l_ogb.ogb32,"' AND oeb01=oea01"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE sel_oeb12_pre FROM l_sql
      EXECUTE sel_oeb12_pre INTO l_tot2,l_chr,l_buf,l_over

      IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
      IF l_chr='Y' THEN #此訂單已結案, 不可再出貨
        #CALL cl_err(l_ogb.ogb32,'axm-150',1) 
         CALL s_errmsg(l_ogb.ogb32,l_ogb.ogb01,g_plant_new,'axm-150',1) #cockroach 0427 
         LET g_success = 'N' RETURN
         #TQC-B20181 add begin-----------  
         LET g_errno='axm-150'                        
	 LET g_msg1='oeb_file'||''||g_plant_new||g_fno
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
      END IF
      IF NOT cl_null(l_buf) THEN #此訂單已設定留置, 不可出貨
         LET l_msg = l_ogb.ogb31 ,' + ', l_ogb.ogb32
        #CALL cl_err(l_msg,'axm-151',1)
         CALL s_errmsg(l_msg,l_ogb.ogb01,g_plant_new,'axm-151',1) #cockroach 0427
         LET g_success = 'N' RETURN
         #TQC-B20181 add begin-----------  
         LET g_errno='axm-151'                        
	 LET g_msg1='oeb_file'||''||g_plant_new||g_fno
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
      END IF
      #no.7168 檢查備品資料
      IF t600sub_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
         #LET l_sql=" SELECT oeo09 FROM ",g_dbs,"oeo_file",
         LET l_sql=" SELECT oeo09 FROM ",cl_get_target_table(g_plant_new,'oeo_file'), #FUN-A50102
                   " WHERE oeo01 = '",l_ogb.ogb31,"' AND oeo03 = '",l_ogb.ogb32,"'",
                   "   AND oeo04 = '",l_ogb.ogb04,"' AND oeo08 = '2'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
         PREPARE sel_oea09_pre FROM l_sql
         EXECUTE sel_oea09_pre INTO l_tot2
          IF cl_null(l_tot2) THEN LET l_tot2 = 0  END IF
          LET l_tot2 = l_tot2 *((100+l_over)/100) #含超交率，備品無法考慮銷退量
      END IF
      #no.7168(end)
      IF l_tot1 > l_tot2 THEN #確認合計數量或金額大於原數量或金額, 不可再確認
        #CALL cl_err(l_ogb.ogb31||' l_tot1 > oeb24','axm-174',1) LET g_success = 'N' RETURN  #MOD-940150 add
        #CALL s_errmsg(l_ogb.ogb31||' l_tot1 > oeb24',l_ogb.ogb01,g_plant_new,'axm-174',1)  #cockroach 0427 #TQC-B50134 mark
         CALL s_errmsg(g_sfno||' l_tot1 > oeb24',g_fno,g_plant_new,'axm-174',1)   #TQC-B50134 add
         LET g_success = 'N' #MOD-940150 add
         #TQC-B20181 add begin-----------  
         LET g_errno='axm-174'                        
	 LET g_msg1='oeb_file'||'l_tot1 > oeb24'||g_plant_new||g_fno
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
      END IF
 
# 出貨通知單出貨數量>訂單數量 --> show warning **********
      IF l_ogb.ogb12 > l_tot2 THEN #
        #CALL cl_err('ogb12>l_tot2','axm-294',1)
         CALL s_errmsg('ogb12>l_tot2',l_ogb.ogb01,g_plant_new,'axm-294',1) #cockroach 0427
         #TQC-B20181 add begin-----------  
         LET g_errno='axm-294'                        
	 LET g_msg1='oeb_file'||'ogb12>l_tot2'||g_plant_new||g_fno
	 CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	 LET g_msg=g_msg[1,255]
	 CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	 LET g_errno=''
	 LET g_msg=''
	 LET g_msg1=''
         #TQC-B20181 add end-------------
      END IF
   END IF
END FUNCTION
 
FUNCTION t600sub_bu1(l_oga,l_ogb)   #更新訂單待出貨單量及已出貨量
   DEFINE l_amount LIKE oeb_file.oeb13   #出貨金額
   DEFINE l_oga    RECORD LIKE oga_file.*   #No.TQC-8C0027
   DEFINE l_ogb    RECORD LIKE ogb_file.*
   DEFINE l_tot3   LIKE ogb_file.ogb12
   DEFINE l_tot2   LIKE ogb_file.ogb12
   DEFINE l_tot1   LIKE ogb_file.ogb12
   DEFINE l_tot4   LIKE ogb_file.ogb12   #No.FUN-740016
   DEFINE l_chr    LIKE type_file.chr1
   DEFINE l_buf    LIKE type_file.chr1000
   DEFINE l_oga00  LIKE oga_file.oga00   #No.FUN-740016
   DEFINE l_oea12  LIKE oea_file.oea12   #No.FUN-740016
   DEFINE l_oeb71  LIKE oeb_file.oeb71   #No.FUN-740016
   DEFINE l_oeb04  LIKE oeb_file.oeb04      
   DEFINE l_oeb24  LIKE oeb_file.oeb24      
   DEFINE l_oeb13  LIKE oeb_file.oeb13      
   DEFINE l_oeb12  LIKE oeb_file.oeb12      
   DEFINE l_oeb05  LIKE oeb_file.oeb05      
   DEFINE l_oeb916 LIKE oeb_file.oeb916     
   DEFINE l_cnt    LIKE type_file.num5      
   DEFINE l_factor LIKE ima_file.ima31_fac  
   DEFINE l_tot    LIKE img_file.img10      
   DEFINE l_oea23  LIKE oea_file.oea23
   DEFINE l_oea213 LIKE oea_file.oea213
   DEFINE l_oea211 LIKE oea_file.oea211
   DEFINE l_azi04  LIKE azi_file.azi04
   DEFINE l_amt    LIKE oea_file.oea62
   DEFINE l_oeb29  LIKE oeb_file.oeb29   #No.TQC-8C0027
   DEFINE l_msg  STRING			 #FUN-970093
 
   IF t600sub_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
      RETURN
   END IF
 
   CALL cl_msg("bu1!")
   IF g_aza.aza88 = 'Y' THEN
      IF NOT cl_null(l_ogb.ogb31) THEN
         #LET l_sql ="SELECT oeb12 FROM ",g_dbs,"oeb_file",
         LET l_sql ="SELECT oeb12 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                    " WHERE oeb01 = '",l_ogb.ogb31,"'",
                    "   AND oeb03 = '",l_ogb.ogb32,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
         PREPARE sel_oeb12n_pre FROM l_sql
         EXECUTE sel_oeb12n_pre INTO l_oeb12
      END IF
   END IF
 
   IF NOT cl_null(l_ogb.ogb31) AND l_ogb.ogb31[1,4] !='MISC' THEN
      #LET l_sql="SELECT SUM(ogb12) FROM ",g_dbs,"ogb_file,",g_dbs,"oga_file",
      LET l_sql="SELECT SUM(ogb12) FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
                                          cl_get_target_table(g_plant_new,'oga_file'),     #FUN-A50102
                " WHERE ogb31='",l_ogb.ogb31,"' AND ogb32='",l_ogb.ogb32,"' AND ogb01=oga01",
                "   AND ogb04='",l_ogb.ogb04,"'", 
                "   AND ((oga09 IN ('1','5') AND (oga011 IS NULL OR oga011=' ')",
                "                              AND ogaconf='Y')",
                "     OR (oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '",
                #"                   AND oga011 IN (SELECT oga01 FROM ",g_dbs,"oga_file,",g_dbs,"ogb_file",
                "                   AND oga011 IN (SELECT oga01 FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
                                                                       cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
                "                                 WHERE ogb31='",l_ogb.ogb31,"'",
                "                                   AND ogb32='",l_ogb.ogb32,"'",
                "                                   AND ogb01=oga01 AND ogaconf='N'))",
                "     OR (oga09 IN ('2','4','6') AND ogaconf='Y' AND ogapost='N')) "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
      PREPARE sel_ogb12_pre1 FROM l_sql
      EXECUTE sel_ogb12_pre1 INTO l_tot3
      IF cl_null(l_tot3) THEN LET l_tot3 = 0 END IF
 
      #LET l_sql ="SELECT SUM(ogb12) FROM ",g_dbs,"ogb_file,",g_dbs,"oga_file",
       LET l_sql ="SELECT SUM(ogb12) FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
                                            cl_get_target_table(g_plant_new,'oga_file'),     #FUN-A50102
                 " WHERE ogb31='",l_ogb.ogb31,"' AND ogb32='",l_ogb.ogb32,"'",
                 "   AND ogb04='",l_ogb.ogb04,"'", 
                 "   AND ogb01=oga01 AND oga09 IN ('2','4','6','A')", 
                 "   AND ogb1005 = '1'  ", 
                 "   AND ogaconf='Y' AND ogapost='Y'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102              
      PREPARE sel_ogb12_pre2 FROM l_sql
      EXECUTE sel_ogb12_pre2 INTO l_tot1 
      IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
      DISPLAY '已出貨數量為tot1=',l_tot1
      LET l_chr='N'
      LET l_sql="SELECT (oeb12*((100+oea09)/100)+oeb25),oeb70,oeahold",
               #"  FROM ",g_dbs,"oeb_file,",g_dbs," oea_file",
                "  FROM ",cl_get_target_table(g_plant_new,'oeb_file'),",", #FUN-A50102
                          cl_get_target_table(g_plant_new,'oea_file'),     #FUN-A50102
                " WHERE oeb01 = '",l_ogb.ogb31,"' AND oeb03 = '",l_ogb.ogb32,"' AND oeb01=oea01"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
      PREPARE sel_oeb12_pre1 FROM l_sql
      EXECUTE sel_oeb12_pre1 INTO l_tot2,l_chr,l_buf
  
      IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
      IF l_chr='Y' THEN
         CALL cl_err(l_ogb.ogb32,'axm-150',1) LET g_success = 'N' RETURN
      END IF
      IF NOT cl_null(l_buf) THEN
         LET l_msg = l_ogb.ogb31 ,' + ', l_ogb.ogb32
         CALL cl_err(l_msg,'axm-151',1) LET g_success = 'N' RETURN
      END IF
      IF l_tot1 > l_tot2 THEN
        #CALL cl_err(l_ogb.ogb31||' l_tot1 > oeb24','axm-174',1) LET g_success = 'N' RETURN  #MOD-940150 add #TQC-B50134 mark
         CALL cl_err(g_sfno||' l_tot1 > oeb24','axm-174',1) LET g_success = 'N' RETURN   #TQC-B50134 add
      END IF
 
      #LET l_sql="SELECT SUM(ogb12) FROM ",g_dbs,"ogb_file,",g_dbs,"oga_file",
      #FUN-AC0002 mark begin------------------------------------------------------
      #LET l_sql="SELECT SUM(ogb12) FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
      #                                    cl_get_target_table(g_plant_new,'oga_file'),     #FUN-A50102
      #          " WHERE ogb31='",l_ogb.ogb31,"'",
      #          "   AND ogb32='",l_ogb.ogb32,"'",
      #          "   AND ogb04='",l_ogb.ogb04,"'",
      #          "   AND ogb01=oga01 AND oga00='B'",
      #          "   AND ogaconf='Y'",
      #          "   AND ogapost='Y'"
      #CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      #CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
      #PREPARE sel_ogb12_pre3 FROM l_sql  
      #EXECUTE sel_ogb12_pre3 INTO l_tot4
      #FUN-AC0002 mark end---------------------------------
      IF cl_null(l_tot4) THEN LET l_tot4 = 0 END IF
 
      #LET l_sql="UPDATE ",g_dbs,"oeb_file SET oeb23='",l_tot3,"',",
      LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                "   SET oeb23='",l_tot3,"',",
                "       oeb24='",l_tot1,"',", 
                "       oeb29='",l_tot4,"' ",  
                " WHERE oeb01 ='", l_ogb.ogb31,"'", 
                "   AND oeb03 ='", l_ogb.ogb32,"'"  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql
      PREPARE upd_oeb_2 FROM l_sql
      EXECUTE upd_oeb_2

     #FUN-B50055 MARK  110518 --
     #IF l_oeb12 = l_tot1 THEN
     #   #LET l_sql = "UPDATE ",g_dbs,"oeb_file SET oeb70='Y'",
     #   LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
     #               "   SET oeb70='Y'",
     #               " WHERE oeb01 = '",l_ogb.ogb31,"'",
     #               "   AND oeb03 = '",l_ogb.ogb32,"'"
     #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
     #   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102             
     #   PREPARE upd_oeb_2 FROM l_sql
     #   EXECUTE upd_oeb_2
     #END IF
     #FUN-B50055 MARK  110518 --

      IF STATUS THEN
         CALL cl_err3("upd","oeb_file",l_ogb.ogb31,l_ogb.ogb32,SQLCA.sqlcode,"","upd oeb24",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oeb24','axm-134',1) LET g_success = 'N' RETURN
      END IF
 
# update 出貨金額 (oea62) for prog:axmq420 ----------
      #LET l_sql= "SELECT oeb04,oeb24,oeb13,oeb05,oeb916 FROM ",g_dbs,"oeb_file ",
      LET l_sql= "SELECT oeb04,oeb24,oeb13,oeb05,oeb916 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                 " WHERE oeb01 = '",l_ogb.ogb31,"'",
                 "   AND oeb03 = '",l_ogb.ogb32,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE sel_oeb04_pre FROM l_sql
      DECLARE t600_curs2 CURSOR FOR sel_oeb04_pre

      LET l_amount = 0 
      FOREACH t600_curs2 INTO l_oeb04,l_oeb24,l_oeb13,l_oeb05,l_oeb916
         CALL s_umfchkm(l_oeb04,l_oeb05,l_oeb916,g_plant_new)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN 
            LET l_factor = 1
         END IF
         LET l_tot = l_oeb24 * l_factor
         LET l_sql="SELECT oea23,oea213,oea211 ",
                   #"  FROM ",g_dbs,"oea_file",
                   "  FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                   " WHERE oea01='",l_ogb.ogb31,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
         PREPARE sel_oea23_pre FROM l_sql
         EXECUTE sel_oea23_pre INTO l_oea23,l_oea213,l_oea211 
   
         #LET l_sql="SELECT azi04 FROM ",g_dbs,"azi_file",
         LET l_sql="SELECT azi04 FROM ",cl_get_target_table(g_plant_new,'azi_file'), #FUN-A50102
                   " WHERE azi01 = '",l_oea23,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
         PREPARE sel_azi04_pre1 FROM l_sql
         EXECUTE sel_azi04_pre1 INTO l_azi04 

         IF l_oea213 = 'N' THEN
           LET l_amt = l_tot * l_oeb13                        
           CALL cl_digcut(l_amt,l_azi04) RETURNING l_amt      
         ELSE
           LET l_amt = l_tot * l_oeb13                        
           CALL cl_digcut(l_amt,l_azi04) RETURNING l_amt     
           LET l_amt = l_amt/ (1+l_oea211/100)
           CALL cl_digcut(l_amt,l_azi04)  RETURNING l_amt      
         END IF
         LET l_amount = l_amount + l_amt
      END FOREACH
      IF cl_null(l_amount) THEN LET l_amount=0 END IF
      #LET l_sql="UPDATE ",g_dbs,"oea_file SET oea62='",l_amount,"'",
      LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102
                "   SET oea62='",l_amount,"'",
                " WHERE oea01='",l_ogb.ogb31,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
      PREPARE upd_oea62_pre FROM l_sql
      EXECUTE upd_oea62_pre
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","oea_file",l_ogb.ogb31,"",SQLCA.sqlcode,"","upd oea62",1)  #No.FUN-670008
         LET g_success = 'N' RETURN
      END IF
   END IF
END FUNCTION
 
#檢查是否為備品資料 no.7168
FUNCTION t600sub_chkoeo(p_oeo01,p_oeo03,p_oeo04)
  DEFINE p_oeo01 LIKE oeo_file.oeo01
  DEFINE p_oeo03 LIKE oeo_file.oeo03
  DEFINE p_oeo04 LIKE oeo_file.oeo04
  DEFINE l_cnt   LIKE type_file.num5
 
  LET l_cnt=0
  #LET l_sql= " SELECT COUNT(*) FROM ",g_dbs,"oeo_file",
  LET l_sql= " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'oeo_file'), #FUN-A50102
             "  WHERE oeo01 = '",p_oeo01,"' AND oeo03 = '",p_oeo03,"'",
             "    AND oeo04 = '",p_oeo04,"' AND oeo08 = '2'"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
  PREPARE sel_cnt_pre1 FROM l_sql
  EXECUTE sel_cnt_pre1 INTO l_cnt
  IF l_cnt > 0 THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION
 
#{
#參數:p_cmd - IF p_cmd='2' 則會跳出"是否執行扣帳的對話選項視窗",其他值則不會跳出
#     p_inTransaction - 呼叫此FUN時,程式是否處在Transction中,IF p_inTransaction=TRUE 則不做 Begin Work,IF p_inTransaction=FALSE 則會呼叫begin work,例如:確認段來呼叫此FUN則傳TRUE,獨立執行此FUN則傳FALSE
#     p_oga01 - 出貨單頭單號
#     p_Input_oga02 - IF TRUE 則Input oga02,IF FALSE 則不Input oga02(WHEN背景執行或外部呼叫時)
#注意 :考慮到會有外部程式來呼叫此扣帳函數,所以把原本裡面的CALL t600_chspic()移到外面作,
#      所以做完_s()後,有需要重秀圖檔的話,必須再呼叫一次t600_chspic()
#}
FUNCTION t600sub_s(p_cmd,p_inTransaction,p_oga01,p_Input_oga02)            # when l_oga.ogapost='N' (Turn to 'Y')
DEFINE p_cmd     LIKE type_file.chr1,         #1.不詢問 2.要詢問  #No.FUN-680137 VARCHAR(1)
       p_inTransaction LIKE type_file.num5,   #FUN-730012 #是否要做 begin work 的指標
       p_oga01 LIKE oga_file.oga01,
       p_Input_oga02 LIKE type_file.num5,
       l_success LIKE type_file.chr1,         #TQC-680018 add #存放g_success值
       l_occ57   LIKE occ_file.occ57
#EFINE l_sql     STRING  #NO.TQC-630166
DEFINE l_ogb19   LIKE ogb_file.ogb19,
       l_ogb11   LIKE ogb_file.ogb11,
       l_ogb12   LIKE ogb_file.ogb12,
       l_qcs01   LIKE qcs_file.qcs01,
       l_qcs02   LIKE qcs_file.qcs02,
       l_qcs091c LIKE qcs_file.qcs091
DEFINE l_ima01   LIKE ima_file.ima01,
       l_ima1012 LIKE ima_file.ima1012,
       l_ogb04   LIKE ogb_file.ogb04,
       l_ogb14   LIKE ogb_file.ogb14,
       l_ogb14t  LIKE ogb_file.ogb14t,
       l_ogb1004 LIKE ogb_file.ogb1004,
       l_tqz02   LIKE tqz_file.tqz02,
       l_sum007  LIKE tsa_file.tsa07,
       l_sum034  LIKE tsa_file.tsa07,
       l_item    LIKE tqy_file.tqy35,
       l_i       LIKE type_file.num5,    #No.FUN-680137 SMALLINT
       l_j       LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE l_oga30   LIKE oga_file.oga30
DEFINE l_oay11   LIKE oay_file.oay11     #No:7647 add
DEFINE l_ogb     RECORD LIKE ogb_file.*  #No.FUN-610090
DEFINE l_oea904  LIKE oea_file.oea904    #NO.FUN-670007
DEFINE l_poz00   LIKE poz_file.poz011    #NO.FUN-670007
DEFINE l_oga02   LIKE oga_file.oga02     #FUN-650009 add
DEFINE l_oga910  LIKE oga_file.oga910    #FUN-650101 #FUN-710037
DEFINE l_imd10   LIKE imd_file.imd10     #FUN-650101
DEFINE l_imd11   LIKE imd_file.imd11     #FUN-650101
DEFINE l_imd12   LIKE imd_file.imd12     #FUN-650101
DEFINE l_yy,l_mm LIKE type_file.num5     #FUN-650009 add
DEFINE l_occ1027 LIKE occ_file.occ1017    #No.TQC-640123
DEFINE li_result LIKE type_file.num5     #FUN-730012
DEFINE lj_result LIKE type_file.chr1     #No.FUN-930108 VARCHAR(1)s_incchk()返回值
DEFINE l_argv0   LIKE ogb_file.ogb09
DEFINE l_oga     RECORD LIKE oga_file.*
DEFINE l_t1      LIKE oay_file.oayslip
DEFINE l_poz     RECORD LIKE poz_file.*
DEFINE l_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090
                          unit   LIKE ima_file.ima25,
                          fac    LIKE img_file.img21,
                          qty    LIKE img_file.img10
                       END RECORD
DEFINE l_imm01   LIKE imm_file.imm01      #No.FUN-610090
DEFINE l_oea99   LIKE oea_file.oea99
DEFINE m_ogb32   LIKE ogb_file.ogb32      #MOD-830222 add
DEFINE l_oha     RECORD LIKE oha_file.*
DEFINE l_ima906  LIKE ima_file.ima906
DEFINE l_msg     LIKE type_file.chr1000
DEFINE l_flow    LIKE oea_file.oea904
DEFINE l_imm03   LIKE imm_file.imm03,  #No.FUN-740016
       l_ogb31   LIKE ogb_file.ogb31,   #CHI-880006
       l_ogb03   LIKE ogb_file.ogb03    #CHI-880006
DEFINE l_tot   LIKE oeb_file.oeb24
DEFINE l_ocn03   LIKE ocn_file.ocn03
DEFINE l_ocn04   LIKE ocn_file.ocn04
DEFINE l_cnt         LIKE type_file.num5   #MOD-8B0077
DEFINE l_flag        LIKE type_file.chr1   #MOD-940273
DEFINE l_oeb19       LIKE oeb_file.oeb19   #MOD-970237
DEFINE l_oeb905      LIKE oeb_file.oeb905  #MOD-970237
DEFINE l_flag1  LIKE type_file.chr1        #No.CHI-9C0027
DEFINE l_agree       LIKE type_file.chr1   #FUN-970017 add #自動確認和簽核
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-730012
   IF s_shut(0) THEN RETURN END IF
   #LET l_sql="SELECT * FROM ",g_dbs,"oga_file WHERE oga01 = '",p_oga01,"'"
   LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
             " WHERE oga01 = '",p_oga01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE sel_oga_pre1 FROM l_sql
    EXECUTE sel_oga_pre1 INTO l_oga.*
  #FUN-970017---add----str----
  #LET l_agree = 'N'
  ##同時具有自動確認和簽核的功能時的判斷
  #LET l_t1=s_get_doc_no(l_oga.oga01)
  #SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=l_t1
  #IF g_oay.oayconf = 'Y' AND g_oay.oayapr = 'Y' AND
  #   g_action_choice = 'efconfirm' THEN

  #   #(1)出貨單確認時,庫存扣帳方式若為'2:立刻扣帳(會詢問)',一律改為'1:立刻扣帳(不詢問)'
  #    IF p_cmd = '2' THEN
  #        LET p_cmd = '1'
  #    END IF

  #   #(2)不能 INPUT oga02
  #    LET p_Input_oga02 = FALSE

  #   #(3)出貨立刻扣帳,扣帳日期設為g_today
  #    LET l_agree = 'Y'
  #END IF
  #FUN-970017---add----end----

  #IF l_oga.oga00 = "A" THEN
  #   LET l_cnt = 0 
  #   SELECT COUNT(*) INTO l_cnt FROM imm_file
  #     WHERE imm09 = p_oga01
  #   IF l_cnt > 0 THEN
  #      CALL cl_err('post=Y','mfg0175',1)
  #      CLOSE t600sub_cl
  #      LET g_success = 'N'  #TQC-930155 add
  #      RETURN
  #   END IF
  #END IF
   IF l_oga.oga01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   LET l_argv0=l_oga.oga09  #FUN-730012
   IF l_argv0 MATCHES '[15]' THEN       #No.7992
      CALL cl_err('','axm-226',0) RETURN
   END IF
  #IF l_oga.ogaconf='X' THEN CALL cl_err('conf=X',9024,0) RETURN END IF
  #IF l_oga.ogaconf='N' THEN CALL cl_err('conf=N','axm-154',0) RETURN END IF
  #IF l_oga.ogapost='Y' THEN CALL cl_err('post=Y','mfg0175',0) RETURN END IF
   IF g_oaz.oaz03 = 'Y' AND g_sma.sma53 IS NOT NULL AND
      l_oga.oga02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF

  #DECLARE ogb_s_c CURSOR FOR
  #   SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
  #CALL s_showmsg_init()
 
  #FOREACH ogb_s_c INTO l_ogb.*
  #   IF cl_null(l_oga.oga99) THEN
  #      CALL s_incchk(l_ogb.ogb09,l_ogb.ogb091,g_user)
  #            RETURNING lj_result
  #      IF NOT lj_result THEN
  #         LET g_success = 'N'
  #         LET g_showmsg = l_ogb.ogb03,"/",l_ogb.ogb09,"/",l_ogb.ogb091,"/",g_user
  #         CALL s_errmsg('ogb03,ogb09,ogb091,inc03',g_showmsg,'','asf-888',1)
  #      END IF
  #    END IF
  #END FOREACH
  #CALL s_showmsg()
  #IF g_success = 'N' THEN
  #   RETURN
  #END IF

   SELECT occ57 INTO l_occ57 FROM occ_file WHERE occ01 =l_oga.oga03   #No.TQC-640123
   IF SQLCA.sqlcode THEN LET l_occ57 = 'N' END IF
 
   IF l_occ57 = 'Y' AND l_oga.oga30 = 'N' AND l_oga.oga09 <> '8' THEN   #MOD-9B0149
      #若為出貨通知單製包裝單,則再check一次,避免先轉出貨單再製包裝單無法確認
      IF g_oaz.oaz67 = '1' AND NOT cl_null(l_oga.oga011)  THEN
         LET l_oga30='N'
         #LET l_sql="SELECT oga30 FROM ",g_dbs,"oga_file", 
         LET l_sql="SELECT oga30 FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                   " WHERE oga01='",l_oga.oga011,"' AND oga09 IN ('1','5')"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
         PREPARE sel_oga30_pre FROM l_sql
         EXECUTE sel_oga30_pre INTO l_oga30
         IF SQLCA.SQLCODE THEN
            LET l_oga30='N'
         END IF
         IF l_oga30='N' THEN
            CALL cl_err(l_oga.oga01,'axm-234',0) RETURN
         END IF
      ELSE
         CALL cl_err(l_oga.oga01,'axm-234',0) RETURN
      END IF
   END IF
 
   IF NOT cl_null(l_oga.oga910) THEN #FUN-710037
      SELECT imd10,imd11,imd12 INTO l_imd10,l_imd11,l_imd12
        FROM imd_file WHERE imd01=l_oga.oga910 #FUN-710037
      IF NOT (l_imd11 MATCHES '[Yy]') THEN
         CALL cl_err(l_oga.oga910,'axm-993',0) #FUN-710037
         RETURN
      END IF
      #FUN-AC0002 mark begin----------------------
      #CASE
      #   WHEN l_oga.oga00 MATCHES '[37]' #3.出至境外倉;7.寄銷訂單
      #      IF NOT (l_imd10 MATCHES '[Ss]') THEN
      #         CALL cl_err(l_oga.oga910,'axm-063',0) #FUN-710037
      #         RETURN
      #      END IF
      #   OTHERWISE
      #END CASE
      #FUN-AC0002 mark end
   END IF
 
 
 
   IF NOT p_inTransaction THEN   #FUN-730012
      LET g_success = 'Y'
      LET g_totsuccess = 'Y' #TQC-620156
   END IF
 
 
   CALL t600sub_lock_cl()
   OPEN t600sub_cl USING l_oga.oga01
   IF STATUS THEN
      CALL cl_err("OPEN t600sub_cl:", STATUS, 1)
      CLOSE t600sub_cl
      LET g_success = 'N'   #TQC-930155 add
      RETURN
   END IF
 
   FETCH t600sub_cl INTO l_oga.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(l_oga.oga01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t600sub_cl
       LET g_success = 'N'   #TQC-930155 add
       RETURN
   END IF
  #IF l_flag = '1' THEN   #MOD-940273
  #   LET l_oga.oga02=l_oga02   #FUN-650009 add
  #END IF   #MOD-940273
  #UPDATE oga_file SET oga02=l_oga.oga02 WHERE oga01=l_oga.oga01   #FUN-650009 add
   #當帳款無法產生,此筆出貨單不可過帳-----#
   #LET l_sql = "UPDATE ",g_dbs,"oga_file SET ogapost='Y' WHERE oga01='",l_oga.oga01,"'"
   LET l_sql = "UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
               "   SET ogapost='Y' WHERE oga01='",l_oga.oga01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE upd_ogapost_pre FROM l_sql
   EXECUTE upd_ogapost_pre
   IF NOT cl_null(l_oga.oga011) AND l_oga.oga09 <> '8' THEN #通知單號  #MOD-7A0177 不回寫產簽收單的出貨單
      #LET l_sql="UPDATE ",g_dbs,"oga_file SET oga02='",l_oga.oga02,"',ogapost='Y' WHERE oga01='",l_oga.oga011,"'"
      LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                "   SET oga02='",l_oga.oga02,"',ogapost='Y' WHERE oga01='",l_oga.oga011,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE upd_oga02_pre FROM l_sql
      EXECUTE upd_oga02_pre
   END IF
   LET l_oga.ogapost='Y'
   #判斷單身料件的料件主檔資料ima_file，如果該料件的ima1012為空,則更新
   #出貨日期oga02至ima1012,否則不更新.
   LET l_sql="SELECT ima01,ima1012",
             #"  FROM ",g_dbs,"ogb_file,",g_dbs,"ima_file",
             "  FROM ",cl_get_target_table(g_plant_new,'ogb_file'),",", #FUN-A50102
                       cl_get_target_table(g_plant_new,'ima_file'),     #FUN-A50102
             " WHERE  ogb01='",l_oga.oga01,"' AND ogb04=ima01"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
   PREPARE sel_ima01_pre FROM l_sql
   DECLARE t600_ima1012 CURSOR FOR sel_ima01_pre
   FOREACH t600_ima1012 INTO l_ima01,l_ima1012
      IF STATUS THEN
         LET g_success = 'N'    #TQC-930155 add
         EXIT FOREACH
      END IF
      IF cl_null(l_ima1012) THEN
         #LET l_sql="UPDATE ",g_dbs,"ima_file",
         LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                   "   SET ima1012='",l_oga.oga69,"'",   #FUN-650009
                   " WHERE ima01='",l_ima01,"'"
      ELSE
         CONTINUE FOREACH
      END IF
   END FOREACH
   LET  p_success1='Y'                    #No.TQC-7C0114
   LET l_flag1='N'
  #CALL t600sub_s1(l_oga.*,p_cmd) RETURNING l_oha.* #FUN-9C0083
   CALL t600sub_s1(l_oga.*,'1') RETURNING l_oha.* #FUN-9C0083
   IF l_flag1='Y' THEN
      LET g_sma.sma894[2,2] = 'N'
   END IF
   IF sqlca.sqlcode THEN LET g_success='N' END IF
 
  #IF s_industry('icd') THEN
  #    CALL t600sub_ind_icd_post(l_oga.oga01,'1')
  #END IF

  #FUN-BA0023 Begin---
   IF g_azw.azw04 = '2' AND g_success = 'Y' THEN
      CALL s_showmsg_init()
      CALL t620sub1_post('1',l_oga.oga01)
      CALL s_showmsg()
   END IF
  #FUN-BA0023 End----- 

   IF g_success = 'Y' AND p_success1='Y' THEN  #No.TQC-7C0114
      CALL cl_flow_notify(l_oga.oga01,'S')
   ELSE
      #ROLLBACK WORK  #FUN-B40017 mark
      LET l_oga.ogapost='N'
   END IF
   #在判斷拆併箱之前先存舊值,因拆併箱也用此變數
    LET l_success = g_success
 
 
   IF l_oga.ogapost = "N" THEN
 
      LET g_success = "Y"
      LET g_totsuccess = "Y"   #MOD-9C0439
 
      IF g_totsuccess="N" THEN    #TQC-620156
         LET g_success="N"
      END IF
   END IF
 
   #在判斷拆併箱之後還原舊值,因拆併箱也用此變數
    LET g_success = l_success
 
END FUNCTION
 
FUNCTION t600sub_s1(l_oga,p_cmd) #FUN-9C0083
  DEFINE p_cmd LIKE type_file.chr1 #FUN-9C0083
  DEFINE l_ogc    RECORD LIKE ogc_file.*
  DEFINE l_oeb19  LIKE oeb_file.oeb19
  DEFINE l_oeb905 LIKE oeb_file.oeb905
  DEFINE l_flag   LIKE type_file.chr1     #No:8741  #No.FUN-680137 VARCHAR(1)
  DEFINE l_ogg    RECORD LIKE ogg_file.*
  DEFINE l_ima906 LIKE ima_file.ima906
  DEFINE l_ima25  LIKE ima_file.ima25
  DEFINE l_ima71  LIKE ima_file.ima71
  DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
  DEFINE l_cnt    LIKE type_file.num5                                                          #No.FUN-680137 SMALLINT
  DEFINE l_occ31  LIKE occ_file.occ31
  DEFINE l_tuq06  LIKE tuq_file.tuq06   #FUN-630102 modify adq->tuq
  DEFINE l_tuq07  LIKE tuq_file.tuq07   #FUN-630102 modify adq->tuq
  DEFINE l_desc   LIKE type_file.chr1    #No.FUN-680137 VARCHAR(01)
  DEFINE l_t      LIKE oay_file.oayslip  # Prog. Version..: '5.30.06-13.03.12(05)   #No.FUN-610064
  DEFINE l_oha53  LIKE oha_file.oha53     #No.FUN-610064
  DEFINE l_oha50  LIKE oha_file.oha50     #No.FUN-670008
  DEFINE l_oayauno LIKE oay_file.oayauno     #No.FUN-610064
  DEFINE l_oay17  LIKE oay_file.oay17     #No.FUN-610064
  DEFINE l_oay18  LIKE oay_file.oay18     #No.FUN-610064
  DEFINE l_oay20  LIKE oay_file.oay20     #No.FUN-610064
  DEFINE li_result LIKE type_file.num5                 #No.FUN-610064  #No.FUN-680137 SMALLINT
  DEFINE p_success LIKE type_file.chr1    # Prog. Version..: '5.30.06-13.03.12(01)     #No.FUN-610064
  DEFINE l_unit   LIKE ogb_file.ogb05     #No.FUN-610064
  DEFINE l_oha01  LIKE oha_file.oha01     #No.FUN-610064
  DEFINE l_occ02  LIKE occ_file.occ02     #No.FUN-610064
  DEFINE l_occ1006 LIKE occ_file.occ1006  #No.FUN-610064
  DEFINE l_occ1017 LIKE occ_file.occ1017  #No.FUN-610064
  DEFINE l_occ09   LIKE occ_file.occ09    #No.FUN-610064
  DEFINE l_occ1005 LIKE occ_file.occ1005  #No.FUN-610064
  DEFINE l_occ1022 LIKE occ_file.occ1022  #No.FUN-610064
  DEFINE l_occ07   LIKE occ_file.occ07    #No.TQC-640123
  DEFINE l_occ1024 LIKE occ_file.occ1024  #No.FUN-610064
  DEFINE l_ohb03   LIKE ohb_file.ohb03    #No.FUN-610064
  DEFINE l_ohb13   LIKE ohb_file.ohb13    #No.FUN-610064
  DEFINE l_ohb13t  LIKE ohb_file.ohb13    #No.FUN-610064
  DEFINE l_ohb14   LIKE ohb_file.ohb14    #No.FUN-610064
  DEFINE l_ohb14t  LIKE ohb_file.ohb14    #No.FUN-610064
  DEFINE l_ohb1001 LIKE ohb_file.ohb1001  #No.FUN-610064
  DEFINE l_qty     LIKE ogb_file.ogb12    #No.TQC-640123
  DEFINE l_oayapr  LIKE oay_file.oayapr   #FUN-710037
  DEFINE l_argv0   LIKE ogb_file.ogb09
  DEFINE l_oga     RECORD LIKE oga_file.*
  DEFINE l_ogb     RECORD LIKE ogb_file.*
  DEFINE l_ogb12   LIKE ogb_file.ogb12 ,
         l_ogb912  LIKE ogb_file.ogb912,
         l_ogb915  LIKE ogb_file.ogb915,
         l_ogb917  LIKE ogb_file.ogb917
  DEFINE l_msg     STRING
  DEFINE l_oha     RECORD LIKE oha_file.*
  DEFINE l_ohb     RECORD LIKE ohb_file.*
  DEFINE l_tot1    LIKE ogc_file.ogc12
  DEFINE l_msg3    STRING        #No.TQC-7C0114
  DEFINE l_oah03   LIKE type_file.chr1   #FUN-820060
  DEFINE l_ima131  LIKE type_file.chr20  #FUN-820060
 #FUN-910088--add--start--
  DEFINE l_tup05   LIKE tup_file.tup05,  
         li_tuq07  LIKE tuq_file.tuq07,   
         li_tuq09  LIKE tuq_file.tuq09
 #FUN-910088--add--end--  
#####
 
   CALL s_showmsg_init()   #No.FUN-6C0083
   LET l_argv0=l_oga.oga09  #FUN-730012
   INITIALIZE l_oha.* TO NULL #FUN-730012

 #DECLARE t600_s1_c CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=l_oga.oga01 AND ogb1005 = '1' #No.FUN-610064
  #LET l_sql="SELECT * FROM ",g_dbs,"ogb_file WHERE ogb01='",l_oga.oga01,"' AND ogb1005 = '1' "
  LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
            " WHERE ogb01='",l_oga.oga01,"' AND ogb1005 = '1' "
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
  PREPARE sel_ogb_pre3 FROM l_sql
  DECLARE t600_s1_c CURSOR FOR sel_ogb_pre3 
 
  FOREACH t600_s1_c INTO l_ogb.*
      IF STATUS THEN EXIT FOREACH END IF
 
      IF l_ogb.ogb17 = 'N' THEN
         CALL t600sub_chk_ogb15_fac(l_oga.*,l_ogb.*) IF g_success='N' THEN RETURN l_oha.* END IF   #No.TQC-7C0114
      END IF
      IF cl_null(l_ogb.ogb04) THEN CONTINUE FOREACH END IF
      CALL t600sub_bu1(l_oga.*,l_ogb.*)   #No.TQC-8C0027
      IF g_success = 'N' THEN RETURN l_oha.* END IF
      IF g_oaz.oaz03 = 'N' THEN CONTINUE FOREACH END IF
      IF l_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF
#########CALL t600_chk_avl_stk(l_ogb.*) #BUG-4A0232,MOD-520078   #MOD-850309 #FUN-A20044
         CALL t600sub_update(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,
                          l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,'',l_ogb.ogb04,l_oga.*,l_ogb.*)  #No:8741  #FUN-5C0075 #FUN-730012
         IF g_success='N' THEN    #No.FUN-6C0083
            LET g_totsuccess="N"
            LET g_success="Y"
            CONTINUE FOREACH
         END IF
       IF g_success='N' THEN RETURN l_oha.* END IF #MOD-4A0232

     ##更新已備置量 no.7182
      #LET l_sql="SELECT oeb19,oeb905 FROM ",g_dbs,"oeb_file",
      LET l_sql="SELECT oeb19,oeb905 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                " WHERE oeb01='",l_ogb.ogb31,"' AND oeb03='",l_ogb.ogb32,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
      PREPARE sel_oeb19_pre FROM l_sql
      EXECUTE sel_oeb19_pre INTO l_oeb19,l_oeb905
      IF l_oeb19 = 'Y' THEN
         IF l_oeb905 > l_ogb.ogb12 THEN
            LET l_oeb905= l_oeb905 - l_ogb.ogb12
         ELSE
            LET l_oeb905 = 0
         END IF
         #LET l_sql="UPDATE ",g_dbs,"oeb_file SET oeb905 = '",l_oeb905,"'",
         LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                   "   SET oeb905 = '",l_oeb905,"'",
                   "WHERE oeb01 = '",l_ogb.ogb31,"'",
                   "  AND oeb03 = '",l_ogb.ogb32,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
         PREPARE upd_oeb905_pre FROM l_sql
         EXECUTE upd_oeb905_pre
         IF STATUS THEN
            LET g_errno = SQLCA.sqlcode    #FUN-BB0120 add
            LET g_showmsg=l_ogb.ogb31,"/",l_ogb.ogb32               #No.FUN-710046
            CALL s_errmsg("obe01,obe03",g_showmsg,"UPD obe_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success = 'N' DISPLAY "4"
            #TQC-B20181 add begin-----------  
           #LET g_errno=SQLCA.sqlcode      #FUN-BB0120 mark 
	    LET g_msg1='oeb_file'||'UPD obe_file'||g_plant_new||g_fno
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            #TQC-B20181 add end-------------
            CONTINUE FOREACH         #No.FUN-710046
         END IF
      END IF
##處理境外倉庫存
      IF l_argv0 = '2' AND l_oga.oga65='Y'  THEN
         CALL t600sub_consign(l_oga.oga66,l_oga.oga67,l_ogb.ogb092,     #No.TQC-6B0174
                           l_ogb.ogb12,l_ogb.ogb05,l_ogb.ogb15_fac,l_ogb.ogb16,l_oga.*,l_ogb.*)  #No.FUN-630061
         IF g_success = 'N' THEN
            LET g_totsuccess="N"
            LET g_success="Y"
            CONTINUE FOREACH   #No.FUN-6C0083
         END IF
      END IF
      SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=l_oga.oga03   #No.TQC-640123
      IF cl_null(l_occ31) THEN LET l_occ31='N' END IF
      IF l_occ31 = 'N' THEN CONTINUE FOREACH END IF  #NO.MOD-4B0070
      SELECT ima25,ima71 INTO l_ima25,l_ima71
        FROM ima_file WHERE ima01=l_ogb.ogb04
         IF cl_null(l_ima71) THEN LET l_ima71=0 END IF
         LET l_cnt=0
         #LET l_sql="SELECT COUNT(*) FROM ",g_dbs,"tuq_file ",
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'tuq_file'), #FUN-A50102
                   " WHERE tuq01='",l_oga.oga03 ,"' AND tuq02='",l_ogb.ogb04,"'",              #No.TQC-640123
                   "   AND tuq03='",l_ogb.ogb092,"' AND tuq04='",l_oga.oga02,"'",
                   "   AND tuq11 ='1'",
                   "   AND tuq12 = '",l_oga.oga04,"'",  
                   "   AND tuq05 = '",l_oga.oga01,"'",  #MOD-7A0084
                   "   AND tuq051= '",l_ogb.ogb03,"'"   #MOD-7A0084
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
         PREPARE sel_cnt_pre3 FROM l_sql
         EXECUTE sel_cnt_pre3 INTO l_cnt
         IF l_cnt=0 THEN
            LET l_fac1=1
            IF l_ogb.ogb05 <> l_ima25 THEN
               CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ima25,g_plant_new)
                    RETURNING l_cnt,l_fac1
               IF l_cnt = '1'  THEN
                  CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)         #No.FUN-710046
                  LET l_fac1=1
               END IF
            END IF
            #LET l_sql="INSERT INTO ",g_dbs,"tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,",   #MOD-7A0084 modify tuq051
            LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'tuq_file'), #FUN-A50102
                      "(tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,",
                                  " tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,",
                                  " tuqplant,tuqlegal) ",  #FUN-980010 add plant & legal  
                      " VALUES('",l_oga.oga03,"','",l_ogb.ogb04,"','",l_ogb.ogb092,"','",l_oga.oga02,"',",
                      "        '",l_oga.oga01,"','",l_ogb.ogb03,"',",   #No.TQC-640123  #MOD-7A0084 modify
                      "        '",l_ogb.ogb05,"','",l_ogb.ogb12,"','",l_fac1,"',",l_ogb.ogb12,"*",l_fac1,",'1','1','",l_oga.oga04,"',",
                      "        '",g_plant_new,"','",p_legal,"')" 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
            PREPARE ins_tuq_pre FROM l_sql
            EXECUTE ins_tuq_pre
            IF SQLCA.sqlcode THEN
               LET g_errno = SQLCA.sqlcode          #FUN-BB0120 add
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"INS tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success ='N'
               #TQC-B20181 add begin-----------  
              #LET g_errno=SQLCA.sqlcode            #FUN-BB0120 mark           
	       LET g_msg1='tuq_file'||'INS tuq_file'||g_plant_new||g_fno
	       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	       LET g_msg=g_msg[1,255]
	       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	       LET g_errno=''
	       LET g_msg=''
	       LET g_msg1=''
               #TQC-B20181 add end-------------
               DISPLAY "5"
               CONTINUE FOREACH     #No.FUN-710046
            END IF
         ELSE
           #LET l_sql= "SELECT UNIQUE tuq06 FROM ",g_dbs,"tuq_file ",
           LET l_sql= "SELECT UNIQUE tuq06 FROM ",cl_get_target_table(g_plant_new,'tuq_file'), #FUN-A50102
                      " WHERE tuq01='",l_oga.oga03 ,"' AND tuq02='",l_ogb.ogb04,"'",              #No.TQC-640123
                      "   AND tuq03='",l_ogb.ogb092,"' AND tuq04='",l_oga.oga02,"'",
                      "   AND tuq11 ='1'",
                      "   AND tuq12 = '",l_oga.oga04,"'",  
                      "   AND tuq05 = '",l_oga.oga01,"'",  #MOD-7A0084
                      "   AND tuq051= '",l_ogb.ogb03,"'"   #MOD-7A0084
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
          CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102              
          PREPARE sel_tuq06_pre FROM l_sql
          EXECUTE sel_tuq06_pre INTO l_tuq06 
            IF SQLCA.sqlcode THEN
               LET g_errno = SQLCA.sqlcode     #FUN-BB0120 add
               LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
               CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"SEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success ='N'
               #TQC-B20181 add begin-----------  
              #LET g_errno=SQLCA.sqlcode       #FUN-BB0120 mark               
	       LET g_msg1='tuq_file'||'SEL tuq_file'||g_plant_new||g_fno
	       CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	       LET g_msg=g_msg[1,255]
	       CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	       LET g_errno=''
	       LET g_msg=''
	       LET g_msg1=''
               #TQC-B20181 add end-------------
               DISPLAY "6"
               CONTINUE FOREACH    #No.FUN-710046
            END IF
            LET l_fac1=1
            IF l_ogb.ogb05 <> l_tuq06 THEN
               CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_tuq06,g_plant_new)
                    RETURNING l_cnt,l_fac1
               IF l_cnt = '1'  THEN
                  CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0) #No.FUN-710046
                  LET l_fac1=1
               END IF
            END IF
            #LET l_sql= "SELECT tuq07 FROM ",g_dbs,"tuq_file ",
            LET l_sql= "SELECT tuq07 FROM ",cl_get_target_table(g_plant_new,'tuq_file'), #FUN-A50102
                       " WHERE tuq01='",l_oga.oga03 ,"' AND tuq02='",l_ogb.ogb04,"'",              #No.TQC-640123
                       "   AND tuq03='",l_ogb.ogb092,"' AND tuq04='",l_oga.oga02,"'",
                       "   AND tuq11 ='1'",
                       "   AND tuq12 = '",l_oga.oga04,"'",  
                       "   AND tuq05 = '",l_oga.oga01,"'",  #MOD-7A0084
                       "   AND tuq051= '",l_ogb.ogb03,"'"   #MOD-7A0084
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
            PREPARE sel_tuq07_pre FROM l_sql
            EXECUTE sel_tuq07_pre INTO l_tuq07
            IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF
            IF l_tuq07+l_ogb.ogb12*l_fac1<0 THEN
               LET l_desc='2'
            ELSE
               LET l_desc='1'
            END IF
            IF l_tuq07+l_ogb.ogb12*l_fac1=0 THEN
               #LET l_sql="DELETE FROM ",g_dbs,"tuq_file",
               LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tuq_file'), #FUN-A50102
                         " WHERE tuq01='",l_oga.oga03 ,"' AND tuq02='",l_ogb.ogb04,"'",              #No.TQC-640123
                         "   AND tuq03='",l_ogb.ogb092,"' AND tuq04='",l_oga.oga02,"'",
                         "   AND tuq11 ='1'",
                         "   AND tuq12 = '",l_oga.oga04,"'",  
                         "   AND tuq05 = '",l_oga.oga01,"'",  #MOD-7A0084
                         "   AND tuq051= '",l_ogb.ogb03,"'"   #MOD-7A0084
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
              CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
              PREPARE del_tuq_pre FROM l_sql
              EXECUTE del_tuq_pre
               IF SQLCA.sqlcode THEN
                  LET g_errno = SQLCA.sqlcode       #FUN-BB0120 add
                  LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
                  CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"DEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success='N'
                  #TQC-B20181 add begin-----------  
                 #LET g_errno=SQLCA.sqlcode         #FUN-BB0120 mark              
	          LET g_msg1='tuq_file'||'DEL tuq_file'||g_plant_new||g_fno
	          CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	          LET g_msg=g_msg[1,255]
	          CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	          LET g_errno=''
	          LET g_msg=''
	          LET g_msg1=''
                  #TQC-B20181 add end-------------
                  DISPLAY "7"
                  CONTINUE FOREACH    #No.FUN-710046
               END IF
            ELSE
               LET l_fac2=1
               IF l_tuq06 <> l_ima25 THEN
                  CALL s_umfchk(l_ogb.ogb04,l_tuq06,l_ima25)
                       RETURNING l_cnt,l_fac2
                  IF l_cnt = '1'  THEN
                     CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)  #No.FUN-710046
                     LET l_fac2=1
                  END IF
               END IF
             #FUN-910088--add--start--
               LET li_tuq07 = l_ogb.ogb12*l_fac1
               LET li_tuq07 = s_digqty(li_tuq07,l_ima25)
               LET li_tuq09 = l_ogb.ogb12*l_fac1*l_fac2
               LET li_tuq09 = s_digqty(li_tuq09,l_ima25)
             #FUN-910088--add--end--
               #LET l_sql="UPDATE ",g_dbs,"tuq_file SET tuq07=tuq07+",l_ogb.ogb12,"*",l_fac1,",",
               LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'tuq_file'), #FUN-A50102
                     #FUN-910088--mark--start--
                     #   "  SET tuq07=tuq07+",l_ogb.ogb12,"*",l_fac1,",",
                     #                               " tuq09=tuq09+",l_ogb.ogb12,"*",l_fac1,"*",l_fac2,",",
                     #FUN-910088--mark--end--
                     #FUN-910088--add--start--
                         "  SET tuq07 = tuq07+",li_tuq07,", ",
                         "      tuq09 = tuq09+",li_tuq09,", ",
                     #FUN-910088--add--end--
                               " tuq10='",l_desc,"'",
                         " WHERE tuq01='",l_oga.oga03 ,"' AND tuq02='",l_ogb.ogb04,"'",              #No.TQC-640123
                         "   AND tuq03='",l_ogb.ogb092,"' AND tuq04='",l_oga.oga02,"'",
                         "   AND tuq11 ='1'",
                         "   AND tuq12 = '",l_oga.oga04,"'",  
                         "   AND tuq05 = '",l_oga.oga01,"'",  #MOD-7A0084
                         "   AND tuq051= '",l_ogb.ogb03,"'"   #MOD-7A0084
               IF SQLCA.sqlcode THEN
                  LET g_errno = SQLCA.sqlcode        #FUN-BB0120 add
                  LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092,"/",l_oga.oga02,"/",l_oga.oga04  #No.FUN-710046
                  CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"UPD tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success='N'
                  #TQC-B20181 add begin-----------  
                 #LET g_errno=SQLCA.sqlcode          #FUN-BB0120 mark             
	          LET g_msg1='tuq_file'||'UPD tuq_file'||g_plant_new||g_fno
	          CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	          LET g_msg=g_msg[1,255]
	          CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	          LET g_errno=''
	          LET g_msg=''
	          LET g_msg1=''
                  #TQC-B20181 add end-------------
                  DISPLAY "8"
                  CONTINUE FOREACH         #No.FUN-710046
               END IF
            END IF
         END IF   #cockroach 0501
     #   END IF
     #END IF
      LET l_fac1=1
      IF l_ogb.ogb05 <> l_ima25 THEN
         CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ima25,g_plant_new)
              RETURNING l_cnt,l_fac1
         IF l_cnt = '1'  THEN
            CALL s_errmsg('','',l_ogb.ogb04,"abm-731",0)   #No.FUN-710046
            LET l_fac1=1
         END IF
      END IF
         LET l_cnt=0
         #LET l_sql="SELECT COUNT(*) FROM ",g_dbs,"tup_file ",
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'tup_file'), #FUN-A50102
                   " WHERE tup01='",l_oga.oga03 ,"' AND tup02='",l_ogb.ogb04,"'",      #No.TQC-640123
                   "   AND tup03='",l_ogb.ogb092,"'",
                   "   AND ((tup08='1' AND tup09='",l_oga.oga04,"') OR ",#FUN-690083 modify
                   "        (tup11='1' AND tup12='",l_oga.oga04,"'))"    #FUN-690083 modify
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
         PREPARE sel_cnt_pre4 FROM l_sql
         EXECUTE sel_cnt_pre4 INTO l_cnt 
      IF cl_null(l_ogb.ogb092) THEN LET l_ogb.ogb092=' ' END IF  #FUN-790001 add
  #FUN-910088--add--start--
      LET l_tup05 = l_ogb.ogb12*l_fac1
      LET l_tup05 = s_digqty(l_tup05,l_ima25)
  #FUN-910088--add--end--
      IF l_cnt=0 THEN
            #LET l_sql="INSERT INTO ",g_dbs,"tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,",
            LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'tup_file'), #FUN-A50102
                      "(tup01,tup02,tup03,tup04,tup05,",
                                  " tup06,tup07,tup08,tup09,tup11,tup12,",
                                  " tupplant,tuplegal) ", 
                      " VALUES('",l_oga.oga03,"','",l_ogb.ogb04,"','",l_ogb.ogb092,"','",l_ima25,"',",           
                      #"       ",l_ogb.ogb12,"*",l_fac1,",'",l_oga.oga02,"','",l_oga.oga02,"','1',",  #FUN-910088--mark--
                      "       ",l_tup05,",'",l_oga.oga02,"','",l_oga.oga02,"','1',",                  #FUN-910088--add--
                      "        '",l_oga.oga04,"','1','",l_oga.oga04,"',",
                      "        '",g_plant_new,"','",p_legal,"')" 
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
            PREPARE ins_tuq_pre1 FROM l_sql
            EXECUTE ins_tuq_pre1
         IF SQLCA.sqlcode THEN
            LET g_errno = SQLCA.sqlcode     #FUN-BB0120 add
            CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","insert tup_file",1)  #No.FUN-670008
            CALL s_errmsg("tup01",l_oga.oga03,"INS tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            #TQC-B20181 add begin-----------  
           #LET g_errno=SQLCA.sqlcode       #FUN-BB0120 mark 
	    LET g_msg1='tup_file'||'INS tup_file'||g_plant_new||g_fno
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            #TQC-B20181 add end-------------
            DISPLAY "9"
            CONTINUE FOREACH                #No.FUN-710046
         END IF
      ELSE
         #LET l_sql="UPDATE ",g_dbs,"tup_file SET tup05=tup05+",l_ogb.ogb12,"*",l_fac1," ",
         LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'tup_file'), #FUN-A50102
                   #"   SET tup05=tup05+",l_ogb.ogb12,"*",l_fac1," ",      #FUN-910088--mark-
                   "   SET tup05=tup05+",l_tup05," ",                      #FUN-910088--add--
                   " WHERE tup01='",l_oga.oga03 ,"' AND tup02='",l_ogb.ogb04,"'",      #No.TQC-640123
                   "   AND tup03='",l_ogb.ogb092,"'",
                   "   AND ((tup08='1' AND tup09='",l_oga.oga04,"') OR ",#FUN-690083 modify
                   "        (tup11='1' AND tup12='",l_oga.oga04,"'))"    #FUN-690083 modify
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
         PREPARE upd_tuq05_pre FROM l_sql
         EXECUTE upd_tuq05_pre 
         IF SQLCA.sqlcode THEN
            LET g_errno = SQLCA.sqlcode    #FUN-BB0120 add
            LET g_showmsg=l_oga.oga03,"/",l_ogb.ogb04,"/",l_ogb.ogb092               #No.FUN-710046
            CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1)  #No.FUN-710046
            LET g_success='N'
            #TQC-B20181 add begin-----------  
           #LET g_errno=SQLCA.sqlcode      #FUN-BB0120 mark 
	    LET g_msg1='tup_file'||'UPD tup_file'||g_plant_new||g_fno
	    CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
	    LET g_msg=g_msg[1,255]
	    CALL p200_log(g_trans_no,g_plant_new,g_fno,'02','POSDB',g_errno,g_msg,'0','N',g_msg1)
	    LET g_errno=''
	    LET g_msg=''
	    LET g_msg1=''
            #TQC-B20181 add end-------------
            DISPLAY "10"
            CONTINUE FOREACH       #No.FUN-710046
         END IF
      END IF
      IF g_success='N' THEN RETURN l_oha.* END IF
  END FOREACH
 #CALL t600_tqw081_update('1')
  IF g_success='N' THEN
     RETURN l_oha.*
  END IF
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
  RETURN l_oha.*  #FUN-730012
END FUNCTION
 
FUNCTION t600sub_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,p_flag,p_item,l_oga,l_ogb) #No:8741  #FUN-5C0075 #FUN-730012
  DEFINE l_oeb19   LIKE oeb_file.oeb19
#  DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_avl_stk  LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_oeb12   LIKE oeb_file.oeb12
  DEFINE l_qoh     LIKE oeb_file.oeb12
  DEFINE p_flag    LIKE type_file.chr1                      #No:8741  #No.FUN-680137 VARCHAR(1)
  DEFINE p_ware    LIKE ogb_file.ogb09,       ##倉庫
         p_loca    LIKE ogb_file.ogb091,      ##儲位
         p_lot     LIKE ogb_file.ogb092,      ##批號
         p_qty     LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
         p_qty2    LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         p_uom     LIKE ima_file.ima31,       ##銷售單位
         p_factor  LIKE ogb_file.ogb15_fac,   ##轉換率
         p_item    LIKE ogc_file.ogc17,       #FUN-5C0075
         l_qty     LIKE ogc_file.ogc12,       ##異動後數量
         l_ima01   LIKE ima_file.ima01,
         l_ima25   LIKE ima_file.ima25,
         l_img     RECORD
                   img10   LIKE img_file.img10,
                   img16   LIKE img_file.img16,
                   img23   LIKE img_file.img23,
                   img24   LIKE img_file.img24,
                   img09   LIKE img_file.img09,
                   img18   LIKE img_file.img18,  #No.MOD-480401
                   img21   LIKE img_file.img21
                   END RECORD,
         l_cnt     LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_oga     RECORD LIKE oga_file.*,
         l_ogb     RECORD LIKE ogb_file.*
  DEFINE l_ima86   LIKE ima_file.ima86 #FUN-730018
  DEFINE l_msg     LIKE type_file.chr1000
 
    #TQC-B40174  聯營及非企業料號不異動 img 及 tlf  ...begin
    IF s_joint_venture( p_item,g_plant_new) OR NOT s_internal_item( p_item,g_plant_new) THEN  #FUN-B40084 mod g_plant---g_plant_new
       RETURN
    END IF
    #TQC-B40174  聯營及非企業料號不異動 img 及 tlf  ...end 
    
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','axm-186',1) LET g_success = 'N' RETURN
    END IF
 
    LET g_forupd_sql ="SELECT img10,img16,img23,img24,img09,img18,img21 ", #No.MOD-480401
                      #" FROM ",g_dbs,"img_file ",
                      " FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                      " WHERE img01= ?  AND img02= ? AND img03= ? ",
                      " AND img04= ?   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING p_item,p_ware,p_loca,p_lot #FUN-5C0075
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       CLOSE img_lock    #TQC-930155 add
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF l_img.img18 < l_oga.oga02 THEN
       CALL cl_err(l_ogb.ogb04,'aim-400',1)   #須修改
       LET g_success='N' RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    LET l_qty= l_img.img10 - p_qty2
 
    #--訂單備置為'N',須check(庫存量ima262-sum(備置量oeb12-oeb24))>出貨量
    IF NOT cl_null(l_ogb.ogb31) AND NOT cl_null(l_ogb.ogb32) THEN
       #LET l_sql="SELECT oeb19 FROM ",g_dbs,"oeb_file",
       LET l_sql="SELECT oeb19 FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                 " WHERE oeb01='",l_ogb.ogb31,"' AND oeb03 = '",l_ogb.ogb32,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102           
       PREPARE sel_oeb19_pre1 FROM l_sql
       EXECUTE sel_oeb19_pre1 INTO l_oeb19
       IF STATUS THEN
          CALL cl_err3("sel","oeb_file",l_ogb.ogb31,l_ogb.ogb32,SQLCA.sqlcode,"","sel oeb:",1)  #No.FUN-670008
          LET g_success='N' RETURN
       END IF
 
       IF p_qty2 > l_img.img10 THEN
          IF g_sma.sma894[2,2]='N' THEN  #cockroach 0430 
            #IF g_bgerr THEN  #cockroach 0430
                CALL s_errmsg('ima01',p_item,l_msg,'mfg-026',1)
            #ELSE
            #   CALL cl_err(l_msg,'mfg-026',1)
            #END IF
             LET g_success='N' RETURN
          END IF
       END IF
        #MOD-4A0232(end)
    END IF
 
 
    IF NOT s_stkminus(p_item,p_ware,p_loca,p_lot,p_qty,p_factor,l_oga.oga02,g_sma.sma894[2,2]) THEN  #FUN-5C0075
       LET g_success='N'
       RETURN
    END IF
    IF p_qty2 > 0 THEN #FUN-B40017 add
       CALL s_upimg1(p_item,p_ware,p_loca,p_lot,-1,p_qty2,g_today, #FUN-8C0084
             '','','','',l_ogb.ogb01,l_ogb.ogb03,'','','','','','','','','','','','',g_plant_new)  #No.FUN-850100
    #FUN-B40017 add ---------------begin-------------------
    ELSE           
    	 CALL s_upimg1(p_item,p_ware,p_loca,p_lot,1,(-1)*p_qty2,g_today, 
             '','','','',l_ogb.ogb01,l_ogb.ogb03,'','','','','','','','','','','','',g_plant_new)
    END IF  
    #FUN-B40017 add -----------------end--------------------    
    IF g_success='N' THEN
       CALL cl_err('s_mupimg()','9050',0) RETURN
    END IF
 
    #Update ima_file
    #LET g_forupd_sql = "SELECT ima25,ima86 FROM ",g_dbs,"ima_file ",
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock CURSOR FROM g_forupd_sql
 
    OPEN ima_lock USING p_item   #FUN-5C0075
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       CLOSE ima_lock
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH ima_lock INTO l_ima25,l_ima86 #FUN-730018
    IF STATUS THEN
       CLOSE ima_lock   #TQC-930155 add
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
   #Call s_udima(p_item,l_img.img23,l_img.img24,p_qty2,  #FUN-5C0075
   #             #g_today,-1)  RETURNING l_cnt   #MOD-920298
   #             l_oga.oga02,-1)  RETURNING l_cnt   #MOD-920298
    IF p_qty2 > 0 THEN #FUN-B40017 add
       CALL s_udima1(p_item,l_img.img23,l_img.img24,p_qty2,l_oga.oga02,-1,g_plant_new) RETURNING l_cnt
    #FUN-B40017 add ------------begin-------------
    ELSE 
    	 CALL s_udima1(p_item,l_img.img23,l_img.img24,(-1)*p_qty2,l_oga.oga02,1,g_plant_new) RETURNING l_cnt
    END IF	
    #FUN-B40017 add -------------end--------------
   #最近一次發料日期 表發料
    IF l_cnt THEN
       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
       LET g_success='N' RETURN
    END IF
    IF g_success='Y' THEN                                                      #CHI-9C0009 mark #CHI-9C0037 remark 
       CALL t600sub_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,p_flag,p_item,l_ima86,l_oga.*,l_ogb.*) #No:8741  #FUN-5C0075
    END IF
END FUNCTION
 
FUNCTION t600sub_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,p_flag,p_item,l_ima86,l_oga,l_ogb) #No:8741  #FUN-5C0075
   DEFINE
      p_ware     LIKE ogb_file.ogb09,       ##倉庫
      p_loca     LIKE ogb_file.ogb091,      ##儲位
      p_lot      LIKE ogb_file.ogb092,      ##批號
      p_qty      LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
      p_uom      LIKE ima_file.ima31,       ##銷售單位
      p_factor   LIKE ogb_file.ogb15_fac,   ##轉換率
      p_unit     LIKE ima_file.ima25,       ##單位
      p_img10    LIKE img_file.img10,     ##異動後數量
      p_item     LIKE img_file.img01,     #FUN-5C0075
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      l_cnt      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      p_flag     LIKE type_file.chr1,     #No:8741  #No.FUN-680137 VARCHAR(1)
      l_ima86    LIKE ima_file.ima86,    #FUN-730018
      l_oga      RECORD LIKE oga_file.*,
      l_ogb      RECORD LIKE ogb_file.*
     
#   IF p_qty > 0 THEN  #FUN-B40017 add    #FUN-B80115  mark
    IF p_qty >= 0 THEN                     #FUN-B80115  add
      #----來源----
      LET g_tlf.tlf01=p_item              #異動料件編號
      LET g_tlf.tlf02=50                  #'Stock'
      LET g_tlf.tlf020=l_ogb.ogb08
      LET g_tlf.tlf021=p_ware             #倉庫
      LET g_tlf.tlf022=p_loca             #儲位
      LET g_tlf.tlf023=p_lot              #批號
      LET g_tlf.tlf024=p_img10            #異動後數量
      LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=l_ogb.ogb01        #出貨單號
      LET g_tlf.tlf027=l_ogb.ogb03        #出貨項次
      #---目的----
      LET g_tlf.tlf03=724
      LET g_tlf.tlf030=' '
      LET g_tlf.tlf031=' '                #倉庫
      LET g_tlf.tlf032=' '                #儲位
      LET g_tlf.tlf033=' '                #批號
      LET g_tlf.tlf034=' '                #異動後庫存數量
      LET g_tlf.tlf035=' '                #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=l_ogb.ogb31        #訂單單號
      LET g_tlf.tlf037=l_ogb.ogb32        #訂單項次
   #FUN-B40017 add begin----------------------------------     
   ELSE
   	  LET p_qty = p_qty*(-1)
      #----來源----
      LET g_tlf.tlf01=p_item              #異動料件編號
      LET g_tlf.tlf02=731                 #'Stock'
      LET g_tlf.tlf020=' '
      LET g_tlf.tlf021=' '                #倉庫
      LET g_tlf.tlf022=' '                #儲位
      LET g_tlf.tlf023=' '                #批號
      LET g_tlf.tlf024=0                  #異動後數量
      LET g_tlf.tlf025=' '                #庫存單位(ima_file or img_file)
      LET g_tlf.tlf026=l_ogb.ogb01        #出貨單號
      LET g_tlf.tlf027=l_ogb.ogb03        #出貨項次
      #---目的----
      LET g_tlf.tlf03=50
      LET g_tlf.tlf030=l_ogb.ogb08
      LET g_tlf.tlf031=p_ware             #倉庫
      LET g_tlf.tlf032=p_loca             #儲位
      LET g_tlf.tlf033=p_lot              #批號
      LET g_tlf.tlf034=p_img10            #異動後庫存數量
      LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
      LET g_tlf.tlf036=l_ogb.ogb31        #訂單單號
      LET g_tlf.tlf037=l_ogb.ogb32        #訂單項次
   END IF	   
   #FUN-B40017 add end------------------------------------  
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oga.oga02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom			#發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   LET g_tlf.tlf13='axmt620'
   LET g_tlf.tlf14=l_ogb.ogb1001   #No.FUN-660073
 
   LET g_tlf.tlf17=' '              #非庫存性料件編號
   CALL s_imaQOH(l_ogb.ogb04)
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oga.oga03 #No.MOD-870252
   LET g_tlf.tlf20 = l_oga.oga46
   LET g_tlf.tlf61= l_ima86 #FUN-730018
   LET g_tlf.tlf62=l_ogb.ogb31    #參考單號(訂單)
   LET g_tlf.tlf63=l_ogb.ogb32    #訂單項次
   LET g_tlf.tlf64=l_ogb.ogb908   #手冊編號 no.A050
   LET g_tlf.tlf66=p_flag         #for axcp500多倉出貨處理   #No:8741
   LET g_tlf.tlf930=l_ogb.ogb930  #FUN-670063
   LET g_tlf.tlf20 = l_ogb.ogb41
   LET g_tlf.tlf41 = l_ogb.ogb42
   LET g_tlf.tlf42 = l_ogb.ogb43
   LET g_tlf.tlf43 = l_ogb.ogb1001
  #CALL s_tlf(1,0)   #非跨DB,不用 cock 0420
  #-----本段恢復使用sub_s_tlf2.4gl異動記錄--cockroach 0501----#
  #-----因討論決定HOBA恢復使用自動編號功能,所以現在將原在南京決定的p200_tlf()mark----#
  #-----p200_tlf()實質是copy s_tlf2()并將內部單別check_func給去掉----#
  #-----現有pos上傳默認單別,則恢復，這里做remark----#
   CALL s_tlf2(1,0,g_plant_new) 
  #CALL p200_tlf(1,0,g_plant_new)
END FUNCTION
 
FUNCTION t600sub_consign(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_qty2,l_oga,l_ogb)  #No.FUN-630061
  DEFINE p_ware   LIKE ogb_file.ogb09,       ##倉庫
         l_ogb    RECORD LIKE ogb_file.*,    #No.FUN-630061
         p_loca   LIKE ogb_file.ogb091,      ##儲位
         p_lot    LIKE ogb_file.ogb092,      ##批號
         p_qty    LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
         p_qty2   LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         l_qty2   LIKE ogc_file.ogc16,       ##銷售數量(img 單位)
         p_uom    LIKE ima_file.ima31,       ##銷售單位
         p_factor LIKE ogb_file.ogb15_fac,   ##轉換率
         l_factor LIKE ogb_file.ogb15_fac,   ##轉換率
         l_qty    LIKE ogc_file.ogc12,       ##異動後數量
         l_cnt    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         l_ima01  LIKE ima_file.ima01,
         l_ima25  LIKE ima_file.ima25,
         p_img    RECORD LIKE img_file.*,
         l_img    RECORD
                  img10   LIKE img_file.img10,
                  img16   LIKE img_file.img16,
                  img23   LIKE img_file.img23,
                  img24   LIKE img_file.img24,
                  img09   LIKE img_file.img09,
                  img21   LIKE img_file.img21
                  END RECORD
   DEFINE l_oeb19   LIKE oeb_file.oeb19
#   DEFINE l_ima262  LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_avl_stk  LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12
   DEFINE l_ima71   LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_ima86   LIKE ima_file.ima86  #FUN-730018
   DEFINE l_oga   RECORD LIKE oga_file.*
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
    IF cl_null(p_qty2) THEN LET p_qty2=0 END IF

    #LET l_sql="SELECT * FROM ",g_dbs,"img_file",
    LET l_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
              " WHERE img01= '",l_ogb.ogb04,"' AND img02= '",p_ware,"'",  #No.FUN-630061
              "  AND img03= '",p_loca,"' AND img04= '",p_lot,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102            
    PREPARE sel_img_pre FROM l_sql
    EXECUTE sel_img_pre INTO p_img.* 
    IF STATUS <> 0 THEN            ## 新增一筆img_file
       INITIALIZE p_img.* TO NULL
       LET p_img.img01=l_ogb.ogb04   #No.FUN-630061
       LET p_img.img02=p_ware
       LET p_img.img03=p_loca
       LET p_img.img04=p_lot
       LET p_img.img05=l_ogb.ogb01  #No.FUN-630061
       LET p_img.img06=l_ogb.ogb03  #No.FUN-630061

       #LET l_sql="SELECT ima25 FROM ",g_dbs,"ima_file WHERE ima01='",p_img.img01 ,"'"
       LET l_sql="SELECT ima25 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                 " WHERE ima01='",p_img.img01 ,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE sel_ima25_pre FROM l_sql
       EXECUTE sel_ima25_pre INTO p_img.img09 
       LET p_img.img10=0
       LET p_img.img13=null   #No:7304
       LET p_img.img17=g_today
       LET p_img.img18=MDY(12,31,9999)
       LET p_img.img21=1
       LET p_img.img22='S'
       LET p_img.img37=l_oga.oga02   #MOD-9B0077
       LET l_sql="SELECT imd10,imd11,imd12,imd13",
                 #"  FROM ",g_dbs,"imd_file WHERE imd01='",p_img.img02,"'"
                 "  FROM ",cl_get_target_table(g_plant_new,'imd_file'), #FUN-A50102
                 " WHERE imd01='",p_img.img02,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
       PREPARE sel_imd10_pre FROM l_sql
       EXECUTE sel_imd10_pre INTO p_img.img22, p_img.img23, p_img.img24, p_img.img25
       LET p_img.img30=0
       LET p_img.img31=0
       LET p_img.img32=0
       LET p_img.img33=0
       LET p_img.img34=1
       IF p_img.img02 IS NULL THEN LET p_img.img02 = ' ' END IF
       IF p_img.img03 IS NULL THEN LET p_img.img03 = ' ' END IF
       IF p_img.img04 IS NULL THEN LET p_img.img04 = ' ' END IF
 
       LET p_img.imgplant = g_plant 
       LET p_img.imglegal = g_legal 
 
      DELETE FROM img_temp 
      INSERT INTO img_temp VALUES (p_img.*)
      #LET l_sql=" INSERT INTO ",g_dbs,"img_file SELECT * FROM img_temp"
      LET l_sql=" INSERT INTO ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                " SELECT * FROM img_temp"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE ins_img_pre FROM l_sql
      EXECUTE ins_img_pre
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("ins","img_file","","",SQLCA.sqlcode,"","ins img:",1)  #No.FUN-670008
          LET g_success='N' RETURN
       END IF
    END IF
    CALL s_umfchkm(l_ogb.ogb04,p_uom,p_img.img09,g_plant_new) RETURNING l_cnt,l_factor  #No.FUN-630061
    IF l_cnt = 1 THEN
       CALL cl_err('','mfg3075',0)
       LET g_success='N' RETURN
    END IF
    LET l_qty2=p_qty*l_factor
 
    LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ",
                       #" FROM ",g_dbs,"img_file ",
                       " FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                       "  WHERE img01= ?  AND img02= ? AND img03= ? ",
                       " AND img04= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock1 CURSOR FROM g_forupd_sql
 
    OPEN img_lock1 USING l_ogb.ogb04,p_ware,p_loca,p_lot  #No.FUN-630061
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock1      #No.MOD-8A0208 add
       LET g_success = 'N'  #No.MOD-8A0208 add
       RETURN
    END IF
 
    FETCH img_lock1 INTO l_img.*
    IF STATUS THEN
       CLOSE img_lock1    #TQC-930155 add
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
 
    CALL s_upimg(l_ogb.ogb04,p_ware,p_loca,p_lot,1,l_qty2,g_today, #FUN-8C0084
          '','','','',l_ogb.ogb01,l_ogb.ogb03,'','','','','','','','','','','','')  #No.FUN-850100
    IF g_success='N' THEN
       CALL cl_err('s_upimg()',SQLCA.SQLCODE,1) RETURN
    END IF

    #Update ima_file
    #LET g_forupd_sql = "SELECT ima25,ima86 FROM ",g_dbs,"ima_file ",
    LET g_forupd_sql = "SELECT ima25,ima86 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                       " WHERE ima01= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE ima_lock1 CURSOR FROM g_forupd_sql
 
    OPEN ima_lock1 USING l_ogb.ogb04  #No.FUN-630061
    IF STATUS THEN
       CALL cl_err("OPEN ima_lock:", STATUS, 1)
       CLOSE ima_lock1
       LET g_success='N'
       RETURN
    END IF
 
    FETCH ima_lock1 INTO l_ima25,l_ima86 #FUN-730018
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1)
       CLOSE ima_lock1
       LET g_success='N'
       RETURN
    END IF
 
   #料件編號 是否可用倉儲 是否為MRP可用倉儲 發料量
    Call s_udima(l_ogb.ogb04,l_img.img23,l_img.img24,l_qty2*l_img.img21,  #No.FUN-630061
                 #g_today,1)  RETURNING l_cnt   #MOD-920298
                 l_oga.oga02,1)  RETURNING l_cnt   #MOD-920298
 
   #最近一次發料日期 表發料
    IF l_cnt THEN
       CALL cl_err('Update Faile',SQLCA.SQLCODE,1)
       LET g_success='N' RETURN
    END IF
 
    IF g_success='Y' THEN
       CALL t600sub_contlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty2,p_uom,l_factor,l_oga.*,l_ogb.*,l_ima86)  #No.FUN-630061
    END IF
 
END FUNCTION
 
FUNCTION t600sub_contlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,l_oga,l_ogb,l_ima86)    #No.FUN-630061
   DEFINE
      p_ware     LIKE ogb_file.ogb09,       ##倉庫
      l_ogb      RECORD LIKE ogb_file.*,    #No.FUN-630061
      p_loca     LIKE ogb_file.ogb091,      ##儲位
      p_lot      LIKE ogb_file.ogb092,      ##批號
      p_qty      LIKE ogc_file.ogc12,       ##銷售數量(銷售單位)
      p_uom      LIKE ima_file.ima31,       ##銷售單位
      p_factor   LIKE ogb_file.ogb15_fac,   ##轉換率
      p_unit     LIKE ima_file.ima25,       ##單位
      p_img10    LIKE img_file.img10,       #異動後數量
      l_sfb02    LIKE sfb_file.sfb02,
      l_sfb03    LIKE sfb_file.sfb03,
      l_sfb04    LIKE sfb_file.sfb04,
      l_sfb22    LIKE sfb_file.sfb22,
      l_sfb27    LIKE sfb_file.sfb27,
      l_sta      LIKE type_file.num5,    #No.FUN-680137 SMALLINT
      l_cnt      LIKE type_file.num5     #No.FUN-680137 SMALLINT
   DEFINE l_argv0 LIKE ogb_file.ogb09
   DEFINE l_ima86 LIKE ima_file.ima86 #FUN-730018
   DEFINE l_oga RECORD LIKE oga_file.*
 
   LET l_argv0=l_oga.oga09  #FUN-730012
   #----來源----
   LET g_tlf.tlf01=l_ogb.ogb04         #異動料件編號  #No.FUN-630061
   LET g_tlf.tlf02=724
   LET g_tlf.tlf020=' '
   LET g_tlf.tlf021=' '                #倉庫
   LET g_tlf.tlf022=' '                #儲位
   LET g_tlf.tlf023=' '                #批號
   LET g_tlf.tlf024=' '                #異動後庫存數量
   LET g_tlf.tlf025=' '                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_ogb.ogb31        #出貨單號  #No.FUN-630061
   LET g_tlf.tlf027=l_ogb.ogb32        #出貨項次   #No.FUN-630061
   #---目的----
   LET g_tlf.tlf03=50                  #'Stock'
   LET g_tlf.tlf030=l_ogb.ogb08  #No.FUN-630061
   LET g_tlf.tlf031=p_ware             #倉庫
   LET g_tlf.tlf032=p_loca             #儲位
   LET g_tlf.tlf033=p_lot              #批號
   LET g_tlf.tlf034=p_img10            #異動後數量
   LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_ogb.ogb01        #訂單單號  #No.FUN-630061
   LET g_tlf.tlf037=l_ogb.ogb03        #訂單項次   #No.FUN-630061
   #-->異動數量
   LET g_tlf.tlf04= ' '             #工作站
   LET g_tlf.tlf05= ' '             #作業序號
   LET g_tlf.tlf06=l_oga.oga02      #發料日期
   LET g_tlf.tlf07=g_today          #異動資料產生日期
   LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user           #產生人
   LET g_tlf.tlf10=p_qty            #異動數量
   LET g_tlf.tlf11=p_uom	    #發料單位
   LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
   LET g_tlf.tlf13='axmt620'
   LET g_tlf.tlf14=l_ogb.ogb1001    #異動原因   #MOD-870120
 
   LET g_tlf.tlf17='To Consign Warehouse'
   IF l_argv0 = '2' AND l_oga.oga65 = 'Y' THEN #FUN-730012
      LET g_tlf.tlf17='To On-Check Warehouse'
   END IF
   CALL s_imaQOH(l_ogb.ogb04)  #No.FUN-630061
        RETURNING g_tlf.tlf18
   LET g_tlf.tlf19=l_oga.oga03 #No.MOD-870252
   LET g_tlf.tlf20 = l_oga.oga46
   LET g_tlf.tlf61= l_ima86 #FUN-730018
   LET g_tlf.tlf62=l_ogb.ogb31    #參考單號(訂單)     #No.FUN-630061
   LET g_tlf.tlf63=l_ogb.ogb32    #訂單項次  #No.FUN-630061
   LET g_tlf.tlf64=l_ogb.ogb908   #手冊編號 no.A050  #No.FUN-630061
   LET g_tlf.tlf930=l_ogb.ogb930 #FUN-670063
   LET g_tlf.tlf20 = l_ogb.ogb41
   LET g_tlf.tlf41 = l_ogb.ogb42
   LET g_tlf.tlf42 = l_ogb.ogb43
   LET g_tlf.tlf43 = l_ogb.ogb1001
   IF g_prog = 'axmt628' THEN 
      LET g_prog = 'axmt629'
     #CALL s_tlf(1,0)
      LET g_prog = 'axmt628'
   ELSE
     #CALL s_tlf(1,0)
   END IF
END FUNCTION
 
#變更狀況碼
FUNCTION t600sub_chstatus(l_new,l_oga)
DEFINE l_new  LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE l_oga  RECORD LIKE oga_file.*
    LET l_oga.ogaconf=l_new
    #ASE l_new
    # WHEN 'N'  #取消確認
    #   UPDATE oga_file SET oga55='0' WHERE oga01=l_oga.oga01
    #   IF SQLCA.sqlcode THEN
    #      LET g_success='N'
    #      RETURN l_oga.*
    #   END IF
    #   LET l_oga.oga55='0'
    # WHEN 'Y'  #確認
    #LET l_sql="UPDATE ",g_dbs,"oga_file SET oga55='1' WHERE oga01='",l_oga.oga01,"'"
    LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
              "   SET oga55='1' WHERE oga01='",l_oga.oga01,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE upd_oga55_pe FROM l_sql
    EXECUTE upd_oga55_pe
          IF SQLCA.sqlcode THEN
             LET g_success='N'
             RETURN l_oga.*
          END IF
          LET l_oga.oga55='1'
    # WHEN 'X'  #作廢
    #   UPDATE oga_file SET oga55='9' WHERE oga01=l_oga.oga01
    #   IF SQLCA.sqlcode THEN
    #      LET g_success='N'
    #      RETURN l_oga.*
    #   END IF
    #   LET l_oga.oga55='9'
    #ND CASE
    RETURN l_oga.*
END FUNCTION
 
FUNCTION t600sub_refresh(p_oga01)
  DEFINE p_oga01 LIKE oga_file.oga01
  DEFINE l_oga RECORD LIKE oga_file.*
 
 #SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01  #FUN-A60044 MARK
  LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oga_file'),  #ADD
              " WHERE oga01='",p_oga01,"' "
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql

  PREPARE sel_oga_prex FROM l_sql
  EXECUTE sel_oga_prex INTO l_oga.*
  IF SQLCA.sqlcode THEN
     LET g_success='N'
     RETURN l_oga.*
  END IF

  RETURN l_oga.*
END FUNCTION
 
FUNCTION t600sub_chk_ogb15_fac(l_oga,l_ogb)
DEFINE l_ogb15_fac   LIKE ogb_file.ogb15_fac
DEFINE l_ogb15       LIKE ogb_file.ogb15
DEFINE l_ogb         RECORD LIKE ogb_file.*
DEFINE l_oga         RECORD LIKE oga_file.*
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_n           LIKE type_file.num5  #add by cock 0427
  
  #TQC-B40174  聯營及非企業料號不異動 img 及 tlf  ...begin
  IF s_joint_venture(l_ogb.ogb04,g_plant_new) OR NOT s_internal_item(l_ogb.ogb04,g_plant_new) THEN   #FUN-B40084 mod g_plant---g_plant_new
     RETURN
  END IF
  #TQC-B40174  聯營及非企業料號不異動 img 及 tlf  ...end
########################################add by cock 0427#########################
#本段判斷若無庫存資料，則自動新建一筆
  LET l_n = 0
  #LET l_sql="SELECT COUNT(*) FROM ",g_dbs,"img_file ", 
  LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
            " WHERE img01 = '",l_ogb.ogb04 ,"' AND img02 = '",l_ogb.ogb09,"'",
            "   AND img03 = '",l_ogb.ogb091,"' AND img04 = '",l_ogb.ogb092,"'"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
  PREPARE sel_ln_pre FROM l_sql
  EXECUTE sel_ln_pre INTO l_n 
  IF l_n IS NULL THEN LET l_n = 0 END IF    
  IF l_n = 0 THEN
    #TQC-C30337 add START
    #若是背景處理時, 固定將 g_sma.sma892 變數的第二碼設為 'N'
     IF g_bgjob='Y' THEN
        LET g_sma.sma892[2,2] = 'N'
     END IF
    #TQC-C30337 add END
     CALL s_madd_img(l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb01,
                     l_ogb.ogb03,g_today,l_ogb.ogbplant)       
  END IF                    
########################################add by cock 0427#########################
  #LET l_sql="SELECT img09 FROM ",g_dbs,"img_file ", 
  LET l_sql="SELECT img09 FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
            " WHERE img01 = '",l_ogb.ogb04 ,"' AND img02 = '",l_ogb.ogb09,"'",
            "   AND img03 = '",l_ogb.ogb091,"' AND img04 = '",l_ogb.ogb092,"'"
  CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
  CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102          
  PREPARE sel_img09_pre FROM l_sql
  EXECUTE sel_img09_pre INTO l_ogb15 
  CALL s_umfchkm(l_ogb.ogb04,l_ogb.ogb05,l_ogb15,g_plant_new)
            RETURNING l_cnt,l_ogb15_fac
  IF l_cnt = 1 THEN
     CALL cl_err('','mfg3075',1)
     LET g_success='N'
     RETURN
  END IF
  IF l_ogb15 != l_ogb.ogb15 OR
     l_ogb15_fac != l_ogb.ogb15_fac THEN
     LET l_ogb.ogb15_fac = l_ogb15_fac
     LET l_ogb.ogb15 = l_ogb15
     LET l_ogb.ogb16 = l_ogb.ogb12 * l_ogb15_fac
     LET l_ogb.ogb16 = s_digqty(l_ogb.ogb16,l_ogb.ogb15)   #FUN-BB0084
 
     #LET l_sql="UPDATE ",g_dbs,"ogb_file ",
     LET l_sql="UPDATE ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
               "   SET ogb15_fac='",l_ogb.ogb15_fac,"',",
                    "    ogb16 ='",l_ogb.ogb16,"',",
                    "    ogb15 ='",l_ogb.ogb15,"'",
               " WHERE ogb01='",l_oga.oga01,"'",   #MOD-7B0208
               "   AND ogb03='",l_ogb.ogb03,"'"    #MOD-7B0208
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","ogb15_fac",g_fno,l_ogb.ogb03,SQLCA.sqlcode,"","",1)
        LET g_success='N'
        RETURN
     END IF
  END IF
  RETURN
END FUNCTION
 
FUNCTION t600sub_ind_icd_post(p_oga01,p_cmd)
   DEFINE p_oga01     LIKE oga_file.oga01
   DEFINE p_cmd       LIKE type_file.chr1
   #DEFINE l_imaicd04  LIKE imaicd_file.imaicd04   #FUN-BA0051 mark
   #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
   DEFINE l_oga       RECORD LIKE oga_file.*
   DEFINE l_ogb       RECORD LIKE ogb_file.*
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_err       STRING
   DEFINE l_argv0     LIKE ogb_file.ogb09
   DEFINE l_ogbi      RECORD LIKE ogbi_file.* #TQC-B80005
 
    SELECT * INTO l_oga.* FROM oga_file WHERE oga01=p_oga01
    IF cl_null(l_oga.oga01) THEN
       CALL cl_err('',-400,0)
       RETURN ""
    END IF
   LET l_argv0=l_oga.oga09
   DECLARE t600_icdpost_cs CURSOR FOR
     SELECT * FROM ogb_file WHERE ogb01 = l_oga.oga01
 
   FOREACH t600_icdpost_cs INTO l_ogb.*
     IF STATUS THEN
        CALL cl_err('t600_icdpost_cs:',STATUS,0)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     #TQC-B80005 --START--
     SELECT * INTO l_ogbi.* FROM ogbi_file
      WHERE ogbi01 = l_ogb.ogb01 AND ogbi03 = l_ogb.ogb03  
     #TQC-B80005 --END--

     #FUN-BA0051 --START mark--
     #LET l_imaicd04 = NULL  LET l_imaicd08 = NULL
     #SELECT imaicd04,imaicd08
     #  INTO l_imaicd04,l_imaicd08
     #  FROM imaicd_file
     # WHERE imaicd00 = l_ogb.ogb04
     #FUN-BA0051 --END mark-- 
     IF p_cmd = '1' THEN  # 過帳
        IF l_argv0 = '1' THEN
           CALL s_icdpost(2,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                           l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                           l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y','',''
                           ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                RETURNING l_flag
           IF l_flag = 0 THEN
              LET g_success = 'N'
	            LET l_err = l_oga.oga01 ,"-", l_ogb.ogb03
	            CALL cl_err(l_err,'DSC017',0) #新增錯誤項次訊息
              RETURN
           END IF
        ELSE
           CALL s_icdpost(-1,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,
                           l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,
                           l_oga.oga01,l_ogb.ogb03,l_oga.oga02,'Y','',''
                           ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                RETURNING l_flag
        END IF
        IF l_flag = 0 THEN
           LET g_success = 'N'
	    LET l_err = l_oga.oga01 ,"-", l_ogb.ogb03
	      CALL cl_err(l_err,'DSC017',0)# 新增錯誤項次訊息
           RETURN
        END IF
     ELSE                 # 過帳還原
        IF l_argv0 = '1' THEN
           CALL s_icdpost(2,l_ogb.ogb04,l_ogb.ogb09,
                           l_ogb.ogb091,l_ogb.ogb092,
                           l_ogb.ogb05,l_ogb.ogb12,
                           l_oga.oga01,l_ogb.ogb03,
                           l_oga.oga02,'N','',''
                           ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                RETURNING l_flag
        ELSE
           CALL s_icdpost(-1,l_ogb.ogb04,l_ogb.ogb09,
                           l_ogb.ogb091,l_ogb.ogb092,
                           l_ogb.ogb05,l_ogb.ogb12,
                           l_oga.oga01,l_ogb.ogb03,
                           l_oga.oga02,'N','',''
                           ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                RETURNING l_flag
        END IF
        IF l_flag = 0 THEN
           LET g_success = 'N'
           EXIT FOREACH
        END IF
     END IF
   END FOREACH
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18
#No.FUN-A30116 
