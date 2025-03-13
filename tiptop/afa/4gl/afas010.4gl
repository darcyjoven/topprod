# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afas010.4gl
# Descriptions...: 固定資產管理系統系統參數設定      
# Date & Author..: 96/04/18 By Sophia
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-480332 04/08/23 By Nicola 控管faa28在azz19為1時，只能輸入BS 
# Modify.........: No.FUN-580096 05/08/22 By Carrier aza26='2'時隱藏faa25
# Modify.........: No.FUN-640012 06/04/06 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.CHI-690048 06/10/03 By Sarah 當aza31(固定資產編號自動編碼否)為'Y'時,faa06(財編是否與序號一致)不可為'Y'
# Modify.........: No.FUN-690073 06/10/17 By Smapmin 資產序號為空白時,財產編號不可和序號一致
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740032 07/04/12 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.MOD-870039 08/07/03 By wujie 附號后開始流水碼不能大于等于4
# Modify.........: No.TQC-880025 08/08/19 By Sarah faa22預設值改為3
# Modify.........: No.MOD-880147 08/08/22 By Sarah 異動faa191前,先比對新舊值長度,若不相同則提示訊息不異動
# Modify.........: No.FUN-930164 09/04/15 By jamie update faa09、faa13成功時，寫入azo_file
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下 
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No:MOD-A70224 10/07/30 By Dido 當 aza19 = '1' 應可開放 faa28 維護銀行中價 
# Modify.........: No:TQC-B20015 10/02/10 By zhangll 增加faa27欄位可輸入性控管
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2)
# Modify.........: No:FUN-AB0088 11/04/02 By chenying 固定資產財簽二功能
# Modify.........: No.FUN-B50039 11/07/05 By fengrui 增加自定義欄位
# Modify.........: No:FUN-B60140 11/08/24 By xuxz "財簽二二次改善"追單

 
DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE
        g_faa_t         RECORD LIKE faa_file.*,  # 預留參數檔
        g_faa_o         RECORD LIKE faa_file.*   # 預留參數檔
    DEFINE g_forupd_sql STRING
    DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680070 SMALLINT
 
DEFINE  t_dbss          LIKE azp_file.azp03      #No.FUN-740032
DEFINE  g_bookno1       LIKE aza_file.aza81      #No.FUN-740032
DEFINE  g_bookno2       LIKE aza_file.aza82      #No.FUN-740032
DEFINE  g_flag          LIKE type_file.chr1      #No.FUN-740032
DEFINE  g_msg           LIKE type_file.chr1000   #FUN-930164 add
DEFINE  g_flag_09       LIKE type_file.chr1      #FUN-930164 add
DEFINE  g_flag_13       LIKE type_file.chr1      #FUN-930164 add
 
MAIN
#    DEFINE l_time      LIKE type_file.chr8         #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
    DEFINE p_row,p_col LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   LET p_row = 3 LET p_col = 4
   OPEN WINDOW s010_w AT p_row,p_col 
   WITH FORM "afa/42f/afas010" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
  #FUN-AB0088---mark----str--------------
  ##No.FUN-680028 --begin
  #IF g_aza.aza63 = 'Y' THEN
  #   CALL cl_set_comp_visible("faa02c",TRUE)
  #ELSE
  #   CALL cl_set_comp_visible("faa02c",FALSE)
  #END IF
  ##No.FUN-680028 --end
  #FUN-AB0088---mark----end-------------- 

   CALL s010_show()
   #No.FUN-580096  --begin                                                      
   CALL cl_set_comp_visible("faa25",g_aza.aza26<>'2')                           
   #No.FUN-580096  --end
 
#   IF g_aza.aza26 != '2' THEN  
#      CALL cl_set_comp_visible("faa29",FALSE)
#   END IF
#   #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL s010_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
   CLOSE WINDOW s010_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION s010_show()
 
    SELECT faa_file.* INTO g_faa.* FROM faa_file WHERE faa00 = '0'
    IF SQLCA.SQLCODE OR g_faa.faa01 IS NULL THEN
       LET g_faa.faa01   = 'Y'    LET g_faa.faa02p  = 'PLANT-1'
       LET g_faa.faa02b  = '00'         
       LET g_faa.faa19   = 'Y'    LET g_faa.faa191  = '0000000000' 
       LET g_faa.faa03   = 'Y'    LET g_faa.faa031  = '0000000000' 
       LET g_faa.faa04   = 'Y'    LET g_faa.faa05   = 'N'    
       LET g_faa.faa06   = 'Y'
       #No:7676
       LET g_faa.faa28   = 'S'
       LET g_faa.faa07   = 1996   LET g_faa.faa08   = 1 
       LET g_faa.faa09   = NULL
       LET g_faa.faa11   = 1996   LET g_faa.faa12   = 1
       LET g_faa.faa13   = NULL 
       LET g_faa.faa15   = '1'    LET g_faa.faa23   = 'N'
       LET g_faa.faa16   = 'N'    LET g_faa.faa17   = '0000'
       LET g_faa.faa18   = '0000' LET g_faa.faa20   = '2'
       LET g_faa.faa24   = 'Y'    LET g_faa.faa25   = 12
       LET g_faa.faa21   = 10     LET g_faa.faa22   = 3   #TQC-880025 4->3
       LET g_faa.faa26   = '2'    LET g_faa.faa27   = 0
       LET g_faa.faa29   = 'N'    LET g_faa.faa30   = 'N'       #No:A099
       LET g_faa.faa31   = 'N'    #FUN-AB0088 
       LET g_faa.faa152  = '1'    LET g_faa.faa232  = 'N'  #No:FUN-B60140
       LET g_faa.faa072  = 1996   LET g_faa.faa082  = 1   #No:FUN-B60140
       LET g_faa.faa092  = NULL  #No:FUN-B60140

       IF SQLCA.SQLCODE THEN
          INSERT INTO faa_file VALUES(g_faa.*)
          IF SQLCA.SQLCODE THEN
