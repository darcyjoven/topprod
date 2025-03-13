# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Program name...: s_tlf1.4gl
# Descriptions...: 將異動資料放入異動記錄檔中(製造管理)
# Date & Author..: 06/05/03 by kim (由s_tlf.4gl改寫成可傳入工廠) #FUN-620017
# Usage..........: CALL s_tlf1(p_cost,p_reason,p_plant)
# Input Parameter: p_cost    是否需要取得該料件之標準成本 1.需要 0.不需要
#                  p_reason  是否需取得該異動之異動原因 1.需要 0.不需要
#                  p_plant   機構別
# Return Code....: None
# Memo...........: 因多工廠之故而加傳 p_dbs 這個參數
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0083 06/12/03 By Nicola 錯誤訊息彙整
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-930155 09/04/14 By Sunyanchun 表中列的數量和VALUES中的？不一致
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun 傳值修改p_dbs->p_plant
# Modify.........: No.FUN-980014 09/09/14 By rainy s_gettrandbs() 存db變數改 g_dbs_tra
# Modify.........: No.FUN-TQC-9A0109 09/10/23 By sunyanchun  post to area 32
# Modify.........: No:FUN-9B0149 09/11/30 By kim add tlf27
# Modify.........: No:TQC-9C0059 09/12/09 By sherry 重新過單
# Modify.........: No:TQC-A40015 10/04/02 By lilingyu add tlf28
# Modify.........: No:FUN-A60028 10/06/24 By lilingyu 平行工藝
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70125 10/07/26 By lilingyu 平行工藝整批處理
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No:CHI-B20023 11/02/21 By sabrina 修改smz02的sql語法
# Modify.........: No:MOD-B30695 11/07/17 By Summer 還原CHI-B20023
# Modify.........: No:FUN-CB0087 12/11/23 By qiull g_tlf.*改用逐個欄位
# Modify.........: No:FUN-BC0062 12/02/20 By lixh1 過帳同時計算異動加權成本
# Modify.........: No:CHI-D10014 13/04/03 By bart 增加tlfs處理

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_chr           LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose 	#No.FUN-680147 SMALLINT
DEFINE   g_db_type       LIKE type_file.chr3     #FUN-620017 	#No.FUN-680147 VARCHAR(3)
DEFINE   g_sql           STRING   #FUN-620017
DEFINE   gs_dbs          LIKE type_file.chr21  #FUN-620017 	#No.FUN-680147 VARCHAR(21)
DEFINE   gs_tdbs         LIKE type_file.chr21  #FUN-980014
 
#FUNCTION s_tlf1(p_cost,p_reason,p_dbs)   #No.FUN-870007-mark
FUNCTION s_tlf1(p_cost,p_reason,p_plant)  #No.FUN-870007
    DEFINE
        p_factor        LIKE pml_file.pml09, 	#No.FUN-680147 DECIMAL(16,8)
        p_cost          LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        p_reason        LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_cnt           LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_reason        LIKE azf_file.azf01,    #No.FUN-680147 VARCHAR(04)
        s_f             LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        g_ima25         LIKE ima_file.ima25,
        l_flag          LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
        p_dbs           LIKE type_file.chr21  	#No.FUN-680147 VARCHAR(21)
