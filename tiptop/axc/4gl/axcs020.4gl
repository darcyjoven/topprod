# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axcs020.4gl
# Descriptions...: LCM參數資料設定作業
# Date & Author..: 99/03/29 By Carol 
 # Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........; NO.FUN-5B0134 05/11/25 BY yiting modify 加上權限判斷 cl_chk_act_auth() 功能
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-930009 09/03/04 By shiwuying 調整欄位控管大於等於0
# Modify.........: No.FUN-930100 09/03/24 By jan 拿掉"除外倉庫"groupbox;增加"維護除外倉庫"ACTION
# Modify.........: No.CHI-940029 09/04/14 By jan 新增cmz27欄位
# Modify.........: No.FUN-970102 09/08/14 By jan cmz01/cmz70/cmz02 移除
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0024 09/10/13 By destiny display xxx.*改为display对应栏位
# Modify.........: No:FUN-AB0036 10/11/11 By jan 新增cmz28欄位
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE
        g_cmz       RECORD LIKE cmz_file.*,
        g_cmz_t     RECORD LIKE cmz_file.*,
        g_cmz_o     RECORD LIKE cmz_file.*
 DEFINE g_forupd_sql          STRING
 #FUN-930100--begin--
 DEFINE tm RECORD
           s1       LIKE type_file.chr1,
           s2       LIKE type_file.chr1,
           s3       LIKE type_file.chr1
           END RECORD
 #FUN-930100--end--
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0146
    DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS	FORM	LINE FIRST + 2,
		MESSAGE	LINE LAST,
		PROMPT	LINE LAST,
		HELP	FILE "axc/hlp/axcs020.hlp",
  INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
    #取得有關的資料
    SELECT * INTO g_cmz.* FROM cmz_file WHERE cmz00 = '0'
 
    LET g_today = TODAY
    LET p_row = 3 LET p_col = 20

    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
    OPEN WINDOW s020_w AT p_row,p_col
        WITH FORM "axc/42f/axcs020"  
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL s020_show()
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL s020_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW s020_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION s020_show()
    SELECT * INTO g_cmz.*  FROM cmz_file
    #FUN-930100--BEGIN--
    IF NOT cl_null(g_cmz.cmz23) THEN
       LET tm.s1 = g_cmz.cmz23[1,3]
       LET tm.s2 = g_cmz.cmz23[2,3]
       LET tm.s3 = g_cmz.cmz23[3,3]
    END IF
    #FUN-930100--end--
    IF SQLCA.sqlcode OR g_cmz.cmz00 IS NULL THEN
        IF SQLCA.sqlcode=-284 THEN
            DELETE FROM cmz_file
        END IF
        INITIALIZE g_cmz.* TO NULL  
        LET g_cmz.cmz00 = "0"       #KEY 
       #LET g_cmz.cmz01 = g_today   #FUN-970102
       #LET g_cmz.cmz02 = 0         #FUN-970102
        LET g_cmz.cmz03 = 0
        LET g_cmz.cmz04 = 0
        LET g_cmz.cmz05 = 0
        LET g_cmz.cmz06 = 0
        LET g_cmz.cmz07 = 0
        LET g_cmz.cmz08 = 0
        LET g_cmz.cmz09 = "1"       #貨齡計算基準
        LET g_cmz.cmz10 = "1"       #呆滯計算基準
       #FUN-930100--BEGIN--
       #LET g_cmz.cmz11 = " "       #除外倉庫1
       #LET g_cmz.cmz12 = " "       #除外倉庫2
       #LET g_cmz.cmz13 = " "       #除外倉庫3
       #LET g_cmz.cmz14 = " "       #除外倉庫4
       #LET g_cmz.cmz15 = " "       #除外倉庫5
       #FUN-930100--END--
        LET g_cmz.cmz20 = 0
        LET g_cmz.cmz21 = 0
        LET g_cmz.cmz22 = 0
        LET g_cmz.cmz30 = 0
        LET g_cmz.cmz31 = 0
        LET g_cmz.cmz32 = 0
        LET g_cmz.cmz40 = 0
        LET g_cmz.cmz41 = 0
        LET g_cmz.cmz42 = 0
        LET g_cmz.cmz50 = 0
        LET g_cmz.cmz51 = 0
        LET g_cmz.cmz52 = 0
        LET g_cmz.cmz60 = 0
        LET g_cmz.cmz61 = 0
        LET g_cmz.cmz62 = 0
        LET g_cmz.cmz25 = '1'   #FUN-930100
        LET g_cmz.cmz17 = 'Y'   #FUN-930100
        LET g_cmz.cmz18 = '1'   #FUN-930100
        LET g_cmz.cmz19 = '1'   #FUN-930100
        LET g_cmz.cmz24 = '1'   #FUN-930100
        LET g_cmz.cmz26 = '1'   #FUN-930100
        LET tm.s1 = '1'         #FUN-930100
        LET tm.s2 = '2'         #FUN-930100
        LET tm.s3 = '3'         #FUN-930100
        LET g_cmz.cmz27 = g_today  #CHI-940029
        LET g_cmz.cmz28 = 'Y'      #FUN-AB0036
        INSERT INTO cmz_file VALUES (g_cmz.*)
        IF SQLCA.sqlcode THEN
