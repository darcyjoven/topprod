# Prog. Version..: '5.30.06-13.04.18(00010)'     #
#
# Pattern name...: axrs010.4gl
# Descriptions...: 應收系統參數(一)設定作業–連線參數
# Date & Author..: 95/02/27 By Danny
# Modify.........: No.FUN-580096 05/08/22 By Carrier aza26='2'時隱藏ooz64
# Modify.........: No.MOD-5B0018 05/11/08 By Smapmin 由ooz02來判斷是否輸入總帳相關資料
# Modify.........: No.FUN-640029 06/04/14 By kim GP3.0 匯率改善功能
# Modify.........: No.FUN-650076 06/05/23 By Smapmin 拿掉ooz18
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳套權限修改
# Modify.........: No.FUN-670026 06/07/25 By Tracy 應收銷退合并
# Modify.........: No.FUN-670047 06/07/14 By Ray 新增多賬套功能
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-740032 07/04/12 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-770025 07/07/04 By Rayven 預收帳款缺省單別與溢收帳款缺省單別,當單別無效時,錄入此單別無控管
# Modify.........: No.TQC-790064 07/09/13 By sherry 內/外銷應收單身儲存最大筆數錄入負數無控管
# Modify.........: No.MOD-870183 08/07/16 By Smapmin aza26<>'2'時隱藏ooz65
# Modify.........: No.FUN-930164 09/04/15 By jamie update ooz09、ooz05ORooz06成功時，寫入azo_file
# Modify.........: No.FUN-920210 09/05/04 By sabrina 新增ooz66 預收/暫收不做月底重評價
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Mofify.........: No.FUN-980020 09/09/03 By douzh 集團架構調整
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.FUN-A40076 10/05/21 By xiaofeizhu add ooz26,ooz27,ooz28
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A40079 10/08/03 By sabrina 當aoos010設定不使用多帳別功能時,axr-090卡關有問題
# Modify.........: No:TQC-960168 10/11/05 By sabrina _u更改段如果按放棄要close ozz_cur1 不然會一直lock住
# Modify.........: No:FUN-AA0088 11/01/13 By wujie    增加ooz29
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.TQC-B60067 11/06/15 By lixiang  對單別的碼長進行控管（和aoos010相關連）
# Modify.........: No.FUN-B50039 11/07/08 By xianghui 增加自訂欄位
# Modify.........: No.FUN-C20018 12/02/03 By wangrr 增加ooz30待抵調帳單別
# Modify.........: No:CHI-C10018 12/05/14 By Polly ooz65出貨應收包含銷退折讓的參數不受限大陸版
# Modify.........: No.FUN-C60033 12/06/11 By minpp 增加ooz32是否做发票管理
# Modify.........: No.FUN-C90105 12/10/16 By xuxz 增加ooz33訂金是否認列收入
# Modify.........: No.MOD-D40225 13/04/28 By xuxz ooz29與ooz26,ooz30需要控管統一
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_ooz_t         RECORD LIKE ooz_file.*,  # 預留參數檔
        g_ooz_o         RECORD LIKE ooz_file.*   # 預留參數檔
DEFINE  g_forupd_sql    STRING
DEFINE  g_cnt           LIKE type_file.num10     #No.FUN-680123 INTEGER   
DEFINE  t_dbss          LIKE azp_file.azp03      #No.FUN-740032
DEFINE  g_bookno1       LIKE aza_file.aza81      #No.FUN-740032
DEFINE  g_bookno2       LIKE aza_file.aza82      #No.FUN-740032
DEFINE  g_flag          LIKE type_file.chr1      #No.FUN-740032
DEFINE  g_msg           LIKE type_file.chr1000   #FUN-930164 add
DEFINE  g_msg2          LIKE type_file.chr1000   #FUN-930164 add
DEFINE  g_flag_09       LIKE type_file.chr1      #FUN-930164 add
DEFINE  g_flag_05       LIKE type_file.chr1      #FUN-930164 add
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0095
    DEFINE
    p_row,p_col         LIKE type_file.num5      #No.FUN-680123 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
#  LET g_ooz.ooz00='0' INSERT INTO ooz_file VALUES(g_ooz.*)
   OPEN WINDOW s010_w AT p_row,p_col 
     WITH FORM "axr/42f/axrs010"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   #No.FUN-580096  --begin                                                      
   CALL cl_set_comp_visible("ooz64",g_aza.aza26<>'2')                           
   IF cl_null(g_ooz.ooz64) THEN LET g_ooz.ooz64='N' END IF                      
   #No.FUN-580096  --end 
 
   IF cl_null(g_ooz.ooz65) THEN LET g_ooz.ooz65 = 'N' END IF  #No.FUN-670026 
   IF cl_null(g_ooz.ooz32) THEN LET g_ooz.ooz32 = 'N' END IF  #FUN-C60033
   #No.FUN-670047  --begin
   IF g_aza.aza63 = 'Y' THEN
      CALL cl_set_comp_visible("ooz02c",TRUE)
   ELSE                           
      CALL cl_set_comp_visible("ooz02c",FALSE)
   END IF
   #No.FUN-670047  --end

   #FUN-C60033---ADD--STR
   IF g_aza.aza26='2' THEN 
      CALL cl_set_comp_visible("ooz32",TRUE)
   ELSE
      CALL cl_set_comp_visible("ooz32",FALSE)
   END IF
   #FUN-C60033--ADD--END
   #FUN-C90105 add --str
   IF g_aza.aza26 != '2' THEN
      LET g_ooz.ooz33 = 'Y' 
      CALL cl_set_comp_visible("ooz33",FALSE)
   ELSE
      CALL cl_set_comp_visible("ooz33",TRUE)
   END IF 
  #FUN-C90105--add--end
 
  #CALL cl_set_comp_visible("ooz65",g_aza.aza26='2')   #MOD-870183 #CHI-C10018 mark
   CALL s010_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
   CALL s010_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
   CLOSE WINDOW s010_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN
 
FUNCTION s010_show()
 
   LET g_ooz_t.* = g_ooz.*
   LET g_ooz_o.* = g_ooz.*