DEFINE p_plant LIKE type_file.chr20  #No.FUN-870007
 
    WHENEVER ERROR CALL cl_err_msg_log   #NO.TQC-9A0109
{
#    IF p_reason=3 THEN                #更改了重要key值欄位
#        LET g_tlf.tlf14='Ckey'
#    END IF
#    IF p_reason=1 THEN                 #需要詢問異動原因
#        LET l_reason=''
#
#        OPEN WINDOW mfglog_w AT 8,3 WITH 3 ROWS, 40 COLUMNS
#        ATTRIBUTE( STYLE = g_win_style )
#
#        CALL cl_getmsg('aoo-015',g_lang) RETURNING g_msg
#        DISPLAY g_msg AT 1,1 ATTRIBUTE(MAGENTA)
#        CALL cl_getmsg('aoo-016',g_lang) RETURNING g_msg
#        WHILE TRUE
#            PROMPT g_msg CLIPPED,': ' FOR l_reason
#                ON KEY(CONTROL-P)
#                    CALL q_azf(10,2,l_reason,'2') RETURNING l_reason
#               ON IDLE g_idle_seconds
#                  CALL cl_on_idle()
##                  CONTINUE PROMPT
#            
#            END PROMPT
#            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#            IF l_reason IS NULL THEN
#                CONTINUE WHILE
#            END IF
#            SELECT azf01 FROM azf_file
#                WHERE azf01=l_reason AND azf02='2' AND
#                azfacti='Y'
#            IF SQLCA.sqlcode THEN
#                CONTINUE WHILE
#            END IF
#            LET g_tlf.tlf14=l_reason
#            EXIT WHILE
#        END WHILE
##       CLOSE WINDOW mfglog_w
#    END IF
#}
#No.FUN-870007-start-
     LET g_plant_new = p_plant CLIPPED
   ##FUN-980014 begin
     #CALL s_gettrandbs()
     #LET gs_dbs = s_dbstring(g_dbs_new)
     CALL s_getdbs()
     LET gs_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET gs_tdbs = g_dbs_tra
   ##FUN-980014 end
     LET g_tlf.tlfplant = g_plant_new
     SELECT azw02 INTO g_tlf.tlflegal FROM azw_file WHERE azw01=g_plant_new
#    #FUN-620017...............begin
#    LET g_sql=p_dbs CLIPPED
#    LET l_cnt=g_sql.getIndexOf(":",1)
#    IF l_cnt>1 THEN  #取得資料庫代碼,去掉最後一碼 ":"
#       LET gs_dbs=g_sql.substring(1,l_cnt-1)
#    END IF
#    LET g_db_type=cl_db_get_database_type()
#    IF g_db_type='IFX' THEN
#       LET gs_dbs=gs_dbs,':'
#    ELSE
#       LET gs_dbs=gs_dbs,'.'
#    END IF
#    LET gs_dbs=p_dbs
#    #FUN-620017...............end
#No.FUN-870007--end--
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( g_tlf.tlf01,p_plant) OR NOT s_internal_item( g_tlf.tlf01,p_plant ) THEN
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
    
#FUN-A60028 --begin--
    IF cl_null(g_tlf.tlf012) THEN LET g_tlf.tlf012 = ' ' END IF 
    IF cl_null(g_tlf.tlf013) THEN LET g_tlf.tlf013 = 0 END IF 
#FUN-A60028 --end--
    
    # 庫存系統由本s_tlf更新借貸會計科目, APM/ASF 則由各prog更新
    #IF g_tlf.tlf13[1,3]='aim'
    #   THEN CALL s_defcour(g_tlf.tlf13,g_tlf.tlf15,g_tlf.tlf16)
    #        RETURNING l_cnt,g_tlf.tlf15,g_tlf.tlf16
    #END IF
    CALL tlfcost() #FUN-620017
    LET g_tlf.tlf07 = TODAY
    LET g_tlf.tlf08 = TIME  
    IF g_tlf.tlf13 = 'aimp880' THEN LET g_tlf.tlf08='99:99:99' END IF
    IF cl_null(g_tlf.tlf12) THEN LET g_tlf.tlf12=1 END IF 
    IF cl_null(g_tlf.tlf026) THEN LET g_tlf.tlf026 = g_tlf.tlf036 END IF 
    IF cl_null(g_tlf.tlf036) THEN LET g_tlf.tlf036 = g_tlf.tlf026 END IF 
    IF g_tlf.tlf05 IS NULL THEN LET g_tlf.tlf05 =' ' END IF
 
    #------ 97/06/23
    LET g_tlf.tlf905='' #No:5416
    LET g_tlf.tlf906=0    
    LET g_tlf.tlf907=0
    #LET g_tlf.tlf66 =''   #MOD-520070
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
    ##--- 收貨不影響庫存,但仍應給 tlf90*的值
    IF g_tlf.tlf13='apmt1101' OR g_tlf.tlf13='asft6001' THEN   
       LET g_tlf.tlf902=g_tlf.tlf031
       LET g_tlf.tlf903=g_tlf.tlf032
       LET g_tlf.tlf904=g_tlf.tlf033
       LET g_tlf.tlf905=g_tlf.tlf036
       LET g_tlf.tlf906=g_tlf.tlf037
       LET g_tlf.tlf907=0             
    END IF
    LET g_tlf.tlf61=g_tlf.tlf905[1,g_doc_len]	#No.FUN-560060	#971028 Roger
    #--------------------------------------------------------------------------
     #MOD-4C0053(ADD IF...END IF)
    IF NOT cl_null(g_tlf.tlf902) THEN
        #FUN-620017...............begin
        #SELECT imd09 INTO g_tlf.tlf901 FROM imd_file WHERE imd01=g_tlf.tlf902
        #                                                AND imdacti = 'Y' #MOD-4B0169
        #LET g_sql="SELECT imd09 FROM ",gs_dbs,   
        #          "imd_file WHERE imd01='",g_tlf.tlf902,"'"
        LET g_sql="SELECT imd09 FROM ",cl_get_target_table(g_plant_new,'imd_file'), #FUN-A50102
                  " WHERE imd01='",g_tlf.tlf902,"'"
 	CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        PREPARE tlf1_c1_pre FROM g_sql
        DECLARE tlf1_c1 CURSOR FOR tlf1_c1_pre
        OPEN tlf1_c1
        FETCH tlf1_c1 INTO g_tlf.tlf901
        #FUN-620017...............end
        #IF STATUS OR g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901='1' END IF #MOD-4B0169
        IF STATUS THEN 
            LET g_success = 'N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('tlf902',g_tlf.tlf902,'',STATUS,1)
            ELSE
               CALL cl_err(g_tlf.tlf902,STATUS,1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN
        END IF
        CLOSE tlf1_c1
         #MOD-4B0169(end)
    END IF
    #--------------------------------------------------------------------------
  # SELECT img21 INTO g_tlf.tlf60 FROM img_file
  #     WHERE img01=g_tlf.tlf01
  #       AND img02=g_tlf.tlf902
  #       AND img03=g_tlf.tlf903
  #       AND img04=g_tlf.tlf904
    #FUN-620017...............begin
    #SELECT ima25 INTO g_ima25 FROM ima_file
    # WHERE ima01=g_tlf.tlf01 AND imaacti='Y'
    #LET g_sql="SELECT ima25 FROM ",gs_dbs,"ima_file",
    LET g_sql="SELECT ima25 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
              " WHERE ima01='",g_tlf.tlf01,"' AND imaacti='Y'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
    PREPARE tlf1_c2_pre FROM g_sql
    DECLARE tlf1_c2 CURSOR FOR tlf1_c2_pre
    OPEN tlf1_c2
    FETCH tlf1_c2 INTO g_ima25
    CLOSE tlf1_c2
    #FUN-620017...............end
    CALL s_umfchk(g_tlf.tlf01,g_tlf.tlf11,g_ima25)
      RETURNING l_flag,g_tlf.tlf60
    IF l_flag THEN
       LET g_success='N'
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('tlf01',g_tlf.tlf01,'','abm-731',1)
       ELSE
          CALL cl_err('','abm-731',1)
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_tlf.tlf60=1.0
    END IF
    IF STATUS OR g_tlf.tlf60 IS NULL THEN LET g_tlf.tlf60=1 END IF
    #--------------------------------------------------------------------------
   #No.+330 010702 by plum
   #IF g_tlf.tlf02=50 OR g_tlf.tlf03=50 AND g_tlf.tlf13<>'aimp880' THEN
    IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) AND g_tlf.tlf13<>'aimp880' THEN
   #No.+330..end
        IF NOT s_chksmz_tlf1(g_tlf.tlf01,g_tlf.tlf905,g_tlf.tlf902,g_tlf.tlf903) #FUN-560043 #MOD-530629
          THEN LET g_success='N' RETURN
       END IF
    END IF
    #--------------------------------------------------------------------------
## 為了避免同一筆單據多人(sessoin)同時過帳造成 重複update img_file
## and insert tlf_file 
    #FUN-620017...............begin   
    #SELECT COUNT(*) INTO g_i FROM tlf_file
    # WHERE tlf01=g_tlf.tlf01
    #   AND tlf02=g_tlf.tlf02
    #   AND tlf03=g_tlf.tlf03
    #   AND tlf902=g_tlf.tlf902
    #   AND tlf903=g_tlf.tlf903
    #   AND tlf904=g_tlf.tlf904
    #   AND tlf905=g_tlf.tlf905
    #   AND tlf906=g_tlf.tlf906
    #LET g_sql="SELECT COUNT(*) FROM ",gs_dbs,"tlf_file",   #FUN-980014
    #LET g_sql="SELECT COUNT(*) FROM ",gs_tdbs,"tlf_file",   #FUN-980014
    LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'tlf_file'), #FUN-A50102
              " WHERE tlf01='",g_tlf.tlf01,"'",
              " AND tlf02=",g_tlf.tlf02,
              " AND tlf03=",g_tlf.tlf03,
              " AND tlf902='",g_tlf.tlf902,"'",
              " AND tlf903='",g_tlf.tlf903,"'",
              " AND tlf904='",g_tlf.tlf904,"'",
              " AND tlf905='",g_tlf.tlf905,"'",
            # " AND tlf906=",g_tlf.tlf906         #FUN-BC0062 mark
              " AND tlf906='",g_tlf.tlf906,"'"    #FUN-BC0062
             ," AND tlff012='",g_tlf.tlf012,"'"   #FUN-A60028
             ," AND tlff013='",g_tlf.tlf013,"'"   #FUN-A60028             
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No.FUN-870007
    PREPARE tlf1_c3_pre FROM g_sql
    DECLARE tlf1_c3 CURSOR FOR tlf1_c3_pre
    OPEN tlf1_c3
    FETCH tlf1_c3 INTO g_i
    CLOSE tlf1_c3
    #FUN-620017...............end
    IF g_i>0 THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('tlf01',g_tlf.tlf01,'s_tlf:ins tlf',-239,1)
       ELSE
          CALL cl_err('(s_tlf:ins tlf)',-239,1)
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success='N'
       RETURN
    END IF