#               CALL cl_err('Ins cmz:',SQLCA.sqlcode,0)   #No.FUN-660127
                CALL cl_err3("ins","cmz_file",g_cmz.cmz00,"",SQLCA.sqlcode,"","Ins cmz:",0)   #No.FUN-660127
                RETURN
        END IF
    END IF
    DISPLAY BY NAME 
       #g_cmz.cmz01,g_cmz.cmz02,g_cmz.cmz03,g_cmz.cmz04,g_cmz.cmz05, #FUN-970102 mark
        g_cmz.cmz03,g_cmz.cmz04,g_cmz.cmz05,                         #FUN-970102 mod
        g_cmz.cmz06,g_cmz.cmz07,g_cmz.cmz08,g_cmz.cmz09,g_cmz.cmz10,
       #g_cmz.cmz11,g_cmz.cmz12,g_cmz.cmz13,g_cmz.cmz14,g_cmz.cmz15,  #FUN-930100mark
        g_cmz.cmz20,g_cmz.cmz21,g_cmz.cmz22,g_cmz.cmz25,g_cmz.cmz17, #FUN-930100 add cmz25,cmz17
        g_cmz.cmz30,g_cmz.cmz31,g_cmz.cmz32,g_cmz.cmz18,g_cmz.cmz19, #FUN-930100 add cmz18.cmz19
        g_cmz.cmz40,g_cmz.cmz41,g_cmz.cmz42,tm.s1,tm.s2,tm.s3,       #FUN-930100 add s1,s2,s3
        g_cmz.cmz50,g_cmz.cmz51,g_cmz.cmz52,g_cmz.cmz26,g_cmz.cmz24, #FUN-930100 add cmz26,cmz24
        g_cmz.cmz60,g_cmz.cmz61,g_cmz.cmz62,g_cmz.cmz27,g_cmz.cmz28  #CHI-940029 add cmz27#FUN-970102 拿掉 cmz70 #FUN-AB0036
        
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION s020_menu()
    MENU ""
    ON ACTION modify 
#NO.FUN-5B0134 START--
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
             CALL s020_u()
          END IF