#  DISPLAY BY NAME g_ooz.ooz01,g_ooz.ooz02,g_ooz.ooz02p,g_ooz.ooz02b,                #No.FUN-670047
   DISPLAY BY NAME g_ooz.ooz01,g_ooz.ooz02,g_ooz.ooz02p,g_ooz.ooz02b,g_ooz.ooz02c,   #No.FUN-670047
                   g_ooz.ooz03,g_ooz.ooz04,g_ooz.ooz09,g_ooz.ooz11,
                   g_ooz.ooz121,g_ooz.ooz122,g_ooz.ooz13,g_ooz.ooz16, 
                   #g_ooz.ooz17,g_ooz.ooz63,g_ooz.ooz10,g_ooz.ooz18,   #FUN-650076
                   g_ooz.ooz17,g_ooz.ooz63,g_ooz.ooz10,   #FUN-650076
                   g_ooz.ooz19,g_ooz.ooz20,g_ooz.ooz64,g_ooz.ooz65,g_ooz.ooz33,g_ooz.ooz32,g_ooz.ooz08, #No.FUN-670026 add ooz65  #FUN-C60033 ADD--ooz32#FUN-C90105 add ooz33
                   g_ooz.ooz21,g_ooz.ooz22,
                   g_ooz.ooz26,                           #FUN-A40076 Add 
                   g_ooz.ooz27,g_ooz.ooz28,g_ooz.ooz30,g_ooz.ooz29,  #FUN-A40076 Add   #No.FUN-AA0088 add ooz29 #FUN-C20018 add ooz30
                   g_ooz.ooz23,g_ooz.ooz24,
                   g_ooz.ooz62,g_ooz.ooz07,g_ooz.ooz66,g_ooz.ooz05,g_ooz.ooz06,   #FUN-920210 add ooz66
                   g_ooz.ooz15,
                   g_ooz.oozud01,g_ooz.oozud02,g_ooz.oozud03,g_ooz.oozud04,g_ooz.oozud05,      #FUN-B50039
                   g_ooz.oozud06,g_ooz.oozud07,g_ooz.oozud08,g_ooz.oozud09,g_ooz.oozud10,      #FUN-B50039
                   g_ooz.oozud11,g_ooz.oozud12,g_ooz.oozud13,g_ooz.oozud14,g_ooz.oozud15       #FUN-B50039
                   
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
 
   MENU ""
      ON ACTION modify 
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN 
            CALL s010_u()
         END IF
      ON ACTION reopen
         LET g_action_choice="reopen"
         IF cl_chk_act_auth() THEN
            CALL s010_y()
         END IF
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #EXIT MENU
      ON ACTION exit
           LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg    
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
           LET g_action_choice = "exit"
         CONTINUE MENU
 
       -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION s010_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_forupd_sql = "SELECT * FROM ooz_file      ",
                     " WHERE ooz00 = '0' FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ooz_curl CURSOR FROM g_forupd_sql
 
   BEGIN WORK
   OPEN ooz_curl 
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   FETCH ooz_curl INTO g_ooz.*
   IF STATUS THEN
      CALL cl_err('',STATUS,0)
      RETURN
   END IF
 
   WHILE TRUE
      CALL s010_i()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_ooz.* = g_ooz_t.*
         CALL s010_show()
         EXIT WHILE
      END IF
 
      UPDATE ooz_file SET * = g_ooz.* WHERE ooz00='0'
      IF STATUS THEN
#        CALL cl_err('',STATUS,0)   #No.FUN-660116
         CALL cl_err3("upd","ooz_file","","",STATUS,"","",0)   #No.FUN-660116
         CONTINUE WHILE
     #FUN-930164---add---str---
      ELSE   
         IF g_flag_09='Y' THEN 
            LET g_errno = TIME
            LET g_msg = 'old:',g_ooz_t.ooz09,' new:',g_ooz.ooz09
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980011 add
               VALUES ('axrs010',g_user,g_today,g_errno,'ooz09',g_msg,g_plant,g_legal)   #FUN-980011 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azo_file","axrs010","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
         END IF 
         IF g_flag_05='Y' THEN 
            LET g_errno = TIME
            LET g_msg = 'old:',g_ooz_t.ooz05,'/',g_ooz_t.ooz06,
                        ' new:',g_ooz.ooz05,'/',g_ooz.ooz06
            LET g_msg2= 'ooz05', ',' ,'ooz06'
            INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980011 add
               VALUES ('axrs010',g_user,g_today,g_errno,g_msg2,g_msg,g_plant,g_legal)    #FUN-980011 add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azo_file","axrs010","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
         END IF 
      #FUN-930164---add---end---
      END IF
 
     #CLOSE ooz_curl    #TQC-960168 mark 
     #COMMIT WORK       #TQC-960168 mark   
      EXIT WHILE
   END WHILE
   CLOSE ooz_curl    #TQC-960168 add 
   COMMIT WORK       #TQC-960168 add   
 
END FUNCTION
 
FUNCTION s010_i()
   DEFINE   l_aza   LIKE type_file.chr1      #No.FUN-680123 VARCHAR(01)
   DEFINE   l_n     LIKE type_file.num5      #No.FUN-680123 SMALLINT
   DEFINE   l_dbs   LIKE type_file.chr21     #No.FUN-740032
   DEFINE   l_plant LIKE type_file.chr10     #No.FUN-980020
   DEFINE   li_chk_bookno  LIKE type_file.num5,      #No.FUN-680123 SMALLINT,   #No.FUN-670006
            l_sql          STRING                    #No.FUN-670006  -add
   DEFINE   l_ooyacti      LIKE ooy_file.ooyacti     #No.TQC-770025
   DEFINE   l_i     LIKE type_file.num5              #No.TQC-B60067
   DEFINE   l_ooz   LIKE type_file.num5              #No.TQC-B60067
   DEFINE   l_ooz2    STRING                         #No.TQC-B60067
   DEFINE   l_ooytype  LIKE ooy_file.ooytype         #FUN-C20018
   DEFINE   l_type  LIKE type_file.chr1      #No.MOD-D40225 add

