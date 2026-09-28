# Prog. Version..: '5.30.03-12.09.18(00005)'     #
#
# Pattern name...: ghrr999.4gl
# Descriptions...: 產品價格表
# Date & Author..: 95/01/23 By Danny
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-550091 05/05/25 By Smapmin 新增地區欄位
# Modify.........: No.FUN-570184 05/08/08 By Sarah 增加欄位開窗功能
# Modify.........: No.MOD-580212 05/09/08 By ice  修改報表列印格式
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-710071 07/01/29 By CoCo 報表輸出至Crystal Reports功能 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50090 10/05/20 By lilingyu 切換語言別後,點退出或者離開按鈕,都無法退出程式
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
           #   wc      VARCHAR(500),    # Where condition
              wc      STRING,     #TQC-630166  # Where condition
              obg11    LIKE type_file.chr8,
              obg22    LIKE type_file.num5                  #No.FUN-680137 VARCHAR(1)    # Input more condition(Y/N)
              END RECORD 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_head1         STRING
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL ghrr999_tm(0,0)        # Input print condition
     
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION ghrr999_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
#DEFINE  l_sql STRING
#DEFINE  l_hrcda01  LIKE  hrcda_file.hrcda01
#DEFINE  l_hrcda02  LIKE  hrcda_file.hrcda02
#DEFINE  l_hrcd03,l_hrcd05   LIKE  hrcd_file.hrcd03
#   LET  l_sql = " select hrcda01,hrcda02 from hrcd_file,hrcda_file  where hrcd08 = 'Y' and hrcda02 = hrcd10 and (hrcda06 is null or hrcda08 is null) " 
#   PREPARE  hrcda_q FROM  l_sql
#   DECLARE  hrcda_s cursor FOR  hrcda_q
#   FOREACH  hrcda_s INTO  l_hrcda01,l_hrcda02
#      SELECT  hrcd03,hrcd05 into l_hrcd03,l_hrcd05 from hrcd_file 
#       WHERE  hrcd10 =  l_hrcda02
#      UPDATE  hrcda_file SET  hrcda06 = l_hrcd03,hrcda08 =  l_hrcd05
#       WHERE  hrcda01 = l_hrcda01 and hrcda02 = l_hrcda02
#   END  FOREACH   
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW ghrr999_w AT p_row,p_col WITH FORM "ghr/42f/ghrr999" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON obg02,obg04,obg03,obg05,obg07,obg08,   #FUN-550091
   CONSTRUCT BY NAME tm.wc ON obg02,obg04
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
      # LET g_action_choice = "locale"    #TQC-A50090
        LET g_action_choice = NULL        #TQC-A50090
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('obguser', 'obggrup') #FUN-980030
 
  IF g_action_choice = "locale" THEN
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()   #FUN-550037(smin)
     CONTINUE WHILE
  END IF
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW ghrr999_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     EXIT PROGRAM
        
  END IF
  IF tm.wc = ' 1=1' THEN 
     CALL cl_err('','9046',0) CONTINUE WHILE
  END IF
  INPUT BY NAME tm.obg11,tm.obg22 WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
    ON ACTION locale
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   #FUN-550037(smin)
       LET g_action_choice = "locale"
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
    ON ACTION CONTROLG 
       CALL cl_cmdask()    # Command execution
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
  END INPUT
  IF INT_FLAG THEN
     LET INT_FLAG = 0 CLOSE WINDOW ghrr999_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
     EXIT PROGRAM
        
  END IF
  END WHILE 
   DISPLAY tm.wc
   CLOSE WINDOW ghrr999_w
END FUNCTION
