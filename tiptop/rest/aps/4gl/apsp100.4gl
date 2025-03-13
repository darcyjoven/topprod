# Prog. Version..: '5.10.05-08.12.18(00009)'     #
# Pattern name...: apsp100.4gl
# Descriptions...: TIPTOP 基礎資料匯出至APS
# Date & Author..: FUN-730056 2007/03/14 By Mandy

# Modify.........: No.FUN-740215 07/04/25 By Joe APS相關調整
# Modify.........: No.FUN-740216 07/04/25 By Joe APS相關調整
# Modify.........: No.FUN-760041 07/07/04 By Joe APS相關調整
# Modify.........: No:FUN-710073 07/12/11 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No:CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No:FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No:CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷

DATABASE ds

GLOBALS "../../config/top.global"
 DEFINE tm              RECORD LIKE aps_say.* #FUN-730056
 DEFINE g_apsapg        RECORD LIKE apsapg.*
 DEFINE g_apsapm        RECORD LIKE apsapm.*
 DEFINE g_apsbmm        RECORD LIKE apsbmm.*
 DEFINE g_apscmm        RECORD LIKE apscmm.*
 DEFINE g_apsdcm        RECORD LIKE apsdcm.*
 DEFINE g_apsocm        RECORD LIKE apsocm.*
 DEFINE g_apsdom1       RECORD LIKE apsdom.*
 DEFINE g_apsdom2       RECORD LIKE apsdom.*
 DEFINE g_apsiam1       RECORD LIKE apsiam.*
 DEFINE g_apsiam2       RECORD LIKE apsiam.*
 DEFINE g_apsarm        RECORD LIKE apsarm.*
 DEFINE g_apsimm        RECORD LIKE apsimm.*
 DEFINE g_apsirm        RECORD LIKE apsirm.*
 DEFINE g_apsmrm        RECORD LIKE apsmrm.*  
 DEFINE g_apspem        RECORD LIKE apspem.*
 DEFINE g_apspfm        RECORD LIKE apspfm.*
 DEFINE g_apsrem        RECORD LIKE apsrem.*
 DEFINE g_apsrgm        RECORD LIKE apsrgm.*
 DEFINE g_apsrom        RECORD LIKE apsrom.*
 DEFINE g_apsslm        RECORD LIKE apsslm.*
 DEFINE g_apssmm        RECORD LIKE apssmm.*
 DEFINE g_apsspm1       RECORD LIKE apsspm.*
 DEFINE g_apsspm2       RECORD LIKE apsspm.*
 DEFINE g_apssim        RECORD LIKE apssim.*
 DEFINE g_apssrm        RECORD LIKE apssrm.*
 DEFINE g_apsuim        RECORD LIKE apsuim.*
 DEFINE g_apswhm        RECORD LIKE apswhm.*
 DEFINE g_apswcm        RECORD LIKE apswcm.*
 DEFINE g_apswmm        RECORD LIKE apswmm.*
 DEFINE g_apswsm        RECORD LIKE apswsm.*
 DEFINE g_apscim        RECORD LIKE apscim.*
 DEFINE g_apsspo        RECORD LIKE apsspo.*
 DEFINE g_apssmo        RECORD LIKE apssmo.*
 DEFINE g_apsddo        RECORD LIKE apsddo.*
 DEFINE g_aps_say       RECORD LIKE aps_say.*
 DEFINE g_apsdb         LIKE type_file.chr21
 DEFINE g_change_lang   LIKE type_file.chr1 
 DEFINE ls_date         STRING
 DEFINE l_flag          LIKE type_file.chr1
 DEFINE l_apsdb         LIKE azf_file.azf03  #FUN-740216

 DEFINE   g_cnt         LIKE type_file.num10 
 DEFINE   g_i           LIKE type_file.num5   
 DEFINE   g_msg         LIKE ze_file.ze03 

MAIN
   DEFINE   l_time       LIKE type_file.chr8
   DEFINE   p_row,p_col  LIKE type_file.num5

   OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST-1,
       PROMPT LINE   LAST,
       INPUT NO WRAP
   DEFER INTERRUPT				

    INITIALIZE g_bgjob_msgfile TO NULL
    LET tm.apsapg   = ARG_VAL(1)
    LET tm.apsapm   = ARG_VAL(2)
    LET tm.apsbmm   = ARG_VAL(3)
    LET tm.apscmm   = ARG_VAL(4)
    LET tm.apsdcm   = ARG_VAL(5)
    LET tm.apsocm   = ARG_VAL(6)
    LET tm.apsdom1  = ARG_VAL(7)
    LET tm.apsdom2  = ARG_VAL(8)
    LET tm.apsiam1  = ARG_VAL(9)
    LET tm.apsiam2  = ARG_VAL(10)
    LET tm.apsarm   = ARG_VAL(11)
    LET tm.apsimm   = ARG_VAL(12)
    LET tm.apsirm   = ARG_VAL(13)
    LET tm.apsmrm   = ARG_VAL(14)
    LET tm.apspem   = ARG_VAL(15)
    LET tm.apspfm   = ARG_VAL(16)
    LET tm.apsrem   = ARG_VAL(17)
    LET tm.apsrgm   = ARG_VAL(18)
    LET tm.apsrom   = ARG_VAL(19)
    LET tm.apsslm   = ARG_VAL(20)
    LET tm.apssmm   = ARG_VAL(21)
    LET tm.apsspm1  = ARG_VAL(22)
    LET tm.apsspm2  = ARG_VAL(23)
    LET tm.apssim   = ARG_VAL(24)
    LET tm.apssrm   = ARG_VAL(25)
    LET tm.apsuim   = ARG_VAL(26)
    LET tm.apswhm   = ARG_VAL(27)
    LET tm.apswcm   = ARG_VAL(28)
    LET tm.apswmm   = ARG_VAL(29)
    LET tm.apswsm   = ARG_VAL(30)
    LET tm.apscim   = ARG_VAL(31)
#---------------------------------------
    LET ls_date     = ARG_VAL(32)
    LET tm.say02    = cl_batch_bg_date_convert(ls_date)
    LET ls_date     = ARG_VAL(33)
    LET tm.dt_bdate = cl_batch_bg_date_convert(ls_date)
    LET ls_date     = ARG_VAL(34)
    LET tm.dt_edate = cl_batch_bg_date_convert(ls_date)
#---------------------------------------
    LET g_bgjob     = ARG_VAL(35)
    IF cl_null(g_bgjob) THEN
        LET g_bgjob = "N"
    END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,l_time,1) RETURNING l_time 

 ##LET g_apsdb = g_dbs CLIPPED,"."          #FUN-740215
   ##FUN-740216----------------------------------------------------
   ##LET g_apsdb = aps_saz.saz01 CLIPPED,":"  #FUN-740215
   SELECT azp03 INTO l_apsdb FROM azp_file WHERE azp01=aps_saz.saz01
   LET g_apsdb = l_apsdb CLIPPED,"."  
   ##FUN-740216----------------------------------------------------

   WHILE TRUE
      IF g_bgjob = "N" OR cl_null(g_bgjob) THEN
         CALL p100_ask()
         IF cl_sure(20,20) THEN
            LET g_success = 'Y'   
            CALL p100_del()  #刪除 log檔
            CALL p100_get()
            CALL p100_aps_say()
            CALL p100_out()
            IF g_success = 'Y' THEN
               ##COMMIT WORK  ##FUN-740216
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ##ROLLBACK WORK  ##FUN-740216
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p100
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         #LET g_success = 'Y'  ##FUN-740216
         CALL p100_del()  #刪除 log檔
         CALL p100_get()
         CALL p100_aps_say()
         CALL p100_out()
         ##IF g_success = "Y" THEN  ##FUN-740216
         ##   COMMIT WORK
         ##ELSE
         ##   ROLLBACK WORK
         ##END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
  END WHILE
  CALL cl_used(g_prog,l_time,2) RETURNING l_time 
END MAIN

FUNCTION p100_wc_default()
DEFINE  l_say02     LIKE aps_say.say02,
        l_say03     LIKE aps_say.say03

   SELECT MAX(say02) INTO l_say02 
     FROM aps_say 
    WHERE say01 = g_user
   IF cl_null(l_say02) THEN
      LET tm.apsapg  = 'Y' 
      LET tm.apsapm  = 'Y' 
      LET tm.apsbmm  = 'Y' 
      LET tm.apscmm  = 'Y' 
      LET tm.apsdcm  = 'Y' 
      LET tm.apsocm  = 'Y' 
      LET tm.apsdom1 = 'Y' 
      LET tm.apsdom2 = 'Y' 
      LET tm.apsiam1 = 'Y' 
      LET tm.apsiam2 = 'Y' 
      LET tm.apsarm  = 'Y' 
      LET tm.apsimm  = 'Y' 
      LET tm.apsirm  = 'Y' 
      LET tm.apsmrm  = 'Y' 
      LET tm.apspem  = 'Y' 
      LET tm.apspfm  = 'Y' 
      LET tm.apsrem  = 'Y' 
      LET tm.apsrgm  = 'Y' 
      LET tm.apsrom  = 'Y' 
      LET tm.apsslm  = 'Y' 
      LET tm.apssmm  = 'Y' 
      LET tm.apsspm1 = 'Y' 
      LET tm.apsspm2 = 'Y' 
      LET tm.apssim  = 'Y' 
      LET tm.apssrm  = 'Y' 
      LET tm.apsuim  = 'Y' 
      LET tm.apswhm  = 'Y' 
      LET tm.apswcm  = 'Y' 
      LET tm.apswmm  = 'Y' 
      LET tm.apswsm  = 'Y' 
      LET tm.apscim  = 'Y' 
      LET tm.dt_bdate  = g_today
      LET tm.dt_edate  = g_today
      LET g_bgjob = 'N'
   ELSE
      SELECT MAX(say03) INTO l_say03 
        FROM aps_say
       WHERE say01 = g_user 
         AND say02 = l_say02
      SELECT * INTO g_aps_say.* 
        FROM aps_say
       WHERE say01 = g_user 
         AND say02 = l_say02 
         AND say03 = l_say03

      LET tm.apsapg   = g_aps_say.apsapg  
      LET tm.apsapm   = g_aps_say.apsapm  
      LET tm.apsbmm   = g_aps_say.apsbmm  
      LET tm.apscmm   = g_aps_say.apscmm  
      LET tm.apsdcm   = g_aps_say.apsdcm  
      LET tm.apsocm   = g_aps_say.apsocm  
      LET tm.apsdom1  = g_aps_say.apsdom1 
      LET tm.apsdom2  = g_aps_say.apsdom2 
      LET tm.apsiam1  = g_aps_say.apsiam1 
      LET tm.apsiam2  = g_aps_say.apsiam2 
      LET tm.apsarm   = g_aps_say.apsarm  
      LET tm.apsimm   = g_aps_say.apsimm  
      LET tm.apsirm   = g_aps_say.apsirm  
      LET tm.apsmrm   = g_aps_say.apsmrm  
      LET tm.apspem   = g_aps_say.apspem  
      LET tm.apspfm   = g_aps_say.apspfm  
      LET tm.apsrem   = g_aps_say.apsrem  
      LET tm.apsrgm   = g_aps_say.apsrgm  
      LET tm.apsrom   = g_aps_say.apsrom  
      LET tm.apsslm   = g_aps_say.apsslm  
      LET tm.apssmm   = g_aps_say.apssmm  
      LET tm.apsspm1  = g_aps_say.apsspm1 
      LET tm.apsspm2  = g_aps_say.apsspm2 
      LET tm.apssim   = g_aps_say.apssim  
      LET tm.apssrm   = g_aps_say.apssrm  
      LET tm.apsuim   = g_aps_say.apsuim  
      LET tm.apswhm   = g_aps_say.apswhm  
      LET tm.apswcm   = g_aps_say.apswcm  
      LET tm.apswmm   = g_aps_say.apswmm  
      LET tm.apswsm   = g_aps_say.apswsm  
      LET tm.apscim   = g_aps_say.apscim  
      LET tm.dt_bdate = g_aps_say.dt_bdate
      LET tm.dt_edate = g_aps_say.dt_edate
      LET g_bgjob = 'N'
   END IF
   LET tm.say01 = g_user
   LET tm.say02 = g_today
   LET tm.say03 = TIME
END FUNCTION
 
FUNCTION p100_ask()
   DEFINE   lc_cmd       LIKE type_file.chr1000
   DEFINE   p_row,p_col  LIKE type_file.num5   

   LET p_row = 2 LET p_col = 23
   OPEN WINDOW p100 AT p_row,p_col WITH FORM "aps/42f/apsp100"
        ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')

