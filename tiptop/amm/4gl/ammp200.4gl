# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: ammp200.4gl
# Descriptions...: 通知單分配作業
# Date & Author..: 00/12/14 By Faith
# Modify.........: 01/01/31 By Chien
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550054 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-560060 05/06/17 By day 單據編號修改
# Modify.........: No.FUN-660094 06/06/12 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-690025 06/09/18 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710113 07/03/22 By Ray 取消單身新增功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-930113 09/03/18 By mike 將oah_file-->pnz_file 
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-BB0086 12/01/12 By tanxc 增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   g_mmj           RECORD LIKE mmj_file.*,
         g_mmj_t         RECORD LIKE mmj_file.*,
         g_old_mmj03     LIKE mmj_file.mmj03,
         g_old_mmj01     LIKE mmj_file.mmj01,
         g_n_mme01       LIKE mme_file.mme01,
         g_mmk01         LIKE mmk_file.mmk01,
         g_mmk07         LIKE mmk_file.mmk07,
         g_mmk08         LIKE mmk_file.mmk08,
         g_mmk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
             mmk02       LIKE mmk_file.mmk02,   #項次
             mmk03       LIKE mmk_file.mmk03,   #料件編號
             mmk031      LIKE mmk_file.mmk031,  #單位
             mmk04       LIKE mmk_file.mmk04,   #圖號
             mmk11       LIKE mmk_file.mmk11,   #需求單號
             mmk111      LIKE mmk_file.mmk111,  #項次
             mmk09       LIKE mmk_file.mmk09,   #開始日期
             mmk10       LIKE mmk_file.mmk10,   #加工數量
             mmk13       LIKE mmk_file.mmk13,   #工時
             mmk05       LIKE mmk_file.mmk05,   #版本
             mmk06       LIKE mmk_file.mmk06,   #規格說明
             mmk14       LIKE mmk_file.mmk14,   #備註
             mmk091      LIKE mmk_file.mmk091,  #完成日期
             mmk12       LIKE mmk_file.mmk12,   #單價
             mmk15       LIKE mmk_file.mmk15,   #加工碼
             mmc02       LIKE mmc_file.mmc02    #加工說明
                         END RECORD,
         g_mmk_t         RECORD                 #程式變數 (舊值)
             mmk02       LIKE mmk_file.mmk02,   #項次
             mmk03       LIKE mmk_file.mmk03,   #料件編號
             mmk031      LIKE mmk_file.mmk031,  #單位
             mmk04       LIKE mmk_file.mmk04,   #圖號
             mmk11       LIKE mmk_file.mmk11,   #需求單號
             mmk111      LIKE mmk_file.mmk111,  #項次
             mmk09       LIKE mmk_file.mmk09,   #開始日期
             mmk10       LIKE mmk_file.mmk10,   #加工數量
             mmk13       LIKE mmk_file.mmk13,   #工時
             mmk05       LIKE mmk_file.mmk05,   #版本
             mmk06       LIKE mmk_file.mmk06,   #規格說明
             mmk14       LIKE mmk_file.mmk14,   #備註
             mmk091      LIKE mmk_file.mmk091,  #完成日期
             mmk12       LIKE mmk_file.mmk12,   #單價
             mmk15       LIKE mmk_file.mmk15,   #加工碼
             mmc02       LIKE mmc_file.mmc02    #加工說明
                         END RECORD,
         tm  RECORD			           # Print condition RECORD
               wc        LIKE type_file.chr1000,   #No.FUN-680100 VARCHAR(300)#Where Condition
               opdate    LIKE type_file.dat        #No.FUN-680100 DATE
            END RECORD,
         tm2_1  RECORD	
              ano        LIKE smy_file.smyslip     #No.FUN-680100 VARCHAR(5)#No.FUN-550054
            END RECORD,
            g_t1              LIKE smy_file.smyslip,               #No.FUN-550054  #No.FUN-680100 VARCHAR(5)
            g_exit            LIKE type_file.chr1,                 #No.FUN-680100 VARCHAR(1)
             g_wc,g_wc2,g_sql STRING,    #No.FUN-580092 HCN        #No.FUN-680100
            g_rec_b           LIKE type_file.num5,                #單身筆數        #No.FUN-680100 SMALLINT
            l_ac              LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680100 SMALLINT
            l_sl              LIKE type_file.num5                 #No.FUN-680100 SMALLINT#目前處理的SCREEN LINE
DEFINE      g_forupd_sql      STRING     #No.FUN-680100
 
#主程式開始
 
 
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0076
    p_row,p_col   LIKE type_file.num5                       #計算被使用時間        #No.FUN-680100 SMALLINT
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)           #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
 
   LET p_row = 2 LET p_col = 2
   OPEN WINDOW p200_w AT p_row,p_col   #顯示畫面
      WITH FORM "amm/42f/ammp200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL p200_menu()
   CLOSE WINDOW p200_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