#NO.FUN-5B0134 END---
 
    #FUN-930100--begin--
    ON ACTION Exclusive_wh
       LET g_action_choice="Exclusive_wh"
       CALL cl_cmdrun('axci200')
    #FUN-930100--end--
 
    ON ACTION help 
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #EXIT MENU
    ON ACTION exit
            LET g_action_choice = "exit"
    EXIT MENU
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
    
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION s020_u()
    CALL cl_opmsg('u')
    MESSAGE ""
    LET g_cmz_o.*=g_cmz.* 
    
    LET g_forupd_sql = "SELECT * FROM cmz_file FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE cmz_cl CURSOR FROM g_forupd_sql
 
    BEGIN WORK
    OPEN cmz_cl
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    FETCH cmz_cl INTO g_cmz.*
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        RETURN
    END IF
    IF cl_null(g_cmz.cmz25) THEN LET g_cmz.cmz25 = '1' END IF #FUN-930100
    IF cl_null(g_cmz.cmz17) THEN LET g_cmz.cmz17 = 'Y' END IF #FUN-930100
    IF cl_null(g_cmz.cmz18) THEN LET g_cmz.cmz18 = '1' END IF #FUN-930100
    IF cl_null(g_cmz.cmz19) THEN LET g_cmz.cmz19 = '1' END IF #FUN-930100
    IF cl_null(g_cmz.cmz26) THEN LET g_cmz.cmz26 = '1' END IF #FUN-930100
    IF cl_null(g_cmz.cmz24) THEN LET g_cmz.cmz24 = '1' END IF #FUN-930100
    IF cl_null(g_cmz.cmz28) THEN LET g_cmz.cmz28 = 'Y' END IF #FUN-AB0036
    IF cl_null(tm.s1)       THEN LET tm.s1 = '1' END IF       #FUN-930100
    IF cl_null(tm.s2)       THEN LET tm.s2 = '2' END IF       #FUN-930100
    IF cl_null(tm.s3)       THEN LET tm.s3 = '3' END IF       #FUN-930100
    LET g_cmz_t.*=g_cmz.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_cmz.* 
    DISPLAY BY NAME g_cmz.cmz03,g_cmz.cmz04,g_cmz.cmz05,g_cmz.cmz06,g_cmz.cmz07,g_cmz.cmz08,
                    g_cmz.cmz09,g_cmz.cmz10,g_cmz.cmz20,g_cmz.cmz21,g_cmz.cmz22,g_cmz.cmz25,
                    g_cmz.cmz17,g_cmz.cmz30,g_cmz.cmz31,g_cmz.cmz32,g_cmz.cmz18,g_cmz.cmz19, 
                    g_cmz.cmz40,g_cmz.cmz41,g_cmz.cmz42,g_cmz.cmz50,g_cmz.cmz51,g_cmz.cmz52,
                    g_cmz.cmz26,g_cmz.cmz24,g_cmz.cmz60,g_cmz.cmz61,g_cmz.cmz62,g_cmz.cmz27,
                    g_cmz.cmz28   #FUN-AB0036
    #No.FUN-9A0024--end       
    WHILE TRUE
        CALL s020_i()
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cmz_file
           SET cmz_file.*=g_cmz.*
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("upd","cmz_file",g_cmz_t.cmz00,"",SQLCA.sqlcode,"","",0)   #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE cmz_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s020_i()
   DEFINE   l_n       LIKE type_file.num5,          #No.FUN-680122 SMALLINT
            l_yy      LIKE type_file.num5,          #No.FUN-680122 SMALLINT
            l_mm      LIKE type_file.num5,          #No.FUN-680122 SMALLINT
            l_cdate   LIKE type_file.chr20          #No.FUN-680122 VARCHAR(10)  
 
   INPUT BY NAME 
     #g_cmz.cmz01,g_cmz.cmz70, #FUN-970102
     #g_cmz.cmz02,g_cmz.cmz03,g_cmz.cmz04,g_cmz.cmz05, #FUN-970102
      g_cmz.cmz03,g_cmz.cmz04,g_cmz.cmz05, #FUN-970102
      g_cmz.cmz06,g_cmz.cmz07,g_cmz.cmz08,g_cmz.cmz09,g_cmz.cmz10,
     #g_cmz.cmz11,g_cmz.cmz12,g_cmz.cmz13,g_cmz.cmz14,g_cmz.cmz15,  #FUN-930100 mark
      g_cmz.cmz20,g_cmz.cmz21,g_cmz.cmz22,
      g_cmz.cmz30,g_cmz.cmz31,g_cmz.cmz32,
      g_cmz.cmz40,g_cmz.cmz41,g_cmz.cmz42,
      g_cmz.cmz50,g_cmz.cmz51,g_cmz.cmz52,
      g_cmz.cmz60,g_cmz.cmz61,g_cmz.cmz62,
      g_cmz.cmz25,g_cmz.cmz17,g_cmz.cmz18,g_cmz.cmz19,g_cmz.cmz28,  #FUN-930100 #FUN-AB0036
      g_cmz.cmz26,g_cmz.cmz24,g_cmz.cmz27,tm.s1,tm.s2,tm.s3         #FUN-930100 #CHI-940029 add cmz27
      WITHOUT DEFAULTS 
 
     #FUN-AB0036--begin--add-----
      BEFORE INPUT 
        CALL s020_set_entry()
        CALL s020_set_no_entry()
     #FUN-AB0036--end--add-------

     #FUN-970102--begin--mark--
     #AFTER FIELD cmz01
     #   IF g_cmz.cmz01 <> g_cmz_o.cmz01 OR g_cmz.cmz70 IS NULL THEN
     #      #計算異動截止日, 往後推一年半
     #      LET l_mm=MONTH(g_cmz.cmz01)
     #      IF l_mm <= 6 THEN
     #         LET l_yy=YEAR(g_cmz.cmz01) -2 
     #         LET l_mm=l_mm+6
     #         LET l_cdate =  l_yy USING "&&&&",l_mm USING "&&",'01'
     #         LET g_cmz.cmz70 = l_cdate
     #      ELSE
     #         LET l_yy=YEAR(g_cmz.cmz01) -1 
     #         LET l_mm=l_mm-6
     #         LET l_cdate =  l_yy USING "&&&&",l_mm USING "&&",'01'
     #         LET g_cmz.cmz70 = l_cdate
     #      END IF
     #      DISPLAY BY NAME g_cmz.cmz70
     #   END IF
     #   LET g_cmz_o.cmz01=g_cmz.cmz01
 
     #AFTER FIELD cmz02
     #   IF NOT cl_null(g_cmz.cmz02) THEN
     #   #  IF g_cmz.cmz02 <=0 THEN              #No.CHI-930009
     #      IF g_cmz.cmz02 < 0 THEN              #No.CHI-930009
     #         LET g_cmz.cmz02=g_cmz_o.cmz02
     #         DISPLAY BY NAME g_cmz.cmz02 
     #         NEXT FIELD cmz02
     #         END IF  
     #   END IF  
     #   LET g_cmz_o.cmz02=g_cmz.cmz02
     #FUN-970102--end--mark--
 
      AFTER FIELD cmz03
         IF NOT cl_null(g_cmz.cmz03) THEN
         #  IF g_cmz.cmz03 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz03 < 0 THEN              #No.CHI-930009
                LET g_cmz.cmz03=g_cmz_o.cmz03
                DISPLAY BY NAME g_cmz.cmz03 
                NEXT FIELD cmz03
            END IF  
         END IF  
         LET g_cmz_o.cmz03=g_cmz.cmz03
        
      AFTER FIELD cmz04
         IF NOT cl_null(g_cmz.cmz04) THEN 
         #  IF g_cmz.cmz04 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz04 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz04=g_cmz_o.cmz04
               DISPLAY BY NAME g_cmz.cmz04 
               NEXT FIELD cmz04
            END IF  
         END IF  
         LET g_cmz_o.cmz04=g_cmz.cmz04
     
      #FUN-930100--begib--
      AFTER FIELD cmz25
         IF NOT cl_null(g_cmz.cmz25) THEN 
            IF g_cmz.cmz25 NOT MATCHES '[12]' THEN
               LET g_cmz.cmz25=g_cmz_o.cmz25
               DISPLAY BY NAME g_cmz.cmz25
               NEXT FIELD cmz25
            END IF
         END IF
         LET g_cmz_o.cmz25=g_cmz.cmz25
 
        
      AFTER FIELD cmz17
         IF NOT cl_null(g_cmz.cmz17) THEN 
            IF g_cmz.cmz17 NOT MATCHES '[YNyn]' THEN
               LET g_cmz.cmz17=g_cmz_o.cmz17
               DISPLAY BY NAME g_cmz.cmz17
               NEXT FIELD cmz17
            END IF
         END IF
 
      AFTER FIELD cmz18
         IF NOT cl_null(g_cmz.cmz18) THEN 
            IF g_cmz.cmz18 NOT MATCHES '[123456]' THEN
               LET g_cmz.cmz18=g_cmz_o.cmz18
               DISPLAY BY NAME g_cmz.cmz18
               NEXT FIELD cmz18
            END IF
         END IF
         LET g_cmz_o.cmz18=g_cmz.cmz18
 
      BEFORE FIELD cmz19         #FUN-AB0036
        CALL s020_set_entry()    #FUN-AB0036
     
      ON CHANGE cmz19             #FUN-AB0036   
        CALL s020_set_no_entry()  #FUN-AB0036

      AFTER FIELD cmz19
         IF NOT cl_null(g_cmz.cmz19) THEN 
            IF g_cmz.cmz19 NOT MATCHES '[12]' THEN
               LET g_cmz.cmz19=g_cmz_o.cmz19
               DISPLAY BY NAME g_cmz.cmz19
               NEXT FIELD cmz19
            END IF
         END IF
         CALL s020_set_no_entry()    #FUN-AB0036
         LET g_cmz_o.cmz19=g_cmz.cmz19
 
      AFTER FIELD cmz26
         IF NOT cl_null(g_cmz.cmz26) THEN 
            IF g_cmz.cmz26 NOT MATCHES '[123]' THEN
               LET g_cmz.cmz26=g_cmz_o.cmz26
               DISPLAY BY NAME g_cmz.cmz26
               NEXT FIELD cmz26
            END IF
         END IF
         LET g_cmz_o.cmz26=g_cmz.cmz26
 
      AFTER FIELD cmz24
         IF NOT cl_null(g_cmz.cmz24) THEN 
            IF g_cmz.cmz24 NOT MATCHES '[1234567]' THEN
               LET g_cmz.cmz24=g_cmz_o.cmz24
               DISPLAY BY NAME g_cmz.cmz24
               NEXT FIELD cmz24
            END IF
         END IF
         LET g_cmz_o.cmz24=g_cmz.cmz24
 
      AFTER FIELD s1 
            IF NOT cl_null(tm.s1) THEN  
               IF tm.s1 NOT MATCHES '[123]' THEN
                  NEXT FIELD s1
               END IF 
               IF NOT cl_null(tm.s2) AND NOT cl_null(tm.s3) THEN
                  LET g_cmz.cmz23 = tm.s1,tm.s2,tm.s3
               END IF
            END IF
 
      AFTER FIELD s2 
            IF NOT cl_null(tm.s2) THEN  
               IF tm.s2 NOT MATCHES '[123]' THEN
                  NEXT FIELD s2
               END IF 
               IF NOT cl_null(tm.s1) AND NOT cl_null(tm.s3) THEN
                  LET g_cmz.cmz23 = tm.s1,tm.s2,tm.s3
               END IF
            END IF
 
      AFTER FIELD s3 
            IF NOT cl_null(tm.s3) THEN  
               IF tm.s3 NOT MATCHES '[123]' THEN
                  NEXT FIELD s3
               END IF 
               IF NOT cl_null(tm.s1) AND NOT cl_null(tm.s2) THEN
                  LET g_cmz.cmz23 = tm.s1,tm.s2,tm.s3
               END IF
            END IF
      #FUN-930100--END--
 
      #CHI-940029--begin--
      AFTER FIELD cmz27
        IF cl_null(g_cmz.cmz27) THEN
           CALL cl_err('','azz-310',0)
           NEXT FIELD cmz27
        END IF
      #CHI-940029--end--
 
      AFTER FIELD cmz05
         IF NOT cl_null(g_cmz.cmz05) THEN 
         #  IF g_cmz.cmz05 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz05 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz05=g_cmz_o.cmz05
               DISPLAY BY NAME g_cmz.cmz05 
               NEXT FIELD cmz05
            END IF  
         END IF  
         LET g_cmz_o.cmz05=g_cmz.cmz05
        
      AFTER FIELD cmz06
         IF NOT cl_null(g_cmz.cmz06) THEN 
         #  IF g_cmz.cmz06 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz06 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz06=g_cmz_o.cmz06
               DISPLAY BY NAME g_cmz.cmz06 
               NEXT FIELD cmz06
            END IF  
         END IF  
         LET g_cmz_o.cmz06=g_cmz.cmz06
        
      AFTER FIELD cmz07
         IF NOT cl_null(g_cmz.cmz07) THEN 
         #  IF g_cmz.cmz07 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz07 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz07=g_cmz_o.cmz07
               DISPLAY BY NAME g_cmz.cmz07 
               NEXT FIELD cmz07
            END IF  
         END IF  
         LET g_cmz_o.cmz07=g_cmz.cmz07
 
      AFTER FIELD cmz08
         IF NOT cl_null(g_cmz.cmz08) THEN 
         #  IF g_cmz.cmz08 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz08 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz08=g_cmz_o.cmz08
               DISPLAY BY NAME g_cmz.cmz08 
               NEXT FIELD cmz08
            END IF  
         END IF  
         LET g_cmz_o.cmz08=g_cmz.cmz08
 
      AFTER FIELD cmz09
         IF NOT cl_null(g_cmz.cmz09) THEN 
            IF g_cmz.cmz09 NOT MATCHES '[12]' THEN
               LET g_cmz.cmz09=g_cmz_o.cmz09
               DISPLAY BY NAME g_cmz.cmz09
               NEXT FIELD cmz09
            END IF
         END IF
         LET g_cmz_o.cmz09=g_cmz.cmz09
 
      AFTER FIELD cmz10
         IF NOT cl_null(g_cmz.cmz10) THEN 
            IF g_cmz.cmz10 NOT MATCHES '[12]' THEN
               LET g_cmz.cmz10=g_cmz_o.cmz10
               DISPLAY BY NAME g_cmz.cmz10
               NEXT FIELD cmz10
            END IF
         END IF
         LET g_cmz_o.cmz10=g_cmz.cmz10
 
      AFTER FIELD cmz20
         IF NOT cl_null(g_cmz.cmz20) THEN 
            IF g_cmz.cmz20 <0 THEN
               LET g_cmz.cmz20=g_cmz_o.cmz20
               DISPLAY BY NAME g_cmz.cmz20 
               NEXT FIELD cmz20
            END IF 
         END IF 
         LET g_cmz_o.cmz20=g_cmz.cmz20
 
      AFTER FIELD cmz21
         IF NOT cl_null(g_cmz.cmz21) THEN 
            IF g_cmz.cmz21 <=0 OR (g_cmz.cmz20>g_cmz.cmz21) THEN
               LET g_cmz.cmz21=g_cmz_o.cmz21
               DISPLAY BY NAME g_cmz.cmz21 
               NEXT FIELD cmz21
            END IF  
         END IF  
         LET g_cmz_o.cmz21=g_cmz.cmz21
 
      AFTER FIELD cmz22
         IF NOT cl_null(g_cmz.cmz22) THEN 
         #  IF  g_cmz.cmz22 <=0 THEN             #No.CHI-930009
            IF  g_cmz.cmz22 < 0 THEN             #No.CHI-930009
               LET g_cmz.cmz22=g_cmz_o.cmz22
               DISPLAY BY NAME g_cmz.cmz22 
               NEXT FIELD cmz22
            END IF  
         END IF  
         LET g_cmz_o.cmz22=g_cmz.cmz22
 
      AFTER FIELD cmz30
         IF NOT cl_null(g_cmz.cmz30) THEN 
            IF g_cmz.cmz30 <=0 THEN
               LET g_cmz.cmz30=g_cmz_o.cmz30
               DISPLAY BY NAME g_cmz.cmz30 
               NEXT FIELD cmz30
            END IF  
         END IF  
         LET g_cmz_o.cmz30=g_cmz.cmz30
 
      AFTER FIELD cmz31
         IF NOT cl_null(g_cmz.cmz31) THEN 
            IF g_cmz.cmz31 <=0 OR (g_cmz.cmz30>g_cmz.cmz31) THEN
               LET g_cmz.cmz31=g_cmz_o.cmz31
               DISPLAY BY NAME g_cmz.cmz31 
               NEXT FIELD cmz31
            END IF  
         END IF  
         LET g_cmz_o.cmz31=g_cmz.cmz31
 
      AFTER FIELD cmz32
         IF NOT cl_null(g_cmz.cmz32) THEN 
         #  IF g_cmz.cmz32 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz32 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz32=g_cmz_o.cmz32
               DISPLAY BY NAME g_cmz.cmz32 
               NEXT FIELD cmz32
            END IF  
         END IF  
         LET g_cmz_o.cmz32=g_cmz.cmz32
 
      AFTER FIELD cmz40
         IF NOT cl_null(g_cmz.cmz40) THEN 
            IF g_cmz.cmz40 <=0 THEN
               LET g_cmz.cmz40=g_cmz_o.cmz40
               DISPLAY BY NAME g_cmz.cmz40 
               NEXT FIELD cmz40
            END IF  
         END IF  
         LET g_cmz_o.cmz40=g_cmz.cmz40
 
      AFTER FIELD cmz41
         IF NOT cl_null(g_cmz.cmz41) THEN 
            IF g_cmz.cmz41 <=0 OR (g_cmz.cmz40>g_cmz.cmz41) THEN
               LET g_cmz.cmz41=g_cmz_o.cmz41
               DISPLAY BY NAME g_cmz.cmz41 
               NEXT FIELD cmz41
            END IF  
         END IF  
         LET g_cmz_o.cmz41=g_cmz.cmz41
 
      AFTER FIELD cmz42
         IF NOT cl_null(g_cmz.cmz42) THEN 
         #  IF g_cmz.cmz42 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz42 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz42=g_cmz_o.cmz42
               DISPLAY BY NAME g_cmz.cmz42 
               NEXT FIELD cmz42
            END IF  
         END IF  
         LET g_cmz_o.cmz42=g_cmz.cmz42
 
      AFTER FIELD cmz50
         IF NOT cl_null(g_cmz.cmz50) THEN 
            IF g_cmz.cmz50 <=0 THEN
               LET g_cmz.cmz50=g_cmz_o.cmz50
               DISPLAY BY NAME g_cmz.cmz50 
               NEXT FIELD cmz50
            END IF  
         END IF  
         LET g_cmz_o.cmz50=g_cmz.cmz50
 
      AFTER FIELD cmz51
         IF NOT cl_null(g_cmz.cmz51) THEN 
            IF g_cmz.cmz51 <=0 OR (g_cmz.cmz50>g_cmz.cmz51) THEN
               LET g_cmz.cmz51=g_cmz_o.cmz51
               DISPLAY BY NAME g_cmz.cmz51 
               NEXT FIELD cmz51
            END IF  
         END IF  
         LET g_cmz_o.cmz51=g_cmz.cmz51
 
      AFTER FIELD cmz52
         IF NOT cl_null(g_cmz.cmz52) THEN 
         #  IF g_cmz.cmz52 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz52 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz52=g_cmz_o.cmz52
               DISPLAY BY NAME g_cmz.cmz52 
               NEXT FIELD cmz52
            END IF  
         END IF  
         LET g_cmz_o.cmz52=g_cmz.cmz52
 
      AFTER FIELD cmz60
         IF NOT cl_null(g_cmz.cmz60) THEN 
            IF cl_null(g_cmz.cmz60) OR g_cmz.cmz60 <=0 THEN
               LET g_cmz.cmz60=g_cmz_o.cmz60
               DISPLAY BY NAME g_cmz.cmz60 
               NEXT FIELD cmz60
            END IF  
         END IF  
         LET g_cmz_o.cmz60=g_cmz.cmz60
      AFTER FIELD cmz61
         IF NOT cl_null(g_cmz.cmz61) THEN 
            IF g_cmz.cmz61 <=0 OR (g_cmz.cmz60>g_cmz.cmz61) THEN
               LET g_cmz.cmz61=g_cmz_o.cmz61
               DISPLAY BY NAME g_cmz.cmz61 
               NEXT FIELD cmz61
            END IF  
         END IF  
         LET g_cmz_o.cmz61=g_cmz.cmz61
 
      AFTER FIELD cmz62
         IF NOT cl_null(g_cmz.cmz62) THEN 
         #  IF g_cmz.cmz62 <=0 THEN              #No.CHI-930009
            IF g_cmz.cmz62 < 0 THEN              #No.CHI-930009
               LET g_cmz.cmz62=g_cmz_o.cmz62
               DISPLAY BY NAME g_cmz.cmz62 
               NEXT FIELD cmz62
            END IF  
         END IF  
         LET g_cmz_o.cmz62=g_cmz.cmz62
 
      AFTER INPUT   
         IF INT_FLAG THEN 
            EXIT INPUT 
         END IF  
        #FUN-970102--begin--mark--
       ##IF cl_null(g_cmz.cmz02) OR g_cmz.cmz02 <=0 THEN   #No.CHI-930009
        #IF cl_null(g_cmz.cmz02) OR g_cmz.cmz02 < 0 THEN   #No.CHI-930009 
        #   LET g_cmz.cmz02 = g_cmz_o.cmz02 
        #   DISPLAY BY NAME g_cmz.cmz02 
        #   NEXT FIELD cmz02 
        #END IF  
        #FUN-970102--end--mark--
       # IF cl_null(g_cmz.cmz03) OR g_cmz.cmz03 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz03) OR g_cmz.cmz03 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz03 = g_cmz_o.cmz03 
            DISPLAY BY NAME g_cmz.cmz03 
            NEXT FIELD cmz03 
         END IF  
       # IF cl_null(g_cmz.cmz04) OR g_cmz.cmz04 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz04) OR g_cmz.cmz04 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz04 = g_cmz_o.cmz04 
            DISPLAY BY NAME g_cmz.cmz04 
            NEXT FIELD cmz04 
         END IF  
       # IF cl_null(g_cmz.cmz05) OR g_cmz.cmz05 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz05) OR g_cmz.cmz05 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz05 = g_cmz_o.cmz05 
            DISPLAY BY NAME g_cmz.cmz05 
            NEXT FIELD cmz05 
         END IF  
       # IF cl_null(g_cmz.cmz06) OR g_cmz.cmz06 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz06) OR g_cmz.cmz06 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz06 = g_cmz_o.cmz06 
            DISPLAY BY NAME g_cmz.cmz06 
            NEXT FIELD cmz06 
         END IF  
       # IF cl_null(g_cmz.cmz07) OR g_cmz.cmz07 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz07) OR g_cmz.cmz07 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz07 = g_cmz_o.cmz07 
            DISPLAY BY NAME g_cmz.cmz07 
            NEXT FIELD cmz07 
         END IF  
       # IF cl_null(g_cmz.cmz08) OR g_cmz.cmz08 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz08) OR g_cmz.cmz08 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz08 = g_cmz_o.cmz08 
            DISPLAY BY NAME g_cmz.cmz08 
            NEXT FIELD cmz08 
         END IF  
         IF cl_null(g_cmz.cmz09) OR g_cmz.cmz09 NOT MATCHES '[12]' THEN 
            LET g_cmz.cmz09 = g_cmz_o.cmz09 
            DISPLAY BY NAME g_cmz.cmz09 
            NEXT FIELD cmz09
         END IF  
         IF cl_null(g_cmz.cmz10) OR g_cmz.cmz10 NOT MATCHES '[12]' THEN 
            LET g_cmz.cmz10 = g_cmz_o.cmz10 
            DISPLAY BY NAME g_cmz.cmz10 
            NEXT FIELD cmz10
         END IF  
         #FUN-930100--BEGIN--
         IF cl_null(g_cmz.cmz25) OR g_cmz.cmz25 NOT MATCHES '[12]' THEN 
            LET g_cmz.cmz25 = g_cmz_o.cmz25 
            DISPLAY BY NAME g_cmz.cmz25 
            NEXT FIELD cmz25
         END IF  
         IF cl_null(g_cmz.cmz17) OR g_cmz.cmz17 NOT MATCHES '[YNyn]' THEN 
            LET g_cmz.cmz17 = g_cmz_o.cmz17 
            DISPLAY BY NAME g_cmz.cmz17 
            NEXT FIELD cmz17
         END IF  
         IF cl_null(g_cmz.cmz18) OR g_cmz.cmz18 NOT MATCHES '[123456]' THEN 
            LET g_cmz.cmz18 = g_cmz_o.cmz18 
            DISPLAY BY NAME g_cmz.cmz18
            NEXT FIELD cmz18
         END IF  
         IF cl_null(g_cmz.cmz19) OR g_cmz.cmz19 NOT MATCHES '[12]' THEN 
            LET g_cmz.cmz19 = g_cmz_o.cmz19 
            DISPLAY BY NAME g_cmz.cmz19 
            NEXT FIELD cmz19
         END IF  
         #FUN-AB0036--begin--add---------
         IF cl_null(g_cmz.cmz28) OR g_cmz.cmz28 NOT MATCHES '[YNyn]' THEN 
            LET g_cmz.cmz28 = g_cmz_o.cmz28 
            DISPLAY BY NAME g_cmz.cmz28 
            NEXT FIELD cmz28
         END IF  
         #FUN-AB0036--end--add-----------
         IF cl_null(g_cmz.cmz26) OR g_cmz.cmz26 NOT MATCHES '[123]' THEN 
            LET g_cmz.cmz26 = g_cmz_o.cmz26 
            DISPLAY BY NAME g_cmz.cmz26
            NEXT FIELD cmz26
         END IF  
         IF cl_null(g_cmz.cmz24) OR g_cmz.cmz24 NOT MATCHES '[1234567]' THEN 
            LET g_cmz.cmz24 = g_cmz_o.cmz24 
            DISPLAY BY NAME g_cmz.cmz24
            NEXT FIELD cmz24
         END IF  
         IF cl_null(tm.s1) OR tm.s1 NOT MATCHES '[123]' THEN 
            NEXT FIELD s1 
         END IF  
         IF cl_null(tm.s2) OR tm.s2 NOT MATCHES '[123]' THEN 
            NEXT FIELD s2 
         END IF  
         IF cl_null(tm.s3) OR tm.s3 NOT MATCHES '[123]' THEN 
            NEXT FIELD s3 
         END IF  
         #FUN-930100--END--
         IF cl_null(g_cmz.cmz20) OR g_cmz.cmz20 <0 THEN 
            LET g_cmz.cmz20 = g_cmz_o.cmz20 
            DISPLAY BY NAME g_cmz.cmz20 
            NEXT FIELD cmz20
         END IF  
         IF cl_null(g_cmz.cmz21) OR g_cmz.cmz21 <=0 THEN 
            LET g_cmz.cmz21 = g_cmz_o.cmz21 
            DISPLAY BY NAME g_cmz.cmz21 
            NEXT FIELD cmz21
         END IF  
       # IF cl_null(g_cmz.cmz22) OR g_cmz.cmz22 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz22) OR g_cmz.cmz22 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz22 = g_cmz_o.cmz22 
            DISPLAY BY NAME g_cmz.cmz22 
            NEXT FIELD cmz22 
         END IF  
 
         IF cl_null(g_cmz.cmz30) OR g_cmz.cmz30 <=0 THEN 
            LET g_cmz.cmz30 = g_cmz_o.cmz30 
            DISPLAY BY NAME g_cmz.cmz30 
            NEXT FIELD cmz30
         END IF  
         IF cl_null(g_cmz.cmz31) OR g_cmz.cmz31 <=0 THEN 
            LET g_cmz.cmz31 = g_cmz_o.cmz31 
            DISPLAY BY NAME g_cmz.cmz31 
            NEXT FIELD cmz31
         END IF  
       # IF cl_null(g_cmz.cmz32) OR g_cmz.cmz32 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz32) OR g_cmz.cmz32 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz32 = g_cmz_o.cmz32 
            DISPLAY BY NAME g_cmz.cmz32 
            NEXT FIELD cmz32 
         END IF  
 
         IF cl_null(g_cmz.cmz40) OR g_cmz.cmz40 <=0 THEN 
            LET g_cmz.cmz40 = g_cmz_o.cmz40 
            DISPLAY BY NAME g_cmz.cmz40 
            NEXT FIELD cmz40
         END IF  
         IF cl_null(g_cmz.cmz41) OR g_cmz.cmz41 <=0 THEN 
            LET g_cmz.cmz41 = g_cmz_o.cmz41 
            DISPLAY BY NAME g_cmz.cmz41 
            NEXT FIELD cmz41 
         END IF  
       # IF cl_null(g_cmz.cmz42) OR g_cmz.cmz42 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz42) OR g_cmz.cmz42 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz42 = g_cmz_o.cmz42 
            DISPLAY BY NAME g_cmz.cmz42 
            NEXT FIELD cmz42
         END IF  
 
         IF cl_null(g_cmz.cmz50) OR g_cmz.cmz50 <=0 THEN 
            LET g_cmz.cmz50 = g_cmz_o.cmz50 
            DISPLAY BY NAME g_cmz.cmz50 
            NEXT FIELD cmz50
         END IF  
         IF cl_null(g_cmz.cmz51) OR g_cmz.cmz51 <=0 THEN 
            LET g_cmz.cmz51 = g_cmz_o.cmz51 
            DISPLAY BY NAME g_cmz.cmz51 
            NEXT FIELD cmz51
         END IF  
       # IF cl_null(g_cmz.cmz52) OR g_cmz.cmz52 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz52) OR g_cmz.cmz52 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz52 = g_cmz_o.cmz52 
            DISPLAY BY NAME g_cmz.cmz52 
            NEXT FIELD cmz52
         END IF  
 
         IF cl_null(g_cmz.cmz60) OR g_cmz.cmz60 <=0 THEN 
            LET g_cmz.cmz60 = g_cmz_o.cmz60 
            DISPLAY BY NAME g_cmz.cmz60 
            NEXT FIELD cmz60
         END IF  
         IF cl_null(g_cmz.cmz61) OR g_cmz.cmz61 <=0 THEN 
            LET g_cmz.cmz61 = g_cmz_o.cmz61 
            DISPLAY BY NAME g_cmz.cmz61 
            NEXT FIELD cmz61
         END IF  
       # IF cl_null(g_cmz.cmz62) OR g_cmz.cmz62 <=0 THEN   #No.CHI-930009
         IF cl_null(g_cmz.cmz62) OR g_cmz.cmz62 < 0 THEN   #No.CHI-930009
            LET g_cmz.cmz62 = g_cmz_o.cmz62 
            DISPLAY BY NAME g_cmz.cmz62 
            NEXT FIELD cmz62 
         END IF  
         LET g_cmz.cmz23 = tm.s1,tm.s2,tm.s3   #FUN-930100
 