#  INPUT BY NAME g_ooz.ooz01,g_ooz.ooz02,g_ooz.ooz02p,g_ooz.ooz02b,               #No.FUN-670047
   INPUT BY NAME g_ooz.ooz01,g_ooz.ooz02,g_ooz.ooz02p,g_ooz.ooz02b,g_ooz.ooz02c,  #No.FUN-670047  
                 g_ooz.ooz03,g_ooz.ooz04,g_ooz.ooz09,g_ooz.ooz11,
                 g_ooz.ooz121,g_ooz.ooz122,g_ooz.ooz13,g_ooz.ooz17,
                 g_ooz.ooz63,g_ooz.ooz10,g_ooz.ooz08,g_ooz.ooz16,
                 #g_ooz.ooz18,g_ooz.ooz19,g_ooz.ooz20,g_ooz.ooz64,   #FUN-650076
                 g_ooz.ooz19,g_ooz.ooz20,g_ooz.ooz64,g_ooz.ooz65,   #FUN-650076 #No.FUN-670026 add ooz65
                 g_ooz.ooz33,                                       #FUN-C90105 add
                 g_ooz.ooz32,g_ooz.ooz21,g_ooz.ooz22,               #FUN-C60033--add--ooz32  
                 g_ooz.ooz26,                                       #FUN-A40076 Add
                 g_ooz.ooz27,g_ooz.ooz28,g_ooz.ooz30,g_ooz.ooz29,  #FUN-A40076 Add FUN-AA0088 add ooz29 #FUN-C20018 add ooz30
                 g_ooz.ooz23,g_ooz.ooz24,
                 g_ooz.ooz62,g_ooz.ooz05,g_ooz.ooz06,g_ooz.ooz07,
                 g_ooz.ooz66,                                        #FUN-920210 add ooz66
                 g_ooz.ooz15,
                 g_ooz.oozud01,g_ooz.oozud02,g_ooz.oozud03,g_ooz.oozud04,g_ooz.oozud05,      #FUN-B50039
                 g_ooz.oozud06,g_ooz.oozud07,g_ooz.oozud08,g_ooz.oozud09,g_ooz.oozud10,      #FUN-B50039
                 g_ooz.oozud11,g_ooz.oozud12,g_ooz.oozud13,g_ooz.oozud14,g_ooz.oozud15       #FUN-B50039
       WITHOUT DEFAULTS 
 
      BEFORE INPUT         #FUN-930164 add
        LET g_flag_09='N'     #FUN-930164 add
        LET g_flag_05='N'     #FUN-930164 add
        CALL cl_set_doctype_format("ooz21")      #No.TQC-B60067 add
        CALL cl_set_doctype_format("ooz22")      #No.TQC-B60067 add
        CALL cl_set_doctype_format("ooz26")      #No.TQC-B60067 add
 
      AFTER FIELD ooz01
         IF NOT cl_null(g_ooz.ooz01) THEN
            IF g_ooz.ooz01 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz01=g_ooz_o.ooz01
               DISPLAY BY NAME g_ooz.ooz01
               NEXT FIELD ooz01
            END IF
         END IF
         LET g_ooz_o.ooz01=g_ooz.ooz01
 
      AFTER FIELD ooz02
         IF NOT cl_null(g_ooz.ooz02) THEN
            IF g_ooz.ooz02 NOT MATCHES "[YN]" THEN
               LET g_ooz.ooz02=g_ooz_o.ooz02
               DISPLAY BY NAME g_ooz.ooz02
               NEXT FIELD ooz02
            END IF
         END IF
         LET g_ooz_o.ooz02=g_ooz.ooz02
#MOD-5B0018
         CALL cl_set_comp_entry("ooz02p,ooz02b,ooz02c",TRUE)     #No.FUN-670047
         IF g_ooz.ooz02='N' THEN
            CALL cl_set_comp_entry("ooz02p,ooz02b,ooz02c",FALSE) #No.FUN-670047
            LET g_ooz.ooz02p=''
            LET g_ooz.ooz02b=''
            LET g_ooz.ooz02c=''     #No.FUN-670047
            DISPLAY BY NAME g_ooz.ooz02p,g_ooz.ooz02b,g_ooz.ooz02c   #No.FUN-670047
         END IF
#END MOD-5B0018
 
      AFTER FIELD ooz02p
         IF NOT cl_null(g_ooz.ooz02p) THEN
            #FUN-990031--mod--str--營運中心要控制在當前法人下
            #SELECT COUNT(*) INTO g_cnt FROM azp_file
            # WHERE azp01 = g_ooz.ooz02p
            SELECT COUNT(*) INTO g_cnt FROM azw_file WHERE azw01 = g_ooz.ooz02p
               AND azw02 = g_legal
            #FUN-990031--mod--end
            IF g_cnt = 0 THEN
               #CALL cl_err('',100,0)   
               CALL cl_err('sel_azw','agl-171',0) #FUN-990031
               LET g_ooz.ooz02p=g_ooz_o.ooz02p
               DISPLAY BY NAME g_ooz.ooz02p
               NEXT FIELD ooz02p
            END IF
         END IF
         #No.FUN-740032  --Begin
         LET l_plant = g_ooz.ooz02p                 #FUN-980020
         LET l_dbs = NULL
         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_ooz.ooz02p
         LET t_dbss = l_dbs
         LET l_dbs = s_dbstring(l_dbs CLIPPED)   #FUN-9B0106 
#        CALL s_get_bookno1(NULL,l_dbs)             #FUN-980020 mark
         CALL s_get_bookno1(NULL,l_plant)           #FUN-980020
              RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag =  '1' THEN  #抓不到帳別
#           CALL cl_err(l_dbs,'aoo-081',1)          #FUN-980020 mark
            CALL cl_err(l_plant,'aoo-081',1)        #FUN-980020
            NEXT FIELD ooz02p
         END IF
         #No.FUN-740032  --End  
         LET g_ooz_o.ooz02p=g_ooz.ooz02p
 
      AFTER FIELD ooz02b
         IF NOT cl_null(g_ooz.ooz02b) THEN
            IF g_ooz.ooz02b <> g_ooz.ooz02c OR cl_null(g_ooz.ooz02c) THEN
               #No.FUN-670006--begin
                CALL s_check_bookno(g_ooz.ooz02b,g_user,g_ooz.ooz02p) 
                     RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                     NEXT FIELD ooz02b
                END IF 
                LET g_plant_new = g_ooz.ooz02p #工廠編號 
                    #CALL s_getdbs()           #FUN-A50102
                    LET l_sql = "SELECT COUNT(*)",
                                #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                                "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                                " WHERE aaa01 = '",g_ooz.ooz02b,"' ",
                                "   AND aaaacti IN ('Y','y') "
 	                CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                    PREPARE s010_pre2 FROM l_sql
                    DECLARE s010_cur2 CURSOR FOR s010_pre2
                    OPEN s010_cur2
                    FETCH s010_cur2 INTO g_cnt
