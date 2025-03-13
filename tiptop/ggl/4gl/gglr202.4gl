# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gglr202.4gl
# Descriptions...: 應交增值稅明細帳
# Date & Author..: 02/03/13 By Flora
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬aag02
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.MOD-560017 05/06/09 By ching fix中文寫死
# Modify.........: No.FUN-580010 05/08/15 By wujie 憑証類報表轉xml
# Modify.........: No.TQC-5B0102 05/11/15 By yoyo報表修改
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670004 06/07/07 By douzh	帳別權限修改
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 增加打印“額外名稱”
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740055 07/04/13 By mike 會計科目加帳套 
# Modify.........: No.TQC-740341 07/04/28 By johnray 帳套問題導致打印錯誤
# Modify.........: No.FUN-7C0064 07/12/20 By Carrier 報表格式轉CR
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.MOD-860252 08/06/25 By chenl 增加打印時選擇是否包含非貨幣性科目的功能。
# Modify.........: No.CHI-870043 08/08/21 By Sarah 1.畫面改為單一科目選項,可開窗挑選統制科目,欄位說明為:"應交增值稅統制科目"
#                                                  2.抓取aag08與畫面相同的科目合計SUM(abb07)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/21 By yinhy 科目查询自动过滤
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD
           b       LIKE aaa_file.aaa01,    # No.FUN-670004
           aag08   LIKE aag_file.aag08,    #CHI-870043 add
           yy      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # apf_file.apf00
           bm      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # apf_file.apf00
           em      LIKE type_file.num5,    #NO FUN-690009   SMALLINT   # apf_file.apf00
           h       LIKE type_file.chr1,    #No.MOD-860252
           e       LIKE type_file.chr1,    #FUN-6C0012
           more    LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)    # Input more condition(Y/N)
           END RECORD,
       g_bookno    LIKE aah_file.aah00,   #帳別   #TQC-610056
      #str CHI-870043 mark
      #g_ary     ARRAY [08] OF RECORD     #列印科目
      #           aag     LIKE type_file.chr8,    #NO FUN-690009   VARCHAR(08)
      #           aag02   LIKE aag_file.aag02,    #No.FUN-7C0064
      #           cnt     LIKE type_file.num5     #NO FUN-690009   SMALLINT
      #          END RECORD,
       g_ary     DYNAMIC ARRAY OF RECORD  #列印科目
                  aag01   LIKE aag_file.aag01,
                  aag02   LIKE aag_file.aag02,
                  abb07   LIKE abb_file.abb07
                 END RECORD,
      #end CHI-870043 mark
       g_idx     LIKE type_file.num10,   #NO FUN-690009   INTEGER
       g_tot_bal LIKE type_file.num20_6  #NO FUN-690009   DECIMAL(20,6)      # User defined variable
DEFINE g_aaa03   LIKE aaa_file.aaa03
DEFINE g_cnt     LIKE type_file.num10    #NO FUN-690009   INTEGER
#DEFINE g_dash   VARCHAR(400)               #Dash line
DEFINE g_i       LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
#DEFINE g_len    SMALLINT                #Report width(79/132/136)
#DEFINE g_pageno SMALLINT                #Report page no
#DEFINE g_zz05   VARCHAR(1)                 #Print tm.wc ?(Y/N)
 