#QBE 查詢資料
FUNCTION p200_cs(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   CLEAR FORM                                        #清除畫面
   CALL g_mmk.clear()
   IF p_cmd != 'g' THEN
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_mmj.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON mmj01,mmj02,mmj03,
                                mmj11,mmj14,mmj04,mmj05,
                                mmj06,mmj07,mmj10,mmj12,
                                mmj15,mmj13
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mmjuser', 'mmjgrup') #FUN-980030
      IF INT_FLAG THEN RETURN END IF
      CONSTRUCT g_wc2 ON mmk02,mmk03,mmk031,mmk04,mmk05,mmk06,
                         mmk09,mmk091,mmk10,mmk11,mmk111,
                         mmk12,mmk13,mmk14,mmk15,mmc02
                    FROM s_mmk[1].mmk02,s_mmk[1].mmk03,s_mmk[1].mmk031,
                         s_mmk[1].mmk04,s_mmk[1].mmk05,s_mmk[1].mmk06,
                         s_mmk[1].mmk09,s_mmk[1].mmk091,s_mmk[1].mmk10,
                         s_mmk[1].mmk11,s_mmk[1].mmk111,s_mmk[1].mmk12,
                        #s_mmk[1].mmk13,s_mmk[1].mmk14,s_mmk[1].mmk13, #FUN-930113 
                         s_mmk[1].mmk13,s_mmk[1].mmk14,s_mmk[1].mmk15, #FUN-930113 
                         s_mmk[1].mmc02
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   ELSE
      LET g_wc2 = " 1=1"
      LET g_wc =  " 1=1"
   END IF
   IF g_wc2 =" 1=1" THEN
      LET g_sql = "SELECT mmj01 ",
                  "  FROM mmj_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY mmj01 "
   ELSE
      LET g_sql = "SELECT DISTINCT mmj_file.mmj01 ",
                  "  FROM mmk_file,mmj_file",
                  " WHERE mmk01 = mmj01 AND ",
                    g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY mmj01 "
   END IF
   PREPARE p200_prepare FROM g_sql
   DECLARE p200_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR p200_prepare
 
   LET g_forupd_sql = "SELECT * FROM mmj_file WHERE mmj01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p200_cl CURSOR FROM g_forupd_sql
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT COUNT(*) FROM mmj_file WHERE ", g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT mmj01) ",
                " FROM mmk_file,mmj_file ",
                " WHERE mmk01=mmj01  ",
                " AND ",g_wc CLIPPED,
                " AND ",g_wc2 CLIPPED
   END IF
   PREPARE p200_precount FROM g_sql
   DECLARE p200_count CURSOR FOR p200_precount
END FUNCTION
 
#中文的MENU
FUNCTION p200_menu()
 
   WHILE TRUE
      CALL p200_bp("G")
      CASE g_action_choice
        #@G.產生
         WHEN "generate"
            IF cl_chk_act_auth() THEN
               CALL p200_g()
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
               ELSE
                  CALL p200_q('g')
               END IF
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL p200_q('q')
            END IF
         WHEN "next"
            CALL p200_fetch('N')
         WHEN "previous"
            CALL p200_fetch('P')
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        #@T.轉出
         WHEN "transfer_out"
            IF cl_chk_act_auth() THEN
               CALL p200_t()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL p200_r()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "jump"
            CALL p200_fetch('/')
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p200_g()
   DEFINE   l_cnt,p_row,p_col   LIKE type_file.num5,          #No.FUN-680100 SMALLINT
            l_mma               RECORD LIKE mma_file.*,
            l_mmb               RECORD LIKE mmb_file.*,
            l_flag              LIKE type_file.num5,          #No.FUN-680100 SMALLINT
            l_sql               STRING,                       #No.FUN-680100
            l_name              LIKE type_file.chr20,         #No.FUN-680100 VARCHAR(20)
            l_pmc               RECORD LIKE pmc_file.*
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p200_g AT p_row,p_col          #條件畫面
      WITH FORM "amm/42f/ammp200_a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("ammp200_a")
 
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON mma01,mma07,mma15,mma021,mmb08,mmamodu
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END CONSTRUCT
      IF INT_FLAG THEN
         CLOSE WINDOW p200_g
         EXIT WHILE
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      LET tm.opdate = TODAY
 
      INPUT BY NAME tm.opdate WITHOUT DEFAULTS
         AFTER FIELD opdate
            IF cl_null(tm.opdate) THEN
               LET tm.opdate = g_today
               NEXT FIELD opdate
            END IF
 
         AFTER INPUT
             IF INT_FLAG THEN
                EXIT INPUT
             END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END INPUT
 
      IF NOT cl_sure(20,20) THEN
         LET INT_FLAG=1
      END IF
      IF INT_FLAG THEN
         CLOSE WINDOW p200_g
         EXIT WHILE
      END IF
      CALL cl_wait()
      LET l_sql="SELECT mma_file.*,mmb_file.* ",
                "  FROM mma_file,mmb_file  WHERE",
                "  mma01=mmb01",
                "   AND mma17 = 'Y' ",
                "   AND mmb13 = '1' ",
                "   AND mmbacti = 'Y' ",	#有效 by tony
                "   AND ",tm.wc CLIPPED, "ORDER BY mmb08,mmb01,mmb02"
         PREPARE p200_prepare1 FROM l_sql
         DECLARE mmj_cl CURSOR FOR p200_prepare1
 
         BEGIN WORK
         LET g_old_mmj03='@@@@@@@@@@'
         LET g_success = 'Y'
         LET g_exit = 'N'
         FOREACH mmj_cl INTO l_mma.*,l_mmb.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('mmj_cl',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
            SELECT COUNT(*) INTO g_cnt FROM mmk_file
             WHERE mmk11 = l_mmb.mmb01
               AND mmk111 = l_mmb.mmb02
            IF g_cnt > 0 THEN
               CONTINUE FOREACH
            END IF
            IF g_old_mmj03 <> l_mmb.mmb08 THEN
               IF g_cnt !=0 AND g_old_mmj03 <> '@@@@@@@@@@' THEN
                  CALL p200_upd_mmj()
               END IF
               SELECT MAX(mmj01)+1 INTO g_mmj.mmj01 FROM mmj_file
               IF cl_null(g_mmj.mmj01) THEN
                  LET g_mmj.mmj01=1
               END IF
               LET g_mmj.mmj01 = g_mmj.mmj01 USING '&&&&&&&&&&'
               LET g_mmj.mmj02 = tm.opdate
               LET g_mmj.mmj03 = l_mmb.mmb08
               SELECT pmc_file.*  INTO l_pmc.* FROM pmc_file  WHERE pmc01 = g_mmj.mmj03
               IF l_mmb.mmb07 = 'M' THEN
                  LET g_mmj.mmj04 = NULL
                  LET g_mmj.mmj05 = NULL
                  LET g_mmj.mmj10 = NULL
                  LET g_mmj.mmj11 = NULL
                  LET g_mmj.mmj12 = NULL
                  LET g_mmj.mmj14 = NULL
               ELSE
                  LET g_mmj.mmj04 = l_pmc.pmc15
                  LET g_mmj.mmj05 = l_pmc.pmc16
                  LET g_mmj.mmj10 = l_pmc.pmc17
                  LET g_mmj.mmj11 = l_pmc.pmc47
                  LET g_mmj.mmj12 = l_pmc.pmc22
                  LET g_mmj.mmj14 = l_pmc.pmc49
               END IF
               LET g_mmj.mmj06 = g_user
               LET g_mmj.mmj07 = l_mma.mma15
               LET g_mmj.mmj08 = NULL
               LET g_mmj.mmj09 = NULL
               LET g_mmj.mmj13 = 0
               LET g_mmj.mmj15 = 0
               LET g_mmj.mmjprno = 0
               LET g_mmj.mmjprdt = NULL
               LET g_mmj.mmjacti = 'Y'
               LET g_mmj.mmjuser = g_user
               LET g_mmj.mmjgrup = g_grup
               LET g_mmj.mmjmodu = NULL
               LET g_mmj.mmjdate = g_today
               LET g_mmj.mmjplant = g_plant #FUN-980004 add
               LET g_mmj.mmjlegal = g_legal #FUN-980004 add
 
               LET g_mmj.mmjoriu = g_user      #No.FUN-980030 10/01/04
               LET g_mmj.mmjorig = g_grup      #No.FUN-980030 10/01/04
               INSERT INTO mmj_file VALUES(g_mmj.*)
               IF SQLCA.sqlcode  THEN
                  LET g_success = 'N'
#                  CALL cl_err('ins mmj #1',SQLCA.sqlcode,0) #No.FUN-660094
                   CALL cl_err3("ins","mmj_file",g_mmj.mmj01,"",SQLCA.SQLCODE,"","ins mmj #1",0)        #NO.FUN-660094
                  EXIT FOREACH
               END IF
            END IF
            CALL  p200_ins_mmk(l_mma.*,l_mmb.*)
 
            LET g_old_mmj03=l_mmb.mmb08
            LET g_cnt=g_cnt+1
         END FOREACH
         IF g_cnt!=0 THEN
            CALL p200_upd_mmj()
         END IF
         IF g_exit = 'Y' THEN
            CALL cl_err(g_mmj.mmj01,'mfg2601',0)
            CONTINUE WHILE
         END IF
         IF g_success = 'Y' THEN
            CALL cl_cmmsg(1) COMMIT WORK
         ELSE
            CALL cl_rbmsg(1) ROLLBACK WORK
         END IF
 
      CALL cl_end(20,20)
      CLOSE WINDOW p200_g
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION p200_ins_mmk(l_mma,l_mmb)
DEFINE   l_mmk   RECORD LIKE mmk_file.*,
         l_mma   RECORD LIKE mma_file.*,
         l_mmb   RECORD LIKE mmb_file.*
 
 
   LET l_mmk.mmk01= g_mmj.mmj01
   SELECT MAX(mmk02)+1 INTO l_mmk.mmk02 FROM mmk_file
    WHERE mmk01 = l_mmk.mmk01
   IF cl_null(l_mmk.mmk02) THEN
      LET l_mmk.mmk02=1
   END IF
   LET l_mmk.mmk02 = l_mmk.mmk02
   LET l_mmk.mmk03 = l_mma.mma05
   LET l_mmk.mmk031= l_mma.mma10
   LET l_mmk.mmk04 = l_mma.mma05
   LET l_mmk.mmk05 = l_mma.mma051
   LET l_mmk.mmk06 = l_mmb.mmb06
   LET l_mmk.mmk07 = l_mmb.mmb07
   LET l_mmk.mmk08 = l_mma.mma10
   LET l_mmk.mmk09 = l_mmb.mmb12
   LET l_mmk.mmk091= l_mmb.mmb121
   LET l_mmk.mmk10 = l_mmb.mmb09
   LET l_mmk.mmk10 = s_digqty(l_mmk.mmk10,l_mmk.mmk031)   #No.FUN-BB0086
   LET l_mmk.mmk11 = l_mmb.mmb01
   LET l_mmk.mmk111= l_mmb.mmb02
   LET l_mmk.mmk12 = l_mmb.mmb10
   LET l_mmk.mmk13 = l_mmb.mmb11
   LET l_mmk.mmk14 = l_mmb.mmb15
   LET l_mmk.mmk15 = l_mmb.mmb05
   LET l_mmk.mmkplant = g_plant #FUN-980004 add
   LET l_mmk.mmklegal = g_legal #FUN-980004 add
 
   INSERT INTO mmk_file VALUES(l_mmk.*)
   IF SQLCA.sqlcode  THEN
      LET g_success = 'N'
 #     CALL cl_err('ins mmk #1',SQLCA.sqlcode,0)     #NO.FUN-660094  
       CALL cl_err3("ins","mmk_file",l_mmk.mmk01,l_mmk.mmk02,SQLCA.SQLCODE,"","ins mmk#1",0) #NO.FUN-660094
   END IF
END FUNCTION
 
FUNCTION p200_upd_mmj()
   DEFINE   l_mmj13   LIKE mmj_file.mmj13,
            l_mmj15   LIKE mmj_file.mmj15,
            l_newno   LIKE mmj_file.mmj01
 
   SELECT SUM(mmk13*mmk10),SUM(mmk12*mmk10) INTO l_mmj15,l_mmj13
     FROM mmk_file WHERE mmk01=g_mmj.mmj01
   UPDATE mmj_file SET
          mmj13=l_mmj13,
          mmj15=l_mmj15
    WHERE mmj01 = g_mmj.mmj01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
#      CALL cl_err('mmj13,mmj15',SQLCA.sqlcode,0) #No.FUN-660094
       CALL cl_err3("upd","mmj_file",g_mmj.mmj01,"",SQLCA.SQLCODE,"","mmj13,mmj15",0)        #NO.FUN-660094
   END IF
END FUNCTION
 
#Query 查詢
FUNCTION p200_q(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_mmk.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL p200_cs(p_cmd)
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN p200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_mmj.* TO NULL
   ELSE
      OPEN p200_count
      FETCH p200_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p200_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION p200_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,                 #處理方式        #No.FUN-680100 VARCHAR(1)
            l_abso   LIKE type_file.num10                 #絕對的筆數      #No.FUN-680100 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     p200_cs INTO g_mmj.mmj01
      WHEN 'P' FETCH PREVIOUS p200_cs INTO g_mmj.mmj01
      WHEN 'F' FETCH FIRST    p200_cs INTO g_mmj.mmj01
      WHEN 'L' FETCH LAST     p200_cs INTO g_mmj.mmj01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p200_cs INTO g_mmj.mmj01
         LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mmj.mmj01,SQLCA.sqlcode,0)
      INITIALIZE g_mmj.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_mmj.* FROM mmj_file WHERE mmj01 = g_mmj.mmj01
   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_mmj.mmj01,SQLCA.sqlcode,0) #No.FUN-660094
       CALL cl_err3("sel","mmj_file",g_mmj.mmj01,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660094
      INITIALIZE g_mmj.* TO NULL
      RETURN
   END IF
 
   CALL p200_show()
END FUNCTION
 
FUNCTION p200_r()
   IF g_mmj.mmj01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   OPEN p200_cl USING g_mmj.mmj01
   FETCH p200_cl INTO g_mmj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_mmj.mmj01,SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
      CALL p200_show()
      IF cl_delh(0,0) THEN
         DELETE FROM mmj_file WHERE mmj01 = g_mmj.mmj01
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_mmj.mmj01,SQLCA.sqlcode,0) #No.FUN-660094
             CALL cl_err3("del","mmj_file",g_mmj.mmj01,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660094
            ROLLBACK WORK
            RETURN
         END IF
         DELETE FROM mmk_file WHERE mmk01 = g_mmj.mmj01
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_mmj.mmj01,SQLCA.sqlcode,0) #No.FUN-660094
             CALL cl_err3("del","mmk_file",g_mmj.mmj01,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660094
            ROLLBACK WORK
            RETURN
         END IF
         CLEAR FORM
         CALL g_mmk.clear()
      END IF
   CLOSE p200_cl
   COMMIT WORK
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p200_show()
   DEFINE   l_pnz02     LIKE pnz_file.pnz02, #FUN-930113 oah-->pnz
            l_pmc03     LIKE pmc_file.pmc03,
            l_pmc15     LIKE pmc_file.pmc15,
            l_pmc16     LIKE pmc_file.pmc16,
            l_gec02     LIKE gec_file.gec02,
            l_gecacti   LIKE gec_file.gecacti,
            l_gen02     LIKE gen_file.gen02,
            l_genacti   LIKE gen_file.genacti,
            l_gem02     LIKE gem_file.gem02,
            l_gemacti   LIKE gem_file.gemacti
 
   LET g_mmj_t.* = g_mmj.*                #保存單頭舊值
   DISPLAY BY NAME g_mmj.mmj01, g_mmj.mmj02, g_mmj.mmj03, g_mmj.mmj11,
                   g_mmj.mmj14, g_mmj.mmj04, g_mmj.mmj05, g_mmj.mmj06,
                   g_mmj.mmj07,g_mmj.mmj10,g_mmj.mmj12,g_mmj.mmj15,
                   g_mmj.mmj13
   SELECT pmc03,pmc15,pmc16
     INTO l_pmc03,l_pmc15,l_pmc16
     FROM pmc_file
    WHERE pmc01 = g_mmj.mmj03
### tony 010110
   IF STATUS THEN
      SELECT gem02,'','' INTO l_pmc03,l_pmc15,l_pmc16 FROM gem_file
       WHERE gem01=g_mmj.mmj03
   END IF
###
   DISPLAY l_pmc03 TO FORMONLY.pmc03
   DISPLAY l_pmc15 TO FORMONLY.pmc15
   DISPLAY l_pmc16 TO FORMONLY.pmc16
 
   SELECT gec02,gecacti
     INTO l_gec02,l_gecacti
     FROM gec_file
    WHERE gec01 = g_mmj.mmj11
   DISPLAY l_gec02 TO FORMONLY.gec02
 
   SELECT gen02,genacti
     INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_mmj.mmj06
   DISPLAY l_gen02 TO FORMONLY.gen02
 
   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = g_mmj.mmj07
   DISPLAY l_gem02 TO FORMONLY.gem02
 
   SELECT pnz02 #FUN-930113 oah-->pnz
     INTO l_pnz02 #FUN-930113 oah-->pnz    
     FROM pnz_file #FUN-930113 oah-->pnz    
    WHERE pnz01 = g_mmj.mmj14 #FUN-930113 oah-->pnz    
   DISPLAY l_pnz02 TO FORMONLY.pnz02 #FUN-930113 oah-->pnz    
 
   CALL p200_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION p200_b()
   DEFINE   l_ac_t           LIKE type_file.num5,               #未取消的ARRAY CNT        #No.FUN-680100 SMALLINT
            l_n              LIKE type_file.num5,               #檢查重複用        #No.FUN-680100 SMALLINT
            l_lock_sw        LIKE type_file.chr1,               #單身鎖住否        #No.FUN-680100 VARCHAR(1)
            p_cmd            LIKE type_file.chr1,               #處理狀態          #No.FUN-680100 VARCHAR(1)
            l_a              LIKE type_file.chr1,               #No.FUN-680100 VARCHAR(1)#可更改否 (含取消)
            l_jump           LIKE type_file.num5,               #No.FUN-680100 SMALLINT#判斷是否跳過AFTER ROW的處理
            l_allow_insert   LIKE type_file.chr1,               #No.FUN-680100 VARCHAR(1)
            l_allow_delete   LIKE type_file.chr1                #No.FUN-680100 VARCHAR(1)
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_mmj.mmj01 IS NULL THEN RETURN END IF
 
#   LET l_allow_insert = cl_detail_input_auth('insert')      #No.TQC-710113
    LET l_allow_delete = cl_detail_input_auth('delete')
    LET l_allow_insert = FALSE      #No.TQC-710113
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT mmk02,mmk03,mmk031,mmk04,mmk11,mmk111,",
                       "       mmk09,mmk10,mmk13,mmk05,mmk06,mmk14,",
                       "       mmk091,mmk12,mmk15",
                       "  FROM mmk_file",
                       "  WHERE mmk01 = ? AND mmk02 = ?",
                       "   FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   INPUT ARRAY g_mmk WITHOUT DEFAULTS FROM s_mmk.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW = l_allow_insert)
 
   BEFORE INPUT
      IF g_rec_b != 0 THEN
        CALL fgl_set_arr_curr(l_ac)
      END IF
 
   BEFORE ROW
      LET l_ac = ARR_CURR()
      LET l_lock_sw = 'N'            #DEFAULT
      LET l_n  = ARR_COUNT()
 
      BEGIN WORK
      OPEN p200_cl USING g_mmj.mmj01
      IF STATUS THEN
         CALL cl_err("OPEN p200_cl:", STATUS, 1)
         CLOSE p200_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH p200_cl INTO g_mmj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_mmj.mmj01,SQLCA.sqlcode,0)
         CLOSE p200_cl
         ROLLBACK WORK
         RETURN
      END IF
      IF g_rec_b >= l_ac THEN
         LET p_cmd='u'
         LET g_mmk_t.* = g_mmk[l_ac].*  #BACKUP
 
         OPEN p200_bcl USING g_mmj.mmj01,g_mmk_t.mmk02
         IF STATUS THEN
            CALL cl_err("OPEN 0200_bcl:", STATUS, 1)
            LET l_lock_sw = "Y"
         ELSE
            FETCH p200_bcl INTO g_mmk[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_mmk_t.mmk02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
         END IF
         CALL cl_show_fld_cont()     #FUN-550037(smin)
      END IF
      NEXT FIELD mmk02
 
   BEFORE DELETE                            #是否取消單身
      IF g_mmk_t.mmk02 > 0 AND
         g_mmk_t.mmk02 IS NOT NULL THEN
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
         DELETE FROM mmk_file
          WHERE mmk01 = g_mmj.mmj01   AND
                mmk02 = g_mmk_t.mmk02
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_mmk_t.mmk02,SQLCA.sqlcode,0) #No.FUN-660094
             CALL cl_err3("del","mmk_file",g_mmj.mmj01,g_mmk_t.mmk02,SQLCA.SQLCODE,"","",0)        #NO.FUN-660094
            ROLLBACK WORK
            CANCEL DELETE
         END IF
         LET g_rec_b = g_rec_b -1
         DISPLAY g_rec_b TO FORMONLY.cn2
         CLOSE p200_bcl
         COMMIT WORK
      END IF
 
      AFTER ROW
        LET l_ac = ARR_CURR()
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd = 'u' THEN
              LET g_mmk[l_ac].* = g_mmk_t.*
           END IF
           CLOSE p200_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
 
#     ON ACTION CONTROLN
#      CALL p200_b_askkey()
#      EXIT INPUT
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE p200_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p200_b_askkey()
   DEFINE   l_wc2   LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(200)
 
   CONSTRUCT l_wc2 ON mmk02,mmk03,mmk031,mmk04,mmk05,mmk06,
                      mmk09,mmk091,mmk10,mmk11,mmk111,
                      mmk12,mmk13,mmk14,mmk15
                 FROM s_mmk[1].mmk02,s_mmk[1].mmk03,s_mmk[1].mmk031,
                      s_mmk[1].ima04,s_mmk[1].mmk05,
                      s_mmk[1].mmk06,s_mmk[1].mmk09,s_mmk[1].mmk091,
                      s_mmk[1].mmk10,s_mmk[1].mmk11,
                      s_mmk[1].mmk12,s_mmk[1].mmk13,
                      s_mmk[1].mmk14,s_mmk[1].mmk15
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL p200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION p200_b_fill(p_wc2)              #BODY FILL UP
   DEFINE   p_wc2   LIKE type_file.chr1000      #No.FUN-680100 VARCHAR(600)
 
   LET g_sql =
       "SELECT mmk02,mmk03,mmk031,mmk04,mmk11,mmk111,mmk09,mmk10,",
       "       mmk13,mmk05,mmk06,mmk14,mmk091,mmk12,mmk15,mmc02",
       " FROM mmk_file LEFT OUTER JOIN mmc_file ON mmk15 = mmc_file.mmc01 ",
       " WHERE  ",
       " mmk01 ='",g_mmj.mmj01,"' AND ",
       p_wc2 CLIPPED
 
   PREPARE p200_pb FROM g_sql
   DECLARE mmk_cl                       #SCROLL CURSOR
       CURSOR FOR p200_pb
 
   CALL g_mmk.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH mmk_cl INTO g_mmk[g_cnt].*   #單身 ARRAY 填充
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_mmk.deleteElement(g_cnt)
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mmk TO s_mmk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
          LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL p200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL p200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL p200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL p200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL p200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION generate
         LET g_action_choice="generate"
         EXIT DISPLAY
      ON ACTION transfer_out
         LET g_action_choice="transfer_out"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       #No.MOD-530688  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
       #No.MOD-530688  --end
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p200_t()
   DEFINE   l_mmk         RECORD   LIKE mmk_file.*,
            l_pmc         RECORD   LIKE pmc_file.*,
            l_mme         RECORD   LIKE mme_file.*,
            l_mmf         RECORD   LIKE mmf_file.*
   DEFINE   l_start       LIKE type_file.chr1,         #No.FUN-680100 VARCHAR(1)
            l_str         LIKE type_file.chr50,        #No.FUN-680100 VARCHAR(50)
            l_startno     LIKE mme_file.mme01,
            l_endno       LIKE mme_file.mme01
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680100 SMALLINT
#No.FUN-550054--begin
   DEFINE   li_result     LIKE type_file.num5          #No.FUN-680100 SMALLINT
#No.FUN-550054--end
 
 
   LET l_start='Y'
   IF g_mmj.mmj01 IS NULL THEN
      RETURN
   END IF
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p2001_w AT p_row,p_col WITH FORM "amm/42f/ammp200_b"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("ammp200_b")
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p2001_w
      RETURN
   END IF
 
   INPUT BY NAME tm2_1.ano WITHOUT DEFAULTS
      AFTER FIELD ano
         IF tm2_1.ano IS NOT NULL THEN
#No.FUN-550054--begin
#            LET g_t1 = tm2_1.ano[1,3]
             LET g_t1 = tm2_1.ano[1,g_doc_len]
            CALL s_check_no("asf",g_t1,"","N","","","")
            RETURNING li_result,tm2_1.ano
            IF (NOT li_result) THEN
               NEXT FIELD ano
            END IF
            LET tm2_1.ano = s_get_doc_no(tm2_1.ano)
            DISPLAY BY NAME tm2_1.ano
#           CALL s_mfgslip(g_t1,'asf','N')
#           IF NOT cl_null(g_errno) THEN
#              CALL cl_err(g_t1,g_errno,0)
#              NEXT FIELD ano
#           END IF
#No.FUN-550054--end
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ano)
               CALL q_smy(FALSE,FALSE,tm2_1.ano,'ASF','N') #TQC-670008
               RETURNING tm2_1.ano
