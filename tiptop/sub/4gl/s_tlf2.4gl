# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Program name...: s_tlf2.4gl
# Descriptions...: 將異動資料放入異動記錄檔中(製造管理)
# Date & Author..: 92/05/25 By Pin
# Usage..........: CALL s_tlf2(p_cost,p_reason,p_plant)
# Input Parameter: p_cost    1. Current
#                  p_reason  是否需取得該異動之異動原因
#                            1.需要 0.不需要
#                  p_plant   機構別
# Return Code....: None
# Modify.........: 93/10/12 By David
# Modify.........: 95/08/03 By Danny
#                 此程式與s_tlf.4gl差異在多了資料庫編號
# Modify.........: #No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-560043 05/06/13 By ching add單別放大
# Modify ........: No.FUN-560060 05/06/15 By wujie 單據編號加大返工
# Modify.........: NO.FUN-670091 06/07/25 BY yiting cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690071 06/09/28 By joe 修正因tlf_file欄位增加,造成過帳無法過的問題
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-8A0055 08/10/07 By claire tlf_file寫入個數不符
# Modify.........: No.TQC-930155 09/04/14 By Sunyanchun 表中列的數量和VALUES中的？不一致
# Modify.........: No.FUN-870007 09/08/18 By Zhangyajun GP5.2新加字段/傳值修改p_dbs->p_plant 
# Modify.........: No.FUN-980014 09/09/14 By rainy s_gettrandbs() 存db變數改 g_dbs_tra
# Modify.........: No.FUN-TQC-9A0109 09/10/23 By sunyanchun  post to area 32
# Modify.........: No:MOD-990256 09/11/10 By Pengu 未更新目的端的img37
# Modify.........: No:FUN-9B0149 09/11/30 By kim add tlf27
# Modify.........: No:TQC-9C0059 09/12/09 By sherry 重新過單
# Modify.........: No:TQC-A40013 10/04/01 By houlia add tlf28
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60044 10/07/21 By Cockroach add tlf012,tlf013
# Modify.........: No.FUN-A70125 10/07/26 By lilingyu 平行工藝整批處理
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-B10016 11/01/14 By Lilan 記錄錯誤訊息回傳Web Service用
# Modify.........: No:CHI-B20023 11/02/21 By sabrina 修改smz02的sql語法
# Modify.........: No:MOD-B30695 11/07/17 By Summer smz02語法要顛倒
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No.TQC-D10075 13/01/21 By xianghui add tlf920
# Modify.........: No:FUN-BC0062 12/02/20 By lixh1 過帳同時計算異動加權成本

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
DEFINE   g_chr           LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
#FUNCTION s_tlf2(p_cost,p_reason,p_dbs)  #No.FUN-870007-mark
FUNCTION s_tlf2(p_cost,p_reason,p_plant) #No.FUN-870007
    DEFINE
        p_factor        LIKE pml_file.pml09, 	#No.FUN-680147 DECIMAL(16,8)
        p_cost          LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        p_dbs           LIKE azp_file.azp03,
        p_tdbs          LIKE type_file.chr21,   #FUN-980014 add
        p_reason        LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_cnt           LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_reason        LIKE apo_file.apo02, 	#No.FUN-680147 VARCHAR(04)
#       l_sql           LIKE type_file.chr1000, #No.FUN-680147 VARCHAR(1000) #No.TQC-930155-mark
        l_sql STRING,    #No.TQC-930155
        s_f             LIKE type_file.num5   	#No.FUN-680147 SMALLINT