#######

#FUN-A70125 --begin--
      IF cl_null(g_tlf.tlf012) THEN
         LET g_tlf.tlf012 = ' '
      END IF
      IF cl_null(g_tlf.tlf013) THEN
        LET g_tlf.tlf013 = 0
      END IF
#FUN-A70125 --end--

    #FUN-620017...............begin
    #NO.TQC-930155---------begin---------------------
    #INSERT INTO tlf_file VALUES(g_tlf.*) #放到資料庫中
    #DROP TABLE tlf1_tmp
    #SELECT * FROM tlf_file WHERE 1=2 INTO TEMP tlf1_tmp
    #INSERT INTO tlf1_tmp VALUES (g_tlf.*)
    #LET g_sql="INSERT INTO ",gs_dbs,"tlf_file ",
    #          "SELECT * FROM tlf1_tmp"
    #PREPARE tlf1_c4_pre FROM g_sql
#No.TQC-930155-start-

#   LET g_sql="INSERT INTO ",gs_dbs,"tlf_file VALUES(",
    #LET g_sql="INSERT INTO ",gs_dbs,"tlf_file (",     #FUN-980014
    #LET g_sql="INSERT INTO ",gs_tdbs,"tlf_file (",     #FUN-980014
    LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'tlf_file'),"(", #FUN-A50102
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
              "tlf2242x,tlf2243x,tlf224x, tlf65x,  tlfplant,tlflegal,tlf27,tlf28,tlf012,tlf013) VALUES (",  #No.FUN-870007 #FUN-9B0149  #TQC-A40015 add tlf28
                                                      #FUN-A60028 add tlf012,tlf013 
#No.TQC-930155--end-- 
              "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "?,?,?,?,?, ?,?,?,?,?)"  #No.FUN-870007 FUN-9B0149   #TQC-A40015 add ?  #FUN-A60028 add ? ?  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
    PREPARE tlf1_c4_pre FROM g_sql
    #EXECUTE tlf1_c4_pre USING g_tlf.*  #FUN-CB0087 mark
    #FUN-CB0087 add start
    EXECUTE tlf1_c4_pre USING g_tlf.tlf01,g_tlf.tlf02,g_tlf.tlf020,g_tlf.tlf021,g_tlf.tlf022,
                              g_tlf.tlf023,g_tlf.tlf024,g_tlf.tlf025,g_tlf.tlf026,g_tlf.tlf027,
                              g_tlf.tlf03,g_tlf.tlf030,g_tlf.tlf031,g_tlf.tlf032,g_tlf.tlf033,
                              g_tlf.tlf034,g_tlf.tlf035,g_tlf.tlf036,g_tlf.tlf037,g_tlf.tlf04,
                              g_tlf.tlf05,g_tlf.tlf06,g_tlf.tlf07,g_tlf.tlf08,g_tlf.tlf09,
                              g_tlf.tlf10,g_tlf.tlf11,g_tlf.tlf12,g_tlf.tlf13,g_tlf.tlf14,
                              g_tlf.tlf15,g_tlf.tlf16,g_tlf.tlf17,g_tlf.tlf18,g_tlf.tlf19,
                              g_tlf.tlf20,g_tlf.tlf21,g_tlf.tlf211,g_tlf.tlf212,g_tlf.tlf2131,
                              g_tlf.tlf2132,g_tlf.tlf214,g_tlf.tlf215,g_tlf.tlf2151,g_tlf.tlf216,g_tlf.tlf2171,
                              g_tlf.tlf2172,g_tlf.tlf219,g_tlf.tlf218,g_tlf.tlf220,g_tlf.tlf221,
                              g_tlf.tlf222,g_tlf.tlf2231,g_tlf.tlf2232,g_tlf.tlf224,g_tlf.tlf225,
                              g_tlf.tlf2251,g_tlf.tlf226,g_tlf.tlf2271,g_tlf.tlf2272,g_tlf.tlf229,
                              g_tlf.tlf230,g_tlf.tlf231,g_tlf.tlf60,g_tlf.tlf61,g_tlf.tlf62,
                              g_tlf.tlf63,g_tlf.tlf64,g_tlf.tlf65,g_tlf.tlf66,g_tlf.tlf901,
                              g_tlf.tlf902,g_tlf.tlf903,g_tlf.tlf904,g_tlf.tlf905,g_tlf.tlf906,
                              g_tlf.tlf907,g_tlf.tlf908,g_tlf.tlf909,g_tlf.tlf910,g_tlf.tlf99,
                              g_tlf.tlf930,g_tlf.tlf931,g_tlf.tlf151,g_tlf.tlf161,g_tlf.tlf2241,
                              g_tlf.tlf2242,g_tlf.tlf2243,g_tlf.tlfcost,g_tlf.tlf41,g_tlf.tlf42,
                              g_tlf.tlf43,g_tlf.tlf211x,g_tlf.tlf212x,g_tlf.tlf21x,g_tlf.tlf221x,
                              g_tlf.tlf222x,g_tlf.tlf2231x,g_tlf.tlf2232x,g_tlf.tlf2241x,g_tlf.tlf2242x,
                              g_tlf.tlf2243x,g_tlf.tlf224x,g_tlf.tlf65x,g_tlf.tlfplant,g_tlf.tlflegal,
                              g_tlf.tlf27,g_tlf.tlf28,g_tlf.tlf012,g_tlf.tlf013

    #FUN-CB0087 add end
    #EXECUTE tlf1_c4_pre