#               SELECT COUNT(*) INTO g_cnt FROM aaa_file
#                WHERE aaa01 = g_ooz.ooz02b
               #No.FUN-670006--end
               IF g_cnt = 0 THEN
                  CALL cl_err('',100,0)
                  LET g_ooz.ooz02b=g_ooz_o.ooz02b
                  DISPLAY BY NAME g_ooz.ooz02b
                  NEXT FIELD ooz02b
               END IF
            ELSE
               IF g_aza.aza63 = 'Y' AND g_ooz.ooz02b = g_ooz.ooz02c THEN  #No.MOD-A40079 add
                  CALL cl_err(g_ooz.ooz02c,'axr-090',0)
                  NEXT FIELD ooz02b
               END IF                                                     #No.MOD-A40079 add
            END IF
            #No.FUN-740032  --Begin
            IF g_ooz.ooz02b <> g_bookno1 THEN
               CALL cl_err(g_ooz.ooz02b,"axc-531",1)
            END IF
            #No.FUN-740032  --End  
         END IF
         LET g_ooz_o.ooz02b=g_ooz.ooz02b
 
      #No.FUN-670047 --begin
      AFTER FIELD ooz02c
         IF NOT cl_null(g_ooz.ooz02c) THEN
            IF g_ooz.ooz02c <> g_ooz.ooz02b OR cl_null(g_ooz.ooz02b) THEN
               CALL s_check_bookno(g_ooz.ooz02c,g_user,g_ooz.ooz02p) 
                    RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                    NEXT FIELD ooz02c
               END IF 
               LET g_plant_new = g_ooz.ooz02p #工廠編號 
                  # CALL s_getdbs()           #FUN-A50102
                   LET l_sql = "SELECT COUNT(*)",
                               #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",
                               "  FROM ",cl_get_target_table(g_plant_new,'aaa_file'), #FUN-A50102
                               " WHERE aaa01 = '",g_ooz.ooz02c,"' ",
                               "   AND aaaacti IN ('Y','y') "
 	               CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                   CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
                   PREPARE s010_pre3 FROM l_sql
                   DECLARE s010_cur3 CURSOR FOR s010_pre3
                   OPEN s010_cur3
                   FETCH s010_cur3 INTO g_cnt
               IF g_cnt = 0 THEN
                  CALL cl_err('',100,0)
                  LET g_ooz.ooz02c=g_ooz_o.ooz02c
                  DISPLAY BY NAME g_ooz.ooz02c
                  NEXT FIELD ooz02c
               END IF
            ELSE
               CALL cl_err(g_ooz.ooz02c,'axr-090',0)
               NEXT FIELD ooz02c
            END IF
            #No.FUN-740032  --Begin
            IF g_ooz.ooz02c <> g_bookno2 THEN
               CALL cl_err(g_ooz.ooz02c,"axc-531",1)
            END IF
            #No.FUN-740032  --End  
         END IF
         LET g_ooz_o.ooz02c=g_ooz.ooz02c
      #No.FUN-670047 --end
 
      AFTER FIELD ooz03
         IF NOT cl_null(g_ooz.ooz03) THEN
            IF g_ooz.ooz03 NOT MATCHES "[YN]" THEN
               LET g_ooz.ooz03=g_ooz_o.ooz03
               DISPLAY BY NAME g_ooz.ooz03
               NEXT FIELD ooz03
            END IF
         END IF
         LET g_ooz_o.ooz03=g_ooz.ooz03
 
      AFTER FIELD ooz04
         IF NOT cl_null(g_ooz.ooz04) THEN
            IF g_ooz.ooz04 NOT MATCHES "[YN]" THEN
               LET g_ooz.ooz04=g_ooz_o.ooz04
               DISPLAY BY NAME g_ooz.ooz04
               NEXT FIELD ooz04
            END IF
         END IF
         LET g_ooz_o.ooz04=g_ooz.ooz04
 
      AFTER FIELD ooz09
         LET g_ooz_o.ooz09=g_ooz.ooz09
        #FUN-930164---add---str---
         IF g_ooz.ooz09 <> g_ooz_t.ooz09 THEN 
            LET g_flag_09='Y'
         END IF
        #FUN-930164---add---end---
 
      AFTER FIELD ooz11
         IF NOT cl_null(g_ooz.ooz11) THEN
            IF g_ooz.ooz11 NOT MATCHES '[YN]' then
               NEXT FIELD ooz11
            END IF
         END IF
  
      AFTER FIELD ooz121
         LET g_ooz_o.ooz121=g_ooz.ooz121
         #No.TQC-790064---Begin
         IF g_ooz_o.ooz121<= 0 THEN 
            CALL cl_err(g_ooz_o.ooz121,'axr-957',0)     
            NEXT FIELD ooz121
         END IF
         #No.TQC-790064---End
      AFTER FIELD ooz122
         LET g_ooz_o.ooz122=g_ooz.ooz122
         #No.TQC-790064---Begin                                                 
         IF g_ooz_o.ooz122 <= 0 THEN                                             
            CALL cl_err(g_ooz_o.ooz122,'axr-957',0) 
            NEXT FIELD ooz122                                                      
         END IF                                                                 
         #No.TQC-790064---End     
      AFTER FIELD ooz13
         IF NOT cl_null(g_ooz.ooz13) THEN
            IF g_ooz.ooz13 NOT MATCHES "[1-3]" THEN
               LET g_ooz.ooz13=g_ooz_o.ooz13
               DISPLAY BY NAME g_ooz.ooz13
               NEXT FIELD ooz13
            END IF
         END IF
         LET g_ooz_o.ooz13=g_ooz.ooz13
    
      AFTER FIELD ooz16
         IF NOT cl_null(g_ooz.ooz16) THEN
            IF g_ooz.ooz16 NOT MATCHES "[YyNn]"  THEN
               LET g_ooz.ooz16=g_ooz_o.ooz16
               DISPLAY BY NAME g_ooz.ooz16
               NEXT FIELD ooz16
            END IF
         END IF
         LET g_ooz_o.ooz16=g_ooz.ooz16 
 
      AFTER FIELD ooz17
         IF NOT cl_null(g_ooz.ooz17) THEN
            IF g_ooz.ooz17 NOT MATCHES '[BSMCD]' THEN #FUN-640029 add M
               LET g_ooz.ooz17=g_ooz_o.ooz17
               DISPLAY BY NAME g_ooz.ooz17
               NEXT FIELD ooz17
            END IF
         END IF
         LET g_ooz_o.ooz17=g_ooz.ooz17
 
      AFTER FIELD ooz63
         IF NOT cl_null(g_ooz.ooz63) THEN
            IF g_ooz.ooz63 NOT MATCHES '[BSMCD]' THEN #FUN-640029 add M
               LET g_ooz.ooz63=g_ooz_o.ooz63
               DISPLAY BY NAME g_ooz.ooz63
               NEXT FIELD ooz63
            END IF
         END IF
         LET g_ooz_o.ooz63=g_ooz.ooz63
 
      AFTER FIELD ooz10
         IF NOT cl_null(g_ooz.ooz10) THEN
            IF g_ooz.ooz10 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz10=g_ooz_o.ooz10
               DISPLAY BY NAME g_ooz.ooz10
               NEXT FIELD ooz10
            END IF
         END IF
         LET g_ooz_o.ooz10=g_ooz.ooz10
    
      #-----FUN-650076---------
      #AFTER FIELD ooz18
      #   IF NOT cl_null(g_ooz.ooz18) THEN
      #      IF g_ooz.ooz18 NOT MATCHES '[YN]'  THEN
      #         LET g_ooz.ooz18=g_ooz_o.ooz18
      #         DISPLAY BY NAME g_ooz.ooz18
      #         NEXT FIELD ooz18
      #      END IF
      #   END IF
      #   LET g_ooz_o.ooz18=g_ooz.ooz18
      #-----END FUN-650076-----
 
      AFTER FIELD ooz19
         IF NOT cl_null(g_ooz.ooz19) THEN
            IF g_ooz.ooz19 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz19=g_ooz_o.ooz19
               DISPLAY BY NAME g_ooz.ooz19
               NEXT FIELD ooz19
            END IF
         END IF
         LET g_ooz_o.ooz19=g_ooz.ooz19
 
      AFTER FIELD ooz20
         IF NOT cl_null(g_ooz.ooz20) THEN
            IF g_ooz.ooz20 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz20=g_ooz_o.ooz20
               DISPLAY BY NAME g_ooz.ooz20
               NEXT FIELD ooz20
            END IF
         END IF
         LET g_ooz_o.ooz20=g_ooz.ooz20
 
      AFTER FIELD ooz08
         IF NOT cl_null(g_ooz.ooz08) THEN
            SELECT *  FROM ool_file WHERE ool01 = g_ooz.ooz08
            IF STATUS THEN 