#            CALL cl_err('',SQLCA.sqlcode,0)    #No.FUN-660136
             CALL cl_err3("ins","faa_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660136
             RETURN
          END IF
       ELSE
          UPDATE faa_file SET faa_file.* = g_faa.* 
              WHERE faa00 = '0' 
          IF SQLCA.SQLCODE THEN
#            CALL cl_err('',SQLCA.sqlcode,0)    #No.FUN-660136
             CALL cl_err3("upd","faa_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660136
             RETURN
         #FUN-930164---add---str---
          ELSE 
             IF g_flag_09='Y' THEN 
                LET g_errno = TIME
                LET g_msg = 'old:',g_faa_t.faa09,' new:',g_faa.faa09
                INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06, azoplant,azolegal) #FUN-980003 add
                   VALUES ('afas010',g_user,g_today,g_errno,'faa09',g_msg, g_plant,g_legal)   #FUN-980003 add
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","azo_file","afas010","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                   RETURN
                END IF
             END IF 
             IF g_flag_13='Y' THEN 
                LET g_errno = TIME
                LET g_msg = 'old:',g_faa_t.faa13,' new:',g_faa.faa13
                INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06, azoplant,azolegal) #FUN-980003 add
                   VALUES ('afas010',g_user,g_today,g_errno,'faa13',g_msg, g_plant,g_legal)   #FUN-980003 add
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","azo_file","afas010","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                   RETURN
                END IF
             END IF 
         #FUN-930164---add---end---
          END IF
       END IF
    END IF
    DISPLAY BY NAME g_faa.faa01,g_faa.faa02p,g_faa.faa02b,g_faa.faa02c,     #No.FUN-680028
                    g_faa.faa19,g_faa.faa191,g_faa.faa03,g_faa.faa031,
                    #No:7676
                    g_faa.faa04,g_faa.faa05 ,g_faa.faa06,g_faa.faa28,
                    g_faa.faa16,g_faa.faa17 ,g_faa.faa18,
                    g_faa.faa20,g_faa.faa24,g_faa.faa21 ,g_faa.faa22,
                    g_faa.faa15,g_faa.faa23 ,g_faa.faa07 ,g_faa.faa08,
                    g_faa.faa09,g_faa.faa11,g_faa.faa12,g_faa.faa13,
                    g_faa.faa25,g_faa.faa26,g_faa.faa27,
                    g_faa.faa29,g_faa.faa30,      #No:A099          
                    g_faa.faa31,g_faa.faa152,g_faa.faa232 ,   #No:FUN-AB0088  #No:FUN-B60140 add faa152,faa232
                    g_faa.faa072 ,g_faa.faa082, g_faa.faa092,  #No:FUN-B60140
                    #FUN-B50039-add-str--
                    g_faa.faaud01,g_faa.faaud02,g_faa.faaud03,g_faa.faaud04,
                    g_faa.faaud05,g_faa.faaud06,g_faa.faaud07,g_faa.faaud08,
                    g_faa.faaud09,g_faa.faaud10,g_faa.faaud11,g_faa.faaud12,
                    g_faa.faaud13,g_faa.faaud14,g_faa.faaud15
                    #FUN-B50039-add-end--
                    
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s010_menu()
    MENU ""
       ON ACTION modify 
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
             CALL s010_u()
          END IF 
       ON ACTION reset 
          LET g_action_choice="reset"
          IF cl_chk_act_auth() THEN
             CALL s010_y()
          END IF
       ON ACTION help
          CALL cl_show_help()
   
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
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
    LET g_forupd_sql = "SELECT * FROM faa_file WHERE faa00 = '0' FOR UPDATE"
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE faa_curl CURSOR FROM g_forupd_sql
    BEGIN WORK
    OPEN faa_curl
    IF STATUS  THEN CALL cl_err('OPEN faa_curl',STATUS,1) RETURN END IF
    FETCH faa_curl INTO g_faa.*
    IF STATUS  THEN CALL cl_err('',STATUS,0) RETURN END IF
    LET g_faa_t.* = g_faa.*
    LET g_faa_o.* = g_faa.*
    DISPLAY BY NAME g_faa.faa01,g_faa.faa02p,g_faa.faa02b,g_faa.faa02c,     #No.FUN-680028
                    g_faa.faa19,g_faa.faa191,g_faa.faa03,g_faa.faa031,
                    #No:7676
                    g_faa.faa04,g_faa.faa05 ,g_faa.faa06,g_faa.faa28,
                    g_faa.faa16,g_faa.faa17 ,g_faa.faa18,
                    g_faa.faa20,g_faa.faa24,g_faa.faa21 ,g_faa.faa22,
                    g_faa.faa15,g_faa.faa23, g_faa.faa07 ,g_faa.faa08,
                    g_faa.faa09,g_faa.faa11,g_faa.faa12,
                    g_faa.faa13,g_faa.faa25,g_faa.faa26,g_faa.faa27,
                    g_faa.faa29,g_faa.faa30,            #No:A099
                    g_faa.faa31,g_faa.faa152,g_faa.faa232 ,   #No:FUN-AB0088 #No:FUN-B60140
                    g_faa.faa072,g_faa.faa082, g_faa.faa092,  #No:FUN-B60140
                    #FUN-B50039-add-str--
                    g_faa.faaud01,g_faa.faaud02,g_faa.faaud03,g_faa.faaud04,
                    g_faa.faaud05,g_faa.faaud06,g_faa.faaud07,g_faa.faaud08,
                    g_faa.faaud09,g_faa.faaud10,g_faa.faaud11,g_faa.faaud12,
                    g_faa.faaud13,g_faa.faaud14,g_faa.faaud15
                    #FUN-B50039-add-end--
                    
    WHILE TRUE
        LET g_faa.faa02p = g_plant
        CALL s010_i()
        IF INT_FLAG THEN
           LET INT_FLAG = 0 CALL cl_err('',9001,0)
           LET g_faa.* = g_faa_t.* CALL s010_show()
           EXIT WHILE
        END IF
        UPDATE faa_file SET * = g_faa.* WHERE faa00='0'
        IF STATUS THEN 