#NO.TQC-930155--------end-----------------
    #FUN-620017...............end
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       #-----No.FUN-6C0083-----
       IF g_bgerr THEN
          CALL s_errmsg('tlf01',g_tlf.tlf01,'s_tlf:ins tlf',STATUS,1)
       ELSE
          CALL cl_err('(s_tlf:ins tlf)',STATUS,1)
       END IF
       #-----No.FUN-6C0083 END-----
       LET g_success='N'
       RETURN
    END IF
    #--------------------------------------------------------------------------
#FUN-BC0062 -------------Begin------------
    #計算異動加權平均成本
    IF NOT s_tlf_mvcost(g_plant_new) THEN
       RETURN
    END IF
#FUN-BC0062 -------------End--------------
    CALL s_tlf1_tlfs()   #CHI-D10014
END FUNCTION
 
#依'料號'及'單別'檢查倉庫儲位正確否
FUNCTION s_chksmz_tlf1(p_part, p_slip, p_ware, p_loc)
   DEFINE p_part	  LIKE imf_file.imf01	# 料號   #No.MOD-490217
   DEFINE p_slip	  LIKE oea_file.oea01	# 單號   #FUN-560043 #MOD-530629 	#No.FUN-680147 VARCHAR(16)
   DEFINE p_ware	  LIKE imf_file.imf02	# 倉庫 	#No.FUN-680147 VARCHAR(10)
   DEFINE p_loc		  LIKE imf_file.imf03	# 儲位 	#No.FUN-680147 VARCHAR(10)
   DEFINE l_slip          LIKE aba_file.aba00         # 單別  #MOD-530629 	#No.FUN-680147 VARCHAR(5)
   DEFINE l_smyware       LIKE smy_file.smyware         #No.FUN-680147 VARCHAR(1)
   DEFINE l_n		  LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE x1,y1		  LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE x2,y2		  LIKE aba_file.aba18 	        #No.FUN-680147 VARCHAR(2)
   DEFINE l_oay12         LIKE oay_file.oay12,          #No.FUN-680147 VARCHAR(01)
          l_smy56         LIKE smy_file.smy56,          #No.FUN-680147 VARCHAR(01)
          g_img37         LIKE img_file.img37,
          g_ima902        LIKE ima_file.ima902
   
   LET l_oay12=' '
   LET l_smy56=' '
   LET l_slip =p_slip[1,g_doc_len]  #MOD-530629 取單別
   IF p_loc IS NULL THEN LET p_loc=' ' END IF
   #--------------------------------------------------- check imf_file
   IF p_part IS NOT NULL THEN	# p_part=NULL 時, 不作imf_file的檢查
      IF g_sma.sma42='1' THEN
         #FUN-620017...............begin
         #SELECT COUNT(*) INTO l_n FROM imf_file
         #   WHERE imf01=p_part AND imf02=p_ware
         #LET g_sql="SELECT COUNT(*) FROM ",gs_dbs,"imf_file",
         LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'imf_file'), #FUN-A50102
                   " WHERE imf01='",p_part,"'",
                   " AND imf02='",p_ware,"'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
         PREPARE tlf1_c5_pre FROM g_sql
         DECLARE tlf1_c5 CURSOR FOR tlf1_c5_pre
         OPEN tlf1_c5
         FETCH tlf1_c5 INTO l_n
         CLOSE tlf1_c5
         #FUN-620017...............end
         IF l_n=0 THEN
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               LET g_showmsg = p_part,"/",p_ware
               CALL s_errmsg('imf01,imf02',g_showmsg,'sel imf','mfg1102',1)
            ELSE
               CALL cl_err('sel imf','mfg1102',1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN 0
         END IF
      END IF
      IF g_sma.sma42='2' THEN
        #FUN-620017...............begin
        #SELECT COUNT(*) INTO l_n FROM imf_file
        #       WHERE imf01=p_part AND imf02=p_ware AND imf03=p_loc
        #LET g_sql="SELECT COUNT(*) FROM ",gs_dbs,"imf_file",
        LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'imf_file'), #FUN-A50102
                  " WHERE imf01='",p_part,"' AND imf02='",p_ware,"'",
                  "   AND imf03='",p_loc,"'"
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
        PREPARE tlf1_c6_pre FROM g_sql
        DECLARE tlf1_c6 CURSOR FOR tlf1_c6_pre
        OPEN tlf1_c6
        FETCH tlf1_c6 INTO l_n
        CLOSE tlf1_c6
        #FUN-620017...............end
        IF l_n=0 THEN
           #-----No.FUN-6C0083-----
           IF g_bgerr THEN
              LET g_showmsg = p_part,"/",p_ware,"/",p_loc
              CALL s_errmsg('imf01,imf02,imf03',g_showmsg,'sel imf','mfg1102',1)
           ELSE
              CALL cl_err('sel imf','mfg1102',1)
           END IF
           #-----No.FUN-6C0083 END-----
           RETURN 0
        END IF
      END IF
   END IF
   #--------------------------------------------------- check smz_file
   #FUN-620017...............begin
   #SELECT smyware INTO l_smyware FROM smy_file WHERE smyslip=l_slip  #MOD-530629
   #LET g_sql="SELECT smyware FROM ",gs_dbs,"smy_file",
   LET g_sql="SELECT smyware FROM ",cl_get_target_table(g_plant_new,'smy_file'), #FUN-A50102
             " WHERE smyslip='",l_slip,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE tlf1_c7_pre FROM g_sql
   DECLARE tlf1_c7 CURSOR FOR tlf1_c7_pre
   OPEN tlf1_c7
   FETCH tlf1_c7 INTO l_smyware
   CLOSE tlf1_c7
   #FUN-620017...............end
   IF SQLCA.sqlcode THEN
      #-----No.FUN-6C0083-----
      IF g_bgerr THEN
         CALL s_errmsg('smyslip',l_slip,'sel smy',STATUS,1)
      ELSE
         CALL cl_err('sel smy',STATUS,1)
      END IF
      #-----No.FUN-6C0083 END-----
      RETURN 0
   END IF
   LET x1=p_ware LET x2=p_ware
   LET y1=p_loc  LET y2=p_loc 
   CASE WHEN l_smyware='1'
             #FUN-620017...............begin
             #SELECT COUNT(*) INTO l_n FROM smz_file
             #  WHERE smz01=l_slip            #MOD-530629  
             #    AND p_ware MATCHES smz02                            
              #LET g_sql="SELECT COUNT(*) FROM ",gs_dbs,"smz_file",
              LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smz_file'), #FUN-A50102
                        " WHERE smz01='",l_slip,"'",
                        "   AND '",p_ware,"' LIKE smz02"      #CHI-B20023 mark  #MOD-B30695 取消mark   
                       #"   AND smz02 LIKE '",p_ware,"'"      #CHI-B20023 add   #MOD-B30695 mark
             #FUN-620017...............end
               #No.B595 010528 by plum 原來只限定要輸91*,目前開放只要輸??????*
               #AND (smz02=p_ware OR
               #    (smz02[1,1]=x1 AND smz02[2,2]='*') OR
               #    (smz02[1,2]=x2 AND smz02[3,3]='*'))
                
               #No.B595..end
             #IF l_n=0 THEN
             #   CALL cl_err('s_chksmz','mfg1104',1) RETURN 0
             #END IF
        WHEN l_smyware='2'
             #FUN-620017...............begin
             #SELECT COUNT(*) INTO l_n FROM smz_file
             #  WHERE smz01=l_slip      #MOD-530629
             #LET g_sql="SELECT COUNT(*) FROM ",gs_dbs,"smz_file",
             LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smz_file'), #FUN-A50102
                       "  WHERE smz01='",l_slip,"'",
                       "    AND '",p_ware,"' LIKE smz02",     #CHI-B20023 mark  #MOD-B30695 取消mark  
                       "    AND '",p_loc,"' LIKE smz03"       #CHI-B20023 mark  #MOD-B30695 取消mark   
                      #"    AND smz02 LIKE '",p_ware,"'",     #CHI-B20023 add   #MOD-B30695 mark   
                      #"    AND smz03 LIKE '",p_loc,"'"       #CHI-B20023 add   #MOD-B30695 mark  
             #FUN-620017...............end
               #No.B595 010528 by plum 原來只限定要輸91*,目前開放只要輸??????*
               #AND (smz02=p_ware OR
               #    (smz02[1,1]=x1 AND smz02[2,2]='*') OR
               #    (smz02[1,2]=x2 AND smz02[3,3]='*'))
               #AND (smz03=p_loc OR
               #    (smz03[1,1]=y1 AND smz03[2,2]='*') OR
               #    (smz03[1,2]=y2 AND smz03[3,3]='*'))
                #AND p_ware MATCHES smz02
                #AND p_loc  MATCHES smz03
               #No.B595..end
             #IF l_n=0 THEN
             #   CALL cl_err('s_chksmz','mfg1104',1) RETURN 0
             #END IF
        WHEN l_smyware='3'
             #FUN-620017...............begin
             #SELECT COUNT(*) INTO l_n FROM smz_file
             #  WHERE smz01=l_slip         #MOD-530629
             #LET g_sql="SELECT COUNT(*) FROM ",gs_dbs,"smz_file",
             LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smz_file'), #FUN-A50102
                       "  WHERE smz01='",l_slip,"'",
                       "    AND '",p_ware,"' LIKE smz02"      #CHI-B20023 mark  #MOD-B30695 取消mark   
                      #"    AND smz02 LIKE '",p_ware,"'"      #CHI-B20023 add   #MOD-B30695 mark
             #FUN-620017...............end
               #No.B595 010528 by plum 原來只限定要輸91*,目前開放只要輸??????*
              # AND (smz02=p_ware OR
              #     (smz02[1,1]=x1 AND smz02[2,2]='*') OR
              #     (smz02[1,2]=x2 AND smz02[3,3]='*'))
               #AND p_ware MATCHES smz02
               #No.B595..end
             #IF l_n>0 THEN
             #   CALL cl_err('s_chksmz','mfg1105',1) RETURN 0
             #END IF
        WHEN l_smyware='4'
             #FUN-620017...............begin
             #SELECT COUNT(*) INTO l_n FROM smz_file
             #  WHERE smz01=l_slip      #MOD-530629
             #LET g_sql="SELECT COUNT(*) FROM ",gs_dbs,"smz_file",
             LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'smz_file'), #FUN-A50102
                       "  WHERE smz01='",l_slip,"'",
                       "    AND '",p_ware,"' LIKE smz02",     #CHI-B20023 mark  #MOD-B30695取消mark    
                       "    AND '",p_loc,"' LIKE smz03"       #CHI-B20023 mark  #MOD-B30695取消mark 
                      #"    AND smz02 LIKE '",p_ware,"'",     #CHI-B20023 add   #MOD-B30695mark  
                      #"    AND smz03 LIKE '",p_loc,"'"       #CHI-B20023 add   #MOD-B30695mark 
             #FUN-620017...............end
               #No.B595 010528 by plum 原來只限定要輸91*,目前開放只要輸??????*
               #AND (smz02=p_ware OR
               #    (smz02[1,1]=x1 AND smz02[2,2]='*') OR
               #    (smz02[1,2]=x2 AND smz02[3,3]='*'))
               #AND (smz03=p_loc OR
               #    (smz03[1,1]=y1 AND smz03[2,2]='*') OR
               #    (smz03[1,2]=y2 AND smz03[3,3]='*'))
               #AND p_ware MATCHES smz02
               #AND p_loc  MATCHES smz03
               #No.B595..end
             #IF l_n>0 THEN
             #   CALL cl_err('s_chksmz','mfg1105',1) RETURN 0
             #END IF
         OTHERWISE LET g_sql=""  #FUN-620017
   END CASE
 
   #FUN-620017...............begin
   IF NOT cl_null(g_sql) THEN
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE tlf1_c8_pre FROM g_sql
      DECLARE tlf1_c8 CURSOR FOR tlf1_c7_pre
      OPEN tlf1_c8
      FETCH tlf1_c8 INTO l_n
      CLOSE tlf1_c8
      IF (l_n=0) AND (l_smyware MATCHES '[1,2]') THEN
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('smz01',l_slip,'s_chksmz','mfg1104',1)
         ELSE
            CALL cl_err('s_chksmz','mfg1104',1)
         END IF
         #-----No.FUN-6C0083 END-----
         RETURN 0
      END IF
      IF (l_n>0) AND (l_smyware MATCHES '[3,4]') THEN
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('smz01',l_slip,'s_chksmz','mfg1104',1)
         ELSE
            CALL cl_err('s_chksmz','mfg1105',1)
         END IF
         #-----No.FUN-6C0083 END-----
         RETURN 0
      END IF
   END IF
   #FUN-620017...............end
   
   #--------------------------------------------------- 97/10/18
   IF g_tlf.tlf02=50 OR g_tlf.tlf03=50 THEN
      #FUN-620017...............begin
      #SELECT img37 INTO g_img37 FROM img_file
      # WHERE img01=g_tlf.tlf01
      #   AND img02=g_tlf.tlf902
      #   AND img03=g_tlf.tlf903
      #   AND img04=g_tlf.tlf904
      #LET g_sql="SELECT img37 FROM ",gs_dbs,"img_file",   #FUN-980014
      #LET g_sql="SELECT img37 FROM ",gs_tdbs,"img_file",   #FUN-980014
      LET g_sql="SELECT img37 FROM ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                " WHERE img01='",g_tlf.tlf01,"'",
                "   AND img02='",g_tlf.tlf902,"'",
                "   AND img03='",g_tlf.tlf903,"'",
                "   AND img04='",g_tlf.tlf904,"'"
  	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No.FUN-870007
      PREPARE tlf1_c9_pre FROM g_sql
      DECLARE tlf1_c9 CURSOR FOR tlf1_c9_pre
      OPEN tlf1_c9
      FETCH tlf1_c9 INTO g_img37
      #FUN-620017...............end
      IF STATUS THEN LET g_img37='' END IF
      CLOSE tlf1_c9
      #FUN-620017...............begin
      #SELECT ima902 INTO g_ima902 FROM ima_file WHERE ima01=g_tlf.tlf01
      #LET g_sql="SELECT ima902 FROM ",gs_dbs,"ima_file",
      LET g_sql="SELECT ima902 FROM ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                " WHERE ima01='",g_tlf.tlf01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE tlf1_c10_pre FROM g_sql
      DECLARE tlf1_c10 CURSOR FOR tlf1_c10_pre
      OPEN tlf1_c10
      FETCH tlf1_c10 INTO g_ima902
      #FUN-620017...............end
      IF STATUS THEN LET g_ima902='' END IF
      CLOSE tlf1_c10
 
      IF g_tlf.tlf13 MATCHES 'axmt*' THEN
         #FUN-620017...............begin
         #SELECT oay12 INTO l_oay12 FROM oay_file WHERE oayslip=l_slip  #MOD-530629   
         #LET g_sql="SELECT oay12 FROM ",gs_dbs,"oay_file",
         LET g_sql="SELECT oay12 FROM ",cl_get_target_table(g_plant_new,'oay_file'), #FUN-A50102
                   " WHERE oayslip='",l_slip,"'"
 	    CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
         PREPARE tlf1_c11_pre FROM g_sql
         DECLARE tlf1_c11 CURSOR FOR tlf1_c11_pre
         OPEN tlf1_c11
         FETCH tlf1_c11 INTO l_oay12
         CLOSE tlf1_c11
         #FUN-620017...............end      
         IF l_oay12='Y' THEN
          # IF g_tlf.tlf06>g_ima902 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_ima902 OR g_ima902 IS NULL THEN
               #FUN-620017...............begin
               #UPDATE ima_file SET ima902=g_tlf.tlf06 WHERE ima01=g_tlf.tlf01
               #LET g_sql="UPDATE ",gs_dbs,"ima_file SET ima902='",g_tlf.tlf06,"'",
               LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                         " SET ima902='",g_tlf.tlf06,"'",
                         " WHERE ima01='",g_tlf.tlf01,"'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
               PREPARE tlf1_c12_pre FROM g_sql
               EXECUTE tlf1_c12_pre
               #FUN-620017...............end
               IF STATUS THEN 
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     CALL s_errmsg('ima01',g_tlf.tlf01,'upd ima902',STATUS,1)
                  ELSE
                     CALL cl_err('upd ima902',STATUS,1)
                  END IF
                  #-----No.FUN-6C0083 END-----
                  RETURN 0
               END IF
            END IF
          # IF g_tlf.tlf06>g_img37 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_img37 OR g_img37 IS NULL THEN
               #FUN-620017...............begin
               #UPDATE img_file SET img37=g_tlf.tlf06         
               #   WHERE img01=g_tlf.tlf01 AND img02=g_tlf.tlf902
               #     AND img03=g_tlf.tlf903 AND img04=g_tlf.tlf904
               #LET g_sql="UPDATE ",gs_dbs,"img_file SET img37='",g_tlf.tlf06,"'",   #FUN-980014
               #LET g_sql="UPDATE ",gs_tdbs,"img_file SET img37='",g_tlf.tlf06,"'",   #FUN-980014
               LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                         " SET img37='",g_tlf.tlf06,"'",
                         " WHERE img01='",g_tlf.tlf01,"'",
                         "   AND img02='",g_tlf.tlf902,"'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No.FUN-870007
               PREPARE tlf1_c13_pre FROM g_sql
               EXECUTE tlf1_c13_pre
               #FUN-620017...............end
               IF STATUS THEN 
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     LET g_showmsg = g_tlf.tlf01,"/",g_tlf.tlf902
                     CALL s_errmsg('img01,img02',g_showmsg,'upd ima902',STATUS,1)
                  ELSE
                     CALL cl_err('upd img37',STATUS,1)
                  END IF
                  #-----No.FUN-6C0083 END-----
                  RETURN 0
               END IF
            END IF
         END IF
      ELSE
          #FUN-620017...............begin
          #SELECT smy56 INTO l_smy56 FROM smy_file WHERE smyslip=l_slip   #MOD-530629    
          #LET g_sql="SELECT smy56 FROM ",gs_dbs,"smy_file",
          LET g_sql="SELECT smy56 FROM ",cl_get_target_table(g_plant_new,'smy_file'), #FUN-A50102
                    " WHERE smyslip='",l_slip,"'"
 	      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
          PREPARE tlf1_c14_pre FROM g_sql
          DECLARE tlf1_c14 CURSOR FOR tlf1_c14_pre
          OPEN tlf1_c14
          FETCH tlf1_c14 INTO l_smy56
          CLOSE tlf1_c14
          #FUN-620017...............end    
         IF l_smy56='Y' THEN
          # IF g_tlf.tlf06>g_ima902 THEN
          #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_ima902 OR g_ima902 IS NULL THEN
               #FUN-620017...............begin
               #UPDATE ima_file SET ima902=g_tlf.tlf06 WHERE ima01=g_tlf.tlf01
               #LET g_sql="UPDATE ",gs_dbs,"ima_file SET ima902='",g_tlf.tlf06,"'",
               LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'ima_file'), #FUN-A50102
                         " SET ima902='",g_tlf.tlf06,"'",
                         " WHERE ima01='",g_tlf.tlf01,"'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
               PREPARE tlf1_c15_pre FROM g_sql
               EXECUTE tlf1_c15_pre
               #FUN-620017...............end
               IF STATUS THEN 
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     CALL s_errmsg('ima01',g_tlf.tlf01,'upd ima902',STATUS,1)
                  ELSE
                     CALL cl_err('upd ima902',STATUS,1)
                  END IF
                  #-----No.FUN-6C0083 END-----
                  RETURN 0
               END IF
            END IF
           #IF g_tlf.tlf06>g_img37 THEN
           #No.+471 010727 mod by linda 必須判斷null,否則新料不會update
            IF g_tlf.tlf06>g_img37 OR g_img37 IS NULL THEN
               #FUN-620017...............begin
               #UPDATE img_file SET img37=g_tlf.tlf06         
               #   WHERE img01=g_tlf.tlf01 AND img02=g_tlf.tlf902
               #     AND img03=g_tlf.tlf903 AND img04=g_tlf.tlf904
               #LET g_sql="UPDATE ",gs_dbs,"img_file",   #FUN-980014
               #LET g_sql="UPDATE ",gs_tdbs,"img_file",   #FUN-980014
               LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'img_file'), #FUN-A50102
                         " SET img37='",g_tlf.tlf06,"'",
                         " WHERE img01='",g_tlf.tlf01,"'",
                         "   AND img02='",g_tlf.tlf902,"'",
                         "   AND img03='",g_tlf.tlf903,"'",
                         "   AND img04='",g_tlf.tlf904,"'"
 	           CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No.FUN-870007
               PREPARE tlf1_c16_pre FROM g_sql
               EXECUTE tlf1_c16_pre
               #FUN-620017...............end
               IF STATUS THEN 
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     LET g_showmsg = g_tlf.tlf01,"/",g_tlf.tlf902,"/",g_tlf.tlf903,"/",g_tlf.tlf904
                     CALL s_errmsg('img01,img02,img03,img04',g_showmsg,'upd ima902',STATUS,1)
                  ELSE
                     CALL cl_err('upd img37',STATUS,1)
                  END IF
                  #-----No.FUN-6C0083 END-----
                  RETURN 0
               END IF
            END IF
         END IF
      END IF
   END IF
   #---------------------------------------------------
   RETURN 1	# TRUE -> OK