#              CALL cl_err('select ool:',STATUS,0)   #No.FUN-660116
               CALL cl_err3("sel","ool_file",g_ooz.ooz08,"",STATUS,"","select ool:",0)   #No.FUN-660116
               NEXT FIELD ooz08
            END IF
         END IF
 
      AFTER FIELD ooz64
         IF NOT cl_null(g_ooz.ooz64) THEN
            IF g_ooz.ooz64 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz64=g_ooz_o.ooz64
               DISPLAY BY NAME g_ooz.ooz64
               NEXT FIELD ooz64
            END IF
         END IF
         LET g_ooz_o.ooz64=g_ooz.ooz64
 
#No.FUN-670026  --start--
      AFTER FIELD ooz65
         IF NOT cl_null(g_ooz.ooz65) THEN
            IF g_ooz.ooz65 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz65 = g_ooz_o.ooz65
               DISPLAY BY NAME g_ooz.ooz65
               NEXT FIELD ooz65
            END IF
            IF g_ooz.ooz62 = 'Y' AND g_ooz.ooz65 = 'Y' THEN
               CALL cl_err('','ooz-001',1)
               LET g_ooz.ooz65 = 'N'
            END IF   
         END IF
         LET g_ooz_o.ooz65 = g_ooz.ooz65
#No.FUN-670026  --end--
#FUN-C60033--ADD---STR
      AFTER FIELD ooz32
         IF NOT cl_null(g_ooz.ooz32) THEN
            IF g_ooz.ooz32 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz32 = g_ooz_o.ooz32
               DISPLAY BY NAME g_ooz.ooz32
               NEXT FIELD ooz32
            END IF
          END IF
          LET g_ooz_o.ooz32 = g_ooz.ooz32