#          CALL cl_err('',STATUS,0)  #No.FUN-660136
           CALL cl_err3("upd","faa_file","","",STATUS,"","",0)   #No.FUN-660136
           CONTINUE WHILE
       #FUN-930164---add---str---
        ELSE 
           IF g_flag_09='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_faa_t.faa09,' new:',g_faa.faa09
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06, azoplant,azolegal) #FUN-980003 add
                 VALUES ('afas010',g_user,g_today,g_errno,'faa09',g_msg, g_plant,g_legal)   #FUN-980003 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","afas010","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE   
              END IF
           END IF 
           IF g_flag_13='Y' THEN 
              LET g_errno = TIME
              LET g_msg = 'old:',g_faa_t.faa13,' new:',g_faa.faa13
              INSERT INTO azo_file (azo01,azo02,azo03,azo04,azo05,azo06, azoplant,azolegal) #FUN-980003 add
                 VALUES ('afas010',g_user,g_today,g_errno,'faa13',g_msg, g_plant,g_legal)   #FUN-980003 add
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","azo_file","afas010","",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                 CONTINUE WHILE   
              END IF
           END IF 
       #FUN-930164---add---end---
        END IF
        CLOSE faa_curl
        COMMIT WORK
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION s010_i()
   DEFINE l_aza LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE l_dbs LIKE type_file.chr21        #No.FUN-740032
   DEFINE l_plant LIKE type_file.chr10      #No.FUN-980020
   
   INPUT BY NAME
     #g_faa.faa01,g_faa.faa02p,g_faa.faa02b,g_faa.faa02c,     #No.FUN-680028   #FUN-AB0088 mark 
      g_faa.faa01,g_faa.faa02p,g_faa.faa02b,                  #FUN-AB0088 add  
      g_faa.faa20,g_faa.faa24,g_faa.faa26,g_faa.faa27, 
      g_faa.faa15,g_faa.faa23 ,g_faa.faa25,g_faa.faa07,
      g_faa.faa08 ,g_faa.faa09,g_faa.faa11,g_faa.faa12,
      g_faa.faa13 ,
      g_faa.faa31,g_faa.faa02c,          #FUN-AB0088          
      g_faa.faa152,g_faa.faa232,g_faa.faa072,g_faa.faa082,g_faa.faa092,  #No:FUN-B60140
      g_faa.faa19,g_faa.faa191,g_faa.faa03,
      #No:7676
      g_faa.faa031,g_faa.faa04,g_faa.faa05,g_faa.faa06,g_faa.faa28,
      g_faa.faa16,g_faa.faa17,g_faa.faa18,g_faa.faa21,g_faa.faa22,
      g_faa.faa29,g_faa.faa30,             #No:A099
      #FUN-B50039-add-str--
      g_faa.faaud01,g_faa.faaud02,g_faa.faaud03,g_faa.faaud04,
      g_faa.faaud05,g_faa.faaud06,g_faa.faaud07,g_faa.faaud08,
      g_faa.faaud09,g_faa.faaud10,g_faa.faaud11,g_faa.faaud12,
      g_faa.faaud13,g_faa.faaud14,g_faa.faaud15
      #FUN-B50039-add-end--
      WITHOUT DEFAULTS 
{--Genero mark
   INPUT BY NAME
      g_faa.faa01,g_faa.faa02p,g_faa.faa02b,
      g_faa.faa19,g_faa.faa191,g_faa.faa03,g_faa.faa031,
      g_faa.faa04,g_faa.faa05 ,g_faa.faa06,
      g_faa.faa16,g_faa.faa17 ,g_faa.faa18,
      g_faa.faa20,g_faa.faa24,g_faa.faa21 ,g_faa.faa22,
      g_faa.faa15,g_faa.faa23 ,g_faa.faa07 ,g_faa.faa08,
      g_faa.faa09,g_faa.faa11,g_faa.faa12,
      g_faa.faa13,g_faa.faa25,g_faa.faa26,g_faa.faa27
      WITHOUT DEFAULTS 
---}
     BEFORE INPUT 
        LET g_before_input_done = FALSE
        CALL s010_set_entry()
        CALL s010_set_no_entry()
        LET g_before_input_done = TRUE
        LET g_flag_09='N'     #FUN-930164 add
        LET g_flag_13='N'     #FUN-930164 add
 
      AFTER FIELD faa01
         IF NOT cl_null(g_faa.faa01) THEN
            IF g_faa.faa01 NOT MATCHES '[YN]' THEN
               LET g_faa.faa01=g_faa_o.faa01
               DISPLAY BY NAME g_faa.faa01
               NEXT FIELD faa01
            END IF
         END IF
         LET g_faa_o.faa01=g_faa.faa01
 
      AFTER FIELD faa02p
         IF NOT cl_null(g_faa.faa02p) THEN
            CALL s010_faa02p('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('g_faa.faa02p',g_errno,0)
               LET g_faa.faa02p = g_faa_o.faa02p
               DISPLAY BY NAME g_faa.faa02p 
               NEXT FIELD faa02p
            END IF
         END IF
         #No.FUN-740032  --Begin
         LET l_dbs = NULL
         LET l_plant = g_faa.faa02p                        #FUN-980020
         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=g_faa.faa02p
         LET t_dbss = l_dbs
         LET l_dbs = s_dbstring(l_dbs CLIPPED)   #FUN-9B0106

#        CALL s_get_bookno1(NULL,l_dbs)                    #FUN-980020 mark
         CALL s_get_bookno1(NULL,l_plant)                  #FUN-980020
              RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag =  '1' THEN  #抓不到帳別
            CALL cl_err(l_dbs,'aoo-081',1)
            NEXT FIELD faa02p
         END IF
         #No.FUN-740032  --End  
         LET g_faa_o.faa02p=g_faa.faa02p
 
      AFTER FIELD faa02b
         IF NOT cl_null(g_faa.faa02b) THEN
            #No.FUN-680028 --begin
            IF g_faa.faa02c = g_faa.faa02b THEN
               CALL cl_err('g_faa.faa02b','afa-888',0)
               NEXT FIELD faa02b
            END IF
            #No.FUN-680028 --end
            CALL s010_faa02b('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('g_faa.faa02b',g_errno,0)
               LET g_faa.faa02b = g_faa_o.faa02b
               DISPLAY BY NAME g_faa.faa02b 
               NEXT FIELD faa02b
            END IF
            #No.FUN-740032  --Begin
            IF g_faa.faa02b <> g_bookno1 THEN
               CALL cl_err(g_faa.faa02b,"axc-531",1)
            END IF
            #No.FUN-740032  --End  
         END IF
         LET g_faa_o.faa02b=g_faa.faa02b
 
      #No.FUN-680028 --begin
      AFTER FIELD faa02c
         IF NOT cl_null(g_faa.faa02c) THEN
            IF g_faa.faa02c = g_faa.faa02b THEN
               CALL cl_err('g_faa.faa02c','afa-888',0)
               NEXT FIELD faa02c
            END IF
            CALL s010_faa02c('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('g_faa.faa02c',g_errno,0)
               LET g_faa.faa02c = g_faa_o.faa02c
               DISPLAY BY NAME g_faa.faa02c 
               NEXT FIELD faa02c
            END IF
            #No.FUN-740032  --Begin
            IF g_faa.faa02c <> g_bookno2 THEN
               CALL cl_err(g_faa.faa02c,"axc-531",1)
            END IF
            #No.FUN-740032  --End  
         END IF
         LET g_faa_o.faa02c=g_faa.faa02c
      #No.FUN-680028 --end
 
      BEFORE FIELD faa19
         CALL s010_set_entry()
 
      AFTER FIELD faa19 
         IF NOT cl_null(g_faa.faa19) THEN
            IF g_faa.faa19 NOT MATCHES'[YN]' THEN
               LET g_faa.faa19=g_faa_o.faa19
               DISPLAY BY NAME g_faa.faa19
               NEXT FIELD faa19
            END IF
         END IF
         CALL s010_set_no_entry()
 
   #  BEFORE FIELD faa191
   #     IF g_faa.faa19 = 'N' THEN
   #        NEXT FIELD faa03
   #     END IF
 
      AFTER FIELD faa191
         IF cl_null(g_faa.faa191) THEN
            LET g_faa.faa191 = '0000000000'
        #str MOD-880147 add
         ELSE
            IF NOT cl_null(g_faa_o.faa191) THEN   #有舊值才與新值比對
               #抓取LENGTH(新值faa191)與LENGTH(舊值faa191)比對,
               #若不相同提示警訊不可異動
               #例:若現在想將faa191改成02,但舊值是1,兩者長度不同,不可異動
               IF LENGTH(g_faa.faa191) != LENGTH(g_faa_o.faa191) THEN
                  #已用底稿序號編號新舊值長度不同,不可異動!
                  CALL cl_err('','afa-191',1)
                  LET g_faa.faa191=g_faa_o.faa191
                  DISPLAY BY NAME g_faa.faa191
                  NEXT FIELD faa191
               END IF
            END IF
        #end MOD-880147 add
         END IF
 
      BEFORE FIELD faa03
         CALL s010_set_entry()
 
      AFTER FIELD faa03 
         IF NOT cl_null(g_faa.faa03) THEN
            IF g_faa.faa03 NOT MATCHES "[YN]" THEN 
               LET g_faa.faa03=g_faa_o.faa03
               DISPLAY BY NAME g_faa.faa03
               NEXT FIELD faa03
            END IF
         END IF
         IF g_faa.faa03 ='Y' THEN 
            LET g_faa.faa04 = 'N' 
            DISPLAY BY NAME g_faa.faa04
         ELSE
            LET g_faa.faa031 = NULL       
            DISPLAY BY NAME g_faa.faa031
         END IF
         LET g_faa_o.faa03=g_faa.faa03
         CALL s010_set_no_entry()
 
   #  BEFORE FIELD faa031
   #     IF g_faa.faa03 = 'N' THEN
   #        NEXT FIELD faa04
   #     END IF
 
      AFTER FIELD faa031
         IF cl_null(g_faa.faa031) THEN
            LET g_faa.faa031 = '0000000000'
         END IF
    
   #  BEFORE FIELD faa04
   #     IF g_faa.faa03 = 'Y' THEN
   #        NEXT FIELD faa05 
   #     END IF
   #     IF cl_ku() AND g_faa.faa03 = 'N' THEN
   #        NEXT FIELD faa03
   #     END IF
 
   #-----FUN-690073---------
      BEFORE FIELD faa04
         CALL s010_set_entry()
   #-----END FUN-690073-----
 
      AFTER FIELD faa04
         IF NOT cl_null(g_faa.faa04) THEN
            IF g_faa.faa04 NOT MATCHES '[YN]' THEN 
               LET g_faa.faa04=g_faa_o.faa04
               DISPLAY BY NAME g_faa.faa04
               NEXT FIELD faa04
            END IF
         END IF
         IF g_faa.faa04 = 'Y' AND g_faa.faa05 = 'Y' THEN 
            CALL cl_err('','afa-001',0)
            NEXT FIELD faa04
         END IF
         LET g_faa_o.faa04=g_faa.faa04
         #-----FUN-690073---------
         IF g_faa.faa04 = 'Y' THEN
            LET g_faa.faa06 = 'N'
            DISPLAY By NAME g_faa.faa06
            CALL s010_set_no_entry()
         END IF
         #-----END FUN-690073-----
 
 
   #  BEFORE FIELD faa05
   #     IF cl_ku() AND g_faa.faa03 = 'Y' THEN
   #        NEXT FIELD faa031
   #     END IF
 
      AFTER FIELD faa05
         IF NOT cl_null(g_faa.faa05) THEN
            IF g_faa.faa05 NOT MATCHES '[YN]' THEN 
               LET g_faa.faa05=g_faa_o.faa05
               DISPLAY BY NAME g_faa.faa05
               NEXT FIELD faa05
            END IF
         END IF
         IF g_faa.faa05 = 'Y' AND g_faa.faa04 = 'Y' THEN
            CALL cl_err('','afa-001',0)
            NEXT FIELD faa05
         END IF
         LET g_faa_o.faa05=g_faa.faa05
 
      AFTER FIELD faa06
         IF NOT cl_null(g_faa.faa06) THEN
            IF g_faa.faa06 NOT MATCHES '[YN]' THEN
               LET g_faa.faa06=g_faa_o.faa06
               DISPLAY BY NAME g_faa.faa06
               NEXT FIELD faa06
            END IF
           #start CHI-690048 add
            IF g_aza.aza31='Y' AND g_faa.faa06='Y' THEN
               LET g_faa.faa06='N'
               DISPLAY BY NAME g_faa.faa06
               #當固定資產編碼自動編碼否(aza31)為Y時,財編是否與序號一致(faa06)不可為Y!
               CALL cl_err('','afa-175',1)
               NEXT FIELD faa06
            END IF
           #end CHI-690048 add
         END IF
         LET g_faa_o.faa06=g_faa.faa06
 
      #No:7676
      AFTER FIELD faa28
         IF NOT cl_null(g_faa.faa28) THEN
            IF g_faa.faa28 NOT MATCHES '[BSMCD]' THEN #FUN-640012 add 'M'
               LET g_faa.faa28=g_faa_o.faa28
               DISPLAY BY NAME g_faa.faa28
               NEXT FIELD faa28
             #-----No.MOD-480332-----
            ELSE
              #IF g_aza.aza19 = "1" AND g_faa.faa28 NOT MATCHES '[BS]' THEN      #MOD-A70224 mark
               IF g_aza.aza19 = "1" AND g_faa.faa28 NOT MATCHES '[BSM]' THEN     #MOD-A70224
                  LET g_faa.faa28=g_faa_o.faa28
                  DISPLAY BY NAME g_faa.faa28
                  NEXT FIELD faa28
               END IF
            END IF
            #-----END---------------
         END IF
         LET g_faa_o.faa28=g_faa.faa28
      #No:7676 end
 
 
      AFTER FIELD faa15
         IF NOT cl_null(g_faa.faa15) THEN
            IF g_faa.faa15 > 4 OR g_faa.faa15 < 1 THEN 
               NEXT FIELD faa15 
            END IF
         END IF
 
      #-----No:FUN-B60140-----
       AFTER FIELD faa152
          IF g_faa.faa31 = "Y" THEN
             IF NOT cl_null(g_faa.faa152) THEN
                IF g_faa.faa152 > 4 OR g_faa.faa152 < 1 THEN
                   NEXT FIELD faa152
                END IF
             END IF
          END IF
       #-----No:FUN-B60140 END-----
      
     BEFORE FIELD faa16
         CALL s010_set_entry()
 
      AFTER FIELD faa16
         IF NOT cl_null(g_faa.faa16) THEN
            IF g_faa.faa16 not matches '[YN]' THEN
               LET g_faa.faa16=g_faa_o.faa16
               DISPLAY BY NAME g_faa.faa16
               NEXT FIELD faa16
            END IF
         END IF
         IF g_faa.faa16 = 'Y' THEN 
            LET g_faa.faa18 = ' '
            DISPLAY BY NAME g_faa.faa18
         END IF
         CALL s010_set_no_entry()
 
      AFTER FIELD faa17
         IF cl_null(g_faa.faa17) AND g_faa.faa16 = 'Y' THEN 
            NEXT FIELD faa17 
         END IF
 
   #  BEFORE FIELD faa18
   #     IF cl_ku() AND g_faa.faa16 = 'Y' THEN 
   #        NEXT FIELD faa17
   #     END IF
   #     IF g_faa.faa16 = 'Y' THEN NEXT FIELD faa20 END IF
 
      AFTER FIELD  faa18
         IF  cl_null(g_faa.faa18) AND g_faa.faa16 = 'N' THEN 
            NEXT FIELD faa18 
         END IF
 
      AFTER FIELD faa20
         IF NOT cl_null(g_faa.faa20) THEN
            IF g_faa.faa20 NOT MATCHES'[12]' THEN 
               LET g_faa.faa20=g_faa_o.faa20
               DISPLAY BY NAME g_faa.faa20
               NEXT FIELD faa20
            END IF   
         END IF   
 
      AFTER FIELD faa24  
         IF NOT cl_null(g_faa.faa24) THEN
            IF g_faa.faa24 not matches '[NY]' THEN
               NEXT FIELD faa24
            END IF
         END IF
 
      AFTER FIELD faa21
         IF NOT cl_null(g_faa.faa21) THEN
            IF g_faa.faa21 > 10 THEN 
               NEXT FIELD faa21
            END IF
         END IF
 
      AFTER FIELD faa22
         IF NOT cl_null(g_faa.faa22) THEN
#No.MOD-870039 --begin
#           IF g_faa.faa22 > 4  THEN 
            IF g_faa.faa22 >= 4  THEN 
               CALL cl_err('','afa-979',0)
#No.MOD-870039 --end
               NEXT FIELD faa22
            END IF
         END IF
 
      AFTER FIELD faa23
         IF NOT cl_null(g_faa.faa23) THEN
            IF g_faa.faa23 NOT MATCHES '[YN]' THEN 
               NEXT FIELD faa23
            END IF
         END IF
    
   #-----No:FUN-B60140-----
      AFTER FIELD faa232
         IF g_faa.faa31= "Y" THEN 
            IF NOT cl_null(g_faa.faa232) THEN 
               IF g_faa.faa232 NOT MATCHES '[YN]' THEN 
                  NEXT FIELD faa232
               END IF
            END IF
         END IF

      AFTER FIELD faa072
         LET g_faa_o.faa072=g_faa.faa072

      AFTER FIELD faa082
         IF g_faa.faa31="Y" THEN 
            IF NOT cl_null(g_faa.faa082) THEN 
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = g_faa.faa072
               IF g_azm.azm02 = 1 THEN 
                  IF g_faa.faa082 > 12 OR g_faa.faa082 < 1 THEN 
                     LET g_faa.faa082=g_faa_o.faa082
                     DISPLAY BY NAME g_faa.faa082
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD faa082
                  END IF
               ELSE 
                  IF g_faa.faa082 > 13 OR g_faa.faa082 < 1 THEN 
                     LET g_faa.faa082=g_faa_o.faa082
                     DISPLAY BY NAME g_faa.faa082
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD faa082
                  END IF
               END IF
            END IF
        END IF
      #-----No:FUN-B60140 END-----
                                            
 
      AFTER FIELD faa07
       # IF cl_null(g_faa.faa07) THEN
       #    LET g_faa.faa07=g_faa_o.faa07
       #    DISPLAY BY NAME g_faa.faa07
       #    NEXT FIELD faa07
       # END IF
         LET g_faa_o.faa07=g_faa.faa07
 
      AFTER FIELD faa08
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_faa.faa08) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_faa.faa07
            IF g_azm.azm02 = 1 THEN
               IF g_faa.faa08 > 12 OR g_faa.faa08 < 1 THEN
                  LET g_faa.faa08=g_faa_o.faa08
                  DISPLAY BY NAME g_faa.faa08
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD faa08
               END IF
            ELSE
               IF g_faa.faa08 > 13 OR g_faa.faa08 < 1 THEN
                  LET g_faa.faa08=g_faa_o.faa08
                  DISPLAY BY NAME g_faa.faa08
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD faa08
               END IF
            END IF
         END IF
#         IF NOT cl_null(g_faa.faa08) THEN
#            IF g_faa.faa08 <1 OR g_faa.faa08 >13 THEN
#               LET g_faa.faa08=g_faa_o.faa08
#               DISPLAY BY NAME g_faa.faa08
#               NEXT FIELD faa08
#            END IF
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD faa11
  #      IF cl_null(g_faa.faa11) THEN
  #         LET g_faa.faa11=g_faa_o.faa11
  #         DISPLAY BY NAME g_faa.faa11
  #         NEXT FIELD faa11
  #      END IF
         LET g_faa_o.faa11=g_faa.faa11
 
      AFTER FIELD faa12
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_faa.faa12) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_faa.faa11
            IF g_azm.azm02 = 1 THEN
               IF g_faa.faa12 > 12 OR g_faa.faa12 < 1 THEN
                  LET g_faa.faa12=g_faa_o.faa12
                  DISPLAY BY NAME g_faa.faa12
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD faa12
               END IF
            ELSE
               IF g_faa.faa12 > 13 OR g_faa.faa12 < 1 THEN
                  LET g_faa.faa12=g_faa_o.faa12
                  DISPLAY BY NAME g_faa.faa12
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD faa12
               END IF
            END IF
         END IF
#         IF NOT cl_null(g_faa.faa12) THEN
#            IF g_faa.faa12 <1 OR g_faa.faa12 >13 THEN
#               LET g_faa.faa12=g_faa_o.faa12
#               DISPLAY BY NAME g_faa.faa12
#               NEXT FIELD faa12
#            END IF
#         END IF
#No.TQC-720032 -- end --
 
      #Add No:TQC-B20015
      BEFORE FIELD faa26
         CALL s010_set_entry()
      #End Add No:TQC-B20015

      AFTER FIELD faa26
         IF NOT cl_null(g_faa.faa26) THEN
            IF g_faa.faa26 NOT MATCHES '[12]' THEN
               NEXT FIELD faa26
            END IF
         END IF
         #Add No:TQC-B20015
         IF g_faa.faa26='2' THEN
            LET g_faa.faa27=0
            DISPLAY BY NAME g_faa.faa27
         END IF
         CALL s010_set_no_entry()
         #End Add No:TQC-B20015
 
      BEFORE FIELD faa27
         IF g_faa.faa26='2' THEN
            LET g_faa.faa27=0
            DISPLAY BY NAME g_faa.faa27
          #  EXIT INPUT    #Genero mark
         END IF
 
      AFTER FIELD faa27
         IF cl_null(g_faa.faa27) THEN
            LET g_faa.faa27=0
         END IF

      #FUN-AB0088---add---str---
      BEFORE FIELD faa31
         CALL s010_set_entry()

      AFTER FIELD faa31 
         IF cl_null(g_faa_o.faa31) OR g_faa_o.faa31 <> g_faa.faa31 THEN
            IF g_faa.faa31 = "Y" THEN
               IF g_aza.aza63 = "Y" THEN
                  LET g_faa.faa02c = g_aza.aza82
               END IF
            ELSE
               LET g_faa.faa02c = NULL
            END IF 
         END IF
         DISPLAY BY NAME g_faa.faa02c
         CALL s010_set_no_entry()
      #FUN-AB0088---add---end--- 
 
      #No:A099 
      #AFTER FIELD faa29
      #   CALL s010_set_no_entry()
      #end #No:A099
 
      #FUN-930164---add---str---
       AFTER FIELD faa09
          IF g_faa.faa09 <> g_faa_t.faa09 THEN 
             LET g_flag_09='Y'
          END IF
       AFTER FIELD faa13
          IF g_faa.faa13 <> g_faa_t.faa13 THEN 
             LET g_flag_13='Y'
          END IF
      #FUN-930164---add---end---
      #FUN-B50039-add-str--
      AFTER FIELD faaud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD faaud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-B50039-add-end--
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(faa02p)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azp"  #FUN-990031 mark
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
                 LET g_qryparam.default1 = g_faa.faa02p
                 CALL cl_create_qry() RETURNING g_faa.faa02p
#                 CALL FGL_DIALOG_SETBUFFER( g_faa.faa02p )
                 DISPLAY BY NAME g_faa.faa02p
                 NEXT FIELD faa02p
              WHEN INFIELD(faa02b)
                 CALL cl_init_qry_var()
                 #No.FUN-740032  --Begin
#                LET g_qryparam.form = "q_aaa"
                 LET g_qryparam.form = "q_m_aaa"
                 LET g_qryparam.default1 = g_faa.faa02b
#                LET g_qryparam.arg1 = t_dbss          #No.FUN-980025 mark
                 LET g_qryparam.plant = g_faa.faa02p   #No.FUN-980025 add  
                 #No.FUN-740032  --End   
                 CALL cl_create_qry() RETURNING g_faa.faa02b
#                 CALL FGL_DIALOG_SETBUFFER( g_faa.faa02b )
                 DISPLAY BY NAME g_faa.faa02b
                 NEXT FIELD faa02b
              #No.FUN-680028 --begin
              WHEN INFIELD(faa02c)
                 CALL cl_init_qry_var()
                 #No.FUN-740032  --Begin
#                LET g_qryparam.form = "q_aaa"
                 LET g_qryparam.form = "q_m_aaa"
                 LET g_qryparam.default1 = g_faa.faa02c
#                LET g_qryparam.arg1 = t_dbss          #No.FUN-980025 mark 
                 LET g_qryparam.plant = g_faa.faa02p   #No.FUN-980025 add  
                 #No.FUN-740032  --End   
                 CALL cl_create_qry() RETURNING g_faa.faa02c
#                 CALL FGL_DIALOG_SETBUFFER( g_faa.faa02c )
                 DISPLAY BY NAME g_faa.faa02c
                 NEXT FIELD faa02c
              #No.FUN-680028 --end
               OTHERWISE EXIT CASE
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
 
FUNCTION s010_faa02p(p_cmd)
DEFINE
     p_cmd     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
     l_azp02   LIKE azp_file.azp02
 
     LET g_errno = ''
     #FUN-990031--mod--str--營運中心要控制在當前法人下  
     #SELECT azp02 INTO l_azp02
     #  FROM azp_file
     # WHERE azp01 = g_faa.faa02p
     SELECT * FROM azw_file WHERE azw01 = g_faa.faa02p 
        AND azw02 = g_legal
     #FUN-990031--mod--end
    CASE
        WHEN SQLCA.SQLCODE = 100  #LET g_errno='aap-025'   #FUN-990031 mark
                                  LET g_errno = 'agl-171'  #FUN-990031 add
                                  LET l_azp02 = NULL
        OTHERWISE
           LET g_errno=SQLCA.SQLCODE USING '------'
    END CASE
END FUNCTION
   
FUNCTION s010_faa02b(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_aaaacti LIKE aaa_file.aaaacti
 
     LET g_errno = ''
     SELECT aaaacti INTO l_aaaacti
       FROM aaa_file
      WHERE aaa01 = g_faa.faa02b
     CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno='agl-043'
                                 LET l_aaaacti = NULL
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        OTHERWISE
            LET g_errno=SQLCA.SQLCODE USING '------'
     END CASE
END FUNCTION
 
#No.FUN-680028 --begin
FUNCTION s010_faa02c(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_aaaacti LIKE aaa_file.aaaacti
 
     LET g_errno = ''
     SELECT aaaacti INTO l_aaaacti
       FROM aaa_file
      WHERE aaa01 = g_faa.faa02c
     CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno='agl-043'
                                 LET l_aaaacti = NULL
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        OTHERWISE
            LET g_errno=SQLCA.SQLCODE USING '------'
     END CASE
END FUNCTION
#No.FUN-680028 --end
 
FUNCTION s010_y()
 DEFINE   l_faa01 LIKE faa_file.faa01        #No.FUN-680070 VARCHAR(01)
     SELECT faa01 INTO l_faa01 FROM faa_file WHERE faa00='0'
     IF l_faa01 = 'Y' THEN RETURN END IF
     UPDATE faa_file SET faa01='Y' WHERE faa00='0'
     IF STATUS THEN
        LET g_faa.faa01='N'
#       CALL cl_err('upd faa01:',STATUS,0)   #No.FUN-660136
        CALL cl_err3("upd","faa_file","","",STATUS,"","upd faa01:",0)   #No.FUN-660136
     ELSE
        LET g_faa.faa01='Y'
     END IF
     DISPLAY BY NAME g_faa.faa01 
END FUNCTION
 
FUNCTION s010_set_entry() 
  
    IF INFIELD(faa19) THEN
       CALL cl_set_comp_entry("faa191",TRUE)
    END IF
 
    IF INFIELD(faa03) THEN
       CALL cl_set_comp_entry("faa031,faa04",TRUE)
    END IF
    
    IF INFIELD(faa16) THEN
       CALL cl_set_comp_entry("faa18",TRUE)
    END IF
    #No:A099
    IF (NOT g_before_input_done) THEN 
        CALL cl_set_comp_entry("faa29",TRUE)
    END IF
    #end No:A099
    #-----FUN-690073---------
    IF INFIELD(faa04) THEN
       CALL cl_set_comp_entry("faa06",TRUE)
    END IF
    #-----END FUN-690073-----
    #Add No:TQC-B20015
    IF INFIELD(faa26) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("faa27",TRUE)
    END IF
    #End Add No:TQC-B20015
 
    #FUN-AB0088---add----str-----    
    IF INFIELD(faa31) THEN
       CALL cl_set_comp_entry("faa02c,faa152,faa232,faa072,faa082,faa092",TRUE)  #No:FUN-B60140
       CALL cl_set_comp_required("faa02c,faa152,faa232,faa072,faa082,faa092",TRUE) #No:FUN-B60140
    END IF
    #FUN-AB0088---add----end-----    

END FUNCTION
 
FUNCTION s010_set_no_entry() 
 
    IF INFIELD(faa19) AND g_faa.faa19='N' THEN
       CALL cl_set_comp_entry("faa191",FALSE)
    END IF
 
    IF INFIELD(faa03) THEN
       IF g_faa.faa03='Y' THEN
          CALL cl_set_comp_entry("faa04",FALSE)
       END IF
       IF g_faa.faa03='N' THEN
          CALL cl_set_comp_entry("faa031",FALSE)
       END IF
    END IF
 
    IF INFIELD(faa16) AND g_faa.faa16='Y' THEN
       CALL cl_set_comp_entry("faa18",FALSE)
    END IF
 
    #No:A099
    IF g_aza.aza26 != '2' THEN  
       CALL cl_set_comp_entry("faa29",FALSE)
    END IF
    #end No:A099
    #-----FUN-690073---------
    IF INFIELD(faa04) THEN
       CALL cl_set_comp_entry("faa06",FALSE)
    END IF
    #-----END FUN-690073-----
    #Add No:TQC-B20015
    IF INFIELD(faa26) OR (NOT g_before_input_done) THEN
       IF g_faa.faa26 = "2" THEN
          CALL cl_set_comp_entry("faa27",FALSE)
       END IF
    END IF
    #End Add No:TQC-B20015
   
    #FUN-AB0088---add----str-----
    IF g_faa.faa31 = 'N' THEN
       CALL cl_set_comp_entry("faa02c,faa152,faa232,faa072,faa082,faa092",FALSE)    #No:FUN-B60140
       CALL cl_set_comp_required("faa02c,faa152,faa232,faa072,faa082,faa092",FALSE)  #No:FUN-B60140
    END IF
    #FUN-AB0088---add----end-----
END FUNCTION