DEFINE p_plant LIKE type_file.chr20  #No.FUN-870007
 
    WHENEVER ERROR CALL cl_err_msg_log      #NO.TQC-9A0109
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( g_tlf.tlf01,p_plant) OR NOT s_internal_item(g_tlf.tlf01,p_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
    IF g_tlf.tlf021 IS NULL THEN LET g_tlf.tlf021=' ' END IF
    IF g_tlf.tlf022 IS NULL THEN LET g_tlf.tlf022=' ' END IF
    IF g_tlf.tlf023 IS NULL THEN LET g_tlf.tlf023=' ' END IF
    IF g_tlf.tlf031 IS NULL THEN LET g_tlf.tlf031=' ' END IF
    IF g_tlf.tlf032 IS NULL THEN LET g_tlf.tlf032=' ' END IF
    IF g_tlf.tlf033 IS NULL THEN LET g_tlf.tlf033=' ' END IF
    IF g_tlf.tlf027 IS NULL THEN LET g_tlf.tlf027 = 0 END IF
    IF g_tlf.tlf037 IS NULL THEN LET g_tlf.tlf037 = 0 END IF
    IF cl_null(g_tlf.tlf012) THEN LET g_tlf.tlf012 = ' ' END IF  #FUN-A60044 ADD
    IF cl_null(g_tlf.tlf013) THEN LET g_tlf.tlf013 = 0 END IF    #FUN-A60044 ADD
 
    LET g_tlf.tlf07 = TODAY
    LET g_tlf.tlf08 = TIME  
    IF g_tlf.tlf13 = 'aimp880' THEN LET g_tlf.tlf08='99:99:99' END IF
    IF cl_null(g_tlf.tlf12) THEN LET g_tlf.tlf12=1 END IF 
    IF cl_null(g_tlf.tlf026) THEN LET g_tlf.tlf026 = g_tlf.tlf036 END IF 
    IF cl_null(g_tlf.tlf036) THEN LET g_tlf.tlf036 = g_tlf.tlf026 END IF 
    IF g_tlf.tlf05 IS NULL THEN LET g_tlf.tlf05   =' ' END IF
 
    #------ 97/06/23
    LET g_tlf.tlf905=' '
    LET g_tlf.tlf906=0    
    LET g_tlf.tlf907=0
    LET g_tlf.tlf66 =''
    LET g_tlf.tlf211=''
    IF g_tlf.tlf02=50 AND g_tlf.tlf03=50 THEN
       PROMPT "來源與目的不可均為50:" FOR CHAR g_chr
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
#             CONTINUE PROMPT
       
       END PROMPT
       LET g_success='N' RETURN
    END IF
    IF g_tlf.tlf02=50 THEN                ##--- 出庫
       LET g_tlf.tlf902=g_tlf.tlf021
       LET g_tlf.tlf903=g_tlf.tlf022
       LET g_tlf.tlf904=g_tlf.tlf023
       LET g_tlf.tlf905=g_tlf.tlf026
       LET g_tlf.tlf906=g_tlf.tlf027
       LET g_tlf.tlf907=-1             
    END IF
    IF g_tlf.tlf03=50 THEN                ##--- 入庫
       LET g_tlf.tlf902=g_tlf.tlf031
       LET g_tlf.tlf903=g_tlf.tlf032
       LET g_tlf.tlf904=g_tlf.tlf033
       LET g_tlf.tlf905=g_tlf.tlf036
       LET g_tlf.tlf906=g_tlf.tlf037
       LET g_tlf.tlf907=1             
    END IF
#No.FUN-560060--begin
#   LET g_tlf.tlf61=g_tlf.tlf905[1,3]		#971028 Roger
    LET g_tlf.tlf61=g_tlf.tlf905[1,g_doc_len]		#971028 Roger
#No.FUN-560060--end  
 
#No.FUN-870007-start-
    LET g_plant_new = p_plant CLIPPED
   #FUN-980014 --begin
    #CALL s_gettrandbs()
    #LET p_dbs = g_dbs_new
    CALL s_getdbs()
    LET p_dbs = g_dbs_new
    CALL s_gettrandbs()
    LET p_tdbs = g_dbs_tra
   #FUN-980014 --end
    LET g_tlf.tlfplant = g_plant_new
    SELECT azw02 INTO g_tlf.tlflegal FROM azw_file WHERE azw01=g_plant_new
#No.FUN-870007--end--
 
    #--------------------------------------------------------------------------
    #LET l_sql = "SELECT imd09 FROM ",p_dbs CLIPPED,"imd_file ",
    LET l_sql = "SELECT imd09 FROM ",cl_get_target_table(g_plant_new,'imd_file'), #FUN-A50102
                " WHERE imd01='",g_tlf.tlf902 CLIPPED,"'"
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE imd_cur FROM l_sql
    DECLARE imd_curs CURSOR FOR imd_cur
    OPEN imd_curs
    FETCH imd_curs INTO g_tlf.tlf901
    IF STATUS
       THEN
       #CALL cl_err('sel imd_file','mfg9040',1)  #FUN-670091
        CALL cl_err3("sel","imd_file",g_tlf.tlf902,"",STATUS,"","",0) #FUN-670091
       LET g_success='N' RETURN
    END IF
    #--------------------------------------------------------------------------
    LET l_sql =
    #"SELECT img21 FROM ",p_dbs CLIPPED,"img_file",  #FUN-980014
    #"SELECT img21 FROM ",p_tdbs CLIPPED,"img_file",  #FUN-980014
    "SELECT img21 FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
    "    WHERE img01='",g_tlf.tlf01,"'",
    "      AND img02='",g_tlf.tlf902,"'",
    "      AND img03='",g_tlf.tlf903,"'",
    "      AND img04='",g_tlf.tlf904,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #No.FUN-870007
    PREPARE img21_cur FROM l_sql
    DECLARE img21_curs CURSOR FOR img21_cur
    OPEN img21_curs
    FETCH img21_curs INTO g_tlf.tlf60
    IF STATUS OR g_tlf.tlf60 IS NULL THEN LET g_tlf.tlf60=1 END IF
    #--------------------------------------------------------------------------
    IF g_tlf.tlf02=50 OR g_tlf.tlf03=50 THEN
#       IF NOT s_chksmz1(g_tlf.tlf01,g_tlf.tlf905[1,g_doc_len],g_tlf.tlf902,g_tlf.tlf903,p_dbs) #FUN-560043 #No.FUN-870007-mark
       IF NOT s_chksmz1(g_tlf.tlf01,g_tlf.tlf905[1,g_doc_len],g_tlf.tlf902,g_tlf.tlf903,g_plant_new)  #No.FUN-870007
          THEN LET g_success='N' RETURN
       END IF
    END IF
    #--------------------------------------------------------------------------

#FUN-A70125 --begin--
      IF cl_null(g_tlf.tlf012) THEN
         LET g_tlf.tlf012 = ' '
      END IF
      IF cl_null(g_tlf.tlf013) THEN
        LET g_tlf.tlf013 = 0
      END IF
#FUN-A70125 --end--

#No.TQC-930155-start-
#   LET l_sql = "INSERT INTO ",p_dbs CLIPPED,"tlf_file",
    #LET l_sql="INSERT INTO ",p_dbs CLIPPED,"tlf_file (",  #FUN-980014
    #LET l_sql="INSERT INTO ",p_tdbs CLIPPED,"tlf_file (",  #FUN-980014
    LET l_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'tlf_file')," (", #FUN-A50102
              "tlf01,   tlf02,   tlf020,  tlf021,  tlf022,  tlf023,  tlf024,  tlf025,  tlf026,  tlf027,",
              "tlf03,   tlf030,  tlf031,  tlf032,  tlf033,  tlf034,  tlf035,  tlf036,  tlf037,  tlf04,",
              "tlf05,   tlf06,   tlf07,   tlf08,   tlf09,   tlf10,   tlf11,   tlf12,   tlf13,   tlf14,",
              "tlf15,   tlf16,   tlf17,   tlf18,   tlf19,   tlf20,   tlf21,   tlf211,  tlf212,  tlf2131,",
              "tlf2132, tlf214,  tlf215,  tlf2151, tlf216,  tlf2171, tlf2172, tlf219,  tlf218,  tlf220,",
              "tlf221,  tlf222,  tlf2231, tlf2232, tlf224,  tlf225,  tlf2251, tlf226,  tlf2271, tlf2272,",
              "tlf229,  tlf230,  tlf231,  tlf60,   tlf61,   tlf62,   tlf63,   tlf64,   tlf65,   tlf66,",
              "tlf901,  tlf902,  tlf903,  tlf904,  tlf905,  tlf906,  tlf907,  tlf908,  tlf909,  tlf910,",
              "tlf99,   tlf930,  tlf931,  tlf151,  tlf161,  tlf2241, tlf2242, tlf2243, tlfcost, tlf41,",
              "tlf42,   tlf43,   tlf211x, tlf212x, tlf21x,  tlf221x, tlf222x, tlf2231x,tlf2232x,tlf2241x,",
              "tlf2242x,tlf2243x,tlf224x, tlf65x,  tlfplant,tlflegal,tlf27,tlf28,tlf012,tlf013,tlf920)",  #No.FUN-870007-add tlfplant,tlflegal #FUN-9B0149#TQC-A40013--add tlf28
                                                                                 #FUN-A60044 ADD tlf012,tlf013 #TQC-D10075 add tlf920