#FUN-C60033--ADD--END 
      AFTER FIELD ooz21    #預收單別
         IF NOT cl_null(g_ooz.ooz21) THEN
            #No.TQC-770025 --start--
            LET l_ooyacti = NULL
            SELECT ooyacti INTO l_ooyacti FROM ooy_file
             WHERE ooyslip = g_ooz.ooz21
            IF l_ooyacti <> 'Y' THEN
               CALL cl_err(g_ooz.ooz21,'axr-956',1)
               NEXT FIELD ooz21
            END IF
            #No.TQC-770025 --end--
            SELECT COUNT(*) INTO l_n FROM ooy_file 
             WHERE ooyslip = g_ooz.ooz21 AND ooytype='23'
            IF l_n = 0  THEN 
               CALL cl_err('sel_ooy_1','mfg3046',0)
               LET g_ooz.ooz21=g_ooz_o.ooz21
               NEXT FIELD ooz21
            END IF
            #No.TQC-B60067--add--
            LET l_ooz2=g_ooz.ooz21
            LET l_ooz=l_ooz2.getlength() 
            IF l_ooz=g_doc_len THEN
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(g_ooz.ooz21[l_i,l_i]) THEN
                     CALL cl_err(g_ooz.ooz21,'sub-146',0)
                     LET g_ooz.ooz21=g_ooz_o.ooz21
                     NEXT FIELD ooz21 
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_ooz.ooz21,'sub-146',0)
               LET g_ooz.ooz21=g_ooz_o.ooz21
               NEXT FIELD ooz21
            END IF
            #No.TQC-B60067--end-- 
         END IF
         LET g_ooz_o.ooz21=g_ooz.ooz21
 
      AFTER FIELD ooz22   #溢收單別
         IF NOT cl_null(g_ooz.ooz22) THEN
            #No.TQC-770025 --start--
            LET l_ooyacti = NULL
            SELECT ooyacti INTO l_ooyacti FROM ooy_file
             WHERE ooyslip = g_ooz.ooz22
            IF l_ooyacti <> 'Y' THEN
               CALL cl_err(g_ooz.ooz22,'axr-956',1)
               NEXT FIELD ooz22
            END IF
            #No.TQC-770025 --end--
            SELECT COUNT(*) INTO l_n FROM ooy_file 
             WHERE ooyslip=g_ooz.ooz22 AND ooytype='24'
            IF l_n = 0  THEN 
               CALL cl_err('sel_ooy_2','mfg3046',0)
               LET g_ooz.ooz22=g_ooz_o.ooz22
               NEXT FIELD ooz22
            END IF
            #No.TQC-B60067--add--
            LET l_ooz2=g_ooz.ooz22
            LET l_ooz=l_ooz2.getlength()
            IF l_ooz=g_doc_len THEN
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(g_ooz.ooz22[l_i,l_i]) THEN
                     CALL cl_err(g_ooz.ooz22,'sub-146',0)
                     LET g_ooz.ooz22=g_ooz_o.ooz22
                     NEXT FIELD ooz22
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_ooz.ooz22,'sub-146',0)
               LET g_ooz.ooz22=g_ooz_o.ooz22
               NEXT FIELD ooz22
            END IF
            #No.TQC-B60067--end-- 
         END IF 
         LET g_ooz_o.ooz22=g_ooz.ooz22

#FUN-A40076--Add--Begin
      AFTER FIELD ooz26
         IF NOT cl_null(g_ooz.ooz26) THEN
            LET l_ooyacti = NULL
            SELECT ooyacti INTO l_ooyacti FROM ooy_file
             WHERE ooyslip = g_ooz.ooz26
            IF l_ooyacti <> 'Y' THEN
               CALL cl_err(g_ooz.ooz26,'axr-956',1)
               NEXT FIELD ooz26
            END IF
            SELECT COUNT(*) INTO l_n FROM ooy_file 
             WHERE ooyslip=g_ooz.ooz26 AND ooytype='14'
            IF l_n = 0  THEN 
               CALL cl_err('sel_ooy_2','mfg3046',0)
               LET g_ooz.ooz26=g_ooz_o.ooz26
               NEXT FIELD ooz26
            END IF
            #No.TQC-B60067--add--
           #MOD-D40225--add--str--根據ooz29判斷ooydmy1是N還是Y
            CALL s010_chk_ooz29() RETURNING l_type
            IF l_type = '1' THEN NEXT FIELD ooz26 END IF
            IF l_type = '2' THEN NEXT FIELD ooz30 END IF
           #MOD-D40225--add--end
            LET l_ooz2=g_ooz.ooz26
            LET l_ooz=l_ooz2.getlength()
            IF l_ooz=g_doc_len THEN
               FOR l_i = 1 TO g_doc_len
                  IF cl_null(g_ooz.ooz26[l_i,l_i]) THEN
                     CALL cl_err(g_ooz.ooz26,'sub-146',0)
                     LET g_ooz.ooz26=g_ooz_o.ooz26
                     NEXT FIELD ooz26
                  END IF
               END FOR
            ELSE
               CALL cl_err(g_ooz.ooz26,'sub-146',0)
               LET g_ooz.ooz26=g_ooz_o.ooz26
               NEXT FIELD ooz26
            END IF
            #No.TQC-B60067--end-- 
         END IF 
         LET g_ooz_o.ooz26=g_ooz.ooz26 
                     
      AFTER FIELD ooz27 
         IF NOT cl_null(g_ooz.ooz27) THEN 
            IF g_ooz.ooz27 != g_ooz_t.ooz27 OR g_ooz_t.ooz27 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM ooc_file WHERE ooc01 = g_ooz.ooz27
               IF l_n =0 THEN
                  CALL cl_err(g_ooz.ooz27,"aap-974",1)
                  LET g_ooz.ooz27 = g_ooz_o.ooz27
                  NEXT FIELD ooz27 
               END IF 
            END IF
         END IF 

      AFTER FIELD ooz28 
         IF NOT cl_null(g_ooz.ooz28) THEN 
            IF g_ooz.ooz28 != g_ooz_t.ooz28 OR g_ooz_t.ooz28 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM ool_file WHERE ool01 = g_ooz.ooz28
               IF l_n =0 THEN
                  CALL cl_err(g_ooz.ooz28,"axr-668",1)
                  LET g_ooz.ooz28 = g_ooz_o.ooz28
                  NEXT FIELD ooz28 
               END IF 
            END IF
         END IF           
#FUN-A40076--Add--End
#FUN-C20018--Add--Start
      AFTER FIELD ooz30
         IF NOT cl_null(g_ooz.ooz30) THEN
            IF g_ooz.ooz30!=g_ooz_t.ooz30 OR g_ooz_t.ooz30 IS NULL THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM ooy_file WHERE ooyslip=g_ooz.ooz30
               IF l_n=0 THEN
                  CALL cl_err(g_ooz.ooz30,"axr110",1)
                  LET g_ooz.ooz30=g_ooz_o.ooz30
                  NEXT FIELD ooz30
               END IF
               SELECT ooyacti,ooytype INTO l_ooyacti,l_ooytype FROM ooy_file 
                WHERE ooyslip=g_ooz.ooz30
               IF l_ooyacti!='Y' THEN
                  CALL cl_err(g_ooz.ooz30,"axr111",1)
                  LET g_ooz.ooz30=g_ooz_o.ooz30
                  NEXT FIELD ooz30
               END IF
               IF l_ooytype!='22' THEN
                  CALL cl_err(g_ooz.ooz30,"axr112",1)
                  LET g_ooz.ooz30=g_ooz_o.ooz30
                  NEXT FIELD ooz30
               END IF
            END IF
           #MOD-D40225--add--str--根據ooz29判斷ooydmy1是N還是Y
            CALL s010_chk_ooz29() RETURNING l_type
            IF l_type = '1' THEN NEXT FIELD ooz26 END IF
            IF l_type = '2' THEN NEXT FIELD ooz30 END IF
           #MOD-D40225--add--end
         END IF