DEFINE   l_table         STRING  #No.FUN-7C0064
DEFINE   g_str           STRING  #No.FUN-7C0064
DEFINE   g_sql           STRING  #No.FUN-7C0064
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
 
    #-----No.MOD-4C0171-----
   LET g_bookno = ARG_VAL(1)   #TQC-610056
   LET g_pdate  = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.aag08 = ARG_VAL(9)   #CHI-870043 add
   LET tm.yy    = ARG_VAL(10)
   LET tm.bm    = ARG_VAL(11)
   LET tm.em    = ARG_VAL(12)
 #str CHI-870043 mark
 ##-----TQC-610056---------
 #LET g_ary[1].aag = ARG_VAL(12)
 #LET g_ary[2].aag = ARG_VAL(13)
 #LET g_ary[3].aag = ARG_VAL(14)
 #LET g_ary[4].aag = ARG_VAL(15)
 #LET g_ary[5].aag = ARG_VAL(16)
 #LET g_ary[6].aag = ARG_VAL(17)
 #LET g_ary[7].aag = ARG_VAL(18)
 #LET g_ary[8].aag = ARG_VAL(19)
 #LET g_ary[1].cnt = ARG_VAL(20)
 #LET g_ary[2].cnt = ARG_VAL(21)
 #LET g_ary[3].cnt = ARG_VAL(22)
 #LET g_ary[4].cnt = ARG_VAL(23)
 #LET g_ary[5].cnt = ARG_VAL(24)
 #LET g_ary[6].cnt = ARG_VAL(25)
 #LET g_ary[7].cnt = ARG_VAL(26)
 #LET g_ary[8].cnt = ARG_VAL(27)
 ##-----END TQC-610056-----
 #end CHI-870043 mark
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
    #-----No.MOD-4C0171 END-----
   #No.FUN-7C0064  --Begin
  #str CHI-870043 mod
  #LET g_sql = "sw.type_file.chr1,   ps.type_file.chr1,",
  #            "aag01.aag_file.aag01,aba01.aba_file.aba01,
  #            "abb03.abb_file.abb03,abb04.abb_file.abb04,",
  #            "abb07.abb_file.abb07,month.type_file.num5,",
  #            "day.type_file.num5"
   LET g_sql = "month.type_file.num5,  day.type_file.num5,",
               "aba01.aba_file.aba01,  abb06.abb_file.abb06,",
               "abb04.abb_file.abb04,",
               "aag02_1.aag_file.aag02,aag02_2.aag_file.aag02,",
               "aag02_3.aag_file.aag02,aag02_4.aag_file.aag02,",
               "aag02_5.aag_file.aag02,aag02_6.aag_file.aag02,",
               "aag02_7.aag_file.aag02,aag02_8.aag_file.aag02,",
               "abb07_1.abb_file.abb07,abb07_2.abb_file.abb07,",
               "abb07_3.abb_file.abb07,abb07_4.abb_file.abb07,",
               "abb07_5.abb_file.abb07,abb07_6.abb_file.abb07,",
               "abb07_7.abb_file.abb07,abb07_8.abb_file.abb07"
  #end CHI-870043 mod
 
   LET l_table = cl_prt_temptable('gglr202',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              #str CHI-870043 mark
              #" VALUES(?,?,?,?,?, ?,?,?,?)"
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "        ?)"
              #end CHI-870043 mark
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-7C0064  --End
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r202_tm(0,0)        # Input print condition
      ELSE CALL r202()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
END MAIN
 
FUNCTION r202_tm(p_row,p_col)
   DEFINE li_chk_bookno  LIKE type_file.num5     #NO FUN-690009   SMALLINT   #No.FUN-670004
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
  #       l_aag_1        LIKE aag_file.aag01,     #CHI-870043 mark
  #       l_aag_2        LIKE aag_file.aag01,     #CHI-870043 mark
  #       l_aag_3        LIKE aag_file.aag01,     #CHI-870043 mark
  #       l_aag_4        LIKE aag_file.aag01,     #CHI-870043 mark
  #       l_aag_5        LIKE aag_file.aag01,     #CHI-870043 mark
  #       l_aag_6        LIKE aag_file.aag01,     #CHI-870043 mark
  #       l_aag_7        LIKE aag_file.aag01,     #CHI-870043 mark
  #       l_aag_8        LIKE aag_file.aag01,     #CHI-870043 mark
          l_cmd        LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r202_w AT p_row,p_col WITH FORM "ggl/42f/gglr202"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
  #call CL_Shwtit(3,56,'gglr202')
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.b    = g_aza.aza81          #No.TQC-740341
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.h    = 'Y'  #No.MOD-860252
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      DISPLAY BY NAME tm.b               #No.TQC-740341
     #str CHI-870043 mark
     #INPUT l_aag_1, l_aag_2, l_aag_3, l_aag_4 ,
     #      l_aag_5, l_aag_6, l_aag_7, l_aag_8
     #      FROM aag_1, aag_2, aag_3, aag_4,
     #           aag_5, aag_6, aag_7, aag_8
     #  #TQC-5B0102--start
     #   ON ACTION CONTROLG
     #      CALL cl_cmdask()    # Command execution
     #  #TQC-5B0102--end
     #
     #   ON ACTION locale
     #     #CALL cl_dynamic_locale()
     #      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     #      LET g_action_choice = "locale"
     #      EXIT INPUT
     #
     #   AFTER FIELD aag_1
     #      IF NOT cl_null(l_aag_1) THEN
     #         LET g_cnt=0
     #         SELECT COUNT(*) INTO g_cnt FROM aag_file
     #          WHERE aag01=l_aag_1
     #            AND aag00=tm.b   #No.FUN-740055
     #            AND aag07<>"1"
     #         IF g_cnt=0 THEN
     #            NEXT FIELD aag_1
     #         END IF
     #      END IF
     #      LET g_ary[1].aag=l_aag_1
     #      LET g_ary[1].cnt="1"
     #
     #   AFTER FIELD aag_2
     #      LET l_aag_2 = duplicate(l_aag_2)   #不使"工廠編號"重覆
     #      IF NOT cl_null(l_aag_2) THEN
     #         LET g_cnt=0
     #         SELECT COUNT(*) INTO g_cnt FROM aag_file
     #          WHERE aag01=l_aag_2
     #           AND  aag00=tm.b   #No.FUN-740055
     #           AND aag07<>"1"
     #         IF g_cnt=0 THEN
     #            NEXT FIELD aag_2
     #         END IF
     #      END IF
     #      LET g_ary[2].aag = l_aag_2
     #      LET g_ary[2].cnt="2"
     #
     #   AFTER FIELD aag_3
     #      LET l_aag_3 = duplicate(l_aag_3)   #不使"工廠編號"重覆
     #      IF NOT cl_null(l_aag_3) THEN
     #         LET g_cnt=0
     #         SELECT COUNT(*) INTO g_cnt FROM aag_file
     #          WHERE aag01=l_aag_3
     #           AND  aag00=tm.b   #No.FUN-740055
     #           AND aag07<>"1"
     #         IF g_cnt=0 THEN
     #            NEXT FIELD aag_3
     #         END IF
     #      END IF
     #      LET g_ary[3].aag = l_aag_3
     #      LET g_ary[3].cnt="3"
     #
     #   AFTER FIELD aag_4
     #      LET l_aag_4 = duplicate(l_aag_4)   #不使"工廠編號"重覆
     #      IF NOT cl_null(l_aag_4) THEN
     #         LET g_cnt=0
     #         SELECT COUNT(*) INTO g_cnt FROM aag_file
     #          WHERE aag01=l_aag_4
     #            AND aag00=tm.b   #No.FUN-740055
     #            AND aag07<>"1"
     #         IF g_cnt=0 THEN
     #            NEXT FIELD aag_4
     #         END IF
     #      END IF
     #      LET g_ary[4].aag = l_aag_4
     #      LET g_ary[4].cnt="4"
     #
     #   AFTER FIELD aag_5
     #      LET l_aag_5 = duplicate(l_aag_5)   #不使"工廠編號"重覆
     #      IF NOT cl_null(l_aag_5) THEN
     #         LET g_cnt=0
     #         SELECT COUNT(*) INTO g_cnt FROM aag_file
     #          WHERE aag01=l_aag_5
     #            AND aag00=tm.b   #No.FUN-740055
     #            AND aag07<>"1"
     #         IF g_cnt=0 THEN
     #           NEXT FIELD aag_5
     #         END IF
     #      END IF
     #      LET g_ary[5].aag = l_aag_5
     #      LET g_ary[5].cnt="5"
     #
     #   AFTER FIELD aag_6
     #      LET l_aag_6 = duplicate(l_aag_6)   #不使"工廠編號"重覆
     #      IF NOT cl_null(l_aag_6) THEN
     #         LET g_cnt=0
     #         SELECT COUNT(*) INTO g_cnt FROM aag_file
     #          WHERE aag01=l_aag_6
     #            AND aag00=tm.b   #No.FUN-740055
     #            AND aag07<>"1"
     #         IF g_cnt=0 THEN
     #            NEXT FIELD aag_6
     #         END IF
     #      END IF
     #      LET g_ary[6].aag = l_aag_6
     #      LET g_ary[6].cnt="6"
     #
     #   AFTER FIELD aag_7
     #      LET l_aag_7 = duplicate(l_aag_7)   #不使"工廠編號"重覆
     #      IF NOT cl_null(l_aag_7) THEN
     #         LET g_cnt=0
     #         SELECT COUNT(*) INTO g_cnt FROM aag_file
     #          WHERE aag01=l_aag_7
     #            AND aag00=tm.b   #No.FUN-740055
     #            AND aag07<>"1"
     #         IF g_cnt=0 THEN
     #            NEXT FIELD aag_7
     #         END IF
     #      END IF
     #      LET g_ary[7].aag = l_aag_7
     #      LET g_ary[7].cnt="7"
     #
     #   AFTER FIELD aag_8
     #      LET l_aag_8 = duplicate(l_aag_8)   #不使"工廠編號"重覆
     #      IF NOT cl_null(l_aag_8) THEN
     #         LET g_cnt=0
     #         SELECT COUNT(*) INTO g_cnt FROM aag_file
     #          WHERE aag01=l_aag_8
     #            AND aag00=tm.b   #No.FUN-740055
     #            AND aag07<>"1"
     #         IF g_cnt=0 THEN
     #            NEXT FIELD aag_8
     #         END IF
     #      END IF
     #      LET g_ary[8].aag = l_aag_8
     #      LET g_ary[8].cnt="8"
     #      IF cl_null(l_aag_1) AND cl_null(l_aag_2) AND
     #         cl_null(l_aag_3) AND cl_null(l_aag_4) AND
     #         cl_null(l_aag_5) AND cl_null(l_aag_6) AND
     #         cl_null(l_aag_7) AND cl_null(l_aag_8) THEN
     #         CALL cl_err(0,'agl-136',0)
     #         NEXT FIELD aag_1
     #      END IF
     #
     #   ON ACTION exit
     #      LET INT_FLAG = 1
     #      EXIT INPUT
     #
     #  #--NO.MOD-860078 start---
     #   ON IDLE g_idle_seconds
     #      CALL cl_on_idle()
     #      CONTINUE INPUT
     #
     #   ON ACTION about         
     #      CALL cl_about()      
     #
     #   ON ACTION help          
     #      CALL cl_show_help()  
     #  #--NO.MOD-860078 end------- 
     #END INPUT
     #IF INT_FLAG THEN
     #   LET INT_FLAG = 0 CLOSE WINDOW r202_w
     #   EXIT PROGRAM
     #END IF
     #end CHI-870043 mark
 
      DISPLAY BY NAME tm.more         # Condition
      INPUT BY NAME tm.b,tm.aag08,tm.yy,tm.bm,tm.em,tm.h,tm.e,tm.more   #FUN-6C0012  #No.MOD-860252 add tm.h   #CHI-870043 add tm.aag08
		  WITHOUT DEFAULTS
         AFTER FIELD b
            IF NOT cl_null(tm.b) THEN
               #No.FUN-670004--begin
               CALL s_check_bookno(tm.b,g_user,g_plant) 
                    RETURNING li_chk_bookno
               IF (NOT li_chk_bookno) THEN
                  NEXT FIELD b
               END IF
               #No.FUN-670004--end
               SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
               IF STATUS THEN
#                 CALL cl_err('sel aaa:',STATUS,0)    #No.FUN-660124
                  CALL cl_err3("sel","aaa.file",tm.b,"",STATUS,"","sel aaa:",0)    #No.FUN-660124   
                  NEXT FIELD b 
               END IF
	    END IF
 
        #str CHI-870043 add
         AFTER FIELD aag08    #應交增值稅統制科目
            IF NOT cl_null(tm.aag08) THEN
               LET g_cnt=0
               SELECT COUNT(*) INTO g_cnt FROM aag_file
                WHERE aag01= tm.aag08
                  AND aag00= tm.b
                  AND aag07= "1"   #統制科目
               IF g_cnt=0 THEN
                  #No.FUN-B10053  --Begin
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag2"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.default1 = tm.aag08
                  LET g_qryparam.arg1 = tm.b
                  LET g_qryparam.where = " aag01 LIKE '",tm.aag08 CLIPPED,"%'"
                  CALL cl_create_qry() RETURNING tm.aag08
                  DISPLAY BY NAME tm.aag08
                  #No.FUN-B10053  --End
                  NEXT FIELD aag08
               END IF
            ELSE
               CALL cl_err('','mfg5103',0)
               NEXT FIELD aag08
            END IF
        #end CHI-870043 add
 
         AFTER FIELD yy
            IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
         AFTER FIELD bm
#No.TQC-720032 -- begin --
            IF NOT cl_null(tm.bm) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.bm > 12 OR tm.bm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD bm
                  END IF
               ELSE
                  IF tm.bm > 13 OR tm.bm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD bm
                  END IF
               END IF
            END IF
#No.TQC-720032 -- end --
            IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
#No.TQC-720032 -- begin --
#           IF tm.bm <1 OR tm.bm > 13 THEN
#              CALL cl_err('','agl-013',0) NEXT FIELD bm
#           END IF
#No.TQC-720032 -- end --
 
         AFTER FIELD em
#No.TQC-720032 -- begin --
            IF NOT cl_null(tm.em) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.em > 12 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                  END IF
               ELSE
                  IF tm.em > 13 OR tm.em < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD em
                  END IF
               END IF
            END IF
#No.TQC-720032 -- end --
            IF cl_null(tm.em) THEN NEXT FIELD em END IF
#No.TQC-720032 -- begin --
#           IF tm.em <1 OR tm.em > 13 THEN
#              CALL cl_err('','agl-013',0) NEXT FIELD em
#           END IF
#No.TQC-720032 -- end --
            IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON ACTION CONTROLP
            CASE
              #str CHI-870043 add
               WHEN INFIELD(aag08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aag2'
                  LET g_qryparam.arg1 = tm.b
                  LET g_qryparam.default1 = tm.aag08
                  CALL cl_create_qry() RETURNING tm.aag08
                  DISPLAY BY NAME tm.aag08
                  NEXT FIELD aag08
              #end CHI-870043 add
               #No.MOD-4C0156 add
               #No.MOD-4C0156 add
               WHEN INFIELD(b)
#                 CALL q_aaa(0,0,tm.b) RETURNING tm.b
#                 CALL FGL_DIALOG_SETBUFFER( tm.b )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b
#                  CALL FGL_DIALOG_SETBUFFER( tm.b )
                  DISPLAY BY NAME tm.b
                  NEXT FIELD b
               #No.MOD-4C0156 end
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r202_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='gglr202'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('gglr202','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                        " '",g_bookno CLIPPED,"'",   #TQC-510056   
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                        " '",tm.aag08 CLIPPED,"'",   #CHI-870043 add
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.bm CLIPPED,"'",
                        " '",tm.em CLIPPED,"'",
                       #str CHI-870043 mark
                       ##-----TQC-610056---------
                       #" '",g_ary[1].aag CLIPPED,"'",
                       #" '",g_ary[2].aag CLIPPED,"'",
                       #" '",g_ary[3].aag CLIPPED,"'",
                       #" '",g_ary[4].aag CLIPPED,"'",
                       #" '",g_ary[5].aag CLIPPED,"'",
                       #" '",g_ary[6].aag CLIPPED,"'",
                       #" '",g_ary[7].aag CLIPPED,"'",
                       #" '",g_ary[8].aag CLIPPED,"'",
                       #" '",g_ary[1].cnt CLIPPED,"'",
                       #" '",g_ary[2].cnt CLIPPED,"'",
                       #" '",g_ary[3].cnt CLIPPED,"'",
                       #" '",g_ary[4].cnt CLIPPED,"'",
                       #" '",g_ary[5].cnt CLIPPED,"'",
                       #" '",g_ary[6].cnt CLIPPED,"'",
                       #" '",g_ary[7].cnt CLIPPED,"'",
                       #" '",g_ary[8].cnt CLIPPED,"'",
                       ##-----END TQC-610056-----
                       #end CHI-870043 mark
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('gglr202',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW r202_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r202()
      ERROR ""
   END WHILE
   CLOSE WINDOW r202_w
END FUNCTION
 
FUNCTION r202()
   DEFINE l_name    LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
#         l_time    LIKE type_file.chr8        #No.FUN-6A0097
          l_sql     LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
          l_chr     LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
          l_aag06   LIKE aag_file.aag06,
          l_month   LIKE type_file.chr2,    #No.FUN-7C0064
          l_day     LIKE type_file.chr2,    #No.FUN-7C0064
          l_cnt     LIKE type_file.num5,    #CHI-870043 add
          l_order   ARRAY[5] OF  LIKE cre_file.cre08,   #NO FUN-690009   VARCHAR(10)
          sr        RECORD
                     aba01   LIKE aba_file.aba01,  #傳票編號
                     aba02   LIKE aba_file.aba02,  #傳票日期
                     abb03   LIKE abb_file.abb03,  #科目編號
                     abb04   LIKE abb_file.abb04,  #摘要
                     abb06   LIKE abb_file.abb06,  #借貸別   #CHI-870043 add
                     abb07   LIKE abb_file.abb07   #異動金額
                    END RECORD,
         #str CHI-870043 add
          sr1       RECORD
                     aag01   LIKE aag_file.aag01,  #科目編號
                     aag02   LIKE aag_file.aag02,  #科目名稱
                     aag13   LIKE aag_file.aag13,  #額外名稱
                     aag06   LIKE aag_file.aag06   #正常餘額型態(1.借餘 2.貸餘)
                    END RECORD
         #end CHI-870043 add
   #No.FUN-B80096--mark--Begin---
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
   CALL cl_del_data(l_table)   #No.FUN-7C0064
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr202'         #No.FUN-580010
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #No.FUN-7C0064
 
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660124
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","",0)    #No.FUN-660124
   END IF
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_aaa03  #No.CHI-6A0004
 
  #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF   #No.FUN-580010
  #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR     #No.FUN-580010
  #No.FUN-7C0064  --Begin
  #CALL cl_outnam('gglr202') RETURNING l_name
  #START REPORT r202_rep TO l_name
  #No.FUN-7C0064  --End  
 
  #str CHI-870043 mod
  #FOR g_idx = 1 TO 8
  #    IF cl_null(g_ary[g_idx].aag) THEN
  #       CONTINUE FOR
  #    END IF
   LET g_idx = 1
   CALL g_ary.clear()
   #找出INPUT輸入的統制科目下的所有明細科目
   LET l_sql = "SELECT aag01,aag02,aag13,aag06 FROM aag_file",
               " WHERE aag08 = '",tm.aag08,"'",
               "   AND aag00 = '",tm.b,"'",
               "   AND aag07!= '1'",    #不為統制科目
               "   AND aag01 IN ",
               "  (SELECT abb03 FROM aba_file,abb_file",
               "    WHERE YEAR(aba02)=",tm.yy,
               "      AND MONTH(aba02) BETWEEN ",tm.bm," AND ",tm.em,
               "      AND aba19  = 'Y' ",
               "      AND aba00  = '",tm.b,"'",
               "      AND abapost= 'Y' ",
               "      AND aba01  = abb01",
               "      AND aba00  = abb00)"
   IF tm.h = 'Y' THEN    #僅貨幣性科目
      LET l_sql = l_sql,"   AND aag09 = 'Y' "
   END IF
   LET l_sql = l_sql," ORDER BY aag01"
   PREPARE r202_prepare0 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare0:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      EXIT PROGRAM
   END IF
   DECLARE r202_curs0 CURSOR FOR r202_prepare0
   FOREACH r202_curs0 INTO sr1.*
      LET g_ary[g_idx].aag01 = sr1.aag01
      IF tm.e='N' THEN    #科目名稱
         LET g_ary[g_idx].aag02 = sr1.aag02
      ELSE                #額外名稱
         LET g_ary[g_idx].aag02 = sr1.aag13
      END IF
      LET g_ary[g_idx].abb07 = 0
      LET g_idx = g_idx + 1
   END FOREACH
 
   LET g_idx = 1
   FOREACH r202_curs0 INTO sr1.*
  #end CHI-870043 mod
      LET l_sql = "SELECT aba01,aba02,abb03,abb04,abb06,abb07 ",
                  "  FROM aba_file,abb_file ",
                  " WHERE YEAR(aba02) = ",tm.yy,
                  "   AND MONTH(aba02) BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                  "   AND aba19 = 'Y' ",
                  "   AND aba00 = '",tm.b,"'",     #No.FUN-740055
                  "   AND abapost= 'Y' ",
                  "   AND aba01 = abb01",
                  "   AND aba00 = abb00 ",         #No.FUN-7C0064
                 #"   AND abb03 = '",g_ary[g_idx].aag,"'",   #CHI-870043 mark
                  "   AND abb03 = '",sr1.aag01,"'",          #CHI-870043
                  " ORDER BY aba01"                          #CHI-870043 add
    #str CHI-870043 mark
    ##No.MOD-860252--begin--
    # IF tm.h = 'Y' THEN    #僅貨幣性科目
    #    LET l_sql = l_sql , " AND aag09 = 'Y' "
    # END IF
    ##No.MOD-860252---end---
    #end CHI-870043 mark
      PREPARE r202_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
         EXIT PROGRAM
      END IF
      DECLARE r202_curs1 CURSOR FOR r202_prepare1
      LET g_pageno = 0
      FOREACH r202_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
        #LET sr.aag = g_ary[g_idx].aag   #CHI-870043 mark
        #str CHI-870043 add
         LET g_ary[1].abb07=0  LET g_ary[2].abb07=0
         LET g_ary[3].abb07=0  LET g_ary[4].abb07=0
         LET g_ary[5].abb07=0  LET g_ary[6].abb07=0
         LET g_ary[7].abb07=0  LET g_ary[8].abb07=0
         IF g_ary[g_idx].aag01 != sr.abb03 THEN
            LET g_idx = g_idx + 1
         END IF
         IF sr1.aag06 = sr.abb06 THEN   #當正常餘額型態 = 傳票單身借貸別
            LET g_ary[g_idx].abb07 = sr.abb07
         ELSE
            LET g_ary[g_idx].abb07 = sr.abb07 * -1
         END IF
         IF cl_null(g_ary[1].aag02) THEN LET g_ary[1].aag02=' ' END IF
         IF cl_null(g_ary[2].aag02) THEN LET g_ary[2].aag02=' ' END IF
         IF cl_null(g_ary[3].aag02) THEN LET g_ary[3].aag02=' ' END IF
         IF cl_null(g_ary[4].aag02) THEN LET g_ary[4].aag02=' ' END IF
         IF cl_null(g_ary[5].aag02) THEN LET g_ary[5].aag02=' ' END IF
         IF cl_null(g_ary[6].aag02) THEN LET g_ary[6].aag02=' ' END IF
         IF cl_null(g_ary[7].aag02) THEN LET g_ary[7].aag02=' ' END IF
         IF cl_null(g_ary[8].aag02) THEN LET g_ary[8].aag02=' ' END IF
         IF cl_null(g_ary[1].abb07) THEN LET g_ary[1].abb07=0   END IF
         IF cl_null(g_ary[2].abb07) THEN LET g_ary[2].abb07=0   END IF
         IF cl_null(g_ary[3].abb07) THEN LET g_ary[3].abb07=0   END IF
         IF cl_null(g_ary[4].abb07) THEN LET g_ary[4].abb07=0   END IF
         IF cl_null(g_ary[5].abb07) THEN LET g_ary[5].abb07=0   END IF
         IF cl_null(g_ary[6].abb07) THEN LET g_ary[6].abb07=0   END IF
         IF cl_null(g_ary[7].abb07) THEN LET g_ary[7].abb07=0   END IF
         IF cl_null(g_ary[8].abb07) THEN LET g_ary[8].abb07=0   END IF
        #end CHI-870043 add
         #No.FUN-7C0064  --Begin
         #OUTPUT TO REPORT r202_rep(sr.*)
         LET l_month = MONTH(sr.aba02)
         LET l_day = DAY(sr.aba02)
        #str CHI-870043 mod
        #EXECUTE insert_prep USING
        #   sr.sw,   g_idx,   tm.aag08,sr.aba01,sr.abb03,
        #   sr.abb04,sr.abb07,l_month, l_day
         EXECUTE insert_prep USING
            l_month,l_day,sr.aba01,sr.abb06,sr.abb04,
            g_ary[1].aag02,g_ary[2].aag02,g_ary[3].aag02,g_ary[4].aag02,
            g_ary[5].aag02,g_ary[6].aag02,g_ary[7].aag02,g_ary[8].aag02,
            g_ary[1].abb07,g_ary[2].abb07,g_ary[3].abb07,g_ary[4].abb07,
            g_ary[5].abb07,g_ary[6].abb07,g_ary[7].abb07,g_ary[8].abb07
        #end CHI-870043 mod
        #No.FUN-7C0064  --End
      END FOREACH
   END FOREACH   #CHI-870043 add
  #END FOR   #CHI-870043 mark
 
   #No.FUN-7C0064  --Begin
   #FINISH REPORT r202_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
  #str CHI-870043 mod
  #LET g_str = g_ary[1].aag02,';',g_ary[2].aag02,';',g_ary[3].aag02,';',
  #            g_ary[4].aag02,';',g_ary[5].aag02,';',g_ary[6].aag02,';',
  #            g_ary[7].aag02,';',g_ary[8].aag02,';',
  #            t_azi04
   LET g_str = tm.b,";",tm.aag08,";",tm.yy USING '####',";",
               tm.bm USING '###',";",tm.em USING '###',";",t_azi04
  #end CHI-870043 mod
   CALL cl_prt_cs3('gglr202','gglr202',g_sql,g_str)
   #No.FUN-7C0064  --End  
   #No.FUN-B80096--mark--Begin--- 
   #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-B80096--mark--End-----
END FUNCTION
 
#No.FUN-7C0064  --Begin
#REPORT r202_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#          l_i,l_a,n    LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#          l_pma02      LIKE pma_file.pma02,
#          sr               RECORD
#                                  sw    LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)
#                                  aag   LIKE aag_file.aag01,
#                                  aba01 LIKE aba_file.aba01,
#                                  aba02 LIKE aba_file.aba02,
#                                  abb03 LIKE abb_file.abb03,
#                                  abb04 LIKE abb_file.abb04,
#                                  abb07 LIKE abb_file.abb07
#                        END RECORD,
#      l_mon        LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#      l_mark       LIKE type_file.num10,   #NO FUN-690009   INTEGER
#      l_day        LIKE type_file.num5,    #NO FUN-690009   SMALLINT
#      l_amt_1      LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#      s_amt_1      LIKE type_file.num20_6, #NO FUN-690009   DECIMAL(20,6)
#      l_name1      LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(12)
#      l_name2      LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(12)
#      l_name3      LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(12)   
#      l_name4      LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(12)
#      l_name5      LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(12)   
#      l_name6      LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(12)
#      l_name7      LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(12)
#      l_name8      LIKE aag_file.aag02,    #NO FUN-690009   VARCHAR(12)
#      l_total1     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#      l_total2     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#      l_total3     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#      l_total4     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#      l_total5     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#      l_total6     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#      l_total7     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#      l_total8     LIKE type_file.num20_6, #NO FUN-690009   DEC(20,6)
#      l_chr        LIKE type_file.chr1     #NO FUN-690009   VARCHAR(1)
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.aba02,sr.aba01,sr.sw,sr.aag
#  FORMAT
#   PAGE HEADER
##No.FUN-580010--begin
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT g_dash[1,g_len]
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##           COLUMN 49,g_x[11] CLIPPED,
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##     PRINT g_dash[1,g_len]
##No.FUN-580010--end
#      FOR l_i = 1 TO 8
#          CASE WHEN g_ary[l_i].cnt="1"
#                    LET l_name1=NULL
#                    #FUN-6C0012.....begin
#                    IF tm.e ='Y' THEN                                           
#                       SELECT aag13 INTO l_name1 FROM aag_file  #MOD-4A0238     
#                        WHERE aag01=g_ary[l_i].aag    
#                          AND aag00=tm.b      #No.FUN-740055                          
#                    ELSE
#                       SELECT aag02 INTO l_name1 FROM aag_file  #MOD-4A0238
#                        WHERE aag01=g_ary[l_i].aag
#                          AND aag00=tm.b   #No.FUN-740055
#                    END IF
#                    #FUN-6C0012.....end
#               WHEN g_ary[l_i].cnt="2"
#                    LET l_name2=NULL
#                    #FUN-6C0012.....begin
#                    IF tm.e ='Y' THEN                                           
#                       SELECT aag13 INTO l_name2 FROM aag_file  #MOD-4A0238     
#                        WHERE aag01=g_ary[l_i].aag  
#                          AND aag00=tm.b   #No.FUN-740055                            
#                    ELSE
#                       SELECT aag02 INTO l_name2 FROM aag_file  #MOD-4A0238
#                        WHERE aag01=g_ary[l_i].aag
#                          AND aag00=tm.b   #No.FUN-740055
#                    END IF
#                    #FUN-6C0012.....end
#               WHEN g_ary[l_i].cnt="3"
#                    LET l_name3=NULL
#                    #FUN-6C0012.....begin
#                    IF tm.e ='Y' THEN                                           
#                       SELECT aag13 INTO l_name3 FROM aag_file  #MOD-4A0238     
#                        WHERE aag01=g_ary[l_i].aag    
#                          AND aag00=tm.b   #No.FUN-740055                          
#                    ELSE
#                       SELECT aag02 INTO l_name3 FROM aag_file  #MOD-4A0238
#                        WHERE aag01=g_ary[l_i].aag
#                          AND aag00=tm.b   #No.FUN-740055
#                    END IF
#                    #FUN-6C0012.....end
#               WHEN g_ary[l_i].cnt="4"
#                    LET l_name4=NULL
#                    #FUN-6C0012.....begin
#                    IF tm.e ='Y' THEN                                           
#                       SELECT aag13 INTO l_name4 FROM aag_file  #MOD-4A0238     
#                        WHERE aag01=g_ary[l_i].aag    
#                          AND aag00=tm.b   #No.FUN-740055                          
#                    ELSE
#                       SELECT aag02 INTO l_name4 FROM aag_file  #MOD-4A0238
#                        WHERE aag01=g_ary[l_i].aag
#                          AND aag00=tm.b   #No.FUN-740055
#                    END IF
#                    #FUN-6C0012.....end
#               WHEN g_ary[l_i].cnt="5"
#                    LET l_name5=NULL
#                    #FUN-6C0012.....begin
#                    IF tm.e ='Y' THEN                                           
#                       SELECT aag13 INTO l_name5 FROM aag_file  #MOD-4A0238     
#                        WHERE aag01=g_ary[l_i].aag    
#                          AND aag00=tm.b   #No.FUN-740055                          
#                    ELSE
#                       SELECT aag02 INTO l_name5 FROM aag_file  #MOD-4A0238
#                        WHERE aag01=g_ary[l_i].aag
#                          AND aag00=tm.b   #No.FUN-740055
#                    END IF
#                    #FUN-6C0012.....end
#               WHEN g_ary[l_i].cnt="6"
#                    LET l_name6=NULL
#                    #FUN-6C0012.....begin
#                    IF tm.e ='Y' THEN                                           
#                       SELECT aag13 INTO l_name6 FROM aag_file  #MOD-4A0238     
#                        WHERE aag01=g_ary[l_i].aag    
#                          AND aag00=tm.b   #No.FUN-740055                          
#                    ELSE
#                       SELECT aag02 INTO l_name6 FROM aag_file  #MOD-4A0238
#                        WHERE aag01=g_ary[l_i].aag
#                          AND aag00=tm.b   #No.FUN-740055
#                    END IF
#                    #FUN-6C0012.....end
#               WHEN g_ary[l_i].cnt="7"
#                    LET l_name7=NULL
#                    #FUN-6C0012.....begin
#                    IF tm.e ='Y' THEN                                           
#                       SELECT aag13 INTO l_name7 FROM aag_file  #MOD-4A0238     
#                        WHERE aag01=g_ary[l_i].aag     
#                          AND aag00=tm.b   #No.FUN-740055                         
#                    ELSE
#                       SELECT aag02 INTO l_name7 FROM aag_file  #MOD-4A0238
#                        WHERE aag01=g_ary[l_i].aag
#                          AND aag00=tm.b   #No.FUN-740055
#                    END IF
#                    #FUN-6C0012.....end
#               WHEN g_ary[l_i].cnt="8"
#                    LET l_name8=NULL
#                    #FUN-6C0012.....begin
#                    IF tm.e ='Y' THEN                                           
#                       SELECT aag13 INTO l_name8 FROM aag_file  #MOD-4A0238     
#                        WHERE aag01=g_ary[l_i].aag    
#                          AND aag00=tm.b   #No.FUN-740055                          
#                    ELSE
#                       SELECT aag02 INTO l_name8 FROM aag_file  #MOD-4A0238
#                        WHERE aag01=g_ary[l_i].aag
#                          AND aag00=tm.b   #No.FUN-740055
#                    END IF
#                    #FUN-6C0012.....end
#       END CASE
#     END FOR
##No.FUN-580010--begin
#      LET g_zaa[35].zaa08 =l_name1
#      LET g_zaa[36].zaa08 =l_name2
#      LET g_zaa[37].zaa08 =l_name3
#      LET g_zaa[38].zaa08 =l_name4
#      LET g_zaa[39].zaa08 =l_name5
#      LET g_zaa[40].zaa08 =l_name6
#      LET g_zaa[41].zaa08 =l_name7
#      LET g_zaa[42].zaa08 =l_name8
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
#            g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
#      PRINT g_dash1
##     PRINT COLUMN 001, g_x[22] CLIPPED,
##           COLUMN 004, g_x[23] CLIPPED,
##           COLUMN 007, g_x[24] CLIPPED,
##           COLUMN 022, g_x[25] CLIPPED,
##           COLUMN 046, l_name1 CLIPPED,
##           COLUMN 059, l_name2 CLIPPED,
##           COLUMN 072, l_name3 CLIPPED,
##           COLUMN 095, l_name4 CLIPPED,
##           COLUMN 108, l_name5 CLIPPED,
##           COLUMN 121, l_name6 CLIPPED,
##           COLUMN 134, l_name7 CLIPPED,
##           COLUMN 147, l_name8 CLIPPED,
##           COLUMN 162, g_x[28] CLIPPED
##     PRINT g_dash[1,g_len]
##No.FUN-580010--end
#      LET l_last_sw = 'n'
# 
#   ON EVERY ROW
#      IF l_amt_1 IS NULL THEN LET l_amt_1=0 END IF
#      IF l_total1 IS NULL THEN LET l_total1=0 END IF
#      IF l_total2 IS NULL THEN LET l_total2=0 END IF
#      IF l_total3 IS NULL THEN LET l_total3=0 END IF
#      IF l_total4 IS NULL THEN LET l_total4=0 END IF
#      IF l_total5 IS NULL THEN LET l_total5=0 END IF
#      IF l_total6 IS NULL THEN LET l_total6=0 END IF
#      IF l_total7 IS NULL THEN LET l_total7=0 END IF
#      IF l_total8 IS NULL THEN LET l_total8=0 END IF
##No.FUn-580010--begin
#      PRINT COLUMN g_c[31],MONTH(sr.aba02) USING "&&",
#            COLUMN g_c[32],DAY(sr.aba02) USING "&&",
#            COLUMN g_c[33],sr.aba01,
#            COLUMN g_c[34],sr.abb04 CLIPPED;
#       FOR l_a = 1 TO 8
#             CASE WHEN  sr.sw="1" AND sr.aag=g_ary[l_a].aag
#               PRINT COLUMN g_c[35], cl_numfor(sr.abb07,30,t_azi04) CLIPPED;  #No.CHI-6A0004  #FUN-6C0012
#               LET l_total1=l_total1+sr.abb07
#             WHEN  sr.sw="1" AND sr.aag=g_ary[l_a].aag
#               PRINT COLUMN g_c[36], cl_numfor(sr.abb07,30,t_azi04) CLIPPED;  #No.CHI-6A0004  #FUN-6C0012
#               LET l_total2=l_total2+sr.abb07
#             WHEN  sr.sw="1" AND sr.aag=g_ary[l_a].aag
#               PRINT COLUMN g_c[37], cl_numfor(sr.abb07,30,t_azi04) CLIPPED;  #No.CHI-6A0004  #FUN-6C0012
#               LET l_total3=l_total3+sr.abb07
#             WHEN  sr.sw="1" AND sr.aag=g_ary[l_a].aag
#               PRINT COLUMN g_c[38], cl_numfor(sr.abb07,30,t_azi04) CLIPPED;  #No.CHI-6A0004  #FUN-6C0012
#               LET l_total4=l_total4+sr.abb07
#             WHEN  sr.sw="2" AND sr.aag=g_ary[l_a].aag
#               PRINT COLUMN g_c[39], cl_numfor(sr.abb07,30,t_azi04) CLIPPED;  #No.CHI-6A0004  #FUN-6C0012
#               LET l_total5=l_total5+sr.abb07
#             WHEN  sr.sw="2" AND sr.aag=g_ary[l_a].aag
#               PRINT COLUMN g_c[40], cl_numfor(sr.abb07,30,t_azi04) CLIPPED;  #No.CHI-6A0004  #FUN-6C0012
#               LET l_total6=l_total6+sr.abb07
#             WHEN  sr.sw="2" AND sr.aag=g_ary[l_a].aag
#               PRINT COLUMN g_c[41], cl_numfor(sr.abb07,30,t_azi04) CLIPPED;  #No.CHI-6A0004  #FUN-6C0012
#               LET l_total7=l_total7+sr.abb07
#             WHEN  sr.sw="2" AND sr.aag=g_ary[l_a].aag
#               PRINT COLUMN g_c[42], cl_numfor(sr.abb07,30,t_azi04) CLIPPED;  #No.CHI-6A0004  #FUN-6C0012
#               LET l_total8=l_total8+sr.abb07
#         END CASE
#       END FOR
#       IF sr.sw="2" THEN LET sr.abb07=sr.abb07*-1 END IF
#       LET l_amt_1=l_amt_1+sr.abb07
#       IF l_amt_1<0 THEN
#           PRINT COLUMN g_c[44],g_x[23] CLIPPED; #"貸";  #MOD-560017
#         ELSE
#           PRINT COLUMN g_c[44],g_x[22] CLIPPED; #"借";  #MOD-560017
#       END IF
#        PRINT COLUMN g_c[44], cl_numfor(l_amt_1,18,t_azi04) CLIPPED     #No.CHI-6A0004  #FUN-6C0012
# 
# 
#
#
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      PRINT COLUMN g_c[34], g_x[24] CLIPPED;
#      PRINT COLUMN g_c[35], cl_numfor(l_total1,30,t_azi04) CLIPPED,     #No.CHI-6A0004  #FUN-6C0012
#            COLUMN g_c[36], cl_numfor(l_total2,30,t_azi04) CLIPPED,     #No.CHI-6A0004  #FUN-6C0012
#            COLUMN g_c[37], cl_numfor(l_total3,30,t_azi04) CLIPPED,     #No.CHI-6A0004  #FUN-6C0012
#            COLUMN g_c[38], cl_numfor(l_total4,30,t_azi04) CLIPPED,     #No.CHI-6A0004  #FUN-6C0012
#            COLUMN g_c[39], cl_numfor(l_total5,30,t_azi04) CLIPPED,     #No.CHI-6A0004  #FUN-6C0012
#            COLUMN g_c[40], cl_numfor(l_total6,30,t_azi04) CLIPPED,     #No.CHI-6A0004  #FUN-6C0012
#            COLUMN g_c[41], cl_numfor(l_total7,30,t_azi04) CLIPPED,     #No.CHI-6A0004  #FUN-6C0012
#            COLUMN g_c[42], cl_numfor(l_total8,30,t_azi04) CLIPPED,     #No.CHI-6A0004  #FUN-6C0012
#            COLUMN g_c[43], cl_numfor(l_amt_1,18,t_azi04) CLIPPED       #No.CHI-6A0004  #FUN-6C0012
##No.FUN-580010--end
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_amt_1=0
#      LET l_total1=0
#      LET l_total2=0
#      LET l_total3=0
#      LET l_total4=0
#      LET l_total5=0
#      LET l_total6=0
#      LET l_total7=0
#      LET l_total8=0
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-7C0064  --End   
 
#str CHI-870043 mark
#FUNCTION duplicate(l_aag)     #檢查輸入之工廠編號是否重覆
#   DEFINE l_aag      LIKE aag_file.aag01
#   DEFINE l_idx, n   LIKE type_file.num10    #NO FUN-690009   INTEGER
# 
#   FOR l_idx = 1 TO n
#       IF g_ary[l_idx].aag = l_aag THEN
#          LET l_aag = ''
#       END IF
#   END FOR
#   RETURN l_aag
#END FUNCTION
#end CHI-870043 mark
#Patch....NO.TQC-610037 <> #