WHILE TRUE
   CALL p100_wc_default()
   DISPLAY BY NAME 
                   tm.say02   ,
                   tm.dt_bdate,
                   tm.dt_edate,
                   tm.apsapg  ,
                   tm.apsapm  ,
                   tm.apsbmm  ,
                   tm.apscmm  ,
                   tm.apsdcm  ,
                   tm.apsocm  ,
                   tm.apsdom1 ,
                   tm.apsdom2 ,
                   tm.apsiam1 ,
                   tm.apsiam2 ,
                   tm.apsarm  ,
                   tm.apsimm  ,
                   tm.apsirm  ,
                   tm.apsmrm  ,
                   tm.apspem  ,
                   tm.apspfm  ,
                   tm.apsrem  ,
                   tm.apsrgm  ,
                   tm.apsrom  ,
                   tm.apsslm  ,
                   tm.apssmm  ,
                   tm.apsspm1 ,
                   tm.apsspm2 ,
                   tm.apssim  ,
                   tm.apssrm  ,
                   tm.apsuim  ,
                   tm.apswhm  ,
                   tm.apswcm  ,
                   tm.apswmm  ,
                   tm.apswsm  ,
                   tm.apscim  ,
                   g_bgjob

   INPUT BY NAME 
                   tm.apsapg  ,
                   tm.apsapm  ,
                   tm.apsbmm  ,
                   tm.apscmm  ,
                   tm.apsdcm  ,
                   tm.apsocm  ,
                   tm.apsiam1 ,
                   tm.apsiam2 ,
                   tm.apsarm  ,
                   tm.apsimm  ,
                   tm.apsirm  ,
                   tm.apspem  ,
                   tm.apspfm  ,
                   tm.apsrem  ,
                   tm.apsrgm  ,
                   tm.apsrom  ,
                   tm.apsslm  ,
                   tm.apssim  ,
                   tm.apssrm  ,
                   tm.apswhm  ,
                   tm.apswcm  ,
                   tm.apswmm  ,
                   tm.apswsm  ,
                   tm.apscim  ,
                   tm.apsdom1 ,
                   tm.apsdom2 ,
                   tm.apsmrm  ,
                   tm.apsuim  ,
                   tm.apssmm  ,
                   tm.apsspm1 ,
                   tm.apsspm2 ,
                   tm.say02   ,
                   tm.dt_bdate,
                   tm.dt_edate,
                   g_bgjob
                 WITHOUT DEFAULTS
      ON ACTION locale
         LET g_change_lang = TRUE        
         EXIT INPUT

      AFTER FIELD dt_bdate
         IF cl_null(tm.dt_bdate) THEN
            NEXT FIELD dt_bdate
         END IF
      AFTER FIELD dt_edate
         IF cl_null(tm.dt_edate) THEN
            NEXT FIELD dt_edate
         END IF
         IF tm.dt_edate < tm.dt_bdate THEN
            NEXT FIELD dt_bdate
         END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      BEFORE INPUT
         CALL cl_qbe_init()

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p100
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "apsp100"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('apsp100','9031',1)
      ELSE
         LET lc_cmd=lc_cmd CLIPPED,
                    " '",tm.apsapg   CLIPPED,"'",
                    " '",tm.apsapm   CLIPPED,"'",
                    " '",tm.apsbmm   CLIPPED,"'",
                    " '",tm.apscmm   CLIPPED,"'",
                    " '",tm.apsdcm   CLIPPED,"'",
                    " '",tm.apsocm   CLIPPED,"'",
                    " '",tm.apsdom1  CLIPPED,"'",
                    " '",tm.apsdom2  CLIPPED,"'",
                    " '",tm.apsiam1  CLIPPED,"'",
                    " '",tm.apsiam2  CLIPPED,"'",
                    " '",tm.apsarm   CLIPPED,"'",
                    " '",tm.apsimm   CLIPPED,"'",
                    " '",tm.apsirm   CLIPPED,"'",
                    " '",tm.apsmrm   CLIPPED,"'",
                    " '",tm.apspem   CLIPPED,"'",
                    " '",tm.apspfm   CLIPPED,"'",
                    " '",tm.apsrem   CLIPPED,"'",
                    " '",tm.apsrgm   CLIPPED,"'",
                    " '",tm.apsrom   CLIPPED,"'",
                    " '",tm.apsslm   CLIPPED,"'",
                    " '",tm.apssmm   CLIPPED,"'",
                    " '",tm.apsspm1  CLIPPED,"'",
                    " '",tm.apsspm2  CLIPPED,"'",
                    " '",tm.apssim   CLIPPED,"'",
                    " '",tm.apssrm   CLIPPED,"'",
                    " '",tm.apsuim   CLIPPED,"'",
                    " '",tm.apswhm   CLIPPED,"'",
                    " '",tm.apswcm   CLIPPED,"'",
                    " '",tm.apswmm   CLIPPED,"'",
                    " '",tm.apswsm   CLIPPED,"'",
                    " '",tm.apscim   CLIPPED,"'",
                    " '",tm.say02    CLIPPED,"'",
                    " '",tm.dt_bdate CLIPPED,"'",
                    " '",tm.dt_edate CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('apsp100',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p100
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE

END FUNCTION

FUNCTION p100_declare()		
   DEFINE l_sql		STRING    

   #-->萬用取替代(10)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsapg VALUES (?,?,?,?,?,?,?,?,?,?)"
   PREPARE p100_p_ins_apsapg FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsapg',STATUS,1) END IF
   DECLARE p100_c_ins_apsapg CURSOR WITH HOLD FOR p100_p_ins_apsapg
   IF STATUS THEN CALL cl_err('dec ins_apsapg',STATUS,1) END IF

   #-->單品取替代(11)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsapm VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?)"
   PREPARE p100_p_ins_apsapm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsapm',STATUS,1) END IF
   DECLARE p100_c_ins_apsapm CURSOR WITH HOLD FOR p100_p_ins_apsapm
   IF STATUS THEN CALL cl_err('dec ins_apsapm',STATUS,1) END IF

   #-->物料清單(20)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsbmm VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?)"
   PREPARE p100_p_ins_apsbmm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsbmm',STATUS,1) END IF
   DECLARE p100_c_ins_apsbmm CURSOR WITH HOLD FOR p100_p_ins_apsbmm
   IF STATUS THEN CALL cl_err('dec ins_apsbmm',STATUS,1) END IF

   #-->顧客(4)個
   LET l_sql="INSERT INTO ",g_apsdb,"apscmm VALUES (?,?,?,?)"
   PREPARE p100_p_ins_apscmm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apscmm',STATUS,1) END IF
   DECLARE p100_c_ins_apscmm CURSOR WITH HOLD FOR p100_p_ins_apscmm
   IF STATUS THEN CALL cl_err('dec ins_apscmm',STATUS,1) END IF

   #-->日行事曆(3)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsdcm VALUES (?,?,?)"
   PREPARE p100_p_ins_apsdcm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsdcm',STATUS,1) END IF
   DECLARE p100_c_ins_apsdcm CURSOR WITH HOLD FOR p100_p_ins_apsdcm
   IF STATUS THEN CALL cl_err('dec ins_apsdcm',STATUS,1) END IF

   #-->需求訂單選配(4)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsocm VALUES (?,?,?,?)"
   PREPARE p100_p_ins_apsocm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsocm',STATUS,1) END IF
   DECLARE p100_c_ins_apsocm CURSOR WITH HOLD FOR p100_p_ins_apsocm
   IF STATUS THEN CALL cl_err('dec ins_apsocm',STATUS,1) END IF

   #-->需求訂單(21)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsdom VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?)"
   PREPARE p100_p_ins_apsdom FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsdom',STATUS,1) END IF
   DECLARE p100_c_ins_apsdom CURSOR WITH HOLD FOR p100_p_ins_apsdom
   IF STATUS THEN CALL cl_err('dec ins_apsdom',STATUS,1) END IF

   #-->存貨預配記錄(10)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsiam VALUES (?,?,?,?,?,?,?,?,?,?)"
   PREPARE p100_p_ins_apsiam FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsiam',STATUS,1) END IF
   DECLARE p100_c_ins_apsiam CURSOR WITH HOLD FOR p100_p_ins_apsiam
   IF STATUS THEN CALL cl_err('dec ins_apsiam',STATUS,1) END IF

   #-->品項分配法則(4)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsarm VALUES (?,?,?,?)"
   PREPARE p100_p_ins_apsarm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsarm',STATUS,1) END IF
   DECLARE p100_c_ins_apsarm CURSOR WITH HOLD FOR p100_p_ins_apsarm
   IF STATUS THEN CALL cl_err('dec ins_apsarm',STATUS,1) END IF

   #-->料件主檔(51)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsimm VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,", 
                                                   "?)"   ##FUN-740216
   PREPARE p100_p_ins_apsimm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsimm',STATUS,1) END IF
   DECLARE p100_c_ins_apsimm CURSOR WITH HOLD FOR p100_p_ins_apsimm
   IF STATUS THEN CALL cl_err('dec ins_apsimm',STATUS,1) END IF

   #-->料件途程(7)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsirm VALUES (?,?,?,?,?,?,?)"
   PREPARE p100_p_ins_apsirm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsirm',STATUS,1) END IF
   DECLARE p100_c_ins_apsirm CURSOR WITH HOLD FOR p100_p_ins_apsirm
   IF STATUS THEN CALL cl_err('dec ins_apsirm',STATUS,1) END IF

   #-->工單備料(10)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsmrm VALUES (?,?,?,?,?,?,?,?,?,?)" 
   PREPARE p100_p_ins_apsmrm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsmrm',STATUS,1) END IF
   DECLARE p100_c_ins_apsmrm CURSOR WITH HOLD FOR p100_p_ins_apsmrm
   IF STATUS THEN CALL cl_err('dec ins_apsmrm',STATUS,1) END IF

   #-->單據追溯(13)個
   LET l_sql="INSERT INTO ",g_apsdb,"apspem VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?)"
   PREPARE p100_p_ins_apspem FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apspem',STATUS,1) END IF
   DECLARE p100_c_ins_apspem CURSOR WITH HOLD FOR p100_p_ins_apspem
   IF STATUS THEN CALL cl_err('dec ins_apspem',STATUS,1) END IF

   #-->預測群組沖銷(2)個
   LET l_sql="INSERT INTO ",g_apsdb,"apspfm VALUES (?,?)"
   PREPARE p100_p_ins_apspfm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apspfm',STATUS,1) END IF
   DECLARE p100_c_ins_apspfm CURSOR WITH HOLD FOR p100_p_ins_apspfm
   IF STATUS THEN CALL cl_err('dec ins_apspfm',STATUS,1) END IF

   #-->設備(7)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsrem VALUES (?,?,?,?,?,?,?)"
   PREPARE p100_p_ins_apsrem  FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsrem',STATUS,1) END IF
   DECLARE p100_c_ins_apsrem  CURSOR WITH HOLD FOR p100_p_ins_apsrem
   IF STATUS THEN CALL cl_err('dec ins_apsrem',STATUS,1) END IF

   #-->設備群組(2)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsrgm VALUES (?,?)"
   PREPARE p100_p_ins_apsrgm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsrgm',STATUS,1) END IF
   DECLARE p100_c_ins_apsrgm CURSOR WITH HOLD FOR p100_p_ins_apsrgm
   IF STATUS THEN CALL cl_err('dec ins_apsrgm',STATUS,1) END IF

   #-->途程制程(21)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsrom VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?)"
   PREPARE p100_p_ins_apsrom FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsrom',STATUS,1) END IF
   DECLARE p100_c_ins_apsrom CURSOR WITH HOLD FOR p100_p_ins_apsrom
   IF STATUS THEN CALL cl_err('dec ins_apsrom',STATUS,1) END IF

   #-->儲位(5)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsslm VALUES (?,?,?,?,?)"
   PREPARE p100_p_ins_apsslm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsslm',STATUS,1) END IF
   DECLARE p100_c_ins_apsslm CURSOR WITH HOLD FOR p100_p_ins_apsslm
   IF STATUS THEN CALL cl_err('dec ins_apsslm',STATUS,1) END IF

   #-->工單檔(22)個
   LET l_sql="INSERT INTO ",g_apsdb,"apssmm VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?)" 
   PREPARE p100_p_ins_apssmm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apssmm',STATUS,1) END IF
   DECLARE p100_c_ins_apssmm CURSOR WITH HOLD FOR p100_p_ins_apssmm
   IF STATUS THEN CALL cl_err('dec ins_apssmm',STATUS,1) END IF

   #-->採購令檔(23)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsspm VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?)" 
   PREPARE p100_p_ins_apsspm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsspm',STATUS,1) END IF
   DECLARE p100_c_ins_apsspm CURSOR WITH HOLD FOR p100_p_ins_apsspm
   IF STATUS THEN CALL cl_err('dec ins_apsspm',STATUS,1) END IF

   #-->料件供應商(17)個
   LET l_sql="INSERT INTO ",g_apsdb,"apssim VALUES (?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?)"  
   PREPARE p100_p_ins_apssim FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apssim',STATUS,1) END IF
   DECLARE p100_c_ins_apssim CURSOR WITH HOLD FOR p100_p_ins_apssim
   IF STATUS THEN CALL cl_err('dec ins_apssim',STATUS,1) END IF

   #-->供給法則(5)個
   LET l_sql="INSERT INTO ",g_apsdb,"apssrm VALUES (?,?,?,?,?)"
   PREPARE p100_p_ins_apssrm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apssrm',STATUS,1) END IF
   DECLARE p100_c_ins_apssrm CURSOR WITH HOLD FOR p100_p_ins_apssrm
   IF STATUS THEN CALL cl_err('dec ins_apssrm',STATUS,1) END IF

   #-->實體庫存(5)個
   LET l_sql="INSERT INTO ",g_apsdb,"apsuim VALUES (?,?,?,?,?)"   
   PREPARE p100_p_ins_apsuim FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apsuim',STATUS,1) END IF
   DECLARE p100_c_ins_apsuim CURSOR WITH HOLD FOR p100_p_ins_apsuim
   IF STATUS THEN CALL cl_err('dec ins_apsuim',STATUS,1) END IF

   #-->倉庫(5)個
   LET l_sql="INSERT INTO ",g_apsdb,"apswhm VALUES (?,?,?,?,?)"
   PREPARE p100_p_ins_apswhm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apswhm',STATUS,1) END IF
   DECLARE p100_c_ins_apswhm CURSOR WITH HOLD FOR p100_p_ins_apswhm
   IF STATUS THEN CALL cl_err('dec ins_apswhm',STATUS,1) END IF

   #-->週行事曆(15)個
   LET l_sql="INSERT INTO ",g_apsdb,"apswcm VALUES (?,?,?,?,?,?,?,?,?,?,", #FUN-740216
                                                   "?,?,?,?,?)"
   PREPARE p100_p_ins_apswcm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apswcm',STATUS,1) END IF
   DECLARE p100_c_ins_apswcm CURSOR WITH HOLD FOR p100_p_ins_apswcm
   IF STATUS THEN CALL cl_err('dec ins_apswcm',STATUS,1) END IF

   #-->工作模式(6)個
   LET l_sql="INSERT INTO ",g_apsdb,"apswmm VALUES (?,?,?,?,?,?)"
   PREPARE p100_p_ins_apswmm FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apswmm',STATUS,1) END IF
   DECLARE p100_c_ins_apswmm CURSOR WITH HOLD FOR p100_p_ins_apswmm
   IF STATUS THEN CALL cl_err('dec ins_apswmm',STATUS,1) END IF

   #-->工作站(4)個
   LET l_sql="INSERT INTO ",g_apsdb,"apswsm VALUES (?,?,?,?)"
   PREPARE p100_p_ins_apswsm  FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apswsm',STATUS,1) END IF
   DECLARE p100_c_ins_apswsm CURSOR WITH HOLD FOR p100_p_ins_apswsm
   IF STATUS THEN CALL cl_err('dec ins_apswsm',STATUS,1) END IF

   #-->系統參數(57)個
   LET l_sql="INSERT INTO ",g_apsdb,"apscim VALUES (?,?,?,?,?,?,?,?,?,?,", ##FUN-740216
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?,?,?,?,",
                                                   "?,?,?,?,?,?,?)"
   PREPARE p100_p_ins_apscim FROM l_sql
   IF STATUS THEN CALL cl_err('pre ins_apscim',STATUS,1) END IF
   DECLARE p100_c_ins_apscim CURSOR WITH HOLD FOR p100_p_ins_apscim
   IF STATUS THEN CALL cl_err('dec ins_apscim',STATUS,1) END IF

END FUNCTION
 
FUNCTION p100_get()
   CALL p100_declare()	       #DECLARE Insert Cursor
   #==>OPEN Cursor
   OPEN p100_c_ins_apsapg 
   OPEN p100_c_ins_apsapm 
   OPEN p100_c_ins_apsbmm 
   OPEN p100_c_ins_apscmm 
   OPEN p100_c_ins_apsdcm 
   OPEN p100_c_ins_apsocm 
   OPEN p100_c_ins_apsdom
   OPEN p100_c_ins_apsiam
   OPEN p100_c_ins_apsarm 
   OPEN p100_c_ins_apsimm 
   OPEN p100_c_ins_apsirm 
   OPEN p100_c_ins_apsmrm 
   OPEN p100_c_ins_apspem 
   OPEN p100_c_ins_apspfm 
   OPEN p100_c_ins_apsrem 
   OPEN p100_c_ins_apsrgm 
   OPEN p100_c_ins_apsrom 
   OPEN p100_c_ins_apsslm 
   OPEN p100_c_ins_apssmm 
   OPEN p100_c_ins_apsspm
   OPEN p100_c_ins_apssim 
   OPEN p100_c_ins_apssrm 
   OPEN p100_c_ins_apsuim 
   OPEN p100_c_ins_apswhm 
   OPEN p100_c_ins_apswcm 
   OPEN p100_c_ins_apswmm 
   OPEN p100_c_ins_apswsm 
   OPEN p100_c_ins_apscim 

   IF g_bgjob = 'N' THEN  
       MESSAGE 'Process apswhm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apswhm()

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsslm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsslm() 

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apssrm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apssrm()      

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process apsimm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsimm()  

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsdom1...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsdom_1()        

   IF g_bgjob = 'N' THEN  
       MESSAGE 'Process apsdom2...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsdom_2()  

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsuim ...'
       CALL ui.interface.refresh()
   END IF
  #CALL p100_apsocm()     #附屬關係,由p100_apsdom_1()再CALL p100_apsocm()
  #IF g_bgjob = 'N' THEN        
  #    MESSAGE 'Process apsiam1 ...'
  #    CALL ui.interface.refresh()
  #END IF
   CALL p100_apsuim()   

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsiam1...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsiam_1()      

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process apsiam2 ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsiam_2()      

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process apswcm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apswcm()      

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process apsdcm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsdcm()  

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsrem ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsrem()   

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsrgm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsrgm()

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apswsm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apswsm()     

   IF g_bgjob = 'N' THEN  
       MESSAGE 'Process apswmm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apswmm()          

   IF g_bgjob = 'N' THEN  
        MESSAGE 'Process apsbmm ...'
        CALL ui.interface.refresh()
   END IF
   CALL p100_apsbmm()  

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apscmm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apscmm()  

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsapg ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsapg() 

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsirm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsirm()   

   IF g_bgjob = 'N' THEN
       MESSAGE 'Process apspfm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apspfm() 

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsmrm....'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsmrm()   

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apssmm ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apssmm()   

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsspm1...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsspm_1() 

   IF g_bgjob = 'N' THEN
       MESSAGE 'Process apsspm2...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsspm_2()

   IF g_bgjob = 'N' THEN 
       MESSAGE 'Process apsarm ...'
       CALL ui.interface.refresh()
   END IF
  #CALL p100_apsapm()      #附屬關係,由p100_apsbmm() 再CALL p100_apsapm()
  #IF g_bgjob = 'N' THEN        
  #    MESSAGE 'Process apsocm ...'
  #    CALL ui.interface.refresh()
  #END IF
   CALL p100_apsarm()      

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process apspem ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apspem()      

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process apsrom ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apsrom()      

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process apssim ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apssim()  

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process apscim ...'
       CALL ui.interface.refresh()
   END IF
   CALL p100_apscim()      

   IF g_bgjob = 'N' THEN        
       MESSAGE 'Process ending...'
       CALL ui.interface.refresh()
   END IF

   #==>CLOSE Cursor
   CLOSE p100_c_ins_apsapg 
   CLOSE p100_c_ins_apsapm 
   CLOSE p100_c_ins_apsbmm 
   CLOSE p100_c_ins_apscmm 
   CLOSE p100_c_ins_apsdcm 
   CLOSE p100_c_ins_apsocm 
   CLOSE p100_c_ins_apsdom
   CLOSE p100_c_ins_apsiam
   CLOSE p100_c_ins_apsarm 
   CLOSE p100_c_ins_apsimm 
   CLOSE p100_c_ins_apsirm 
   CLOSE p100_c_ins_apsmrm 
   CLOSE p100_c_ins_apspem 
   CLOSE p100_c_ins_apspfm 
   CLOSE p100_c_ins_apsrem 
   CLOSE p100_c_ins_apsrgm 
   CLOSE p100_c_ins_apsrom 
   CLOSE p100_c_ins_apsslm 
   CLOSE p100_c_ins_apssmm 
   CLOSE p100_c_ins_apsspm
   CLOSE p100_c_ins_apssim 
   CLOSE p100_c_ins_apssrm 
   CLOSE p100_c_ins_apsuim 
   CLOSE p100_c_ins_apswhm 
   CLOSE p100_c_ins_apswcm 
   CLOSE p100_c_ins_apswmm 
   CLOSE p100_c_ins_apswsm 
   CLOSE p100_c_ins_apscim 
END FUNCTION

FUNCTION p100_apswsm()
  DEFINE l_sql          STRING
  DEFINE l_eca01        LIKE eca_file.eca01
  DEFINE l_eca02        LIKE eca_file.eca02
  DEFINE l_eca05        LIKE eca_file.eca05

  IF tm.apswsm  = 'N' THEN RETURN END IF

  #虛擬製程
  IF aps_saz.saz02 = 'Y' THEN
     INITIALIZE g_apswsm.* TO NULL    
     LET g_apswsm.ws_id    = 'APS-WS'
     LET g_apswsm.location = NULL
     LET g_apswsm.ws_name  = 'APS-WS Name'
     LET g_apswsm.ws_des   = NULL

     PUT p100_c_ins_apswsm  FROM g_apswsm.* 
     IF STATUS THEN
        LET g_msg = 'Key:',g_apswsm.ws_id   
        CALL err('apswsm',g_msg,STATUS)
     END IF
     RETURN
  END IF

  DECLARE p100_apswsm_c CURSOR FOR
     SELECT eca01,eca02,eca05  FROM eca_file

  FOREACH p100_apswsm_c INTO l_eca01,l_eca02,l_eca05
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apswsm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apswsm.* TO NULL    
     IF cl_null(l_eca05) THEN LET l_eca05 = ' ' END IF
     LET g_apswsm.ws_id    = l_eca01
     LET g_apswsm.location = l_eca05
     LET g_apswsm.ws_name  = l_eca02
     LET g_apswsm.ws_des   = l_eca02

     PUT p100_c_ins_apswsm  FROM g_apswsm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apswsm.ws_id  
        CALL err('apswsm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apswsm_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apswmm()      #工作模式
DEFINE l_sql            STRING                 
DEFINE l_aps_sae   	RECORD LIKE aps_sae.* 

  IF tm.apswmm  = 'N' THEN RETURN END IF

  DECLARE p100_apswmm_c CURSOR FOR SELECT aps_sae.* FROM aps_sae

  FOREACH p100_apswmm_c INTO l_aps_sae.*  
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apswmm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apswmm.* TO NULL   
     LET g_apswmm.wm_id   = l_aps_sae.wm_id   
     LET g_apswmm.st_t    = l_aps_sae.st_t    
     LET g_apswmm.ed_t    = l_aps_sae.ed_t    
     LET g_apswmm.wk_type = l_aps_sae.wk_type 
     LET g_apswmm.wm_name = l_aps_sae.wm_name 
     LET g_apswmm.wm_des  = l_aps_sae.wm_des  

     PUT p100_c_ins_apswmm  FROM g_apswmm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apswmm.wm_id CLIPPED,'+',g_apswmm.st_t 
        CALL err('apswmm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN
     CALL cl_err('p100_apswmm_c:',STATUS,1) RETURN
  END IF
END FUNCTION
 
FUNCTION p100_apswcm() 
DEFINE l_sql            STRING                 
DEFINE l_aps_wcm   	RECORD LIKE aps_wcm.* 

  IF tm.apswcm  = 'N' THEN RETURN END IF

  DECLARE p100_apswcm_c CURSOR FOR SELECT aps_wcm.* FROM aps_wcm

  FOREACH p100_apswcm_c INTO l_aps_wcm.*  
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apswcm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apswcm.* TO NULL   
     LET g_apswcm.wcaln_id = l_aps_wcm.wcaln_id
     LET g_apswcm.mon_wmid = l_aps_wcm.mon_wmid
     LET g_apswcm.tue_wmid = l_aps_wcm.tue_wmid
     LET g_apswcm.wed_wmid = l_aps_wcm.wed_wmid
     LET g_apswcm.thu_wmid = l_aps_wcm.thu_wmid
     LET g_apswcm.fri_wmid = l_aps_wcm.fri_wmid
     LET g_apswcm.sat_wmid = l_aps_wcm.sat_wmid
     LET g_apswcm.sun_wmid = l_aps_wcm.sun_wmid
     LET g_apswcm.mon_exhr = l_aps_wcm.mon_exhr
     LET g_apswcm.tue_exhr = l_aps_wcm.tue_exhr
     LET g_apswcm.wed_exhr = l_aps_wcm.wed_exhr
     LET g_apswcm.thu_exhr = l_aps_wcm.thu_exhr
     LET g_apswcm.fri_exhr = l_aps_wcm.fri_exhr
     LET g_apswcm.sat_exhr = l_aps_wcm.sat_exhr
     LET g_apswcm.sun_exhr = l_aps_wcm.sun_exhr

     PUT p100_c_ins_apswcm  FROM g_apswcm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apswcm.wcaln_id CLIPPED
        CALL err('apswcm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN
     CALL cl_err('p100_apswcm_c:',STATUS,1) RETURN
  END IF
END FUNCTION

FUNCTION p100_apsocm(l_oeo01,l_oeo03) 
DEFINE l_sql       STRING                
DEFINE l_oeo01     LIKE oeo_file.oeo01
DEFINE l_oeo03     LIKE oeo_file.oeo03
DEFINE l_oeo04     LIKE oeo_file.oeo04
DEFINE l_oeb04     LIKE oeb_file.oeb04
DEFINE l_seq       LIKE type_file.num10 

  IF tm.apsocm  = 'N' THEN RETURN END IF

  DECLARE p100_apsocm_c CURSOR FOR 
     SELECT oeo01,oeo04,oeb04
       FROM oeo_file,oeb_file
      WHERE oeo01 = l_oeo01
        AND oeo03 = l_oeo03
        AND oeo01 = oeb01
        AND oeo03 = oeb03
  LET l_seq = 0
  FOREACH p100_apsocm_c INTO l_oeo01,l_oeo04,l_oeb04
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsocm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsocm.* TO NULL
     LET l_seq = l_seq + 1
     LET g_apsocm.opt_pid  = l_oeo04
     LET g_apsocm.feat_pid = l_oeb04
     LET g_apsocm.do_id    = l_oeo01
     LET g_apsocm.seq_txt  = l_seq USING '&&&&'

     PUT p100_c_ins_apsocm FROM g_apsocm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsocm.opt_pid  CLIPPED,'+',
                           g_apsocm.feat_pid CLIPPED,'+',
                           g_apsocm.do_id    CLIPPED,'+',
                           g_apsocm.seq_txt  CLIPPED,'+'
        CALL err('apsocm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsocm_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apsapg()      
DEFINE l_sql            STRING                
DEFINE l_bmd            RECORD LIKE bmd_file.*
DEFINE l_bmb            RECORD LIKE bmb_file.*
DEFINE l_bmb_rowid      LIKE type_file.chr18   # saki 20070821 rowid chr18 -> num10 

  IF tm.apsapg  = 'N' THEN RETURN END IF

  DECLARE p100_apsapg_c CURSOR FOR 
     SELECT *
       FROM bmd_file
      WHERE bmd01 = 'ALL'

  FOREACH p100_apsapg_c INTO l_bmd.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsapg_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsapg.* TO NULL
     LET g_apsapg.in_pid   = l_bmd.bmd01
     LET g_apsapg.sub_pid  = l_bmd.bmd04
     LET g_apsapg.sb_aprio = l_bmd.bmd03
     LET g_apsapg.in_qty   = l_bmd.bmd07 
     LET g_apsapg.eff_st   = l_bmd.bmd05
     LET g_apsapg.eff_et   = l_bmd.bmd06
     #只為了找到bmb_file相對應中的任何一筆就OK-------str--
     INITIALIZE l_bmb.* TO NULL
     LET l_bmb_rowid = NULL
     SELECT MIN(ROWID) INTO l_bmb_rowid FROM bmb_file
      WHERE bmb03 = l_bmd.bmd01
     SELECT * INTO l_bmb.* 
       FROM bmb_file
      WHERE ROWID = l_bmb_rowid
     #-----------------------------------------------end--
     IF NOT cl_null(l_bmb.bmb07) THEN
         LET g_apsapg.out_qty  = l_bmb.bmb07
     ELSE
         LET g_apsapg.out_qty  = 1
     END IF
     IF NOT cl_null(l_bmb.bmb08) THEN
         LET g_apsapg.shrink   = l_bmb.bmb08 
     ELSE
         LET g_apsapg.shrink   = 0
     END IF
     LET g_apsapg.sub_type = l_bmd.bmd02
     LET g_apsapg.al_ratio = l_bmd.bmd07

     PUT p100_c_ins_apsapg FROM g_apsapg.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsapg.in_pid CLIPPED,'+',g_apsapg.sub_pid
        CALL err('apsapg',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsapg_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apscmm()      
DEFINE l_sql            STRING                
DEFINE l_occ            RECORD LIKE occ_file.*

  IF tm.apscmm  = 'N' THEN RETURN END IF

  DECLARE p100_apscmm_c CURSOR FOR 
    SELECT * FROM occ_file

  FOREACH p100_apscmm_c INTO l_occ.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apscmm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apscmm.* TO NULL
     IF l_occ.occ01 IS NOT NULL AND l_occ.occ02 IS NOT NULL THEN  #FUN-760041
        LET g_apscmm.cm_id    = l_occ.occ01
        LET g_apscmm.cmg_id   = l_occ.occ02
        LET g_apscmm.cm_name  = l_occ.occ34
        LET g_apscmm.cmg_name = l_occ.occ34
        
        PUT p100_c_ins_apscmm FROM g_apscmm.*
        IF STATUS THEN
           LET g_msg = 'Key:',g_apscmm.cm_id  CLIPPED,'+',
                              g_apscmm.cmg_id CLIPPED
           CALL err('apscmm',g_msg,STATUS)
        END IF
     END IF 
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apscmm_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apsiam_1()    ##存貨預配紀錄(工單) 
DEFINE l_sql            STRING                
DEFINE l_aps_saj   	RECORD LIKE aps_saj.* 

  IF tm.apsiam1 = 'N' THEN RETURN END IF

  DECLARE p100_apsiam1_c CURSOR FOR 
   SELECT aps_saj.* FROM aps_saj

  FOREACH p100_apsiam1_c INTO l_aps_saj.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsiam1_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsiam1.* TO NULL
     LET g_apsiam1.pid      = l_aps_saj.pid
     LET g_apsiam1.oid      = l_aps_saj.oid
     LET g_apsiam1.wh_id    = l_aps_saj.wh_id
     LET g_apsiam1.stk_loc  = l_aps_saj.stk_loc
     LET g_apsiam1.fed_qty  = l_aps_saj.fed_qty
     LET g_apsiam1.dm_qty   = l_aps_saj.dm_qty   
     LET g_apsiam1.is_mt    = l_aps_saj.is_mt    
     LET g_apsiam1.location = l_aps_saj.location 
     LET g_apsiam1.is_lock  = l_aps_saj.is_lock  
     LET g_apsiam1.is_do    = l_aps_saj.is_do    

     PUT p100_c_ins_apsiam FROM g_apsiam1.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsiam1.pid     CLIPPED,'+',
                           g_apsiam1.oid     CLIPPED,'+',
                           g_apsiam1.wh_id   CLIPPED,'+',
                           g_apsiam1.stk_loc CLIPPED
        CALL err('apsiam1',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsiam1_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apsiam_2()     ##存貨預配紀錄(訂單)
DEFINE l_sql            STRING                
DEFINE l_oeb       	RECORD LIKE oeb_file.*
DEFINE l_ima08          LIKE ima_file.ima08

  IF tm.apsiam2 = 'N' THEN RETURN END IF

  DECLARE p100_apsiam2_c CURSOR FOR 
   SELECT * FROM oeb_file

  FOREACH p100_apsiam2_c INTO l_oeb.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsiam2_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsiam2.* TO NULL
     LET g_apsiam2.pid      = l_oeb.oeb04
     LET g_apsiam2.oid      = l_oeb.oeb01
     LET g_apsiam2.wh_id    = l_oeb.oeb09
     LET g_apsiam2.stk_loc  = l_oeb.oeb091
     LET g_apsiam2.fed_qty  = l_oeb.oeb905
     LET g_apsiam2.dm_qty   = l_oeb.oeb12
     SELECT ima08 INTO l_ima08
       FROM ima_file
      WHERE ima01 = l_oeb.oeb04
     IF l_ima08 MATCHES '[PVZ]' THEN
         LET g_apsiam2.is_mt    = 0
     ELSE
         LET g_apsiam2.is_mt    = 1
     END IF
     LET g_apsiam2.is_mt    = l_ima08
     LET g_apsiam2.location = NULL
     LET g_apsiam2.is_lock  = l_oeb.oeb19
     LET g_apsiam2.is_do    = 1

     PUT p100_c_ins_apsiam FROM g_apsiam2.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsiam2.pid     CLIPPED,'+',
                           g_apsiam2.oid     CLIPPED,'+',
                           g_apsiam2.wh_id   CLIPPED,'+',
                           g_apsiam2.stk_loc CLIPPED
        CALL err('apsiam2',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsiam2_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apscim()      
DEFINE l_sql            STRING                
DEFINE l_aps_cim   	RECORD LIKE aps_cim.* 

  IF tm.apscim  = 'N' THEN RETURN END IF

  DECLARE p100_apscim_c CURSOR FOR 
   SELECT aps_cim.* FROM aps_cim

  FOREACH p100_apscim_c INTO l_aps_cim.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apscim_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apscim.* TO NULL
     LET g_apscim.casecode = l_aps_cim.casecode   
     LET g_apscim.purrule  = l_aps_cim.purrule    
     LET g_apscim.peglock  = l_aps_cim.peglock    
     LET g_apscim.invlock  = l_aps_cim.invlock    
     LET g_apscim.cripart  = l_aps_cim.cripart    
     LET g_apscim.lotpst   = l_aps_cim.lotpst     
     LET g_apscim.fixtime  = l_aps_cim.fixtime    
     LET g_apscim.opitmfl  = l_aps_cim.opitmfl    
     LET g_apscim.mrpmode  = l_aps_cim.mrpmode    
     LET g_apscim.priflag  = l_aps_cim.priflag    
     LET g_apscim.dewoflg  = l_aps_cim.dewoflg    
     LET g_apscim.sastock  = l_aps_cim.sastock    
     LET g_apscim.mulalc   = l_aps_cim.mulalc     
     LET g_apscim.loaltpt  = l_aps_cim.loaltpt    
     LET g_apscim.initime  = l_aps_cim.initime    
     LET g_apscim.supunit  = l_aps_cim.supunit    
     LET g_apscim.chkitem  = l_aps_cim.chkitem    
     LET g_apscim.savevo   = l_aps_cim.savevo     
     LET g_apscim.ordcons  = l_aps_cim.ordcons    
     LET g_apscim.relfcst  = l_aps_cim.relfcst    
     LET g_apscim.consper  = l_aps_cim.consper    
     LET g_apscim.conrept  = l_aps_cim.conrept    
     LET g_apscim.conrepd  = l_aps_cim.conrepd    
     LET g_apscim.conrptw  = l_aps_cim.conrptw    
     LET g_apscim.comblot  = l_aps_cim.comblot    
     LET g_apscim.combrat  = l_aps_cim.combrat    
     LET g_apscim.btksel   = l_aps_cim.btksel     
     LET g_apscim.cpmaxcl  = l_aps_cim.cpmaxcl    
     LET g_apscim.samsize  = l_aps_cim.samsize    
     LET g_apscim.difrate  = l_aps_cim.difrate    
     LET g_apscim.inirule  = l_aps_cim.inirule    
     LET g_apscim.levrule  = l_aps_cim.levrule    
     LET g_apscim.inprule  = l_aps_cim.inprule    
     LET g_apscim.parproc  = l_aps_cim.parproc    
     LET g_apscim.fcrule   = l_aps_cim.fcrule     
     LET g_apscim.offrule  = l_aps_cim.offrule    
     LET g_apscim.extrule  = l_aps_cim.extrule    
     LET g_apscim.depoflg  = l_aps_cim.depoflg    
     LET g_apscim.phsdate  = l_aps_cim.phsdate    
     LET g_apscim.mrphor   = l_aps_cim.mrphor     
     LET g_apscim.mrppr1   = l_aps_cim.mrppr1     
     LET g_apscim.mrpper2  = l_aps_cim.mrpper2    
     LET g_apscim.mrpper3  = l_aps_cim.mrpper3    
     LET g_apscim.mrpper4  = l_aps_cim.mrpper4    
     LET g_apscim.mrpprr1  = l_aps_cim.mrpprr1    
     LET g_apscim.mrpprr2  = l_aps_cim.mrpprr2    
     LET g_apscim.mrpprr3  = l_aps_cim.mrpprr3    
     LET g_apscim.mrpprr4  = l_aps_cim.mrpprr4    
     LET g_apscim.ncrtlsp  = l_aps_cim.ncrtlsp    
     LET g_apscim.mrpdays  = l_aps_cim.mrpdays    
     LET g_apscim.starttm  = l_aps_cim.starttm    
     LET g_apscim.invfrst  = l_aps_cim.invfrst    
     LET g_apscim.bomlchk  = l_aps_cim.bomlchk    
     LET g_apscim.pospseq  = l_aps_cim.pospseq    
     LET g_apscim.poexcpt  = l_aps_cim.poexcpt    
     LET g_apscim.altprul  = l_aps_cim.altprul    
     LET g_apscim.fcsttor  = l_aps_cim.fcsttor    

     PUT p100_c_ins_apscim FROM g_apscim.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apscim.casecode CLIPPED
        CALL err('apscim',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apscim_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apspfm()      
DEFINE l_sql            STRING                
DEFINE l_aps_pfm   	RECORD LIKE aps_pfm.* 

  IF tm.apspfm  = 'N' THEN RETURN END IF

  DECLARE p100_apspfm_c CURSOR FOR 
   SELECT aps_pfm.* FROM aps_pfm

  FOREACH p100_apspfm_c INTO l_aps_pfm.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apspfm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apspfm.* TO NULL
     LET g_apspfm.pid = l_aps_pfm.pid 
     LET g_apspfm.mid = l_aps_pfm.mid 

     PUT p100_c_ins_apspfm FROM g_apspfm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apspfm.pid CLIPPED,'+',
                           g_apspfm.mid CLIPPED
        CALL err('apspfm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apspfm_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apssrm()      
DEFINE l_sql            STRING                
DEFINE l_aps_srm   	RECORD LIKE aps_srm.* 

  IF tm.apssrm  = 'N' THEN RETURN END IF

  DECLARE p100_apssrm_c CURSOR FOR 
   SELECT aps_srm.* FROM aps_srm

  FOREACH p100_apssrm_c INTO l_aps_srm.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apssrm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apssrm.* TO NULL
     LET g_apssrm.rid      = l_aps_srm.rid      
     LET g_apssrm.sply_typ = l_aps_srm.sply_typ 
     LET g_apssrm.wh_id    = l_aps_srm.wh_id    
     LET g_apssrm.stk_loc  = l_aps_srm.stk_loc  
     LET g_apssrm.priority = l_aps_srm.priority 

     PUT p100_c_ins_apssrm FROM g_apssrm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apssrm.rid      CLIPPED,'+',
                           g_apssrm.sply_typ CLIPPED,'+',
                           g_apssrm.wh_id    CLIPPED,'+',
                           g_apssrm.stk_loc  CLIPPED
        CALL err('apssrm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apssrm_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apsarm()      
DEFINE l_sql            STRING                
DEFINE l_aps_arm   	RECORD LIKE aps_arm.* 

  IF tm.apsarm  = 'N' THEN RETURN END IF

  DECLARE p100_apsarm_c CURSOR FOR 
   SELECT aps_arm.* FROM aps_arm

  FOREACH p100_apsarm_c INTO l_aps_arm.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsarm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsarm.* TO NULL
     LET g_apsarm.pid      = l_aps_arm.pid      
     LET g_apsarm.rid      = l_aps_arm.rid      
     LET g_apsarm.compt    = l_aps_arm.compt    
     LET g_apsarm.sply_rid = l_aps_arm.sply_rid 

     PUT p100_c_ins_apsarm FROM g_apsarm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsarm.pid      CLIPPED,'+',
                           g_apsarm.rid      CLIPPED,'+',
                           g_apsarm.compt    CLIPPED,'+',
                           g_apsarm.sply_rid CLIPPED
        CALL err('apsarm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsarm_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apspem()      
DEFINE l_sql            STRING                
DEFINE l_aps_pem   	RECORD LIKE aps_pem.* 

  IF tm.apspem  = 'N' THEN RETURN END IF

  DECLARE p100_apspem_c CURSOR FOR 
   SELECT aps_pem.* FROM aps_pem

  FOREACH p100_apspem_c INTO l_aps_pem.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apspem_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apspem.* TO NULL
     LET g_apspem.fed_oid  = l_aps_pem.fed_oid 
     LET g_apspem.dm_qty   = l_aps_pem.dm_qty  
     LET g_apspem.feded_id = l_aps_pem.feded_id
     LET g_apspem.is_do    = l_aps_pem.is_do   
     LET g_apspem.fed_qty  = l_aps_pem.fed_qty 
     LET g_apspem.is_po    = l_aps_pem.is_po   
     LET g_apspem.sup_qty  = l_aps_pem.sup_qty 
     LET g_apspem.is_lock  = l_aps_pem.is_lock 
     LET g_apspem.pid      = l_aps_pem.pid     
     LET g_apspem.p_alias  = l_aps_pem.p_alias 
     LET g_apspem.slack    = l_aps_pem.slack   
     LET g_apspem.is_error = l_aps_pem.is_error
     LET g_apspem.err_msg  = l_aps_pem.err_msg 

     PUT p100_c_ins_apspem FROM g_apspem.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apspem.fed_oid CLIPPED
        CALL err('apspem',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apspem_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsdcm()      #日行事曆
DEFINE l_sql            STRING                
DEFINE l_aps_sad   	RECORD LIKE aps_sad.* 

  IF tm.apsdcm  = 'N' THEN RETURN END IF

  DECLARE p100_apsdcm_c CURSOR FOR SELECT aps_sad.* FROM aps_sad

  FOREACH p100_apsdcm_c INTO l_aps_sad.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsdcm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsdcm.* TO NULL
     LET g_apsdcm.dcaln_id = l_aps_sad.dcaln_id 
     IF NOT cl_null(l_aps_sad.d_date) THEN
        LET g_apsdcm.d_date = l_aps_sad.d_date
     END IF
     LET g_apsdcm.wm_id     = l_aps_sad.wm_id

     PUT p100_c_ins_apsdcm FROM g_apsdcm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsdcm.dcaln_id CLIPPED,g_apsdcm.d_date
        CALL err('apsdcm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsdcm_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsrem()      #設備資源
DEFINE l_sql           STRING                
DEFINE l_eci01         LIKE eci_file.eci01 
DEFINE l_eci03         LIKE eci_file.eci03 
DEFINE l_eci06         LIKE eci_file.eci06 
DEFINE l_wcaln_id      LIKE aps_eci.wcaln_id 
DEFINE l_dcaln_id      LIKE aps_eci.dcaln_id 
DEFINE l_eq_type       LIKE aps_eci.eq_type  

  IF tm.apsrem  = 'N' THEN RETURN END IF
 
  #新增虛擬設備資源檔
  IF aps_saz.saz02 = 'Y' THEN
     INITIALIZE g_apsrem.* TO NULL
     LET g_apsrem.eq_id     = 'APS-equip'
     LET g_apsrem.ws_id     = 'APS-WS'
     LET g_apsrem.wcaln_id  = NULL
     LET g_apsrem.dcaln_id  = NULL
     LET g_apsrem.eq_type   = 0       
     LET g_apsrem.eq_name   = 'APS-equip Name'
     LET g_apsrem.eq_des    = NULL

     PUT p100_c_ins_apsrem  FROM g_apsrem.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsrem.eq_id
        CALL err('apsrem',g_msg,STATUS)
     END IF
     RETURN
  END IF

  DECLARE p100_apsrem_c CURSOR FOR
     SELECT eci01,eci03,eci06,wcaln_id,dcaln_id,eq_type  
       FROM eci_file,aps_eci
      WHERE eci01 = eq_id

  FOREACH p100_apsrem_c INTO l_eci01,l_eci03,l_eci06,
                             l_wcaln_id,l_dcaln_id,l_eq_type   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsrem_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsrem.* TO NULL
     LET g_apsrem.eq_id     = l_eci01
     LET g_apsrem.ws_id     = l_eci03
     LET g_apsrem.wcaln_id  = l_wcaln_id
     LET g_apsrem.dcaln_id  = l_dcaln_id
     LET g_apsrem.eq_type   = l_eq_type 
     LET g_apsrem.eq_name   = l_eci06
     LET g_apsrem.eq_des    = l_eci06 

     PUT p100_c_ins_apsrem  FROM g_apsrem.*
     IF STATUS THEN
        LET g_msg='Key:',g_apsrem.eq_id 
        CALL err('apsrem',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsrem:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsrgm()      #設備群組
DEFINE l_sql            STRING
DEFINE l_aps_saa   	RECORD LIKE aps_saa.*

  IF tm.apsrgm   = 'N' THEN RETURN END IF

  DECLARE p100_apsrgm_c CURSOR FOR
     SELECT aps_saa.*  FROM aps_saa  WHERE 1=1

  FOREACH p100_apsrgm_c INTO l_aps_saa.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsrgm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsrgm.* TO NULL
     LET g_apsrgm.eqg_id = l_aps_saa.eqg_id
     LET g_apsrgm.eq_id  = l_aps_saa.eq_id

     PUT p100_c_ins_apsrgm  FROM g_apsrgm.*
     IF STATUS THEN
        LET g_msg='Key:',g_apsrgm.eqg_id CLIPPED,'+',g_apsrgm.eq_id CLIPPED
        CALL err('apsrgm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsrgm_c:',STATUS,1) RETURN END IF
END FUNCTION

 
FUNCTION p100_apsimm()      #料件主檔
DEFINE l_sql            STRING
DEFINE l_aps_ima   	RECORD LIKE aps_ima.*
DEFINE l_ima   	        RECORD LIKE ima_file.*
DEFINE l_pmc03          LIKE pmc_file.pmc03
DEFINE l_pmh04          LIKE pmh_file.pmh04
DEFINE l_pmh07          LIKE pmh_file.pmh07
DEFINE l_pmh_rowid      LIKE type_file.chr18   # saki 20070821 rowid chr18 -> num10 
DEFINE l_azf06          LIKE azf_file.azf06     #FUN-740216  

  IF tm.apsimm   = 'N' THEN RETURN END IF

  DECLARE p100_apsimm_c CURSOR FOR
   SELECT ima_file.*,aps_ima.*
     FROM ima_file,OUTER aps_ima 
     WHERE ima01 = aps_ima.pid
       AND imaacti = 'Y'
  FOREACH p100_apsimm_c INTO l_ima.*,l_aps_ima.*   
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsimm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsimm.* TO NULL
     LET g_apsimm.pid        = l_ima.ima01
     LET g_apsimm.ss_qty     = l_ima.ima27
     IF NOT cl_null(l_aps_ima.lot_rule) THEN
        LET g_apsimm.lot_rule   = l_aps_ima.lot_rule
     ELSE
        LET g_apsimm.lot_rule   = 0
     END IF
     IF NOT cl_null(l_aps_ima.is_used) THEN
        LET g_apsimm.is_used    = l_aps_ima.is_used
     ELSE
        LET g_apsimm.is_used    = 0
     END IF
     IF NOT cl_null(l_aps_ima.is_int) THEN
        LET g_apsimm.is_int     = l_aps_ima.is_int
     ELSE
        LET g_apsimm.is_int     = 0
     END IF
     #FUN-740216-----------------------------------
     #IF l_ima.ima08 MATCHES '[PVZ]' THEN
     #    LET g_apsimm.p_type  = 2
     #ELSE 
     #    IF l_ima.ima16 = 0  THEN
     #        LET g_apsimm.p_type  = 0
     #    ELSE
     #        LET g_apsimm.p_type  = 1
     #    END IF
     #END IF
     SELECT azf06 INTO l_azf06 FROM azf_file WHERE l_ima.ima12 = azf01 AND azf02 = 'G'
     IF l_azf06 MATCHES '[01]' THEN 
        LET g_apsimm.p_type = 0
     END IF
     IF l_azf06 = 2 THEN 
        LET g_apsimm.p_type = 1
     END IF
     IF l_azf06 = 3 THEN 
        LET g_apsimm.p_type = 2
     END IF
     #FUN-740216-----------------------------------
     LET g_apsimm.unit_id    = l_ima.ima25
     IF NOT cl_null(l_aps_ima.max_lot) THEN
        LET g_apsimm.max_lot    = l_aps_ima.max_lot
     ELSE
        LET g_apsimm.max_lot    = 999999
     END IF
     IF l_ima.ima08 MATCHES '[PVZ]' THEN
          LET g_apsimm.min_lot  = l_ima.ima46
          LET g_apsimm.inc_lot  = l_ima.ima45
          LET g_apsimm.fix_lt   = l_ima.ima48+l_ima.ima49+l_ima.ima491+l_ima.ima50  #(天)
     ELSE 
          LET g_apsimm.min_lot  = l_ima.ima561
          LET g_apsimm.inc_lot  = l_ima.ima56
         #LET g_apsimm.fix_lt   = (l_ima.ima59/l_ima.ima56)+(l_ima.ima61/l_ima.ima56)    #(天)  #CHI-810015 mark     #FUN-710073 mod
          LET g_apsimm.fix_lt   = l_ima.ima59 + l_ima.ima61    #(天)                            #CHI-810015 mark還原 #FUN-710073 mark 
     END IF
     IF NOT cl_null(l_aps_ima.is_ctl) THEN
        LET g_apsimm.is_ctl     = l_aps_ima.is_ctl
     ELSE
        LET g_apsimm.is_ctl     = 0
     END IF
     IF l_ima.ima08 = 'X' THEN
        LET g_apsimm.is_phan  = 1
     ELSE
        LET g_apsimm.is_phan  = 0
     END IF
     LET g_apsimm.p_des         = l_ima.ima021 CLIPPED
     LET g_apsimm.use_qty       = l_ima.ima64
     IF NOT cl_null(l_aps_ima.is_cons) THEN
        LET g_apsimm.is_cons       = l_aps_ima.is_cons
     ELSE
        LET g_apsimm.is_cons       = 0
     END IF
     IF NOT cl_null(l_aps_ima.mo_tol) THEN
        LET g_apsimm.mo_tol        = l_aps_ima.mo_tol
     ELSE
        LET g_apsimm.mo_tol        = 0
     END IF
     IF NOT cl_null(l_aps_ima.po_tol) THEN
        LET g_apsimm.po_tol        = l_aps_ima.po_tol
     ELSE
        LET g_apsimm.po_tol        = 0
     END IF

     IF NOT cl_null(l_aps_ima.is_feat) THEN
         LET g_apsimm.is_feat       = l_aps_ima.is_feat
     ELSE
         LET g_apsimm.is_feat       = 0
     END IF

     IF NOT cl_null(l_aps_ima.con_type) THEN
        LET g_apsimm.con_type      = l_aps_ima.con_type
     ELSE
        LET g_apsimm.con_type      = 0
     END IF
     IF NOT cl_null(l_aps_ima.rel_refo) THEN
        LET g_apsimm.rel_refo      = l_aps_ima.rel_refo
     ELSE
        LET g_apsimm.rel_refo      = 0
     END IF
     IF NOT cl_null(l_aps_ima.lst_cmb ) THEN
        LET g_apsimm.lst_cmb       = l_aps_ima.lst_cmb
     ELSE
        LET g_apsimm.lst_cmb       = 0
     END IF
     IF NOT cl_null(l_aps_ima.lst_cblm) THEN
        LET g_apsimm.lst_cblm      = l_aps_ima.lst_cblm
     ELSE
        LET g_apsimm.lst_cblm      = 1
     END IF
     IF NOT cl_null(l_aps_ima.is_cnsn ) THEN
        LET g_apsimm.is_cnsn       = l_aps_ima.is_cnsn
     ELSE
        LET g_apsimm.is_cnsn       = 0
     END IF
     LET g_apsimm.planner          = l_ima.ima67
     LET g_apsimm.buyer            = l_ima.ima43
     LET g_apsimm.pg_id            = NULL
     IF NOT cl_null(l_aps_ima.sfx_lt) THEN
         LET g_apsimm.sfx_lt = l_aps_ima.sfx_lt
     ELSE
         LET g_apsimm.sfx_lt = 0
     END IF
     LET g_apsimm.pur_unit = l_ima.ima44
     LET g_apsimm.pur_tsr  = l_ima.ima44_fac
     LET g_apsimm.mfg_unit = l_ima.ima55
     LET g_apsimm.mfg_tsr  = l_ima.ima55_fac
     LET g_apsimm.sal_unit = l_ima.ima31
     LET g_apsimm.sal_tsr  = l_ima.ima31_fac
     LET g_apsimm.sply_rid = l_aps_ima.sply_rid
     LET g_apsimm.al_ratio    = l_aps_ima.al_ratio
     LET g_apsimm.pmc_id      = l_ima.ima67                  
     LET g_apsimm.orip_id     = l_aps_ima.orip_id
     #只為了找到pmh_file相對應中的任何一筆就OK-------str--
     LET l_pmh04 = NULL
     LET l_pmh07 = NULL
     LET l_pmh_rowid = NULL
     SELECT MIN(ROWID) INTO l_pmh_rowid FROM pmh_file
      WHERE pmh01 = l_ima.ima01
        AND pmh02 = l_ima.ima54
        AND pmh21 = " "                                             #CHI-860042                                                     
        AND pmh22 = '1'                                             #CHI-860042
     SELECT pmh04,pmh07 INTO l_pmh04,l_pmh07
       FROM pmh_file
      WHERE ROWID = l_pmh_rowid
     #-----------------------------------------------end--
     LET g_apsimm.maker       = l_pmh07   
     LET g_apsimm.abc_id      = l_ima.ima07                       
     LET g_apsimm.mak_pid     = l_pmh04    
     LET g_apsimm.pro_line_id = l_aps_ima.pro_line_id
     LET g_apsimm.pro_line_nm = l_aps_ima.pro_line_nm
     LET l_pmc03 = NULL    #FUN-760041
     SELECT pmc03 INTO l_pmc03 
       FROM pmc_file
      WHERE pmc01 = l_ima.ima54
     LET g_apsimm.sup_name    = l_pmc03                        
     LET g_apsimm.is_b_point  = l_aps_ima.is_b_point
     LET g_apsimm.a_price     = l_ima.ima53
     LET g_apsimm.is_phan_del = l_aps_ima.is_phan_del
     LET g_apsimm.pro_des     = l_ima.ima02
     LET g_apsimm.p_class1_id = l_ima.ima06
     LET g_apsimm.cons_bs     = l_aps_ima.cons_bs  #FUN-760041

     PUT p100_c_ins_apsimm  FROM g_apsimm.*
     IF STATUS THEN
        LET g_msg='Key:',g_apsimm.pid
        CALL err('apsimm',g_msg,STATUS)
     END IF

     #-->產生虛設料件途程檔 & 途程檔
     IF aps_saz.saz02 = 'Y' THEN
         CALL p100_apsirm_sub(l_ima.ima01)
         CALL p100_apsrom_sub(l_ima.ima01)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsimm_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsbmm()      #BOM
DEFINE l_sql            STRING       
DEFINE l_ecb03          LIKE ecb_file.ecb03
DEFINE l_aps_bmb   	RECORD LIKE aps_bmb.*  
DEFINE l_bmb   	        RECORD LIKE bmb_file.*  

  IF tm.apsbmm  = 'N' THEN RETURN END IF

  DECLARE p100_apsbmm_c CURSOR FOR 
   SELECT bmb_file.*,aps_bmb.*
     FROM bmb_file,OUTER aps_bmb
    WHERE bmb01 = aps_bmb.out_pid 
      AND bmb03 = aps_bmb.in_pid 
      AND bmb02 = aps_bmb.seq_txt         
      AND (bmb04 <= g_today OR bmb04 IS NULL)
      AND (bmb05 >  g_today OR bmb05 IS NULL)

  FOREACH p100_apsbmm_c INTO l_bmb.*,l_aps_bmb.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsbmm_c:',STATUS,1) EXIT FOREACH
     END IF
     LET l_ecb03 = NULL           #FUN-760041
     SELECT ecb03 INTO l_ecb03 FROM ecb_file 
      WHERE ecb01 = l_bmb.bmb01 
        AND ecb09 = l_bmb.bmb06
      
     INITIALIZE g_apsbmm.* TO NULL
     LET g_apsbmm.out_pid  = l_bmb.bmb01
     LET g_apsbmm.in_pid   = l_bmb.bmb03
   ##LET g_apsbmm.seq_txt  = l_bmb.bmb02 USING '#####' #FUN-760041                             
     LET g_apsbmm.seq_txt  = l_bmb.bmb02               #FUN-760041                             
     LET g_apsbmm.out_pqty = l_bmb.bmb07
     LET g_apsbmm.in_pqty  = l_bmb.bmb06
     LET g_apsbmm.eff_st   = l_bmb.bmb04
     LET g_apsbmm.eff_et   = l_bmb.bmb05
     #FUN-740215--start 物料清單已不控管,由替代料檔控制
     ##LET g_apsbmm.p_acode  = l_bmb.bmb16 
     ##IF NOT cl_null(l_aps_bmb.p_aprio) THEN
     ##   LET g_apsbmm.p_aprio  = l_aps_bmb.p_aprio
     ##ELSE
     ##   LET g_apsbmm.p_aprio  = 0
     ##END IF
     #FUN-740215--end--------------------------------------- 
     IF NOT cl_null(l_aps_bmb.g_acode) THEN
        LET g_apsbmm.g_acode  = l_aps_bmb.g_acode
     ELSE
        LET g_apsbmm.g_acode  = 0
     END IF
     IF NOT cl_null(l_aps_bmb.is_used) THEN
        LET g_apsbmm.is_used  = l_aps_bmb.is_used
     ELSE
        LET g_apsbmm.is_used  = 0
     END IF
     LET g_apsbmm.shrink   = l_bmb.bmb08
     IF NOT cl_null(l_aps_bmb.is_sub_p) THEN
        LET g_apsbmm.is_sub_p = l_aps_bmb.is_sub_p
     ELSE
        LET g_apsbmm.is_sub_p = 0
     END IF
     IF NOT cl_null(l_aps_bmb.is_issue) THEN
        LET g_apsbmm.is_issue = l_aps_bmb.is_issue
     ELSE
        LET g_apsbmm.is_issue = 0
     END IF
     IF NOT cl_null(l_aps_bmb.is_cnsn) THEN
        LET g_apsbmm.is_cnsn  = l_aps_bmb.is_cnsn
     ELSE
        LET g_apsbmm.is_cnsn  = 0
     END IF
     IF NOT cl_null(l_aps_bmb.is_altod) THEN
        LET g_apsbmm.is_altod  = l_aps_bmb.is_altod
     ELSE
        LET g_apsbmm.is_altod = 0
     END IF
     IF NOT cl_null(l_aps_bmb.cret_typ) THEN
        LET g_apsbmm.cret_typ = l_aps_bmb.cret_typ
     ELSE
        LET g_apsbmm.cret_typ = 0
     END IF
     IF NOT cl_null(l_aps_bmb.al_ratio) THEN
        LET g_apsbmm.al_ratio = l_aps_bmb.al_ratio
     ELSE
        LET g_apsbmm.al_ratio = 0
     END IF
     LET g_apsbmm.sequ_num = l_ecb03
     LET g_apsbmm.op_id = l_bmb.bmb09
     PUT p100_c_ins_apsbmm  FROM g_apsbmm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsbmm.out_pid CLIPPED,'+',g_apsbmm.in_pid CLIPPED,'+',g_apsbmm.seq_txt CLIPPED
        CALL err('apsbmm',g_msg,STATUS)
     END IF
     IF tm.apsapm = 'Y' THEN
         CALL p100_apsapm(l_bmb.bmb01,l_bmb.bmb02,l_bmb.bmb03,l_bmb.bmb07,l_bmb.bmb08) #單品取替代料 #FUN-740215
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsbmm_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsapm(p_bmb01,p_bmb02,p_bmb03,p_bmb07,p_bmb08)  #單品取替代 #FUN-740215
DEFINE l_sql        STRING
DEFINE p_bmb01      LIKE bmb_file.bmb01,
       p_bmb02      LIKE bmb_file.bmb02, #FUN-740215
       p_bmb03      LIKE bmb_file.bmb03,
       p_bmb07      LIKE bmb_file.bmb07,
       p_bmb08      LIKE bmb_file.bmb08,   
       l_bmd        RECORD LIKE bmd_file.*

  IF tm.apsapm  = 'N' THEN RETURN END IF

  DECLARE p100_apsapm CURSOR FOR
     SELECT bmd_file.*  FROM bmd_file
      WHERE bmd08 = p_bmb01 
        AND bmd01 = p_bmb03
      ORDER BY bmd08,bmd01

  FOREACH p100_apsapm INTO l_bmd.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsapm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsapm.* TO NULL
     LET g_apsapm.out_pid    = l_bmd.bmd08
     LET g_apsapm.in_pid     = l_bmd.bmd01
     LET g_apsapm.sub_pid    = l_bmd.bmd04
   ##LET g_apsapm.sb_aprio   = l_bmd.bmd03               #FUN-740215
     LET g_apsapm.sb_aprio   = (p_bmb02*10)+l_bmd.bmd03
     LET g_apsapm.in_qty     = l_bmd.bmd07
     LET g_apsapm.eff_st     = l_bmd.bmd05
     LET g_apsapm.eff_et     = l_bmd.bmd06
     LET g_apsapm.out_qty    = p_bmb07
     LET g_apsapm.shirnk     = p_bmb08
     LET g_apsapm.sub_type   = l_bmd.bmd02
     LET g_apsapm.al_ratio   = l_bmd.bmd07

     PUT p100_c_ins_apsapm  FROM g_apsapm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsapm.out_pid CLIPPED,'+',
                           g_apsapm.in_pid  CLIPPED,'+',
                           g_apsapm.sub_pid CLIPPED
        CALL err('apsapm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsapm_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsirm()           #料件途程
#FUN-740216--------------------------------------------------
#DEFINE l_cnt        LIKE type_file.num10   
#DEFINE l_aps_ecu    RECORD LIKE aps_ecu.*
DEFINE l_ima94      LIKE ima_file.ima94                  
DEFINE l_ecu01      LIKE ecu_file.ecu01                  
DEFINE l_ecu02      LIKE ecu_file.ecu02                  
DEFINE l_ict        LIKE aps_ecu.ict                     
DEFINE l_is_alt     LIKE aps_ecu.is_alt                  
#FUN-740216--------------------------------------------------
 
  IF tm.apsirm = 'N' THEN RETURN END IF
  #若系統不走製程
  IF aps_saz.saz02 = 'Y' THEN RETURN END IF

  DECLARE p100_apsirm_c CURSOR FOR
   #SELECT aps_ecu.*                #FUN-740216
    SELECT ecu01,ecu02,aps_ecu.ict,aps_ecu.is_alt
      FROM ecu_file,OUTER aps_ecu
     WHERE ecu01 = aps_ecu.pid
       AND ecu02 = aps_ecu.route_id

  FOREACH p100_apsirm_c INTO l_ecu01,l_ecu02,l_ict,l_is_alt
     IF SQLCA.sqlcode THEN
        CALL cl_err('p100_apsirm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsirm.* TO NULL
     LET g_apsirm.pid       = l_ecu01
     LET g_apsirm.route_id  = l_ecu02
    #FUN-740216-----------------------------------------------------
    #判斷料建製程是否為料件基本資料中(ima94)預設製程編號,若是途程序號給0,否則給1
    #FUN-740216-----------------------------------------------------
     SELECT ima94 INTO l_ima94 FROM ima_file WHERE ima01 = l_ecu01 
     IF l_ima94 = l_ecu02 THEN 
        LET g_apsirm.sequ_num  = 0
     ELSE
        LET g_apsirm.sequ_num  = 1
     END IF
     LET g_apsirm.ict       = 1
     IF NOT cl_null(l_ict ) THEN
        LET g_apsirm.ict = l_ict
     ELSE
        LET g_apsirm.ict = 1
     END IF
     LET g_apsirm.eff_st    = NULL
     LET g_apsirm.eff_et    = NULL
     IF NOT cl_null(l_is_alt ) THEN
        LET g_apsirm.is_alt = l_is_alt
     ELSE
        LET g_apsirm.is_alt = 1
     END IF

     PUT p100_c_ins_apsirm FROM g_apsirm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsirm.pid CLIPPED,'+',g_apsirm.route_id CLIPPED
        CALL err('apsirm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsirm_c:',STATUS,1) RETURN END IF

  #FUN-740216----取消附屬關係做法-------------
  #IF tm.apsrom = 'Y' THEN  #途程檔
  #    CALL p100_apsrom()
  #END IF
  #FUN-740216---------------------------------
END FUNCTION

FUNCTION p100_apsdom_1()      #訂單需求
DEFINE l_sql        STRING
DEFINE l_oeb        RECORD LIKE oeb_file.*
DEFINE l_oea        RECORD LIKE oea_file.*
DEFINE l_aps_dom    RECORD LIKE aps_dom.*
DEFINE l_do_id      LIKE aps_dom.do_id
DEFINE l_chr4       LIKE type_file.chr4
DEFINE l_occ34      LIKE occ_file.occ34

  IF tm.apsdom1   = 'N' THEN RETURN END IF

  DECLARE p100_apsdom1_c CURSOR FOR
     SELECT oea_file.*,oeb_file.*
       FROM oea_file,oeb_file
      WHERE oea01 = oeb01 
        AND oeb12>oeb24 
        AND oeb70='N'
        AND oeb15 <= tm.dt_edate
        AND oeaconf = 'Y'
 
  FOREACH p100_apsdom1_c INTO l_oea.*,l_oeb.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('p100_apsdom1_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsdom1.* TO NULL

     LET l_chr4  = l_oeb.oeb03 USING '&&&&'
     LET l_do_id = l_oea.oea01 CLIPPED,'-',l_chr4
     LET g_apsdom1.do_id    =  l_do_id
     LET g_apsdom1.pid      =  l_oeb.oeb04              #訂購品項之品號
     LET g_apsdom1.o_qty    =  l_oeb.oeb12              #訂購數量
     IF NOT cl_null(l_oeb.oeb15) THEN #交期
        LET g_apsdom1.due_date =  l_oeb.oeb15
     ELSE
        LET g_apsdom1.due_date =  NULL
     END IF
     SELECT * INTO l_aps_dom.*
       FROM aps_dom
      WHERE do_id = l_do_id
     LET g_apsdom1.can_csum =  0
     LET g_apsdom1.cus_id   =  l_oea.oea03 CLIPPED
     LET g_apsdom1.is_skl   =  1
     LET g_apsdom1.o_type   =  'R'                      #訂單型式
     LET g_apsdom1.p_fm_id  =  NULL                     #產品族編號
     LET g_apsdom1.priority =  0
     LET g_apsdom1.s_oid    =  l_oeb.oeb01              #顧客或銷售訂單之編號
     LET g_apsdom1.cus_oid  =  l_oea.oea10              #客戶單號
     LET g_apsdom1.ship_qty =  l_oeb.oeb24              #已出貨量
     LET g_apsdom1.unit_id  =  l_oeb.oeb05    
        SELECT occ34 INTO l_occ34
          FROM occ_file
         WHERE occ01 = l_oea.oea03
     LET g_apsdom1.cmg_id   =  l_occ34         
     LET g_apsdom1.owner    =  l_oea.oea14     
     LET g_apsdom1.ts_rate  =  l_oeb.oeb05_fac          #轉換率       
     LET g_apsdom1.o_date   =  l_oea.oea02              #訂單開立日期 
     LET g_apsdom1.allo_rid =  l_aps_dom.allo_rid
     LET g_apsdom1.ship_day =  l_aps_dom.ship_day
     LET g_apsdom1.c_pid    =  l_oeb.oeb11
   
     PUT p100_c_ins_apsdom FROM g_apsdom1.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsdom1.do_id CLIPPED
        CALL err('apsdom11',g_msg,STATUS)
     END IF
     IF tm.apsocm = 'Y' THEN 
         CALL p100_apsocm(l_oeb.oeb01,l_oeb.oeb03)
     END IF

  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsdom1_c:',STATUS,1) RETURN END IF
END FUNCTION


FUNCTION p100_apsdom_2()      #預測訂單需求
DEFINE l_sql         STRING
DEFINE l_opc         RECORD
                     opc01  LIKE opc_file.opc01,
                     opc02  LIKE opc_file.opc02,
                     opc03  LIKE opc_file.opc03,
                     opc04  LIKE opc_file.opc04
                     END RECORD
DEFINE l_opc01       LIKE opc_file.opc01
DEFINE l_opc02       LIKE opc_file.opc02
DEFINE l_opc03       LIKE opc_file.opc03
DEFINE l_opc04       LIKE opc_file.opc04
DEFINE l_opd05       LIKE opd_file.opd05
DEFINE l_opd06       LIKE opd_file.opd06
DEFINE l_opd07       LIKE opd_file.opd07
DEFINE l_opd08       LIKE opd_file.opd08
DEFINE l_opd09       LIKE opd_file.opd09
DEFINE l_occ34       LIKE occ_file.occ34
DEFINE l_ima25       LIKE ima_file.ima25
DEFINE l_obk03       LIKE obk_file.obk03
DEFINE l_seq         LIKE type_file.num10 
DEFINE l_aps_dom     RECORD LIKE aps_dom.*

  IF tm.apsdom2  = 'N' THEN RETURN END IF

  LET l_sql = " SELECT opc01,opc02,opc03,opc04,opd05,opd06,opd07,opd08,opd09",
              "   FROM opc_file,opd_file ",
              "  WHERE opc01=? AND opc02=? AND opc03=? AND opc04=? ",
              "    AND opc01=opd01 AND opc02 = opd02  ",
              "    AND opc03=opd03 AND opc04 = opd04  ",
              "    ORDER BY opd06 DESC "

   PREPARE p100_p_opc FROM l_sql
   IF STATUS THEN CALL cl_err('pre p_opc ',STATUS,1) END IF
   DECLARE p100_opc_c CURSOR  FOR p100_p_opc
   IF STATUS THEN CALL cl_err('dec ins_opc_c',STATUS,1) END IF

   #-->只抓日期小於計劃基準日且最靠近者
   DECLARE p100_opc_c1 CURSOR FOR
       SELECT opc01,opc02,MAX(opc03),opc04
         FROM opc_file
        WHERE opc03<= tm.say02      #計劃日期<=基準日期
        GROUP BY opc01,opc02,opc04

   LET l_seq  = 0
   FOREACH p100_opc_c1 INTO l_opc.opc01,l_opc.opc02,l_opc.opc03,l_opc.opc04
      IF SQLCA.sqlcode THEN CALL cl_err('p100_opc_c1',STATUS,1) RETURN END IF
     #FUN-740216------------------------------------------------------------
     #OPEN p100_opc_c USING l_opc.opc01,l_opc.opc02,l_opc.opc03,l_opc.opc04
     #FOREACH p100_opc_c INTO l_opc01,l_opc02,l_opc03,l_opc04,
     #                         l_opd05,l_opd06,l_opd07,l_opd08,l_opd09
      FOREACH p100_opc_c USING l_opc.opc01,l_opc.opc02,l_opc.opc03,l_opc.opc04
         INTO l_opc01,l_opc02,l_opc03,l_opc04,l_opd05,l_opd06,l_opd07,l_opd08,l_opd09
     #FUN-740216------------------------------------------------------------
        IF STATUS THEN CALL cl_err('p100_opc_c',STATUS,1) RETURN END IF
        INITIALIZE g_apsdom2.* TO NULL
        LET l_seq = l_seq + 1
        LET g_apsdom2.do_id    = 'FORCAST',l_seq USING '&&&&'    #訂單編號 
        LET g_apsdom2.pid      =  l_opc01                #訂購品項之品號
        IF aps_saz.saz03 = '1' THEN
           LET g_apsdom2.o_qty =  l_opd08                #計劃數量
        ELSE
           #FUN-740216--------------------------------------------------
           #若在預測訂單中確認數量為空值時,須宣告為0
           IF l_opd09 IS NULL THEN
              LET g_apsdom2.o_qty =  0                      #確認數量
           ELSE 
           #FUN-740216--------------------------------------------------
              LET g_apsdom2.o_qty =  l_opd09                #確認數量
           END IF
        END IF
        LET g_apsdom2.due_date =  l_opd06
        LET g_apsdom2.can_csum =  1                      #是否能被消耗
        LET g_apsdom2.cus_id   =  l_opc02                #客戶代號
        LET g_apsdom2.is_skl   =  1                      #是否納入排程 
        LET g_apsdom2.o_type   =  'F'                    #訂單型式
        LET g_apsdom2.p_fm_id  =  NULL                   #產品族編號
        LET g_apsdom2.priority =  0                      #訂單之優先順序 
        LET g_apsdom2.s_oid    =  l_opd05                #顧客或銷售訂單之編號
        LET g_apsdom2.cus_oid  =  NULL                   #客戶單號
        LET g_apsdom2.ship_qty =  0                      #已出貨量
        SELECT ima25 INTO l_ima25
          FROM ima_file
         WHERE ima01 = l_opc01
        LET g_apsdom2.unit_id  =  l_ima25                
        SELECT occ34 INTO l_occ34
          FROM occ_file
         WHERE occ01 = l_opc02
        LET g_apsdom2.cmg_id   =  l_occ34                
        LET g_apsdom2.owner    =  l_opc04                #業務員       
        LET g_apsdom2.ts_rate  =  1                      #轉換率       
        LET g_apsdom2.o_date   =  l_opc03                #訂單計劃日期 
        SELECT * INTO l_aps_dom.*
          FROM aps_dom
         WHERE do_id = g_apsdom2.do_id
        LET g_apsdom2.allo_rid =  l_aps_dom.allo_rid
        LET g_apsdom2.ship_day =  l_aps_dom.ship_day
        SELECT MAX(obk03) INTO l_obk03
          FROM obk_file
         WHERE obk01 = l_opc01
           AND obk02 = l_opc02
        LET g_apsdom2.c_pid    =  l_obk03

        PUT p100_c_ins_apsdom FROM g_apsdom2.*
        IF STATUS THEN
           LET g_msg = 'Key:',g_apsdom2.do_id CLIPPED
           CALL err('apsdom2',g_msg,STATUS)
        END IF
      END FOREACH
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_opc_c1',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsmrm()      #工單備料
DEFINE l_sql       STRING
DEFINE l_seq       LIKE type_file.num10 
DEFINE l_sfa01     LIKE sfa_file.sfa01,
       l_sfa06     LIKE sfa_file.sfa06,
       l_sfa03     LIKE sfa_file.sfa03,
       l_sfa30     LIKE sfa_file.sfa30,
       l_sfa31     LIKE sfa_file.sfa31,
       l_sfa05     LIKE sfa_file.sfa05,
       l_sfa065    LIKE sfa_file.sfa065,
       l_sfa28     LIKE sfa_file.sfa28,
       l_sfa13     LIKE sfa_file.sfa13,
       l_sfa08     LIKE sfa_file.sfa08,  
       l_sfa12     LIKE sfa_file.sfa12,  
       l_ecm03     LIKE ecm_file.ecm03,  
       l_str       LIKE type_file.chr20 
DEFINE l_old_sfa01 LIKE sfa_file.sfa01    #FUN-740216

  IF tm.apsmrm   = 'N' THEN RETURN END IF

  DECLARE p100_apsmrm_c CURSOR FOR
      SELECT sfa01,sfa06,sfa03,sfa30,sfa31,
             sfa05,sfa065,sfa28,sfa13,sfa08,sfa12
          FROM sfa_file,sfb_file
         WHERE sfb01=sfa01
           AND sfb04!='8' 
           AND sfb13<=tm.dt_edate
           AND (sfa05>sfa06+sfa065)
           AND sfb23='Y' 
           AND sfb87!='X'

  #LET l_seq  = 0   #FUN-740216
  FOREACH p100_apsmrm_c INTO l_sfa01,l_sfa06,l_sfa03,l_sfa30,l_sfa31,
                             l_sfa05,l_sfa065,l_sfa28,l_sfa13,l_sfa08,l_sfa12
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsmrm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsmrm.* TO NULL
     #-->替代率不正確
     IF cl_null(l_sfa28) OR l_sfa28 = 0 THEN
        LET l_str = l_sfa01 ,'-',l_sfa03
        CALL cl_getmsg('aps-100',g_lang) RETURNING g_msg
        CALL err(l_str,g_msg,'aps-100')
     END IF
     
     #FUN-740216-------------------------------------------------
     IF l_old_sfa01 = l_sfa01 THEN
        LET l_seq = l_seq + 1
     ELSE
        LET l_seq = 1
        LET l_old_sfa01 = l_sfa01
     END IF
     LET l_ecm03 = NULL
     #FUN-740216-------------------------------------------------

     SELECT ecm03 INTO l_ecm03 
       FROM ecm_file 
      WHERE ecm01=l_sfa01
        AND ecm04=l_sfa08
     LET g_apsmrm.mo_id    = l_sfa01                              #製令編號
     LET g_apsmrm.in_pid   = l_sfa03                              #元件編號
     #LET l_seq = l_seq + 1                       #FUN-740216
     LET g_apsmrm.seq_txt  = l_seq USING '&&&&'                   
     LET g_apsmrm.sequ_num = l_ecm03                              #加工序號  
     LET g_apsmrm.in_pqty  = (l_sfa06 + l_sfa065)/l_sfa28*l_sfa13 #元件已領用量
     LET g_apsmrm.wh_id    = l_sfa30
     LET g_apsmrm.in_dmqty = (l_sfa05/l_sfa28)*l_sfa13            #元件需求量
     #LET g_apsmrm.seq_txt  = NULL                #FUN-740216                      
     LET g_apsmrm.stk_loc  = l_sfa31                      
     LET g_apsmrm.is_cnsn  = 0
     LET g_apsmrm.rm1      = NULL

     PUT p100_c_ins_apsmrm FROM g_apsmrm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsmrm.in_pid CLIPPED,'+',
                           g_apsmrm.mo_id  CLIPPED,'+',
                           g_apsmrm.seq_txt
        CALL err('apsmrm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsmrm_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsuim()      #庫存數量
DEFINE l_sql       LIKE type_file.chr1000
DEFINE l_img01     LIKE img_file.img01,
       l_img02     LIKE img_file.img02,
       l_img03     LIKE img_file.img03,
       l_img04     LIKE img_file.img04,
       l_img10     LIKE img_file.img10,
       l_name      LIKE type_file.chr1000 

  IF tm.apsuim  = 'N' THEN RETURN END IF

  DECLARE p100_apsuim_c CURSOR FOR
      SELECT img01, img02, img03, img04,SUM(img10*img21)
        FROM img_file
       WHERE img24='Y'
      GROUP BY  img01,img02,img03,img04

  FOREACH p100_apsuim_c INTO l_img01,l_img02,l_img03,l_img04,l_img10
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsuim_c:',STATUS,1) EXIT FOREACH
     END IF
     IF l_img10 <=0 THEN CONTINUE FOREACH END IF
     LET g_apsuim.pid      = l_img01          #料件編號
     LET g_apsuim.wh_id    = l_img02          #倉庫編號
     LET g_apsuim.stk_loc  = l_img03          #庫房儲位
     LET g_apsuim.unalcqty = l_img10          #可用量
     LET g_apsuim.location = NULL             #庫房位置 

     PUT p100_c_ins_apsuim FROM g_apsuim.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsuim.pid CLIPPED,g_apsuim.wh_id CLIPPED
        CALL err('apsuim',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsuim_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apssmm()      #工單資料
DEFINE l_sql        STRING
DEFINE l_aps_smm    RECORD LIKE aps_smm.*
DEFINE l_sfb01      LIKE sfb_file.sfb01,
       l_sfb08      LIKE sfb_file.sfb08,
       l_sfb15      LIKE sfb_file.sfb15,
       l_sfb13      LIKE sfb_file.sfb13,
       l_sfb05      LIKE sfb_file.sfb05,
       l_sfb40      LIKE sfb_file.sfb40,
       l_sfb09      LIKE sfb_file.sfb09,
       l_sfb06      LIKE sfb_file.sfb06,
       l_sfb04      LIKE sfb_file.sfb04,
       l_sfb22      LIKE sfb_file.sfb22,
       l_sfb221     LIKE sfb_file.sfb221,
       l_sfb12      LIKE sfb_file.sfb12 ,  
       l_sfbuser    LIKE sfb_file.sfbuser,
       l_ima08      LIKE ima_file.ima08,
       l_ima55      LIKE ima_file.ima55, 
       l_ima16      LIKE ima_file.ima16,
       l_ima55_fac  LIKE ima_file.ima55_fac, 
       l_sfb41      LIKE sfb_file.sfb41    
DEFINE l_azf06      LIKE azf_file.azf06     #FUN-740216  
DEFINE l_ima12      LIKE ima_file.ima12     #FUN-740216  

  IF tm.apssmm   = 'N' THEN RETURN END IF

  DECLARE p100_apssmm_c CURSOR FOR
      SELECT sfb01,sfb08,sfb15,sfb13,sfb05,sfb40,sfb08,sfb09,sfb06,sfb04,
             sfb22,sfb221,sfb12,sfbuser,ima08,ima55,ima16,ima55_fac,sfb41,ima12  #FUN-740216 add ima12 
        FROM sfb_file,ima_file
       WHERE sfb08>sfb09 
         AND sfb04<'8' 
         AND sfb15<=tm.dt_edate
         AND ima01=sfb05
         AND sfb87!='X'
         AND sfb01 IS NOT NULL 
         AND sfb01 != ' '

  FOREACH p100_apssmm_c INTO l_sfb01, l_sfb08,l_sfb15,l_sfb13,l_sfb05,
                             l_sfb40, l_sfb08,l_sfb09,l_sfb06,l_sfb04,
                             l_sfb22, l_sfb221,l_sfb12, l_sfbuser,
                             l_ima08,l_ima55,l_ima16,l_ima55_fac,l_sfb41,l_ima12  #FUN-740216 add ima12 
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apssmm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apssmm.* TO NULL
     LET g_apssmm.mo_id    = l_sfb01          #製令編號
     LET g_apssmm.dm_qty   = l_sfb08          #需求數量
     LET g_apssmm.erp_oid  = l_sfb01          #EPR中對應的製令單號
     IF NOT cl_null(l_sfb15) THEN
        #ERP預計完工日期
        LET g_apssmm.fmcmp_t  = l_sfb15                               
     END IF
     IF NOT cl_null(l_sfb13) THEN
        #ERP預計開立日期
        LET g_apssmm.fmrel_t  = l_sfb13 
     END IF
     LET g_apssmm.pid      = l_sfb05            #製令品號
     LET g_apssmm.priority = l_sfb40            #優先順序
     LET g_apssmm.route_id = l_sfb06            #途程編號  
     #FUN-740216-----------------------------------
     #IF l_ima.ima08 MATCHES '[PVZ]' THEN
     #    LET g_apsimm.p_type  = 2
     #ELSE 
     #    IF l_ima.ima16 = 0  THEN
     #        LET g_apsimm.p_type  = 0
     #    ELSE
     #        LET g_apsimm.p_type  = 1
     #    END IF
     #END IF
     SELECT azf06 INTO l_azf06 FROM azf_file WHERE l_ima12 = azf01 AND azf02 = 'G'
     IF l_azf06 MATCHES '[01]' THEN 
        LET g_apssmm.p_type = 0
     END IF
     IF l_azf06 = 2 THEN 
        LET g_apssmm.p_type = 1
     END IF
     IF l_azf06 = 3 THEN 
        LET g_apssmm.p_type = 2
     END IF
     #FUN-740216-----------------------------------
     LET g_apssmm.unit_id  = l_ima55            #生產單位      
     LET g_apssmm.is_rel   = 0                  #製令是否已發料
     LET g_apssmm.prj_id   = null               #計畫批號
     LET g_apssmm.pdu_qty  = l_sfb09            #已生產量
     LET g_apssmm.scrp_qty = l_sfb12            
     LET g_apssmm.owner    = l_sfbuser          
     LET g_apssmm.state    = l_sfb04            
     LET g_apssmm.ts_rate  = l_ima55_fac        
     SELECT * INTO l_aps_smm.*
       FROM aps_smm
      WHERE mo_id = g_apssmm.mo_id
     LET g_apssmm.sply_rid = l_aps_smm.sply_rid
     LET g_apssmm.is_firm  = l_sfb41            
     LET g_apssmm.creator  = l_sfbuser
     LET g_apssmm.rm1      = NULL
     LET g_apssmm.rm2      = NULL

     PUT p100_c_ins_apssmm FROM g_apssmm.*
     IF STATUS THEN
       #CALL cl_err('ins apssmm',STATUS,1) EXIT PROGRAM
        LET g_msg = 'Key:',g_apssmm.mo_id CLIPPED
        CALL err('apssmm',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apssmm_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsspm_1()      #請購單
DEFINE l_sql       STRING
DEFINE l_aps_spm   RECORD LIKE aps_spm.*
DEFINE l_pmk04     LIKE pmk_file.pmk04,
       l_pmk09     LIKE pmk_file.pmk09,
       l_pmkuser   LIKE pmk_file.pmkuser,
       l_pml34     LIKE pml_file.pml34,  
       l_pml04     LIKE pml_file.pml04,
       l_pml01     LIKE pml_file.pml01,
       l_pml02     LIKE pml_file.pml02,
       l_pml20     LIKE pml_file.pml20,
       l_pml21     LIKE pml_file.pml21,
       l_pml07     LIKE pml_file.pml07,
       l_pml16     LIKE pml_file.pml16,
       l_pml09     LIKE pml_file.pml09,
       l_pml11     LIKE pml_file.pml11

  IF tm.apsspm1  = 'N' THEN RETURN END IF

  DECLARE p100_apsspm1_c CURSOR FOR
      SELECT pmk04,pmk09,pmkuser,
             pml34,pml04,pml01,pml02,pml20,pml21,pml07,pml16,pml09,pml11 
        FROM pmk_file,pml_file
       WHERE  pml20>pml21 
         AND pml16<='2'
         AND pml33<=tm.dt_edate
         AND pml01=pmk01 
         AND pmk02<>'SUB' 
         AND pmk18 != 'X'
         AND pml38='Y' 

  FOREACH p100_apsspm1_c INTO l_pmk04,l_pmk09,l_pmkuser,
              l_pml34,l_pml04,l_pml01,l_pml02,l_pml20,l_pml21,l_pml07, 
              l_pml16,l_pml09,l_pml11                                 
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsspm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsspm1.* TO NULL
     LET g_apsspm1.po_id     = l_pml01,'-',l_pml02 using '&&&&' #採購單編號
     IF NOT cl_null(l_pml34) THEN
        #ERP預計抵達日期
        LET g_apsspm1.fmava_t   = l_pml34   
     END IF
     LET g_apsspm1.location  = NULL             #供應商位置
     LET g_apsspm1.pid       = l_pml04          #訂購品項之品號
     LET g_apsspm1.pur_qty   = l_pml20          #預計請購數量  
     IF NOT cl_null(l_pmk04) THEN
        #ERP預計開立日期
        LET g_apsspm1.fmrel_t   = l_pmk04       
     END IF
     LET g_apsspm1.sup_id    = l_pmk09          #供應商編號
     LET g_apsspm1.unit_id   = l_pml07          #採購單位
     LET g_apsspm1.prj_id    = NULL             #計畫批號
     LET g_apsspm1.erp_oid   = l_pml01,'-',l_pml02 using '&&&&' #採購單編號 
     LET g_apsspm1.stk_qty   = l_pml21      #已轉採購單  
     SELECT * INTO l_aps_spm.*
       FROM aps_spm
      WHERE po_id = g_apsspm1.po_id
     LET g_apsspm1.is_hold   = l_aps_spm.is_hold
     LET g_apsspm1.owner     = l_pmkuser
     LET g_apsspm1.state     = l_pml16
     LET g_apsspm1.ts_rate   = l_pml09
     LET g_apsspm1.sply_rid  = l_aps_spm.sply_rid
     LET g_apsspm1.is_firm   = l_pml11
     LET g_apsspm1.unin_qty  = 0
     LET g_apsspm1.unst_qty  = 0
     LET g_apsspm1.retu_qty  = 0
     LET g_apsspm1.creator   = NULL
     LET g_apsspm1.rm1       = NULL
     LET g_apsspm1.rm2       = NULL

     PUT p100_c_ins_apsspm FROM g_apsspm1.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsspm1.po_id CLIPPED
        CALL err('apsspm1',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsspm1_c:',STATUS,1) RETURN END IF
END FUNCTION
 
FUNCTION p100_apsspm_2()      #採購單
DEFINE l_sql       STRING
DEFINE l_aps_spm   RECORD LIKE aps_spm.*
DEFINE l_pmm04     LIKE pmm_file.pmm04,
       l_pmm09     LIKE pmm_file.pmm09,
       l_pmm12     LIKE pmm_file.pmm12,
       l_pmmuser   LIKE pmm_file.pmmuser,
       l_pmn34     LIKE pmn_file.pmn34, 
       l_pmn04     LIKE pmn_file.pmn04,
       l_pmn01     LIKE pmn_file.pmn01,
       l_pmn02     LIKE pmn_file.pmn02,
       l_pmn20     LIKE pmn_file.pmn20,
       l_pmn51     LIKE pmn_file.pmn51,
       l_pmn55     LIKE pmn_file.pmn55,
       l_pmn07     LIKE pmn_file.pmn07,
       l_pmn16     LIKE pmn_file.pmn16,
       l_pmn09     LIKE pmn_file.pmn09,
       l_pmn11     LIKE pmn_file.pmn11,
       l_pmn53     LIKE pmn_file.pmn53 

  IF tm.apsspm2 = 'N' THEN RETURN END IF
  DECLARE p100_apsspm2_c CURSOR FOR
      SELECT pmm04,pmm09,pmm12,pmmuser,
             pmn34,pmn04,pmn01,pmn02,pmn20,pmn51,pmn55,pmn07,pmn16,pmn09,pmn11,pmn53  ##NO:TQC-670035
        FROM pmm_file,pmn_file
        WHERE pmn20>(pmn50-pmn55) 
          AND pmn16<='2' 
          AND pmn33<=tm.dt_edate
          AND pmn01=pmm01 
          AND pmm02<>'SUB' 
          AND pmm18 != 'X'
          AND pmn38='Y'   

  FOREACH p100_apsspm2_c INTO l_pmm04,l_pmm09,l_pmm12,l_pmmuser,
              l_pmn34,l_pmn04,l_pmn01,l_pmn02,l_pmn20,l_pmn51,l_pmn55,l_pmn07,
              l_pmn16,l_pmn09,l_pmn11,l_pmn53                                 
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsspm_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apsspm2.* TO NULL
     LET g_apsspm2.po_id     = l_pmn01,'-',l_pmn02 using '&&&&' #採購單編號
     IF NOT cl_null(l_pmn34) THEN
        #ERP預計抵達日期
        LET g_apsspm2.fmava_t   = l_pmn34  
     END IF
     LET g_apsspm2.location  = NULL         #供應商位置
     LET g_apsspm2.pid       = l_pmn04      #訂購品項之品號
     LET g_apsspm2.pur_qty   = l_pmn20      #預計採購數量  
     IF NOT cl_null(l_pmm04) THEN
        #ERP預計開立日期
        LET g_apsspm2.fmrel_t   = l_pmm04     
     END IF
     LET g_apsspm2.sup_id    = l_pmm09      #供應商編號
     LET g_apsspm2.unit_id   = l_pmn07      #採購單位
     LET g_apsspm2.prj_id    = NULL         #計畫批號
     LET g_apsspm2.erp_oid   = l_pmn01,'-',l_pmn02 using '&&&&' #EPR中對應的採購令單號
     LET g_apsspm2.stk_qty   = l_pmn53      #已入庫數量  
     SELECT * INTO l_aps_spm.*
       FROM aps_spm
      WHERE po_id = g_apsspm2.po_id
     LET g_apsspm2.is_hold   = l_aps_spm.is_hold
     LET g_apsspm2.owner     = l_pmmuser
     LET g_apsspm2.state     = l_pmn16
     LET g_apsspm2.ts_rate   = l_pmn09
     LET g_apsspm2.sply_rid  = l_aps_spm.sply_rid
     LET g_apsspm2.is_firm   = l_pmn11
     LET g_apsspm2.unin_qty  = l_pmn51
     LET g_apsspm2.unst_qty  = 0 
     LET g_apsspm2.retu_qty  = l_pmn55
     LET g_apsspm2.creator   = l_pmm12
     LET g_apsspm2.rm1       = NULL
     LET g_apsspm2.rm2       = NULL

     PUT p100_c_ins_apsspm FROM g_apsspm2.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsspm2.po_id
        CALL err('apsspm2',g_msg,STATUS)
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsspm2_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apswhm() 
DEFINE l_sql         STRING
DEFINE l_aps_imd     RECORD LIKE aps_imd.*
DEFINE l_imd01       LIKE imd_file.imd01
DEFINE l_imd02       LIKE imd_file.imd02
DEFINE l_imd14       LIKE imd_file.imd14     
DEFINE l_name        LIKE type_file.chr1000 
DEFINE l_seq         LIKE type_file.num10  

  IF tm.apswhm  = 'N' THEN RETURN END IF

  LET l_sql = " SELECT imd01,imd02,imd14,aps_imd.*", 
              "   FROM imd_file,OUTER aps_imd ",
              "  WHERE imd01=aps_imd.wh_id ",
              "  ORDER BY imd01 "

   PREPARE p100_p_imd FROM l_sql
   IF STATUS THEN CALL cl_err('pre p_imd ',STATUS,1) END IF
   DECLARE p100_imd_c CURSOR  FOR p100_p_imd
   IF STATUS THEN CALL cl_err('dec ins_imd_c',STATUS,1) END IF

   OPEN p100_imd_c
   FOREACH  p100_imd_c INTO l_imd01,l_imd02,l_imd14,l_aps_imd.*  
     IF STATUS THEN CALL cl_err('p100_imd_c',STATUS,1) RETURN END IF
     INITIALIZE g_apswhm.* TO NULL
     LET g_apswhm.wh_id    = l_imd01
     LET g_apswhm.wh_name  = l_imd02
     LET g_apswhm.priority = l_imd14  
     IF NOT cl_null(l_aps_imd.immove ) THEN
        LET g_apswhm.immove     = l_aps_imd.immove
     ELSE
        LET g_apswhm.immove     = 0
     END IF
     IF NOT cl_null(l_aps_imd.is_main) THEN
        LET g_apswhm.is_main    = l_aps_imd.is_main
     ELSE
        LET g_apswhm.is_main    = 0
     END IF

     PUT p100_c_ins_apswhm  FROM g_apswhm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apswhm.wh_id CLIPPED
        CALL err('apswhm',g_msg,STATUS)
     END IF
   END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apswhm_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apsslm()
DEFINE l_sql         STRING
DEFINE l_aps_ime     RECORD LIKE aps_ime.*
DEFINE l_ime01       LIKE ime_file.ime01
DEFINE l_ime02       LIKE ime_file.ime02
DEFINE l_ime03       LIKE ime_file.ime03
DEFINE l_ime10       LIKE ime_file.ime10    
DEFINE l_name        LIKE type_file.chr1000 
DEFINE l_seq         LIKE type_file.num10   

  IF tm.apsslm  = 'N' THEN RETURN END IF

  LET l_sql = " SELECT ime01,ime02,ime03,ime10,aps_ime.*",  
              "   FROM ime_file,OUTER aps_ime ",
              "  WHERE ime01=aps_ime.wh_id ",
              "    AND ime02=aps_ime.stk_loc ",
              "  ORDER BY ime01,ime02 "

   PREPARE p100_p_ime FROM l_sql
   IF STATUS THEN CALL cl_err('pre p_ime ',STATUS,1) END IF
   DECLARE p100_ime_c CURSOR  FOR p100_p_ime
   IF STATUS THEN CALL cl_err('dec ins_ime_c',STATUS,1) END IF

   OPEN p100_ime_c
   FOREACH  p100_ime_c INTO l_ime01,l_ime02,l_ime03,l_ime10,l_aps_ime.*  ##No:TQC-670035
     IF STATUS THEN CALL cl_err('p100_ime_c',STATUS,1) RETURN END IF
     INITIALIZE g_apsslm.* TO NULL
     LET g_apsslm.wh_id    = l_ime01
     LET g_apsslm.stk_loc  = l_ime02
     LET g_apsslm.stk_name = l_ime03
     LET g_apsslm.priority = l_ime10  
     IF NOT cl_null(l_aps_ime.is_cnsn) THEN
        LET g_apsslm.is_cnsn    = l_aps_ime.is_cnsn
     ELSE
        LET g_apsslm.is_cnsn    = 0
     END IF
     PUT p100_c_ins_apsslm  FROM g_apsslm.*
     IF STATUS THEN
        LET g_msg = 'Key:',g_apsslm.wh_id CLIPPED
        CALL err('apsslm',g_msg,STATUS)
     END IF
   END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsslm_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_aps_say()
  SELECT COUNT(*) INTO g_cnt FROM aps_say
   WHERE say01 = g_user AND say02 = tm.say02 AND say03 = tm.say03
  LET tm.say04 = TIME
  IF g_cnt = 0 THEN
     INSERT INTO aps_say VALUES(
        tm.say01,
        tm.say02,
        tm.say03,
        tm.say04,
        tm.dt_bdate ,
        tm.dt_edate ,
        tm.apsapg   ,
        tm.apsapm   ,
        tm.apsbmm   ,
        tm.apscmm   ,
        tm.apsdcm   ,
        tm.apsocm   ,
        tm.apsdom1  ,
        tm.apsdom2  ,
        tm.apsiam1  ,
        tm.apsiam2  ,
        tm.apsarm   ,
        tm.apsimm   ,
        tm.apsirm   ,
        tm.apsmrm   ,
        tm.apspem   ,
        tm.apspfm   ,
        tm.apsrem   ,
        tm.apsrgm   ,
        tm.apsrom   ,
        tm.apsslm   ,
        tm.apssmm   ,
        tm.apsspm1  ,
        tm.apsspm2  ,
        tm.apssim   ,
        tm.apssrm   ,
        tm.apsuim   ,
        tm.apswhm   ,
        tm.apswcm   ,
        tm.apswmm   ,
        tm.apswsm   ,
        tm.apscim   ,
        tm.apsspo   ,
        tm.apssmo   ,
        tm.apsddo   
     )
     IF STATUS THEN
        CALL cl_err3("ins","aps_say",tm.say01,tm.say02,STATUS,"","ins aps_say fail:",1)  # FUN-660095
     END IF
  ELSE
     UPDATE aps_say SET
         say04    = tm.say04,
         dt_bdate = tm.dt_bdate ,
         dt_edate = tm.dt_edate ,
         apsapg   = tm.apsapg   ,
         apsapm   = tm.apsapm   ,
         apsbmm   = tm.apsbmm   ,
         apscmm   = tm.apscmm   ,
         apsdcm   = tm.apsdcm   ,
         apsocm   = tm.apsocm   ,
         apsdom1  = tm.apsdom1  ,
         apsdom2  = tm.apsdom2  ,
         apsiam1  = tm.apsiam1  ,
         apsiam2  = tm.apsiam2  ,
         apsarm   = tm.apsarm   ,
         apsimm   = tm.apsimm   ,
         apsirm   = tm.apsirm   ,
         apsmrm   = tm.apsmrm   ,
         apspem   = tm.apspem   ,
         apspfm   = tm.apspfm   ,
         apsrem   = tm.apsrem   ,
         apsrgm   = tm.apsrgm   ,
         apsrom   = tm.apsrom   ,
         apsslm   = tm.apsslm   ,
         apssmm   = tm.apssmm   ,
         apsspm1  = tm.apsspm1  ,
         apsspm2  = tm.apsspm2  ,
         apssim   = tm.apssim   ,
         apssrm   = tm.apssrm   ,
         apsuim   = tm.apsuim   ,
         apswhm   = tm.apswhm   ,
         apswcm   = tm.apswcm   ,
         apswmm   = tm.apswmm   ,
         apswsm   = tm.apswsm   ,
         apscim   = tm.apscim   ,
         apsspo   = tm.apsspo   ,
         apssmo   = tm.apssmo   ,
         apsddo   = tm.apsddo   
      WHERE say01 = g_user 
        AND say02 = tm.say02
        AND say03 = tm.dt_bdate
     IF STATUS THEN
        CALL cl_err3("upd","aps_say",g_user,tm.say02,STATUS,"","upd aps_say fail:",1) 
     END IF
  END IF
END FUNCTION

FUNCTION p100_del()
DEFINE l_sql            STRING

  DELETE FROM aps_sax  WHERE  1=1

  #-->刪除萬用取替代檔
  IF tm.apsapg  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsapg WHERE 1=1 "
     PREPARE p100_p_del_apsapg  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsapg',STATUS,1) END IF
     EXECUTE p100_p_del_apsapg
  END IF

  #-->刪除單品取替代檔
  IF tm.apsapm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsapm WHERE 1=1 "
     PREPARE p100_p_del_apsapm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsapm',STATUS,1) END IF
     EXECUTE p100_p_del_apsapm
  END IF

  #-->刪除物料清單檔
  IF tm.apsbmm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsbmm WHERE 1=1 "
     PREPARE p100_p_del_apsbmm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsbmm',STATUS,1) END IF
     EXECUTE p100_p_del_apsbmm
  END IF

  #-->刪除客戶檔
  IF tm.apscmm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apscmm WHERE 1=1 "
     PREPARE p100_p_del_apscmm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apscmm',STATUS,1) END IF
     EXECUTE p100_p_del_apscmm
  END IF

  #-->刪除日行事曆
  IF tm.apsdcm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsdcm WHERE 1=1 "
     PREPARE p100_p_del_apsdcm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsdcm',STATUS,1) END IF
     EXECUTE p100_p_del_apsdcm
  END IF

  #-->刪除需求訂單選配檔
  IF tm.apsocm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsocm WHERE 1=1 "
     PREPARE p100_p_del_apsocm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsocm',STATUS,1) END IF
     EXECUTE p100_p_del_apsocm
  END IF

  #-->刪除訂單需求
  IF tm.apsdom1 = 'Y'  OR tm.apsdom2 = 'Y' THEN
     IF tm.apsdom1 = 'Y' THEN
        LET l_sql="DELETE FROM ",g_apsdb,"apsdom WHERE o_type = 'R'"
        PREPARE p100_p_del_apsdom1  FROM l_sql
        IF STATUS THEN CALL cl_err('pre del_apsdom1',STATUS,1) END IF
        EXECUTE p100_p_del_apsdom1
     END IF
     IF tm.apsdom2 = 'Y' THEN
        LET l_sql="DELETE FROM ",g_apsdb,"apsdom WHERE o_type = 'F'"
        PREPARE p100_p_del_apsdom2  FROM l_sql
        IF STATUS THEN CALL cl_err('pre del_apsdom2',STATUS,1) END IF
        EXECUTE p100_p_del_apsdom2
     END IF
  END IF

  #-->刪除存貨預配記錄檔
  IF tm.apsiam1 = 'Y' OR tm.apsiam2 = 'Y' THEN 
     LET l_sql="DELETE FROM ",g_apsdb,"apsiam WHERE 1=1 "
     PREPARE p100_p_del_apsiam  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsiam',STATUS,1) END IF
     EXECUTE p100_p_del_apsiam
  END IF

  #-->刪除品項分配法則檔
  IF tm.apsarm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsarm WHERE 1=1 "
     PREPARE p100_p_del_apsarm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsarm',STATUS,1) END IF
     EXECUTE p100_p_del_apsarm
  END IF

  #-->刪除料件主檔
  IF tm.apsimm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsimm WHERE 1=1 "
     PREPARE p100_p_del_apsimm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsimm',STATUS,1) END IF
     EXECUTE p100_p_del_apsimm
  END IF

  #-->刪除品項途程檔
  IF tm.apsirm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsirm WHERE 1=1 "
     PREPARE p100_p_del_apsirm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsirm',STATUS,1) END IF
     EXECUTE p100_p_del_apsirm
  END IF

  #-->刪除工單備料檔
  IF tm.apsmrm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsmrm WHERE 1=1 "
     PREPARE p100_p_del_apsmrm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsmrm',STATUS,1) END IF
     EXECUTE p100_p_del_apsmrm
  END IF

  #-->刪除單據追溯檔
  IF tm.apspem  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apspem WHERE 1=1 "
     PREPARE p100_p_del_apspem  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apspem',STATUS,1) END IF
     EXECUTE p100_p_del_apspem
  END IF

  #-->刪除預測群組沖銷檔
  IF tm.apspfm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apspfm WHERE 1=1 "
     PREPARE p100_p_del_apspfm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apspfm',STATUS,1) END IF
     EXECUTE p100_p_del_apspfm
  END IF

  #-->刪除設備
  IF tm.apsrem = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsrem WHERE 1=1 "
     PREPARE p100_p_del_apsrem  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsrem',STATUS,1) END IF
     EXECUTE p100_p_del_apsrem
  END IF

  #-->刪除設備群組
  IF tm.apsrgm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsrgm WHERE 1=1 "
     PREPARE p100_p_del_apsrgm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsrgm',STATUS,1) END IF
     EXECUTE p100_p_del_apsrgm
  END IF

  #-->刪除製程檔
  IF tm.apsrom = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsrom WHERE 1=1 "
     PREPARE p100_p_del_apsrom  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsrom',STATUS,1) END IF
     EXECUTE p100_p_del_apsrom
  END IF

  #-->刪除儲位資料
  IF tm.apsslm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsslm WHERE 1=1 "
     PREPARE p100_p_del_apsslm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsslm',STATUS,1) END IF
     EXECUTE p100_p_del_apsslm
  END IF

  #-->刪除製令,工單資料
  IF tm.apssmm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apssmm WHERE 1=1 "
     PREPARE p100_p_del_apssmm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apssmm',STATUS,1) END IF
     EXECUTE p100_p_del_apssmm
  END IF

  #-->刪除採購令
  IF tm.apsspm1 = 'Y' OR tm.apsspm2 ='Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsspm WHERE 1=1 "
     PREPARE p100_p_del_apsspm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsspm',STATUS,1) END IF
     EXECUTE p100_p_del_apsspm
  END IF

  #-->刪除料件供應商檔
  IF tm.apssim = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apssim WHERE 1=1 "
     PREPARE p100_p_del_apssim  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apssim',STATUS,1) END IF
     EXECUTE p100_p_del_apssim
  END IF

  ##FUN-740216-------------------------------------------------
  #-->刪除供給法則檔
  IF tm.apssrm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apssrm WHERE 1=1 "
     PREPARE p100_p_del_apssrm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apssrm',STATUS,1) END IF
     EXECUTE p100_p_del_apssrm
  END IF
  ##FUN-740216-------------------------------------------------

  #-->刪除實體庫存檔
  IF tm.apsuim = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apsuim WHERE 1=1 "
     PREPARE p100_p_del_apsuim  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apsuim',STATUS,1) END IF
     EXECUTE p100_p_del_apsuim
  END IF

  #-->刪除倉庫資料
  IF tm.apswhm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apswhm WHERE 1=1 "
     PREPARE p100_p_del_apswhm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apswhm',STATUS,1) END IF
     EXECUTE p100_p_del_apswhm
  END IF

  ##FUN-740216-------------------------------------------------
  #-->刪除週行事曆檔
  IF tm.apswcm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apswcm WHERE 1=1 "
     PREPARE p100_p_del_apswcm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apswcm',STATUS,1) END IF
     EXECUTE p100_p_del_apswcm
  END IF
  ##FUN-740216-------------------------------------------------

  #-->刪除工作模式
  IF tm.apswmm = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apswmm WHERE 1=1 "
     PREPARE p100_p_del_apswmm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apswmm',STATUS,1) END IF
     EXECUTE p100_p_del_apswmm
  END IF

  #-->刪除工作站
  IF tm.apswsm  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apswsm WHERE 1=1 "
     PREPARE p100_p_del_apswsm  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apswsm',STATUS,1) END IF
     EXECUTE p100_p_del_apswsm
  END IF

  #-->刪除系統參數檔
  IF tm.apscim  = 'Y' THEN
     LET l_sql="DELETE FROM ",g_apsdb,"apscim WHERE 1=1 "
     PREPARE p100_p_del_apscim  FROM l_sql
     IF STATUS THEN CALL cl_err('pre del_apscim',STATUS,1) END IF
     EXECUTE p100_p_del_apscim
  END IF

END FUNCTION

FUNCTION err(p_sax03,err_code1,err_code2)
 DEFINE p_sax03   LIKE aps_sax.sax03
 DEFINE err_code2  LIKE  aps_sax.sax05    
 DEFINE err_code1  LIKE aps_sax.sax04    
 DEFINE aps_sax   RECORD LIKE aps_sax.*

  LET aps_sax.sax01 = g_today
  LET aps_sax.sax02 = TIME
  LET aps_sax.sax03 = p_sax03
  LET aps_sax.sax04 = err_code1
  LET aps_sax.sax05 = err_get(err_code2)
  INSERT INTO aps_sax VALUES(aps_sax.*)

END FUNCTION

FUNCTION p100_out()
 DEFINE l_i           LIKE type_file.num5,    
        l_name        LIKE type_file.chr20,   
        sr            RECORD LIKE aps_sax.*,
        l_za05        LIKE type_file.chr1000 

    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

    DECLARE p100_cs CURSOR FOR SELECT * FROM aps_sax
    CALL cl_outnam('apsp100') RETURNING l_name
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aoop100'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 100 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    START REPORT p100_rep TO l_name
    FOREACH p100_cs INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT p100_rep(sr.*)
    END FOREACH

    FINISH REPORT p100_rep

    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT p100_rep(sr)
    DEFINE
        l_trailer_sw   LIKE type_file.chr1,    # NO.FUN-690010 VARCHAR(1),
        sr RECORD LIKE aps_sax.*
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.sax03,sr.sax01,sr.sax02

    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT ' '
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]  #TQC-6A0089
            LET l_trailer_sw = 'y'

        BEFORE GROUP OF sr.sax03
            CASE sr.sax03
              WHEN 'apswsm'  LET g_msg = g_x[11] CLIPPED #zaa資料為中文檔案名稱+產生
              WHEN 'apsapg'  LET g_msg = g_x[12] CLIPPED
              WHEN 'apswmm'  LET g_msg = g_x[13] CLIPPED
              WHEN 'apswcm'  LET g_msg = g_x[14] CLIPPED
              WHEN 'apsdcm'  LET g_msg = g_x[15] CLIPPED
              WHEN 'apsrem'  LET g_msg = g_x[16] CLIPPED
              WHEN 'apsrgm'  LET g_msg = g_x[17] CLIPPED
              WHEN 'apsimm'  LET g_msg = g_x[18] CLIPPED
              WHEN 'apssim'  LET g_msg = g_x[19] CLIPPED
              WHEN 'apsbmm'  LET g_msg = g_x[20] CLIPPED
              WHEN 'apsapm'  LET g_msg = g_x[21] CLIPPED
              WHEN 'apscmm'  LET g_msg = g_x[22] CLIPPED
              WHEN 'apsirm'  LET g_msg = g_x[23] CLIPPED
              WHEN 'apsrom'  LET g_msg = g_x[24] CLIPPED
              WHEN 'apsocm'  LET g_msg = g_x[25] CLIPPED
              WHEN 'apsdom1' LET g_msg = g_x[26] CLIPPED
              WHEN 'apsdom2' LET g_msg = g_x[27] CLIPPED
              WHEN 'apsiam1' LET g_msg = g_x[28] CLIPPED
              WHEN 'apsmrm'  LET g_msg = g_x[29] CLIPPED
              WHEN 'apsuim'  LET g_msg = g_x[30] CLIPPED
              WHEN 'apssmm'  LET g_msg = g_x[31] CLIPPED
              WHEN 'apsspm1' LET g_msg = g_x[32] CLIPPED
              WHEN 'apsspm2' LET g_msg = g_x[33] CLIPPED
              WHEN 'apsiam2' LET g_msg = g_x[34] CLIPPED#
              WHEN 'apsarm'  LET g_msg = g_x[35] CLIPPED
              WHEN 'apspem'  LET g_msg = g_x[36] CLIPPED
              WHEN 'apspfm'  LET g_msg = g_x[37] CLIPPED
              WHEN 'apsslm'  LET g_msg = g_x[38] CLIPPED
              WHEN 'apssrm'  LET g_msg = g_x[39] CLIPPED
              WHEN 'apswhm'  LET g_msg = g_x[40] CLIPPED
              WHEN 'apscim'  LET g_msg = g_x[41] CLIPPED
            END CASE
            PRINT sr.sax03,':',g_msg CLIPPED

        ON EVERY ROW
            PRINT COLUMN 1, sr.sax01 CLIPPED,
                  COLUMN 10,sr.sax02 CLIPPED,
                  COLUMN 19,sr.sax04 CLIPPED
            PRINT COLUMN 19,sr.sax05 CLIPPED

        ON LAST ROW
            PRINT g_dash[1,g_len]  
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                  g_x[7] CLIPPED
            LET l_trailer_sw = 'n'

        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]   
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9),
                      g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT

FUNCTION p100_apssim()
  DEFINE l_aps_sim  RECORD LIKE aps_sim.*
  DEFINE l_ima      RECORD LIKE ima_file.*
  DEFINE l_pmh      RECORD LIKE pmh_file.*
  DEFINE l_cnt      LIKE type_file.num10   #FUN-740216
  DEFINE l_sql      STRING                 #FUN-740216

  IF tm.apssim  = 'N' THEN RETURN END IF  #FUN-740215

  DECLARE p100_apssim_c CURSOR FOR
 ##SELECT pmh_file.*,aps_sim.*              #FUN-740216
   SELECT pmh_file.*,aps_sim.*,ima_file.*
     FROM pmh_file,OUTER aps_sim,OUTER ima_file
     WHERE pmh01 = aps_sim.pid    
       AND pmh02 = aps_sim.sup_id 
       AND pmh01 = ima_file.ima01
       AND pmh21 = " "                                             #CHI-860042                                                      
       AND pmh22 = '1'                                             #CHI-860042

##FOREACH p100_apssim_c INTO l_aps_sim.*,l_pmh.*,l_ima.*   #FUN-740216
  FOREACH p100_apssim_c INTO l_pmh.*,l_aps_sim.*,l_ima.*   #FUN-740216
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apssim_c:',STATUS,1) EXIT FOREACH
     END IF
     INITIALIZE g_apssim.* TO NULL
     LET g_apssim.pid       = l_pmh.pmh01
     LET g_apssim.sup_id    = l_pmh.pmh02
     LET g_apssim.inc_lot   = l_ima.ima45
     LET g_apssim.location  = NULL 
     IF NOT cl_null(l_aps_sim.max_lot) THEN
        LET g_apssim.max_lot   = l_aps_sim.max_lot
     ELSE
        LET g_apssim.max_lot   = 999999
     END IF
     LET g_apssim.min_lot   = l_ima.ima46
     LET g_apssim.unit_id   = l_ima.ima44
     LET g_apssim.insp_day  = l_ima.ima491
     LET g_apssim.fix_lt    = l_ima.ima50 + l_ima.ima48 + l_ima.ima49

     IF NOT cl_null(l_aps_sim.var_lt) THEN
        LET g_apssim.var_lt    = l_aps_sim.var_lt
     ELSE
        LET g_apssim.var_lt    = 0
     END IF

     IF NOT cl_null(l_aps_sim.base_qty) THEN
        LET g_apssim.base_qty  = l_aps_sim.base_qty
     ELSE
        LET g_apssim.base_qty = 1
     END IF

     IF NOT cl_null(l_aps_sim.lst_cmb ) THEN
        LET g_apssim.lst_cmb  = l_aps_sim.lst_cmb
     ELSE
        LET g_apssim.lst_cmb  = 0
     END IF

     IF NOT cl_null(l_aps_sim.lst_cblm ) THEN
        LET g_apssim.lst_cblm  = l_aps_sim.lst_cblm
     ELSE
        LET g_apssim.lst_cblm = 1
     END IF

     LET g_apssim.ts_rate  = l_ima.ima44_fac

     IF NOT cl_null(l_aps_sim.lot_rule ) THEN
         LET g_apssim.lot_rule = l_aps_sim.lot_rule
     ELSE
         LET g_apssim.lot_rule = 0
     END IF

     IF NOT cl_null(l_aps_sim.sfx_lt ) THEN
         LET g_apssim.sfx_lt   = l_aps_sim.sfx_lt
     ELSE
         LET g_apssim.sfx_lt   = 0
     END IF
     IF NOT cl_null(l_aps_sim.svr_lt ) THEN
         LET g_apssim.svr_lt   = l_aps_sim.svr_lt
     ELSE
         LET g_apssim.svr_lt   = 0
     END IF

     #FUN-740216---------------------------------------------------------
     #因TIPTOP在apmi254中PK值為-料號+供應商+幣別+作業編號+價格型態
     #但APS的料件供應商檔PK值為-料號+供應商,
     #故在此處判斷,僅第一筆轉入,其後則跳過
     LET l_cnt = 0
     LET l_sql = " SELECT COUNT(*) ",
                 "   FROM ",g_apsdb,"apssim ",
                 "  WHERE pid = '",l_pmh.pmh01,"' ",
                 "    AND sup_id = '",l_pmh.pmh02,"'"

     PREPARE p100_p_cnt_apssim FROM l_sql
     IF STATUS THEN CALL cl_err('pre cnt_apssim',STATUS,1) END IF
     DECLARE p100_d_cnt_apssim CURSOR WITH HOLD FOR p100_p_cnt_apssim
     IF STATUS THEN CALL cl_err('dec cnt_apssim',STATUS,1) END IF
     OPEN p100_d_cnt_apssim
     FETCH p100_d_cnt_apssim INTO l_cnt
     CLOSE p100_d_cnt_apssim

     IF l_cnt = 0 THEN
     #FUN-740216---------------------------------------------------------
        PUT p100_c_ins_apssim  FROM g_apssim.*
        IF STATUS THEN
           LET g_msg='Key:',g_apssim.pid CLIPPED,'+',g_apssim.sup_id
           CALL err('apssim',g_msg,STATUS)
        END IF
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apssim_c:',STATUS,1) RETURN END IF
END FUNCTION

FUNCTION p100_apsirm_sub(p_ima01)
  DEFINE p_ima01    LIKE ima_file.ima01

    #-->料件途程檔
    INITIALIZE g_apsirm.* TO NULL
    LET g_apsirm.pid       = p_ima01
    LET g_apsirm.route_id  = 'APS----',p_ima01 CLIPPED
    LET g_apsirm.sequ_num  = 10
    LET g_apsirm.ict       = 1
    LET g_apsirm.eff_st    = NULL
    LET g_apsirm.eff_et    = NULL
    LET g_apsirm.is_alt    = 1         

    PUT p100_c_ins_apsirm  FROM g_apsirm.*
    IF STATUS THEN
       LET g_msg='Key:',g_apsirm.pid CLIPPED,'+',g_apsirm.route_id CLIPPED
       CALL err('apsirm',g_msg,STATUS)
    END IF
END FUNCTION

FUNCTION p100_apsrom_sub(p_ima01)
  DEFINE p_ima01    LIKE ima_file.ima01
  DEFINE l_ima      RECORD LIKE ima_file.*

    SELECT * INTO l_ima.*
      FROM ima_file
     WHERE ima01 = p_ima01
    
    IF cl_null(l_ima.ima48) THEN LET l_ima.ima48 = 0 END IF
    IF cl_null(l_ima.ima49) THEN LET l_ima.ima49 = 0 END IF
    IF cl_null(l_ima.ima50) THEN LET l_ima.ima50 = 0 END IF

    #-->途程檔
    INITIALIZE g_apsrom.* TO NULL
    LET g_apsrom.route_id   = 'APS----',p_ima01 CLIPPED
    LET g_apsrom.sequ_num   = 10
    LET g_apsrom.op_id      = 'APS-TASK'
    LET g_apsrom.eff_st     = NULL
    LET g_apsrom.eff_et     = NULL
    LET g_apsrom.eq_id      = 'APS-equip'
    LET g_apsrom.eqg_id     = NULL
    LET g_apsrom.is_batch   = NULL
    LET g_apsrom.setup_t    = (l_ima.ima50 + l_ima.ima48 + l_ima.ima49) * 86400  #(秒)
    LET g_apsrom.pre_ps_t   = 0
   #LET g_apsrom.ps_t       = l_ima.ima60 * 86400        #(秒)   #No:FUN-840194      #CHI-810015 mark還原#FUN-710073 mark
    LET g_apsrom.ps_t       = l_ima.ima60/l_ima.ima601 * 86400   #(秒) #No:FUN-840194         #CHI-810015 mark還原#FUN-710073 mark
   #LET g_apsrom.ps_t       = (l_ima.ima60/l_ima.ima56) * 86400  #(秒)  #CHI-810015 mark    #FUN-710073 mod
    LET g_apsrom.lotpos_t   = 0
    LET g_apsrom.eqpos_t    = 0  
    LET g_apsrom.trans_qty  = 0
    LET g_apsrom.base_qty   = l_ima.ima56   #生產批量
    LET g_apsrom.max_eqnm   = 0
    LET g_apsrom.min_emq    = NULL
    LET g_apsrom.os_code    = 0
    LET g_apsrom.altop_p    = 0
    LET g_apsrom.max_bsiz   = 9999
    LET g_apsrom.min_bsiz   = 1

    PUT p100_c_ins_apsrom  FROM g_apsrom.*
    IF STATUS THEN
       LET g_msg='Key:',g_apsrom.route_id CLIPPED,
                 g_apsrom.sequ_num USING '&&&&'
       CALL err('apsrom',g_msg,STATUS)
    END IF
END FUNCTION

#==>途程檔
FUNCTION p100_apsrom()  
DEFINE l_ecb        RECORD LIKE ecb_file.*
DEFINE l_aps_ecb    RECORD LIKE aps_ecb.*
DEFINE l_cnt        LIKE type_file.num10   
DEFINE l_eca06      LIKE eca_file.eca06
DEFINE l_sql        STRING                #FUN-740216

  IF tm.apsrom  = 'N' THEN RETURN END IF  #FUN-740216

  DECLARE p100_apsrom_c CURSOR FOR
    SELECT ecb_file.*,aps_ecb.*
      FROM ecb_file,OUTER aps_ecb
     WHERE ecb02 = aps_ecb.route_id 
       AND ecb03 = aps_ecb.sequ_num  
       AND ecb06 = aps_ecb.op_id

  FOREACH p100_apsrom_c INTO l_ecb.*,l_aps_ecb.*
     IF SQLCA.sqlcode THEN
         CALL cl_err('p100_apsrom_c:',STATUS,1) EXIT FOREACH
     END IF

     INITIALIZE g_apsrom.* TO NULL
     LET g_apsrom.route_id   = l_ecb.ecb02
     LET g_apsrom.sequ_num   = l_ecb.ecb03
     LET g_apsrom.op_id      = l_ecb.ecb06
     LET g_apsrom.eff_st     = NULL
     LET g_apsrom.eff_et     = NULL
     LET g_apsrom.eq_id      = l_ecb.ecb07
     LET g_apsrom.eqg_id     = l_aps_ecb.eqg_id
     IF NOT cl_null(l_aps_ecb.is_batch ) THEN
        LET g_apsrom.is_batch = l_aps_ecb.is_batch
     ELSE
        LET g_apsrom.is_batch = 0
     END IF
     SELECT eca06 INTO l_eca06 
       FROM eca_file 
      WHERE eca01 = l_ecb.ecb08 
     IF l_eca06 = 1 THEN 
         LET g_apsrom.setup_t = l_ecb.ecb20
     ELSE 
         LET g_apsrom.setup_t = l_ecb.ecb18
     END IF
     IF NOT cl_null(l_aps_ecb.pre_ps_t) THEN
        LET g_apsrom.pre_ps_t = l_aps_ecb.pre_ps_t
     ELSE
        LET g_apsrom.pre_ps_t = 0
     END IF
     IF l_eca06 = 1 THEN 
        LET g_apsrom.ps_t = l_ecb.ecb21
     ELSE 
        LET g_apsrom.ps_t = l_ecb.ecb19
     END IF
     IF NOT cl_null(l_aps_ecb.lotpos_t) THEN
        LET g_apsrom.lotpos_t = l_aps_ecb.lotpos_t
     ELSE
        LET g_apsrom.lotpos_t = 0
     END IF
     IF NOT cl_null(l_aps_ecb.eqpos_t) THEN
        LET g_apsrom.eqpos_t = l_aps_ecb.eqpos_t  
     ELSE
        LET g_apsrom.eqpos_t = 0                 
     END IF
     IF NOT cl_null(l_aps_ecb.trans_qty) THEN
        LET g_apsrom.trans_qty = l_aps_ecb.trans_qty
     ELSE 
        LET g_apsrom.trans_qty = 0
     END IF
     IF NOT cl_null(l_aps_ecb.base_qty) THEN
        LET g_apsrom.base_qty = l_aps_ecb.base_qty
     ELSE
        LET g_apsrom.base_qty = 1
     END IF
     IF NOT cl_null(l_aps_ecb.max_eqnm) THEN
        LET g_apsrom.max_eqnm = l_aps_ecb.max_eqnm
     ELSE
        LET g_apsrom.max_eqnm = 0
     END IF
     LET g_apsrom.min_emq = l_aps_ecb.min_emq
     IF l_ecb.ecb39 MATCHES '[Yy]' THEN
        LET g_apsrom.os_code = 1
     ELSE
        LET g_apsrom.os_code = 0
     END IF
     IF NOT cl_null(l_aps_ecb.altop_p) THEN
        LET g_apsrom.altop_p = l_aps_ecb.altop_p
     ELSE
        LET g_apsrom.altop_p = 0
     END IF

     IF g_apsrom.is_batch = 0 THEN
        LET g_apsrom.max_bsiz = 1
     ELSE
        IF NOT cl_null(l_aps_ecb.max_bsiz) THEN
           LET g_apsrom.max_bsiz = l_aps_ecb.max_bsiz
        ELSE
           LET g_apsrom.max_bsiz = 9999
        END IF
     END IF
     IF NOT cl_null(l_aps_ecb.min_bsiz) THEN
        LET g_apsrom.min_bsiz = l_aps_ecb.min_bsiz
     ELSE
        LET g_apsrom.min_bsiz = 1
     END IF
     #FUN-740216---------------------------------------------------------
     #因TIPTOP在aeci100中可以設定不同料號,但是相同製程編號.序號.作業編號
     #的情況發生,但對APS是不允許,故在此處判斷,僅第一筆轉入,其後則跳過
     LET l_cnt = 0
     LET l_sql = " SELECT COUNT(*) ",
                 "   FROM ",g_apsdb,"apsrom ",
                 "  WHERE route_id = '",l_ecb.ecb02,"' ",
                 "    AND sequ_num = ",l_ecb.ecb03,
                 "    AND op_id    = '",l_ecb.ecb06,"'"

     PREPARE p100_p_cnt_apsrom FROM l_sql
     IF STATUS THEN CALL cl_err('pre cnt_apsrom',STATUS,1) END IF
     DECLARE p100_d_cnt_apsrom CURSOR WITH HOLD FOR p100_p_cnt_apsrom
     IF STATUS THEN CALL cl_err('dec cnt_apsrom',STATUS,1) END IF
     OPEN p100_d_cnt_apsrom
     FETCH p100_d_cnt_apsrom INTO l_cnt
     CLOSE p100_d_cnt_apsrom

     IF l_cnt = 0 THEN
     #FUN-740216---------------------------------------------------------
        PUT p100_c_ins_apsrom  FROM g_apsrom.*
        IF STATUS THEN
           LET g_msg = 'Key:',g_apsrom.route_id CLIPPED,'+',
                              g_apsrom.sequ_num CLIPPED,'+',
                              g_apsrom.op_id    CLIPPED
           CALL err('apsrom',g_msg,STATUS)
        END IF
     END IF
  END FOREACH
  IF SQLCA.sqlcode THEN CALL cl_err('p100_apsrom_c:',STATUS,1) RETURN END IF
END FUNCTION