#FUN-C20018--Add--End
#No.FUN-AA0088 --begin
      AFTER FIELD ooz29
         IF NOT cl_null(g_ooz.ooz29) THEN
            IF g_ooz.ooz29 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz29=g_ooz_o.ooz29
               DISPLAY BY NAME g_ooz.ooz29
               NEXT FIELD ooz29
            END IF
           #MOD-D40225--add--str
            CALL s010_chk_ooz29() RETURNING l_type
            IF l_type = '1' THEN NEXT FIELD ooz26 END IF
            IF l_type = '2' THEN NEXT FIELD ooz30 END IF
           #MOD-D40225--add--end
         END IF
         LET g_ooz_o.ooz29=g_ooz.ooz29
#No.FUN-AA0088 --end 
      AFTER FIELD ooz23
         IF NOT cl_null(g_ooz.ooz23) THEN
            IF g_ooz.ooz23 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz23=g_ooz_o.ooz23
               DISPLAY BY NAME g_ooz.ooz23
               NEXT FIELD ooz23
            END IF
         END IF
         LET g_ooz_o.ooz23=g_ooz.ooz23
 
      AFTER FIELD ooz24
         IF NOT cl_null(g_ooz.ooz24) THEN
            IF g_ooz.ooz24 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz24=g_ooz_o.ooz24
               DISPLAY BY NAME g_ooz.ooz24
               NEXT FIELD ooz24
            END IF
         END IF
         LET g_ooz_o.ooz24=g_ooz.ooz24
 
      AFTER FIELD ooz62
         IF NOT cl_null(g_ooz.ooz62) THEN
            IF g_ooz.ooz62 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz62=g_ooz_o.ooz62
               DISPLAY BY NAME g_ooz.ooz62
               NEXT FIELD ooz62
            END IF
#No.FUN-670026  --start--
            IF g_ooz.ooz62 = 'Y' AND g_ooz.ooz65 = 'Y' THEN
               CALL cl_err('','ooz-001',1)
               LET g_ooz.ooz62 = 'N'
            END IF   
#No.FUN-670026  --end--
         END IF
         LET g_ooz_o.ooz62=g_ooz.ooz62
 
      AFTER FIELD ooz07
         IF NOT cl_null(g_ooz.ooz07) THEN
            IF g_ooz.ooz07 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz07=g_ooz_o.ooz07
               DISPLAY BY NAME g_ooz.ooz07
               NEXT FIELD ooz07
            END IF
         END IF
         LET g_ooz_o.ooz07=g_ooz.ooz07
 
  #FUN-920210---add---start---
      AFTER FIELD ooz66
         IF NOT cl_null(g_ooz.ooz66) THEN
            IF g_ooz.ooz66 NOT MATCHES '[YN]' THEN
               LET g_ooz.ooz66=g_ooz_o.ooz66
               DISPLAY BY NAME g_ooz.ooz66
               NEXT FIELD ooz66
            END IF
         END IF
         LET g_ooz_o.ooz66=g_ooz.ooz66
  #FUN-920210---add---end---
 
      AFTER FIELD ooz05
         LET g_ooz_o.ooz05=g_ooz.ooz05
        #FUN-930164---add---str---
         IF g_ooz.ooz05 <> g_ooz_t.ooz05 THEN 
            LET g_flag_05='Y'
         END IF
        #FUN-930164---add---end---
 
      AFTER FIELD ooz06
         IF NOT cl_null(g_ooz.ooz06) THEN
            IF g_ooz.ooz06 < 1 OR g_ooz.ooz06 > 13 THEN
               LET g_ooz.ooz06=g_ooz_o.ooz06
               DISPLAY BY NAME g_ooz.ooz06
               NEXT FIELD ooz06
            END IF
         END IF
         LET g_ooz_o.ooz06=g_ooz.ooz06
        #FUN-930164---add---str---
         IF g_ooz.ooz06 <> g_ooz_t.ooz06 THEN 
            LET g_flag_05='Y'
         END IF
        #FUN-930164---add---end---
 
      AFTER FIELD ooz15
         IF NOT cl_null(g_ooz.ooz15) THEN
            IF g_ooz.ooz15 NOT MATCHES '[123]' THEN
               LET g_ooz.ooz15=g_ooz_o.ooz15
               DISPLAY BY NAME g_ooz.ooz15
               NEXT FIELD ooz15
            END IF
         END IF
         LET g_ooz_o.ooz15=g_ooz.ooz15
 
      #FUN-B50039-add-str--
      AFTER FIELD oozud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD oozud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ooz02p) 
               CALL cl_init_qry_var()
               #FUN-990031--add--str--
               #LET g_qryparam.form ='q_azp'
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.where = "azw02 = '",g_legal,"' " 
               #FUN-990031--add--end 
               LET g_qryparam.default1 =g_ooz.ooz02p 
               CALL cl_create_qry() RETURNING g_ooz.ooz02p
#               CALL FGL_DIALOG_SETBUFFER( g_ooz.ooz02p )
               DISPLAY BY NAME g_ooz.ooz02p
               NEXT FIELD ooz02p
            WHEN INFIELD(ooz02b)
               CALL cl_init_qry_var()
               #No.FUN-740032  --Begin
#              LET g_qryparam.form ='q_aaa' 
               LET g_qryparam.form ='q_m_aaa' 
#              LET g_qryparam.arg1 = t_dbss         #No.FUN-980025 mark  
               LET g_qryparam.plant = g_ooz.ooz02p  #No.FUN-980025add
               LET g_qryparam.default1 =g_ooz.ooz02b 
               #No.FUN-740032  --End  
               CALL cl_create_qry() RETURNING g_ooz.ooz02b
#               CALL FGL_DIALOG_SETBUFFER( g_ooz.ooz02b )
               DISPLAY BY NAME g_ooz.ooz02b
               NEXT FIELD ooz02b
            #No.FUN-670047 --begin
            WHEN INFIELD(ooz02c)
               CALL cl_init_qry_var()
               #No.FUN-740032  --Begin
#              LET g_qryparam.form ='q_aaa' 
               LET g_qryparam.form ='q_m_aaa' 