#FUN-930100--begin--mark--
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(cmz11)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_imd"
#                 LET g_qryparam.default1 = g_cmz.cmz11
#                #LET g_qryparam.arg1     = "A"
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                 CALL cl_create_qry() RETURNING g_cmz.cmz11
#                 #CALL FGL_DIALOG_SETBUFFER( g_cmz.cmz11)
#                 DISPLAY BY NAME g_cmz.cmz11
#                 NEXT FIELD cmz11
#           WHEN INFIELD(cmz12)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_imd"
#                 LET g_qryparam.default1 = g_cmz.cmz12
#                #LET g_qryparam.arg1     = "A"
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                 CALL cl_create_qry() RETURNING g_cmz.cmz12
#                 #CALL FGL_DIALOG_SETBUFFER( g_cmz.cmz12)
#                 DISPLAY BY NAME g_cmz.cmz12
#                 NEXT FIELD cmz12
#           WHEN INFIELD(cmz13)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_imd"
#                 LET g_qryparam.default1 = g_cmz.cmz13
#                #LET g_qryparam.arg1     = "A"
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                 CALL cl_create_qry() RETURNING g_cmz.cmz13
#                #CALL FGL_DIALOG_SETBUFFER( g_cmz.cmz13)
#                 DISPLAY BY NAME g_cmz.cmz13
#                 NEXT FIELD cmz13
#           WHEN INFIELD(cmz14)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_imd"
#                 LET g_qryparam.default1 = g_cmz.cmz14
#                #LET g_qryparam.arg1     = "A"
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                 CALL cl_create_qry() RETURNING g_cmz.cmz14
#                 #CALL FGL_DIALOG_SETBUFFER( g_cmz.cmz14)
#                 DISPLAY BY NAME g_cmz.cmz14
#                 NEXT FIELD cmz14
#           WHEN INFIELD(cmz15)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form     = "q_imd"
#                 LET g_qryparam.default1 = g_cmz.cmz15
#                #LET g_qryparam.arg1     = "A"
#                  LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
#                 CALL cl_create_qry() RETURNING g_cmz.cmz15
#                 #CALL FGL_DIALOG_SETBUFFER( g_cmz.cmz15)
#                 DISPLAY BY NAME g_cmz.cmz15
#                 NEXT FIELD cmz15
#        END CASE
#FUN-930100--end--mark--
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

#FUN-AB0036 begin--add-------
FUNCTION s020_set_entry()
  CALL cl_set_comp_entry("cmz28",TRUE)
END FUNCTION

FUNCTION s020_set_no_entry()
  IF cl_null(g_cmz.cmz19) OR g_cmz.cmz19 <> '1' THEN
     CALL cl_set_comp_entry("cmz28",FALSE)
  ELSE
     CALL cl_set_comp_entry("cmz28",TRUE)
  END IF
END FUNCTION
#FUN-AB0036-end--add--------