#No.TQC-930155--end--
   {ckp#1}      " VALUES(?,?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",
                        "?,?,?,?,?,?,?,?,?,?,",     #FUN-690071 #MOD-8A0055 add 6個?
                        #"?)"                       #MOD-8A0055 #TQC-930155--mark----
                        "?,?,?,?,?,?,?,?,?,?,",     #TQC-930155--add-------
                       #"?,?,?,?,?,?,?)"                #TQC-930155--add-------  #No.FUN-870007-add ? #FUN-9B0149 #TQC-A40013--add?
                        "?,?,?,?,?,?,?,?,?,?)"                #TQC-930155--add-------  #No.FUN-870007-add ? #FUN-9B0149 #TQC-A40013--add? #TQC-D10075 add ?
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE tlf_ins FROM l_sql
#   DECLARE tlf_ins1 CURSOR FOR tlf_ins
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = "N"
       RETURN
    END IF
    EXECUTE tlf_ins USING g_tlf.*
    IF SQLCA.sqlcode THEN
       LET g_success='N'
       #CALL cl_err('(s_tlf2:ckp#1)',SQLCA.sqlcode,1)  #FUN-670091
        CALL cl_err3("ins","tlf_file","","",STATUS,"","",1)  #FUN-670091
       RETURN
    END IF
    #--------------------------------------------------------------------------
#FUN-BC0062 -------------Begin------------
    #計算異動加權平均成本
    IF NOT s_tlf_mvcost(g_plant_new) THEN
       RETURN
    END IF
#FUN-BC0062 -------------End--------------
END FUNCTION
 
#依'料號'及'單別'檢查倉庫儲位正確否
#FUNCTION s_chksmz1(p_part, p_slip, p_ware, p_loc,p_dbs)   #No.FUN-870007-mark
FUNCTION s_chksmz1(p_part, p_slip, p_ware, p_loc,p_plant)  #NO.FUN-870007
   DEFINE p_part	LIKE imf_file.imf01	# 料號 #No.MOD-490217
   DEFINE p_slip	LIKE smy_file.smyslip   # 單別  #FUN-560043 	#No.FUN-680147 VARCHAR(5)
   DEFINE p_ware	LIKE smz_file.smz02     # 倉庫  #No.FUN-680147 VARCHAR(10)
   DEFINE p_loc		LIKE smz_file.smz03     # 儲位  #No.FUN-680147 VARCHAR(10) 
   DEFINE p_dbs		LIKE type_file.chr21 	#  	#No.FUN-680147 VARCHAR(20)
   DEFINE p_tdbs		LIKE type_file.chr21 	#No.FUN-980014
   DEFINE l_smyware	LIKE smy_file.smyware   #No.FUN-680147 VARCHAR(1)
   DEFINE l_n		LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE x1,y1		LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE x2,y2		LIKE aba_file.aba18 	#No.FUN-680147 VARCHAR(2)
   DEFINE l_oay12         LIKE oay_file.oay12,  #No.FUN-680147 VARCHAR(01)
          l_smy56         LIKE smy_file.smy56,  #No.FUN-680147 VARCHAR(01)
          l_sql           LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(300)
          g_img37         LIKE img_file.img37,
          g_ima902        LIKE ima_file.ima902,
          l_sma RECORD    LIKE sma_file.*
   DEFINE p_plant LIKE type_file.chr20  #No.FUN-870007
  
  #FUN-980014 modify --begin
   #SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_plant  #No.FUN-870007 
   LET g_plant_new = p_plant
   CALL s_getdbs()
   LET p_dbs = g_dbs_new
   CALL s_gettrandbs()
   LET p_tdbs = g_dbs_tra
  #FUN-980014 modify --end
   LET l_oay12=' '
   LET l_smy56=' '
   IF p_loc IS NULL THEN LET p_loc=' ' END IF
   #--------------------------------------------------------------------------
   #LET l_sql = "SELECT * FROM ",p_dbs CLIPPED,"sma_file ",
   LET l_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'sma_file'), #FUN-A50102
               " WHERE sma00='0'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE sma_cur FROM l_sql
   DECLARE sma_curs CURSOR FOR sma_cur
   OPEN sma_curs
   FETCH sma_curs INTO l_sma.*
   IF STATUS THEN
     #CALL cl_err('sel sma_file',STATUS,1)  #FUN-670091
      CALL cl_err3("sel","sma_file","","",STATUS,"","",1)  #FUN-670091
      LET g_errno = STATUS                                 #FUN-B10016 add
      LET g_success='N' 
      RETURN
   END IF
   #--------------------------------------------------- check imf_file
   IF p_part IS NOT NULL THEN      # p_part=NULL 時, 不作imf_file的檢查
      #LET l_sql = "SELECT COUNT(*) FROM ",p_dbs CLIPPED,"imf_file",
      LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'imf_file'), #FUN-A50102
                  " WHERE imf01='",p_part CLIPPED,"'",
                  "   AND imf02='",p_ware CLIPPED,"'"
      IF l_sma.sma42='2' THEN
         LET l_sql = l_sql CLIPPED," AND imf03='",p_loc CLIPPED,"'"
      END IF
      IF l_sma.sma42 MATCHES '[12]' THEN
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE imf_cur FROM l_sql
         DECLARE imf_curs CURSOR FOR imf_cur
         OPEN imf_curs
         FETCH imf_curs INTO l_n
         IF l_n=0 THEN
            LET g_errno = 'mfg1102'                   #FUN-B10016 add
            CALL cl_err('sel imf','mfg1102',1) RETURN 0
         END IF
      END IF
   END IF
   #--------------------------------------------------- check smz_file
   #LET l_sql = "SELECT smyware FROM ",p_dbs CLIPPED,"smy_file",
   LET l_sql = "SELECT smyware FROM ",cl_get_target_table(g_plant_new,'smy_file'), #FUN-A50102
               " WHERE smyslip='",p_slip CLIPPED,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE smy_cur FROM l_sql
   DECLARE smy_curs CURSOR FOR smy_cur
   OPEN smy_curs
   FETCH smy_curs INTO l_smyware
   
   IF STATUS THEN
       LET g_errno = STATUS                                  #FUN-B10016 add
      #CALL cl_err('sel smy',STATUS,1) #FUN-670091 
       CALL cl_err3("sel","smy_file","","",STATUS,"","",1)   #FUN-670091
       RETURN 0
   END IF
   LET x1=p_ware LET x2=p_ware
   LET y1=p_loc  LET y2=p_loc 
   CASE WHEN l_smyware='1' OR l_smyware='3'
             LET l_sql = 
             #"SELECT COUNT(*) FROM ",p_dbs CLIPPED,"smz_file",
             "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smz_file'), #FUN-A50102
             " WHERE smz01='",p_slip,"'",
            #"   AND (smz02='",p_ware,"' OR ",                          #CHI-B20023 mark 
            #"       (smz02[1,1]='",x1,"' AND smz02[2,2]='*') OR",      #CHI-B20023 mark   
            #"       (smz02[1,2]='",x2,"' AND smz02[3,3]='*'))"         #CHI-B20023 mark  
            #"   AND smz02 LIKE '",p_ware,"'"                           #CHI-B20023 add  #MOD-B30695 mark 
             "   AND '",p_ware,"' LIKE smz02 "                          #MOD-B30695 add
        WHEN l_smyware='2' OR l_smyware='4'
             LET l_sql = 
             #"SELECT COUNT(*) FROM ",p_dbs CLIPPED,"smz_file",
             "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smz_file'), #FUN-A50102
             " WHERE smz01='",p_slip,"'",
            #CHI-B20023---modify---start---
            #"   AND (smz02='",p_ware,"' OR ",
            #"       (smz02[1,1]='",x1,"' AND smz02[2,2]='*') OR",
            #"       (smz02[1,2]='",x2,"' AND smz02[3,3]='*'))",
            #"   AND (smz03='",p_loc,"' OR",
            #"       (smz03[1,1]='",y1,"' AND smz03[2,2]='*') OR",
            #"       (smz03[1,2]='",y2,"' AND smz03[3,3]='*'))"
            #MOD-B30695---modify---start---
            #"   AND smz02 LIKE '",p_ware,"'",
            #"   AND smz03 LIKE '",p_loc,"'" 
             "   AND '",p_ware,"' LIKE smz02 ",
             "   AND '",p_loc,"' LIKE smz03 "
            #MOD-B30695---modify---end--- 
            #CHI-B20023---modify---end---
   END CASE
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE smz_cur FROM l_sql
   DECLARE smz_curs CURSOR FOR smz_cur
   OPEN smz_curs
   FETCH smz_curs INTO l_n
   CASE
        WHEN l_smyware MATCHES '[12]' AND l_n=0
             LET g_errno = 'mfg1104'                   #FUN-B10016 add
             CALL cl_err('s_chksmz1','mfg1104',1) RETURN 0
        WHEN l_smyware MATCHES '[34]' AND l_n>0
             LET g_errno = 'mfg1105'                   #FUN-B10016 add
             CALL cl_err('s_chksmz1','mfg1105',1) RETURN 0
   END CASE
   #--------------------------------------------------- 97/10/18
   IF g_tlf.tlf02=50 OR g_tlf.tlf03=50 THEN
 
      LET l_sql =
      #"SELECT img37 FROM ",p_dbs CLIPPED,"img_file",   #FUN-980014
      #"SELECT img37 FROM ",p_tdbs CLIPPED,"img_file",   #FUN-980014
      "SELECT img37 FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
      " WHERE img01='",g_tlf.tlf01,"'",
      "   AND img02='",g_tlf.tlf902,"'",
      "   AND img03='",g_tlf.tlf903,"'",
      "   AND img04='",g_tlf.tlf904,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #No.FUN-870007
      PREPARE img37_cur FROM l_sql
      DECLARE img37_curs CURSOR FOR img37_cur
      OPEN img37_curs
      FETCH img37_curs INTO g_img37
      IF STATUS THEN LET g_img37='' END IF
 
      LET l_sql =
      #"SELECT ima902 FROM ",p_dbs CLIPPED,"ima_file ",
      "SELECT ima902 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
      " WHERE ima01='",g_tlf.tlf01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE ima902_cur FROM l_sql
      DECLARE ima902_curs CURSOR FOR ima902_cur
      OPEN ima902_curs
      FETCH ima902_curs INTO g_ima902
      IF STATUS THEN LET g_ima902='' END IF
 
      IF g_tlf.tlf13 MATCHES 'axmt*' THEN
         LET l_sql =
         #"SELECT oay12 FROM ",p_dbs CLIPPED,"oay_file",
         "SELECT oay12 FROM ",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
         " WHERE oayslip='",p_slip,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE oay12_cur FROM l_sql
         DECLARE oay12_curs CURSOR FOR oay12_cur
         OPEN oay12_curs
         FETCH oay12_curs INTO l_oay12
         IF l_oay12='Y' THEN
          # IF g_tlf.tlf06>g_ima902 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_ima902 OR g_ima902 IS NULL THEN
               LET l_sql =
              #"UPDATE ima_file SET ima902=? WHERE ima01=?"            #FUN-C30315 mark
               "UPDATE ima_file SET ima902=?,imadate=? WHERE ima01=?"  #FUN-C30315 add
               PREPARE ima_upd FROM l_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('prepare:',SQLCA.sqlcode,1)
                  LET g_errno = SQLCA.sqlcode                   #FUN-B10016 add
                  LET g_success = "N"
                  RETURN
               END IF
              #EXECUTE ima_upd USING g_tlf.tlf06,g_tlf.tlf01          #FUN-C30315 mark
               EXECUTE ima_upd USING g_tlf.tlf06,g_today,g_tlf.tlf01  #FUN-C30315 add
               IF STATUS THEN 
                  #CALL cl_err('upd ima902',STATUS,1)  #FUN-670091
                   CALL cl_err3("upd","ima_file",g_tlf.tlf06,g_tlf.tlf01,STATUS,"","",1) #FUN-670091
                   LET g_errno = STATUS                          #FUN-B10016 add
                   RETURN 0
               END IF
            END IF
          # IF g_tlf.tlf06>g_img37 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_img37 OR g_img37 IS NULL THEN
               LET l_sql =
               #"UPDATE ",p_dbs CLIPPED ," img_file SET img37=?",   #No:MOD-990256 modify
               "UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
               "  SET img37=?",
               "   WHERE img01=? AND img02=?",
               "     AND img03=? AND img04=?"
	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#No:MOD-990256 add
               CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
               PREPARE img_upd FROM l_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('prepare:',SQLCA.sqlcode,1)
                  LET g_errno = SQLCA.sqlcode                   #FUN-B10016 add
                  LET g_success = "N"
                  RETURN
               END IF
               EXECUTE img_upd USING g_tlf.tlf06,g_tlf.tlf01,g_tlf.tlf902,
                                     g_tlf.tlf903,g_tlf.tlf904
               IF STATUS THEN 
                  #CALL cl_err('upd img37',STATUS,1)  #FUN-670091
                   CALL cl_err3("upd","img_file",g_tlf.tlf06,g_tlf.tlf01,STATUS,"","",1) #FUN-670091 
                   LET g_errno = STATUS                          #FUN-B10016 add
                   RETURN 0
               END IF
            END IF
         END IF
      ELSE
         LET l_sql =
         #"SELECT smy56 FROM ",p_dbs CLIPPED,"smy_file",
         "SELECT smy56 FROM ",cl_get_target_table(g_plant_new,'smy_file'), #FUN-A50102
         " WHERE smyslip='",p_slip,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE smy56_cur FROM l_sql
         DECLARE smy56_curs CURSOR FOR smy56_cur
         OPEN smy56_curs
         FETCH smy56_curs INTO l_smy56
 
         IF l_smy56='Y' THEN
          # IF g_tlf.tlf06>g_ima902 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_ima902 OR g_ima902 IS NULL THEN
               LET l_sql =
              #"UPDATE ima_file SET ima902=? WHERE ima01=?"            #FUN-C30315 mark
               "UPDATE ima_file SET ima902=?,imadate=? WHERE ima01=?"  #FUN-C30315 add
               PREPARE ima902_upd FROM l_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('prepare:',SQLCA.sqlcode,1)
                  LET g_errno = SQLCA.sqlcode                          #FUN-B10016 add
                  LET g_success = "N"
                  RETURN
               END IF
              #EXECUTE ima902_upd USING g_tlf.tlf06,g_tlf.tlf01
               EXECUTE ima902_upd USING g_tlf.tlf06,g_today,g_tlf.tlf01 #FUN-C30315 add
               IF STATUS THEN 
                  #CALL cl_err('upd ima902',STATUS,1) #FUN-670091
                   CALL cl_err3("upd","ima_file",g_tlf.tlf06,g_tlf.tlf01,STATUS,"","",1) #FUN-670091
                   LET g_errno = STATUS                          #FUN-B10016 add
                   RETURN 0
               END IF
            END IF
          # IF g_tlf.tlf06>g_img37 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_img37 OR g_img37 IS NULL THEN
               LET l_sql =
               #"UPDATE ",p_dbs CLIPPED ," img_file SET img37=?",   #No:MOD-990256 modify
               "UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
               "  SET img37=?", 
               "   WHERE img01=? AND img02=?",
               "     AND img03=? AND img04=?"
	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#No:MOD-990256 add
               CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
               PREPARE img37_upd FROM l_sql
               IF SQLCA.sqlcode THEN
                  CALL cl_err('prepare:',SQLCA.sqlcode,1)
                  LET g_errno = SQLCA.sqlcode                           #FUN-B10016 add
                  LET g_success = "N" 
                  RETURN
               END IF
               EXECUTE img37_upd USING g_tlf.tlf06,g_tlf.tlf01,g_tlf.tlf902,
                                     g_tlf.tlf903,g_tlf.tlf904
               IF STATUS THEN 
                  #CALL cl_err('upd img37',STATUS,1) #FUN-670091
                   CALL cl_err3("upd","img_file",g_tlf.tlf06,g_tlf.tlf01,STATUS,"","",1) #FUN-670091
                   LET g_errno = STATUS                          #FUN-B10016 add 
                   RETURN 0
               END IF
            END IF
         END IF
      END IF
   END IF
   #---------------------------------------------------
   RETURN 1	# TRUE -> OK
END FUNCTION
#TQC-9C0059