#              LET g_qryparam.arg1 = t_dbss         #No.FUN-980025 mark
               LET g_qryparam.plant = g_ooz.ooz02p  #No.FUN-980025add
               LET g_qryparam.default1 =g_ooz.ooz02c 
               #No.FUN-740032  --End  
               CALL cl_create_qry() RETURNING g_ooz.ooz02c
               DISPLAY BY NAME g_ooz.ooz02c
               NEXT FIELD ooz02c
            #No.FUN-670047 --end
            WHEN INFIELD(ooz08) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ='q_ool' 
               LET g_qryparam.default1 =g_ooz.ooz08 
               CALL cl_create_qry() RETURNING g_ooz.ooz08
#               CALL FGL_DIALOG_SETBUFFER( g_ooz.ooz08 )
               DISPLAY BY NAME g_ooz.ooz08
               NEXT FIELD ooz08
            WHEN INFIELD(ooz21) 
               #CALL q_ooy( FALSE, TRUE,g_ooz.ooz21,'23',g_sys) #TQC-670008
               CALL q_ooy( FALSE, TRUE,g_ooz.ooz21,'23','AXR')  #TQC-670008 
                    RETURNING g_ooz.ooz21
               DISPLAY BY NAME g_ooz.ooz21 
               NEXT FIELD ooz21
            WHEN INFIELD(ooz22) 
               #CALL q_ooy( FALSE, TRUE,g_ooz.ooz22,'24',g_sys) #TQC-670008
               CALL q_ooy( FALSE, TRUE,g_ooz.ooz22,'24','AXR')  #TQC-670008 
                    RETURNING g_ooz.ooz22
               DISPLAY BY NAME g_ooz.ooz22
               NEXT FIELD ooz22
            #FUN-A40076--Add--Begin   
            WHEN INFIELD(ooz26) 
               #MOD-D40225使用g_qryparam.where將ooydmy1的條件傳入q_ooy
               #          由於q_ooy使用的作業很多，如果直接加傳參數會可能會有漏改
               #          故此處使用q_qryparam.where傳入，同時在q_ooy修改where條件
               #          從而實現所需功能
               #MOD-D40225使用完成后清空g_qryparam.where
               LET g_qryparam.where = " ooydmy1 = '",g_ooz.ooz29,"'"#MOD-40225 add
               CALL q_ooy( FALSE, TRUE,g_ooz.ooz26,'14','AXR')
                    RETURNING g_ooz.ooz26
               DISPLAY BY NAME g_ooz.ooz26
               LET g_qryparam.where = ""#MOD-D40225
               NEXT FIELD ooz26 
            WHEN INFIELD(ooz27)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ooc1"
               LET g_qryparam.arg1 = g_bookno1   
               LET g_qryparam.default1 = g_ooz.ooz27
               CALL cl_create_qry() RETURNING g_ooz.ooz27
               NEXT FIELD ooz27
            WHEN INFIELD(ooz28)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ool01"
               LET g_qryparam.default1 = g_ooz.ooz28
               CALL cl_create_qry() RETURNING g_ooz.ooz28
               NEXT FIELD ooz28               
            #FUN-A40076--Add--End  
            #FUN-C20018--Add--Start
            WHEN INFIELD(ooz30)
              #MOD-D40225使用g_qryparam.where將ooydmy1的條件傳入q_ooy
               #          由於q_ooy使用的作業很多，如果直接加傳參數會可能會有漏改
               #          故此處使用q_qryparam.where傳入，同時在q_ooy修改where條件
               #          從而實現所需功能
               #MOD-D40225使用完成后清空g_qryparam.where
               LET g_qryparam.where = " ooydmy1 = '",g_ooz.ooz29,"'"#MOD-D40225 add
               CALL q_ooy(FALSE,TRUE,g_ooz.ooz30,'22','AXR') RETURNING g_ooz.ooz30
               DISPLAY BY NAME g_ooz.ooz30
               LET g_qryparam.where = ""#MOD-D40225
               NEXT FIELD ooz30  
            #FUN-C20018--Add--End
       END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
 
END FUNCTION
 
FUNCTION s010_y()
 DEFINE   l_ooz01 LIKE ooz_file.ooz01    #No.FUN-680123 VARCHAR(01)
     SELECT ooz01 INTO l_ooz01 FROM ooz_file WHERE ooz00='0'
     IF l_ooz01 = 'Y' THEN RETURN END IF
     UPDATE ooz_file SET ooz01='Y' WHERE ooz00='0'
     IF STATUS THEN
        LET g_ooz.ooz01='N'
#       CALL cl_err('upd ooz01:',STATUS,0)   #No.FUN-660116
        CALL cl_err3("upd","ooz_file","","",STATUS,"","upd ooz01:",0)   #No.FUN-660116
     ELSE
        LET g_ooz.ooz01='Y'
     END IF
     DISPLAY BY NAME g_ooz.ooz01 
END FUNCTION
#MOD-D40225--str
FUNCTION s010_chk_ooz29()
   DEFINE l_n LIKE type_file.num5

   LET l_n = 0
   IF NOT cl_null(g_ooz.ooz26) THEN
      SELECT COUNT(*) INTO l_n FROM ooy_file
       WHERE ooyslip=g_ooz.ooz26
         AND ooydmy1 = g_ooz.ooz29
      IF l_n = 0 THEN
         IF g_ooz.ooz29 = 'N' THEN
            CALL cl_err(g_ooz.ooz26,'anm-036',0)
         ELSE
            CALL cl_err(g_ooz.ooz26,'anm-131',0)
         END IF
         RETURN '1'
      END IF
   END IF
   IF NOT cl_null(g_ooz.ooz30) THEN
      SELECT COUNT(*) INTO l_n FROM ooy_file
       WHERE ooyslip=g_ooz.ooz30
         AND ooydmy1 = g_ooz.ooz29
      IF l_n = 0 THEN
         IF g_ooz.ooz29 = 'N' THEN
            CALL cl_err(g_ooz.ooz30,'anm-036',0)
         ELSE
            CALL cl_err(g_ooz.ooz30,'anm-131',0)
         END IF
         RETURN '2'
      END IF
   END IF
   RETURN '0'
END FUNCTION
#MOD-D40225--end