END FUNCTION
 
FUNCTION tlfcost()
#--->現時成本
    LET g_tlf.tlf211 = 0
    LET g_tlf.tlf212 = 0
    LET g_tlf.tlf2131= 0
    LET g_tlf.tlf2132= 0
    LET g_tlf.tlf214 = 0
    LET g_tlf.tlf215 = 0
    LET g_tlf.tlf2151 = 0
    LET g_tlf.tlf216 = 0 
    LET g_tlf.tlf2171= 0
    LET g_tlf.tlf2172= 0
    LET g_tlf.tlf219 = 0 
    LET g_tlf.tlf218 = 0
    LET g_tlf.tlf220 = 0
    LET g_tlf.tlf221 = 0
    LET g_tlf.tlf222 = 0 
    LET g_tlf.tlf2231= 0
    LET g_tlf.tlf2232= 0
    LET g_tlf.tlf224 = 0
    LET g_tlf.tlf225 = 0
    LET g_tlf.tlf2251 = 0
    LET g_tlf.tlf226 = 0
    LET g_tlf.tlf2271= 0
    LET g_tlf.tlf2272= 0
    LET g_tlf.tlf229 = 0
    LET g_tlf.tlf230= 0
    LET g_tlf.tlf231=0
    LET g_tlf.tlf64='1'