#               CALL FGL_DIALOG_SETBUFFER( tm2_1.ano )
               DISPLAY BY NAME tm2_1.ano
               NEXT FIELD ano
            OTHERWISE EXIT CASE
         END CASE
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
 
   IF NOT cl_sure(0,0) THEN
      LET INT_FLAG =1
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p2001_w
      RETURN
   END IF
   CALL cl_wait()
   LET g_sql="SELECT mmj_file.*,mmk_file.* ",
             "  FROM mmj_file, mmk_file  WHERE ",
             "  mmj01='",g_mmj.mmj01,"' AND mmj01=mmk01 ",
             "   AND ",g_wc CLIPPED, " ORDER BY mmj03,mmk11,mmk111"
 
   PREPARE p200_prepare2 FROM g_sql
   DECLARE mmf_cl  CURSOR FOR p200_prepare2
 
   BEGIN WORK
      LET g_old_mmj01='@@@@@@@@@@'
      LET g_success = 'Y'
      LET g_exit = 'N'
 
   FOREACH mmf_cl INTO g_mmj.*,l_mmk.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('mmf_cl',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      IF g_old_mmj01 <> g_mmj.mmj01 THEN
#No.FUN-560060-begin
        CALL s_auto_assign_no("asf",tm2_1.ano,g_mmj.mmj02,"N","mme_file","mme01","","","")
          RETURNING li_result,g_n_mme01
        IF (NOT li_result) THEN
           RETURN
        END IF
#        CALL s_smyauno(tm2.ano,g_mmj.mmj02) RETURNING g_i,g_n_mme01
#        IF g_i THEN
#           RETURN
#        END IF
#No.FUN-560060-end
         INITIALIZE l_mme.* TO NULL
         LET l_mme.mme01 = g_n_mme01
         LET l_mme.mme02 = g_mmj.mmj02
         LET l_mme.mme03 = g_mmj.mmj03
         LET l_mme.mme04 = g_mmj.mmj04
         LET l_mme.mme05 = g_mmj.mmj05
         LET l_mme.mme06 = g_mmj.mmj06
         LET l_mme.mme07 = g_mmj.mmj07
         LET l_mme.mme08 = g_mmj.mmj08
         LET l_mme.mme09 = g_mmj.mmj09
         LET l_mme.mme10 = g_mmj.mmj10
         LET l_mme.mme11 = g_mmj.mmj11
         LET l_mme.mme12 = g_mmj.mmj12
         LET l_mme.mme13 = g_mmj.mmj13
         LET l_mme.mme14 = g_mmj.mmj14
         LET l_mme.mme15 = g_mmj.mmj15
         LET l_mme.mmeprno = g_mmj.mmjprno
         LET l_mme.mmeprdt = g_mmj.mmjprdt
         LET l_mme.mmeacti = 'Y'
         LET l_mme.mmeuser = g_user
         LET l_mme.mmegrup = g_grup
         LET l_mme.mmedate = g_today
         LET l_mme.mmeplant = g_plant #FUN-980004 add
         LET l_mme.mmelegal = g_legal #FUN-980004 add
         LET l_mme.mmeoriu = g_user      #No.FUN-980030 10/01/04
         LET l_mme.mmeorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO mme_file VALUES (l_mme.*)
         IF SQLCA.sqlcode  THEN
            LET g_success = 'N'
#            CALL cl_err('ins mme #1',SQLCA.sqlcode,0) #No.FUN-660094
             CALL cl_err3("ins","mme_file",l_mme.mme01,"",SQLCA.SQLCODE,"","ins mme #1",0)        #NO.FUN-660094
         END IF
         IF l_start='Y' THEN
            LET l_startno=l_mme.mme01
            LET l_start='N'
         END IF
         LET l_endno=l_mme.mme01
      END IF
      LET g_old_mmj01 = g_mmj.mmj01
         INITIALIZE l_mmf.* TO NULL
 
      LET l_mmf.mmf01 = l_mme.mme01
         SELECT MAX(mmf02)+1 INTO l_mmf.mmf02 FROM mmf_file WHERE mmf01 = l_mmf.mmf01                  #Jason 010202
      IF cl_null(l_mmf.mmf02) THEN
         LET l_mmf.mmf02=1
      END IF
         LET l_mmf.mmf03 = l_mmk.mmk03
         LET l_mmf.mmf031= l_mmk.mmk031
         LET l_mmf.mmf04 = l_mmk.mmk04
         LET l_mmf.mmf05 = l_mmk.mmk05
         LET l_mmf.mmf06 = l_mmk.mmk06
         LET l_mmf.mmf07 = l_mmk.mmk07
         LET l_mmf.mmf08 = l_mmk.mmk08
         LET l_mmf.mmf09 = l_mmk.mmk09
         LET l_mmf.mmf091= l_mmk.mmk091
         LET l_mmf.mmf10 = l_mmk.mmk10
         LET l_mmf.mmf11 = l_mmk.mmk11
         LET l_mmf.mmf111= l_mmk.mmk111
         LET l_mmf.mmf12 = l_mmk.mmk12
         LET l_mmf.mmf13 = l_mmk.mmk13
         LET l_mmf.mmf14 = l_mmk.mmk14
         LET l_mmf.mmf15 = l_mmk.mmk15
         LET l_mmf.mmfacti = 'Y'
         LET l_mmf.mmfuser = g_user
         LET l_mmf.mmfgrup = g_grup
         LET l_mmf.mmfdate = g_today
         LET l_mmf.mmfplant = g_plant #FUN-980004 add
         LET l_mmf.mmflegal = g_legal #FUN-980004 add
 
      LET l_mmf.mmforiu = g_user      #No.FUN-980030 10/01/04
      LET l_mmf.mmforig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO mmf_file VALUES (l_mmf.*)
      IF SQLCA.sqlcode  THEN
         LET g_success = 'N'
#         CALL cl_err('ins mmf #1',SQLCA.sqlcode,0) #No.FUN-660094
          CALL cl_err3("ins","mmf_file",l_mmf.mmf01,l_mmf.mmf02,SQLCA.SQLCODE,"","ins mmf #1",0)        #NO.FUN-660094
      ELSE
         DELETE FROM mmk_file WHERE mmk01=l_mmk.mmk01 AND mmk02 = l_mmk.mmk02
         IF SQLCA.sqlcode  THEN
            LET g_success = 'N'
#            CALL cl_err('del mmk #1',SQLCA.sqlcode,0) #No.FUN-660094
             CALL cl_err3("del","mmk_file",l_mmk.mmk01,l_mmk.mmk02,SQLCA.SQLCODE,"","del mmk #1",0)        #NO.FUN-660094
         END IF
      END IF
 
#     IF l_mmk.mmk07 <> 'M'  AND  l_pmc.pmc05 = '2' THEN     #No.FUN-690025
      IF l_mmk.mmk07 <> 'M'  AND  l_pmc.pmc05 = '3' THEN     #No.FUN-690025
         ROLLBACK WORK
         LET g_msg ='此廠商,g_mmj.mmj03,不為自製且不准交易 '
            LET INT_FLAG = 0  ######add for prompt bug
         PROMPT g_msg FOR g_chr
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
#               CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         END PROMPT
      END IF
      IF g_success = 'Y' THEN
         UPDATE mmb_file SET
                mmb13='2',
                mmb131=l_mmf.mmf01,
                mmb132=l_mmf.mmf02
         WHERE mmb01 = l_mmf.mmf11 AND
               mmb02 = l_mmf.mmf111
         IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
#            CALL cl_err('l_mmb.mmb01',SQLCA.SQLCODE,0) #No.FUN-660094
             CALL cl_err3("upd","mmb_file",l_mmf.mmf11,l_mmf.mmf111,SQLCA.SQLCODE,"","",0)        #NO.FUN-660094
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
   DELETE FROM mmj_file WHERE mmj01=g_mmj.mmj01
   IF SQLCA.sqlcode  THEN
#      CALL cl_err('dek mmj #1',SQLCA.sqlcode,0) #No.FUN-660094
       CALL cl_err3("del","mmj_file",g_mmj.mmj01,"",SQLCA.SQLCODE,"","dek mmj #1",0)        #NO.FUN-660094
      LET g_success='N'
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1) COMMIT WORK
      LET l_str='通知單號轉出範圍:',l_startno,' -> ',l_endno
      CALL cl_msgany(17,16,l_str)
      CLOSE WINDOW p2001_w
   ELSE
      CALL cl_rbmsg(1) ROLLBACK WORK
      CLOSE WINDOW p2001_w
   END IF
 
   CLEAR FORM
   CALL g_mmk.clear()
   INITIALIZE g_mmj.* TO NULL
END FUNCTION
#Patch....NO.TQC-6