END FUNCTION
#TQC-9C0059
#CHI-D10014---begin
FUNCTION s_tlf1_tlfs()
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_rvbs   RECORD LIKE rvbs_file.*
   DEFINE l_sql    STRING
   DEFINE l_rvbs01 LIKE rvbs_file.rvbs01                                      
   DEFINE l_rvbs02 LIKE rvbs_file.rvbs02                                    
   DEFINE l_rvbs09 LIKE rvbs_file.rvbs09                                        
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
   DEFINE l_tlfs02   LIKE tlfs_file.tlfs02
   DEFINE l_tlfs03   LIKE tlfs_file.tlfs03
   DEFINE l_tlfs04   LIKE tlfs_file.tlfs04
   DEFINE l_cnt      LIKE type_file.num5   
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06 
   DEFINE l_cnt1     LIKE type_file.num5 

   IF g_prog <> "aimp701" THEN
      RETURN
   END IF 
   
   LET g_sql="SELECT ima918,ima921 FROM ",cl_get_target_table(g_plant_new,'ima_file'), 
                    " WHERE ima01='",g_tlf.tlf01,"'",
                    "   AND imaacti = 'Y' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE tlf1_tlfs_p1 FROM g_sql
   EXECUTE tlf1_tlfs_p1 INTO l_ima918,l_ima921
   
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
 
   IF g_tlf.tlf907 = 1 THEN                                                     
         LET l_rvbs09 = 1                                                          
         LET l_rvbs01 = g_tlf.tlf036                                            
         LET l_rvbs02 = g_tlf.tlf037                                            
         LET l_tlfs02 = g_tlf.tlf031
         LET l_tlfs03 = g_tlf.tlf032  
         LET l_tlfs04 = g_tlf.tlf033  
   END IF                                                                       
                                                                                
   IF g_tlf.tlf907 = -1 THEN                                                    
      LET l_rvbs09 = -1                                              
      LET l_rvbs01 = g_tlf.tlf026                                            
      LET l_rvbs02 = g_tlf.tlf027                                            
      LET l_tlfs02 = g_tlf.tlf021
      LET l_tlfs03 = g_tlf.tlf022  
      LET l_tlfs04 = g_tlf.tlf023  
   END IF                                                                       
                                                                                                                                                          
   LET g_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'rvbs_file'), 
                   "  WHERE rvbs01 = '",l_rvbs01,"'",   
                   "    AND rvbs02 = ",l_rvbs02, 
                   "    AND rvbs09 = ",l_rvbs09 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
   PREPARE rvbs_pre FROM g_sql
   DECLARE rvbs_cs CURSOR FOR rvbs_pre
   
   FOREACH rvbs_cs INTO l_rvbs.*
      IF STATUS THEN 
         IF g_bgerr THEN 
            CALL s_errmsg('','','foreach:',STATUS,1)
         ELSE
            CALL cl_err('foreach:',STATUS,1)
         END IF
         EXIT FOREACH
      END IF

      IF l_rvbs.rvbs00 = 'aimt700' THEN CONTINUE FOREACH END IF  
   
      LET l_tlfs.tlfs01 = g_tlf.tlf01
      LET l_tlfs.tlfs02 = l_tlfs02
      LET l_tlfs.tlfs03 = l_tlfs03  
      LET l_tlfs.tlfs04 = l_tlfs04  
      LET l_tlfs.tlfs05 = l_rvbs.rvbs03
      LET l_tlfs.tlfs06 = l_rvbs.rvbs04

      LET g_sql="SELECT img09 FROM ",cl_get_target_table(g_plant_new,'img_file'), 
                    " WHERE img01='",l_tlfs.tlfs01,"'",
                    "   AND img02='",l_tlfs.tlfs02,"'",
                    "   AND img03='",l_tlfs.tlfs03,"'",
                    "   AND img04='",l_tlfs.tlfs04,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE tlf1_tlfs_p2 FROM g_sql
      EXECUTE tlf1_tlfs_p2 INTO l_tlfs.tlfs07

      LET l_tlfs.tlfs08 = l_rvbs.rvbs00
      LET l_tlfs.tlfs09 = g_tlf.tlf907

      LET l_tlfs.tlfs10 = l_rvbs.rvbs01    
      LET l_tlfs.tlfs11 = l_rvbs.rvbs02    
      LET l_tlfs.tlfs111 = g_tlf.tlf06  
      LET l_tlfs.tlfs12 = g_tlf.tlf07 
      LET l_tlfs.tlfs13 = l_rvbs.rvbs06

      LET l_tlfs.tlfs14 = l_rvbs.rvbs07
      LET l_tlfs.tlfs15 = l_rvbs.rvbs08
      LET l_tlfs.tlfsplant = g_plant  
      LET l_tlfs.tlfslegal = g_legal  
 
      INSERT INTO tlfs_file VALUES(l_tlfs.*)

      LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'tlfs_file'),"(", 
              "tlfs01,  tlfs02,  tlfs03,  tlfs04,  tlfs05,  tlfs06,  tlfs07,  tlfs08,  tlfs09,  tlfs10,",
              "tlfs11,  tlfs12,  tlfs13,  tlfs14,  tlfs15,  tlfs111, tlfsplant,tlfslegal ) VALUES (", 
              "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  
 	  CALL cl_replace_sqldb(g_sql) RETURNING g_sql      
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE tlf1_tlfs_p3 FROM g_sql
      EXECUTE tlf1_tlfs_p3 USING l_tlfs.*
      
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('tlfs01',l_tlfs.tlfs01,'s_tlfs:ins tlfs',STATUS,1)
         ELSE
             CALL cl_err3("sel","tlfs_file",l_tlfs.tlfs01,"",STATUS,"","",1)
         END IF
         LET g_success='N'
         RETURN
      END IF
 
   END FOREACH
 
END FUNCTION
#CHI-D10014---end

