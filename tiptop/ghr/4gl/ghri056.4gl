# Prog Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri056.4gl
# Descriptions...: 员工每天考勤汇总维护作业
# Date & Author..: 13/05/24 By lifang
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrcp    DYNAMIC ARRAY OF RECORD
            check       LIKE type_file.chr1,
            hrat03      LIKE hrat_file.hrat03,
            hrcp01      LIKE hrcp_file.hrcp01,
            hrat01      LIKE hrat_file.hrat01,
            hrat02      LIKE hrat_file.hrat02,
            hrat04      LIKE hrat_file.hrat04,
            hrao02      LIKE hrao_file.hrao02,
            hrat87      LIKE hrat_file.hrat87,
            hrat88      LIKE hrat_file.hrat88,
            hrat05      LIKE hrat_file.hrat05,
            hras04      LIKE hras_file.hras04,
            hrat19      LIKE hrat_file.hrat19,  #FUN-151118 wangjya
            hrat19_name LIKE hrad_file.hrad03,  #FUN-151118 wangjya
            hrcp03      LIKE hrcp_file.hrcp03,
            hrcp04      LIKE hrcp_file.hrcp04,
            hrcp04_name LIKE hrbo_file.hrbo03,
            hrcp05      LIKE hrcp_file.hrcp05,
            hrcp06      LIKE hrcp_file.hrcp06,
            hrcp07      LIKE hrcp_file.hrcp07,
            hrcp08      LIKE hrcp_file.hrcp08,
            hrcp09      LIKE hrcp_file.hrcp09,
            hrcp10      LIKE hrcp_file.hrcp10,
            hrcp11      LIKE hrcp_file.hrcp11,
            hrcp12      LIKE hrcp_file.hrcp12,
            hrcp40      LIKE hrcp_file.hrcp40,
            hrcp41      LIKE hrcp_file.hrcp41,
            hrcp42      LIKE hrcp_file.hrcp42,
            hrcp13      LIKE hrcp_file.hrcp13,
            hrcp14      LIKE hrcp_file.hrcp14,
            hrcp15      LIKE hrcp_file.hrcp15,
            hrcp16      LIKE hrcp_file.hrcp16,
            hrcp17      LIKE hrcp_file.hrcp17,
            hrcp18      LIKE hrcp_file.hrcp18,
            hrcp19      LIKE hrcp_file.hrcp19,
            hrcp20      LIKE hrcp_file.hrcp20,
            hrcp21      LIKE hrcp_file.hrcp21,
            hrcp37      LIKE hrcp_file.hrcp37,
            hrcp38      LIKE hrcp_file.hrcp38,
            hrcp39      LIKE hrcp_file.hrcp39,
            hrcp43      LIKE hrcp_file.hrcp43,
            hrcp44      LIKE hrcp_file.hrcp44,
            hrcp45      LIKE hrcp_file.hrcp45,
            hrcp46      LIKE hrcp_file.hrcp46,
            hrcp47      LIKE hrcp_file.hrcp47,
            hrcp48      LIKE hrcp_file.hrcp48,
            hrcp49      LIKE hrcp_file.hrcp49,
            hrcp50      LIKE hrcp_file.hrcp50,
            hrcp51      LIKE hrcp_file.hrcp51,
            hrcp22      LIKE hrcp_file.hrcp22,
            hrcp23      LIKE hrcp_file.hrcp23,
            hrcp24      LIKE hrcp_file.hrcp24,
            hrcp25      LIKE hrcp_file.hrcp25,
            hrcp26      LIKE hrcp_file.hrcp26,
            hrcp27      LIKE hrcp_file.hrcp27,
            hrcp28      LIKE hrcp_file.hrcp28,
            hrcp29      LIKE hrcp_file.hrcp29,
            hrcp30      LIKE hrcp_file.hrcp30,
            hrcp31      LIKE hrcp_file.hrcp31,
            hrcp32      LIKE hrcp_file.hrcp32,
            hrcp33      LIKE hrcp_file.hrcp33,
            hrcp34      LIKE hrcp_file.hrcp34,
            hrcp35      LIKE hrcp_file.hrcp35,
            hrag07      LIKE hrag_file.hrag07,
            hrcpconf    LIKE hrcp_file.hrcpconf,
            hrcpud03    LIKE hrcp_file.hrcpud03,
            hrcpud01    LIKE hrcp_file.hrcpud01
                 END RECORD,
       g_hrcp_t  RECORD
            check       LIKE type_file.chr1,
            hrat03      LIKE hrat_file.hrat03,
            hrcp01      LIKE hrcp_file.hrcp01,
            hrat01      LIKE hrat_file.hrat01,
            hrat02      LIKE hrat_file.hrat02,
            hrat04      LIKE hrat_file.hrat04,
            hrao02      LIKE hrao_file.hrao02,
            hrat87      LIKE hrat_file.hrat87,
            hrat88      LIKE hrat_file.hrat88,
            hrat05      LIKE hrat_file.hrat05,
            hras04      LIKE hras_file.hras04,
            hrat19      LIKE hrat_file.hrat19,  #FUN-151118 wangjya
            hrat19_name LIKE hrad_file.hrad03,  #FUN-151118 wangjya
            hrcp03      LIKE hrcp_file.hrcp03,
            hrcp04      LIKE hrcp_file.hrcp04,
            hrcp04_name LIKE hrbo_file.hrbo03,
            hrcp05      LIKE hrcp_file.hrcp05,
            hrcp06      LIKE hrcp_file.hrcp06,
            hrcp07      LIKE hrcp_file.hrcp07,
            hrcp08      LIKE hrcp_file.hrcp08,
            hrcp09      LIKE hrcp_file.hrcp09,
            hrcp10      LIKE hrcp_file.hrcp10,
            hrcp11      LIKE hrcp_file.hrcp11,
            hrcp12      LIKE hrcp_file.hrcp12,
            hrcp40      LIKE hrcp_file.hrcp40,
            hrcp41      LIKE hrcp_file.hrcp41,
            hrcp42      LIKE hrcp_file.hrcp42,
            hrcp13      LIKE hrcp_file.hrcp13,
            hrcp14      LIKE hrcp_file.hrcp14,
            hrcp15      LIKE hrcp_file.hrcp15,
            hrcp16      LIKE hrcp_file.hrcp16,
            hrcp17      LIKE hrcp_file.hrcp17,
            hrcp18      LIKE hrcp_file.hrcp18,
            hrcp19      LIKE hrcp_file.hrcp19,
            hrcp20      LIKE hrcp_file.hrcp20,
            hrcp21      LIKE hrcp_file.hrcp21,
            hrcp37      LIKE hrcp_file.hrcp37,
            hrcp38      LIKE hrcp_file.hrcp38,
            hrcp39      LIKE hrcp_file.hrcp39,
            hrcp43      LIKE hrcp_file.hrcp43,
            hrcp44      LIKE hrcp_file.hrcp44,
            hrcp45      LIKE hrcp_file.hrcp45,
            hrcp46      LIKE hrcp_file.hrcp46,
            hrcp47      LIKE hrcp_file.hrcp47,
            hrcp48      LIKE hrcp_file.hrcp48,
            hrcp49      LIKE hrcp_file.hrcp49,
            hrcp50      LIKE hrcp_file.hrcp50,
            hrcp51      LIKE hrcp_file.hrcp51,
            hrcp22      LIKE hrcp_file.hrcp22,
            hrcp23      LIKE hrcp_file.hrcp23,
            hrcp24      LIKE hrcp_file.hrcp24,
            hrcp25      LIKE hrcp_file.hrcp25,
            hrcp26      LIKE hrcp_file.hrcp26,
            hrcp27      LIKE hrcp_file.hrcp27,
            hrcp28      LIKE hrcp_file.hrcp28,
            hrcp29      LIKE hrcp_file.hrcp29,
            hrcp30      LIKE hrcp_file.hrcp30,
            hrcp31      LIKE hrcp_file.hrcp31,
            hrcp32      LIKE hrcp_file.hrcp32,
            hrcp33      LIKE hrcp_file.hrcp33,
            hrcp34      LIKE hrcp_file.hrcp34,
            hrcp35      LIKE hrcp_file.hrcp35,
            hrag07      LIKE hrag_file.hrag07,
            hrcpconf    LIKE hrcp_file.hrcpconf,
            hrcpud03    LIKE hrcp_file.hrcpud03,
            hrcpud01    LIKE hrcp_file.hrcpud01
                 END RECORD
DEFINE g_wc         STRING
DEFINE g_sql        STRING
DEFINE g_forupd_sql STRING
DEFINE g_rec_b      LIKE type_file.num10
DEFINE l_ac         LIKE type_file.num10
DEFINE g_cnt        LIKE type_file.num10
DEFINE g_hrcp_colour DYNAMIC ARRAY OF RECORD  #属性数组，名称与单身数组一致，类型定义为string
            check       STRING,
            hrat03      STRING,
            hrcp01      STRING,
            hrat01      STRING,
            hrat02      STRING,
            hrat04      STRING,
            hrao02      STRING,
            hrat87      STRING,
            hrat88      STRING,
            hrat05      STRING,
            hras04      STRING,
            hrat19      STRING,        #FUN-151118 wangjya
            hrat19_name STRING,        #FUN-151118 wangjya
            hrcp03      STRING,
            hrcp04      STRING,
            hrcp04_name STRING,
            hrcp05      STRING,
            hrcp06      STRING,
            hrcp07      STRING,
            hrcp08      STRING,
            hrcp09      STRING,
            hrcp10      STRING,
            hrcp11      STRING,
            hrcp12      STRING,
            hrcp40      STRING,
            hrcp41      STRING,
            hrcp42      STRING,
            hrcp13      STRING,
            hrcp14      STRING,
            hrcp15      STRING,
            hrcp16      STRING,
            hrcp17      STRING,
            hrcp18      STRING,
            hrcp19      STRING,
            hrcp20      STRING,
            hrcp21      STRING,
            hrcp37      STRING,
            hrcp38      STRING,
            hrcp39      STRING,
            hrcp43      STRING,
            hrcp44      STRING,
            hrcp45      STRING,
            hrcp46      STRING,
            hrcp47      STRING,
            hrcp48      STRING,
            hrcp49      STRING,
            hrcp50      STRING,
            hrcp51      STRING,
            hrcp22      STRING,
            hrcp23      STRING,
            hrcp24      STRING,
            hrcp25      STRING,
            hrcp26      STRING,
            hrcp27      STRING,
            hrcp28      STRING,
            hrcp29      STRING,
            hrcp30      STRING,
            hrcp31      STRING,
            hrcp32      STRING,
            hrcp33      STRING,
            hrcp34      STRING,
            hrcp35      STRING,
            hrag07      STRING,
            hrcpconf    STRING,
            hrcpud03    STRING,
            hrcpud01    STRING
           END RECORD

MAIN

   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW i056_w AT 2,3 WITH FORM "ghr/42f/ghri056"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   CALL cl_set_comp_visible("hrcp01,check",FALSE)
   CALL i056_menu()
   CLOSE WINDOW i056_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN


FUNCTION i056_menu()
DEFINE l_n   LIKE type_file.num10
DEFINE l_msg STRING
DEFINE l_hratid LIKE hrat_file.hratid

   WHILE TRUE
      CALL i056_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i056_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() AND NOT cl_null(g_hrcp[1].hrcp01) THEN
               CALL i056_b()
            ELSE
               LET g_action_choice = " "
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i056_confirm('Y')
            END IF
         WHEN "unconfirm"
            IF cl_chk_act_auth() THEN
               CALL i056_confirm('N')
            END IF
#         WHEN "auto_generate"
#            IF cl_chk_act_auth() THEN
#            #   CALL i056_auto_generate()
#           CALL  i056_dateupdate_group()
#            END IF
         WHEN "exceltoreport"
            IF cl_chk_act_auth() THEN
               CALL i056_exceltoreport()
            END IF
         WHEN "dateupdate"
            LET l_n=ARR_CURR()
            IF l_n=0 THEN
               CONTINUE WHILE
            END IF
            IF g_hrcp[l_n].hrat01 IS NULL THEN
               CONTINUE WHILE
            END IF
            #add by zhuzw 20140925 start
            SELECT hratid INTO l_hratid FROM hrat_file
             WHERE hrat01 = g_hrcp[l_n].hrat01
            UPDATE hrcp_file
           	   SET hrcp35 = 'N'
       	     WHERE hrcp02 = l_hratid  AND hrcp03 = g_hrcp[l_n].hrcp03
       	     #add by zhuzw 20140925 end
            LET l_msg="ghrp056 Y ",g_hrcp[l_n].hrcp03," ",g_hrcp[l_n].hrcp03," 1 ",g_hrcp[l_n].hrat01," "
            CALL cl_cmdrun_wait(l_msg)
            CALL i056_b_fill()

          WHEN "dateupdate_group"
            IF cl_chk_act_auth() THEN
          #     CALL i056_dateupdate_group()   #mark by fangyuanz171220
                CALL i056_dateupdate_group1()   #add by fangyuanz171220
            END IF

          WHEN "exporttoexcel"   # 141016
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcp),'','')
            END IF

         WHEN "importresult"
            IF cl_chk_act_auth() THEN
              CALL i056_importresult()
            END IF
         WHEN "cardtimeshow"
            IF cl_chk_act_auth() THEN
              LET l_n=ARR_CURR()
              IF l_n=0 THEN
                 CONTINUE WHILE
              END IF
              CALL i056_showtimes(g_hrcp[l_n].hrat01,g_hrcp[l_n].hrcp03)
            END IF
#         #160901 add by zhangtn--str--
#         WHEN "open_ghrq056"
#            IF cl_chk_act_auth() THEN
#              LET l_n=ARR_CURR()
#              IF l_n=0 THEN
#                 CALL cl_cmdrun("ghrq056")
#              ELSE
#                 LET l_msg="ghrq056 '",g_hrcp[l_n].hrat01,"' '",g_hrcp[l_n].hrcp03,"' "
#                 CALL cl_cmdrun(l_msg)
#              END IF
#            END IF 
#         #160901 add by zhangtn--end--

      END CASE
   END WHILE
END FUNCTION

FUNCTION i056_q()
   CALL i056_b_askkey()
END FUNCTION

FUNCTION i056_b()
DEFINE l_sql           STRING
DEFINE l_hratid        LIKE hrat_file.hratid
DEFINE l_hrcp02        LIKE hrcp_file.hrcp02
DEFINE l_hrcp03        LIKE hrcp_file.hrcp03
DEFINE l_hrboa02       LIKE hrboa_file.hrboa02
DEFINE l_hrboa05       LIKE hrboa_file.hrboa05
DEFINE l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
       p_cmd           LIKE type_file.chr1,            #處理狀態
       l_count         LIKE type_file.num10

   IF cl_null(g_hrcp[1].hrcp01) THEN
      RETURN
   END IF

   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""

   LET g_forupd_sql="SELECT 'N','',hrcp01,hrcp02,'','','','','','','','','',hrcp03,hrcp04,'',hrcp05,hrcp06,hrcp07,hrcp08,",
                     "      hrcp09,hrcp10,hrcp11,hrcp12,hrcp40,hrcp41,hrcp42,hrcp13,hrcp14,hrcp15,hrcp16,",
                     "      hrcp17,hrcp18,hrcp19,hrcp20,hrcp21,hrcp37,hrcp38,hrcp39,hrcp43,hrcp44,hrcp45,hrcp46,hrcp47,hrcp48,hrcp49,hrcp50,hrcp51,hrcp22,hrcp23,hrcp24,hrcp25,",
                     "      hrcp26,hrcp27,hrcp28,hrcp29,hrcp30,hrcp31,hrcp32,hrcp33,hrcp34,hrcp35,''
                     ,hrcpconf,hrcpud03,hrcpud01",
                     " FROM hrcp_file ",
                     " WHERE  hrcp03 = ?  and hrcp02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i056_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   INPUT ARRAY g_hrcp WITHOUT DEFAULTS FROM s_hrcp.*
     ATTRIBUTE (COUNT=g_rec_b,UNBUFFERED,
                INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF

       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'

          IF g_rec_b>=l_ac THEN
             BEGIN WORK
             LET p_cmd='u'
             LET g_hrcp_t.* = g_hrcp[l_ac].*  #BACKUP
             SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcp_t.hrat01
             
             OPEN i056_bcl USING g_hrcp_t.hrcp03,l_hratid
             IF STATUS THEN
                CALL cl_err("OPEN i056_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i056_bcl INTO g_hrcp[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrcp_t.hrat01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             SELECT hrat01,hrat02,hrat04,hrat05,hrat19,hrat03
               INTO g_hrcp[l_ac].hrat01,g_hrcp[l_ac].hrat02,g_hrcp[l_ac].hrat04,g_hrcp[l_ac].hrat05,g_hrcp[l_ac].hrat19,g_hrcp[l_ac].hrat03
               FROM hrat_file
              WHERE hratid = g_hrcp[l_ac].hrat01
             SELECT hrao02 INTO g_hrcp[l_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrcp[l_ac].hrat04
             SELECT hrap06 INTO g_hrcp[l_ac].hras04 FROM hrap_file
              WHERE hrap05 = g_hrcp[l_ac].hrat05 AND hrap01 = g_hrcp[l_ac].hrat04

             SELECT hrad03 INTO g_hrcp[l_ac].hrat19_name  FROM hrad_file WHERE hrad02=g_hrcp[l_ac].hrat19
             SELECT hrbo03 INTO g_hrcp[l_ac].hrcp04_name FROM hrbo_file WHERE hrbo02 = g_hrcp[l_ac].hrcp04
             SELECT hrag07 INTO g_hrcp[l_ac].hrag07 FROM hrag_file WHERE hrag01='505' AND hrag06=g_hrcp[l_ac].hrag07
#             SELECT hrbm04 INTO g_hrcp[l_ac].hrcp10_name FROM hrbm_file WHERE hrbm03 = g_hrcp[l_ac].hrcp10
#             SELECT hrbm04 INTO g_hrcp[l_ac].hrcp12_name FROM hrbm_file WHERE hrbm03 = g_hrcp[l_ac].hrcp12
#             SELECT hrbm04 INTO g_hrcp[l_ac].hrcp14_name FROM hrbm_file WHERE hrbm03 = g_hrcp[l_ac].hrcp14
#             SELECT hrbm04 INTO g_hrcp[l_ac].hrcp16_name FROM hrbm_file WHERE hrbm03 = g_hrcp[l_ac].hrcp16
#             SELECT hrbm04 INTO g_hrcp[l_ac].hrcp18_name FROM hrbm_file WHERE hrbm03 = g_hrcp[l_ac].hrcp18
#             SELECT hrbm04 INTO g_hrcp[l_ac].hrcp20_name FROM hrbm_file WHERE hrbm03 = g_hrcp[l_ac].hrcp20

             CALL cl_show_fld_cont()
          END IF

       AFTER FIELD hrcp04
           IF g_hrcp[l_ac].hrcp04!=g_hrcp_t.hrcp04 THEN
              LET g_hrcp[l_ac].hrcp05=NULL
              #LET l_sql="SELECT hrboa02,hrboa05 FROM hrboa_file",
              #          " WHERE hrboa15='",g_hrcp[l_ac].hrcp04,"' AND hrboa08='001'",
              #          " ORDER BY hrboa01"
              #PREPARE hrcp05_p FROM l_sql
              #DECLARE hrcp05_c CURSOR FOR hrcp05_p
              #FOREACH hrcp05_c INTO l_hrboa02,l_hrboa05
              #   IF cl_null(g_hrcp[l_ac].hrcp05) THEN
              #      LET g_hrcp[l_ac].hrcp05=l_hrboa02,'-',l_hrboa05
              #   ELSE
              #      LET g_hrcp[l_ac].hrcp05=g_hrcp[l_ac].hrcp05,'|',l_hrboa02,'-',l_hrboa05
              #   END IF
              #END FOREACH
              #LET g_hrcp[l_ac].hrcp07='Y'
              SELECT hrbo03,hrbo15 INTO g_hrcp[l_ac].hrcp04_name,g_hrcp[l_ac].hrcp05 FROM hrbo_file WHERE hrbo02 = g_hrcp[l_ac].hrcp04
              DISPLAY BY NAME g_hrcp[l_ac].hrcp05,g_hrcp[l_ac].hrcp04_name,g_hrcp[l_ac].hrcp07
           END IF

       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hrcp[l_ac].* = g_hrcp_t.*
             CLOSE i056_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF g_hrcp[l_ac].hrcpconf='Y' THEN
             CALL cl_err('','ghr-155',0)
             LET g_hrcp[l_ac].*=g_hrcp_t.*
             CLOSE i056_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF

          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hrcp[l_ac].hrat01,-263,0)
             LET g_hrcp[l_ac].* = g_hrcp_t.*
          ELSE
             SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcp[l_ac].hrat01 AND rownum = 1
             UPDATE hrcp_file SET hrcp04=g_hrcp[l_ac].hrcp04,
                                  hrcp05=g_hrcp[l_ac].hrcp05,
                                  hrcp06=g_hrcp[l_ac].hrcp06,
                                  hrcp07='Y',
                                  hrcp35='N',
                                  hrcpmodu=g_user,
                                  hrcpdate=g_today
                            WHERE hrcp03 = g_hrcp_t.hrcp03
                              AND hrcp02 = l_hratid
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hrcp_file",g_hrcp_t.hrcp01,"",SQLCA.sqlcode,"","",1)
                LET g_hrcp[l_ac].* = g_hrcp_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
                SELECT hrat01,hrcp03 INTO l_hrcp02,l_hrcp03 FROM hrcp_file LEFT join hrat_file ON hratid=hrcp02 WHERE hrcp01=g_hrcp_t.hrcp01
                LET l_sql="ghrp056 Y ",l_hrcp03," ",l_hrcp03," 1 ",l_hrcp02," "
                CALL cl_cmdrun_wait(l_sql)
             END IF
          END IF

       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hrcp[l_ac].* = g_hrcp_t.*
             END IF
             CLOSE i056_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF

          CLOSE i056_bcl
          COMMIT WORK

       ON ACTION controlp
          CASE
              WHEN INFIELD(hrcp06)
                 CALL i056_hrcp06_gen() RETURNING g_hrcp[l_ac].hrcp06
                 DISPLAY BY NAME g_hrcp[l_ac].hrcp06
                 NEXT FIELD hrcp06
              WHEN INFIELD(hrcp04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbo02"
                 CALL cl_create_qry() RETURNING g_hrcp[l_ac].hrcp04
                 DISPLAY BY NAME g_hrcp[l_ac].hrcp04
                 NEXT FIELD hrcp04
          END CASE

       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hrat01) AND l_ac > 1 THEN
             LET g_hrcp[l_ac].* = g_hrcp[l_ac-1].*
             NEXT FIELD hrat01
          END IF

       ON ACTION CONTROLZ
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

   END INPUT

   CLOSE i056_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i056_b_askkey()
 DEFINE l_wc            STRING  #160818 add by zhangtn
 
    CLEAR FORM
    CALL g_hrcp.clear()
    LET g_rec_b=0

    CONSTRUCT g_wc ON hrat03,hrat01,hrat02,hrat04,hrat87,hrat88,hrat05,hrat19,hrcp03,hrcp04,hrcp07,hrcp08,
                      hrcp10,hrcp11,hrcp12,hrcp40,hrcp41,hrcp42,hrcp13,hrcp14,hrcp15,hrcp16,hrcp17,hrcp18,hrcp19,hrcp20,hrcp21,hrcp37,
                      hrcp38,hrcp39,hrcp43,hrcp44,hrcp45,hrcp46,hrcp47,hrcp48,hrcp49,hrcp50,hrcp51,hrcpconf
         FROM s_hrcp[1].hrat03,s_hrcp[1].hrat01,s_hrcp[1].hrat02,s_hrcp[1].hrat04,s_hrcp[1].hrat87,s_hrcp[1].hrat88,s_hrcp[1].hrat05,s_hrcp[1].hrat19,s_hrcp[1].hrcp03,s_hrcp[1].hrcp04,s_hrcp[1].hrcp07,s_hrcp[1].hrcp08,
              s_hrcp[1].hrcp10,s_hrcp[1].hrcp11,s_hrcp[1].hrcp12,s_hrcp[1].hrcp40,s_hrcp[1].hrcp41,s_hrcp[1].hrcp42,s_hrcp[1].hrcp13,s_hrcp[1].hrcp14,s_hrcp[1].hrcp15,s_hrcp[1].hrcp16,s_hrcp[1].hrcp17,s_hrcp[1].hrcp18,s_hrcp[1].hrcp19,s_hrcp[1].hrcp20,s_hrcp[1].hrcp21,s_hrcp[1].hrcp37,
              s_hrcp[1].hrcp38,s_hrcp[1].hrcp39,s_hrcp[1].hrcp43,s_hrcp[1].hrcp44,s_hrcp[1].hrcp45,s_hrcp[1].hrcp46,s_hrcp[1].hrcp47,s_hrcp[1].hrcp48,s_hrcp[1].hrcp49,s_hrcp[1].hrcp50,s_hrcp[1].hrcp51,s_hrcp[1].hrcpconf

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_hrao01_1"
               #  LET g_qryparam.arg1='1'#部门
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat87)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_hrao01"
                 LET g_qryparam.arg1='2'#课
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat87
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat88)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_hrao01"
                 LET g_qryparam.arg1='3'#组
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat88
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat05
                 NEXT FIELD hrat05
              #FUN-151118 wangjya
              WHEN INFIELD(hrat19)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrad02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat19
                 NEXT FIELD hrat19
              #FUN-151118 wangjya
              WHEN INFIELD(hrcp04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbo02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcp04
                 NEXT FIELD hrcp04
              WHEN INFIELD(hrcp10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcp10
                 NEXT FIELD hrcp10
              WHEN INFIELD(hrcp12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcp12
                 NEXT FIELD hrcp12
              WHEN INFIELD(hrcp14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcp14
                 NEXT FIELD hrcp14
              WHEN INFIELD(hrcp16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcp16
                 NEXT FIELD hrcp16
              WHEN INFIELD(hrcp18)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcp18
                 NEXT FIELD hrcp18
              WHEN INFIELD(hrcp20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcp20
                 NEXT FIELD hrcp20
         OTHERWISE EXIT CASE
         END CASE

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()


      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcpuser', 'hrcpgrup') #FUN-980030
   # CALL cl_get_hrzxa(g_user) RETURNING l_wc #160818 add by zhangtn
   # LET g_wc = g_wc CLIPPED," AND ",l_wc CLIPPED #160818 add by zhangtn 

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc = NULL
       RETURN
    END IF

    CALL i056_b_fill()

END FUNCTION

FUNCTION i056_b_fill()
    LET g_sql = "SELECT 'N',hrat03,hrcp01,hrat01,hrat02,hrat04,'',hrat87,hrat88,hrat05,'',hrat19,'',hrcp03,hrcp04,'',hrcp05,hrcp06,hrcp07,",
                "       hrcp08,hrcp09,hrcp10,hrcp11,hrcp12,hrcp40,hrcp41,hrcp42,hrcp13,hrcp14,hrcp15,hrcp16,hrcp17,",
                "       hrcp18,hrcp19,hrcp20,hrcp21,hrcp37,hrcp38,hrcp39,hrcp43,hrcp44,hrcp45,hrcp46,hrcp47,hrcp48,hrcp49,hrcp50,hrcp51,hrcp22,hrcp23,hrcp24,hrcp25,hrcp26,hrcp27,hrcp28,",
                "       hrcp29,hrcp30,hrcp31,hrcp32,hrcp33,hrcp34,hrcp35,hrat90,hrcpconf,hrcpud03,hrcpud01 ",
                " FROM hrcp_file,hrat_file ",
                " WHERE hrcp02 = hratid AND ", g_wc CLIPPED,
                " ORDER BY hrat01,hrcp03"

    PREPARE i056_pb FROM g_sql
    DECLARE hrcp_curs CURSOR FOR i056_pb

    CALL g_hrcp.clear()
    CALL g_hrcp_colour.clear()


    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrcp_curs INTO g_hrcp[g_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT hrao02 INTO g_hrcp[g_cnt].hrao02 FROM hrao_file WHERE hrao01 = g_hrcp[g_cnt].hrat04
        SELECT hras04 INTO g_hrcp[g_cnt].hras04 FROM hras_file  WHERE hras01 = g_hrcp[g_cnt].hrat05
        SELECT hrad03 INTO g_hrcp[g_cnt].hrat19_name  FROM hrad_file WHERE hrad02=g_hrcp[g_cnt].hrat19

        SELECT hrbo03 INTO g_hrcp[g_cnt].hrcp04_name FROM hrbo_file WHERE hrbo02 = g_hrcp[g_cnt].hrcp04
        SELECT hrag07 INTO g_hrcp[g_cnt].hrag07 FROM hrag_file WHERE hrag01='505' AND hrag06=g_hrcp[g_cnt].hrag07
#        SELECT hrbm04 INTO g_hrcp[g_cnt].hrcp10_name FROM hrbm_file WHERE hrbm03 = g_hrcp[g_cnt].hrcp10
#        SELECT hrbm04 INTO g_hrcp[g_cnt].hrcp12_name FROM hrbm_file WHERE hrbm03 = g_hrcp[g_cnt].hrcp12
#        SELECT hrbm04 INTO g_hrcp[g_cnt].hrcp14_name FROM hrbm_file WHERE hrbm03 = g_hrcp[g_cnt].hrcp14
#        SELECT hrbm04 INTO g_hrcp[g_cnt].hrcp16_name FROM hrbm_file WHERE hrbm03 = g_hrcp[g_cnt].hrcp16
#        SELECT hrbm04 INTO g_hrcp[g_cnt].hrcp18_name FROM hrbm_file WHERE hrbm03 = g_hrcp[g_cnt].hrcp18
#        SELECT hrbm04 INTO g_hrcp[g_cnt].hrcp20_name FROM hrbm_file WHERE hrbm03 = g_hrcp[g_cnt].hrcp20
        SELECT hrao02 INTO g_hrcp[g_cnt].hrat87 FROM hrao_file WHERE hrao01=g_hrcp[g_cnt].hrat87
        SELECT hrao02 INTO g_hrcp[g_cnt].hrat88 FROM hrao_file WHERE hrao01=g_hrcp[g_cnt].hrat88
        IF g_hrcp[g_cnt].hrcp08='92' THEN
          CALL i056_set_colour(g_cnt,'red')
        ELSE
          CALL i056_set_colour(g_cnt,'black')
        END IF
        LET g_cnt = g_cnt + 1
        --IF g_cnt > g_max_rec THEN
           --CALL cl_err( '', 9035, 0 )
           --EXIT FOREACH
        --END IF
    END FOREACH
    CALL g_hrcp.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2

END FUNCTION

FUNCTION i056_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrcp TO s_hrcp.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY
         CALL cl_navigator_setting(1,1)
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL DIALOG.setArrayAttributes("s_hrcp",g_hrcp_colour)

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY

#      ON ACTION auto_generate
#         LET g_action_choice="auto_generate"
#         EXIT DISPLAY

      ON ACTION exceltoreport
         LET g_action_choice="exceltoreport"
         EXIT DISPLAY

      ON ACTION dateupdate
         LET g_action_choice="dateupdate"
         EXIT DISPLAY

     ON ACTION dateupdate_group
         LET g_action_choice="dateupdate_group"
         EXIT DISPLAY

      ON ACTION exporttoexcel  # 141016
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION importresult
         LET g_action_choice="importresult"
         EXIT DISPLAY

      ON ACTION cardtimeshow
         LET g_action_choice="cardtimeshow"
         EXIT DISPLAY

#      #160901 add by zhangtn---str--
#      ON ACTION open_ghrq056
#         LET g_action_choice="open_ghrq056"
#         EXIT DISPLAY
#      #160901 add by zhangtn---end--


         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i056_confirm(p_cmd)
  DEFINE l_hrcp35     LIKE hrcp_file.hrcp35
  DEFINE p_cmd        LIKE type_file.chr1
  DEFINE l_i          LIKE type_file.num10

  CALL cl_set_comp_visible('check',TRUE)
  CALL cl_set_comp_entry('hrcp04,hrcp06',FALSE)
  INPUT ARRAY g_hrcp WITHOUT DEFAULTS FROM s_hrcp.*
     ATTRIBUTE (COUNT=g_rec_b,UNBUFFERED,
                INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

      ON ACTION sel_all
         LET g_action_choice="sel_all"
         FOR l_i = 1 TO g_rec_b
             LET g_hrcp[l_i].check = 'Y'
             DISPLAY BY NAME g_hrcp[l_i].check
         END FOR

      ON ACTION sel_none
         LET g_action_choice="sel_none"
         FOR l_i = 1 TO g_rec_b
             LET g_hrcp[l_i].check = 'N'
             DISPLAY BY NAME g_hrcp[l_i].check
         END FOR

      ON ACTION accept
         FOR l_i = 1 TO g_rec_b
             IF g_hrcp[l_i].check = 'Y' THEN
                SELECT hrcp35 INTO l_hrcp35 FROM hrcp_file WHERE hrcp01=g_hrcp[l_i].hrcp01
                IF l_hrcp35='N' THEN
                   CONTINUE FOR
                END IF
                UPDATE hrcp_file SET hrcpconf = p_cmd WHERE hrcp01 = g_hrcp[l_i].hrcp01
             END IF
         END FOR
         EXIT INPUT

     ON ACTION CANCEL
        LET INT_FLAG=0
        EXIT INPUT

  END INPUT
  CALL cl_set_comp_visible('check',FALSE)
  CALL cl_set_comp_entry('hrcp04,hrcp06',TRUE)
  CALL i056_b_fill()
END FUNCTION

FUNCTION i056_hrcp06_gen()
DEFINE tm  RECORD
       bm1 LIKE type_file.chr5,
       em1 LIKE type_file.chr5,
       bm2 LIKE type_file.chr5,
       em2 LIKE type_file.chr5,
       bm3 LIKE type_file.chr5,
       em3 LIKE type_file.chr5,
       bm4 LIKE type_file.chr5,
       em4 LIKE type_file.chr5
       END RECORD
DEFINE l_str LIKE hrcp_file.hrcp06

  OPEN WINDOW i056_w1 WITH FORM "ghr/42f/ghri056_1"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("ghri056_1")
  CALL cl_set_label_justify("i056_w1","right")
  INPUT tm.bm1,tm.em1,tm.bm2,tm.em2,tm.bm3,tm.em3,tm.bm4,tm.em4
    WITHOUT DEFAULTS FROM bm1,em1,bm2,em2,bm3,em3,bm4,em4

       BEFORE INPUT
          LET tm.bm1="00:00"
          LET tm.bm2="00:00"
          LET tm.bm3="00:00"
          LET tm.bm4="00:00"
          LET tm.em1="00:00"
          LET tm.em2="00:00"
          LET tm.em3="00:00"
          LET tm.em4="00:00"
          DISPLAY BY NAME tm.*

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CALL cl_err('',9001,0)
      CLOSE WINDOW i056_w1
      RETURN ''
   END IF
   IF tm.em1>tm.bm1 THEN
      LET l_str=tm.bm1,'-',tm.em1
   END IF
   IF tm.em2>tm.bm2 THEN
      IF NOT cl_null(l_str) THEN
         LET l_str=l_str,'|',tm.bm2,'-',tm.em2
      ELSE
         LET l_str=tm.bm2,'-',tm.em2
      END IF
   END IF
   IF tm.em3>tm.bm3 THEN
      IF NOT cl_null(l_str) THEN
         LET l_str=l_str,'|',tm.bm3,'-',tm.em3
      ELSE
         LET l_str=tm.bm3,'-',tm.em3
      END IF
   END IF
   IF tm.em4>tm.bm4 THEN
      IF NOT cl_null(l_str) THEN
         LET l_str=l_str,'|',tm.bm4,'-',tm.em4
      ELSE
         LET l_str=tm.bm4,'-',tm.em4
      END IF
   END IF

   CLOSE WINDOW i056_w1
   RETURN l_str
END FUNCTION

#FUNCTION i056_auto_generate()
#DEFINE b_date  LIKE type_file.dat
#DEFINE e_date  LIKE type_file.dat
#DEFINE type    LIKE type_file.chr1
#DEFINE l_msg   STRING
#DEFINE l_str   STRING
#DEFINE hrat03  LIKE hrat_file.hrat03
#DEFINE hrat03_name LIKE hraa_file.hraa12
#
#  OPEN WINDOW i056_w2  WITH FORM "ghr/42f/ghri056_2"
#   ATTRIBUTE (STYLE = g_win_style CLIPPED)
#  CALL cl_ui_locale("ghri056_2")
#
#  INPUT BY NAME b_date,e_date,hrat03,type,l_str WITHOUT DEFAULTS
#
#        BEFORE INPUT
#           LET b_date=g_today
#           LET e_date=g_today
#           LET type='1'
#           DISPLAY BY NAME b_date,e_date,type
#
#        AFTER FIELD hrat03
#         IF NOT cl_null(hrat03) THEN
#            SELECT hraa12 INTO hrat03_name FROM hraa_file WHERE hraa01=hrat03
#            DISPLAY hrat03_name TO hrat03_name
#         END IF
#
#        ON ACTION controlp
#           CASE
#            WHEN INFIELD (l_str)
#               CALL cl_init_qry_var()
#                        
#               IF type='1' THEN
#                #  LET g_qryparam.form = "q_hrat01"
#                  CALL q_hrat(TRUE, "q_hrat","")  RETURNING  l_str
#               ELSE
#                   LET g_qryparam.form = "q_hrcb"
#                   LET g_qryparam.state = "c"
#                   CALL cl_create_qry() RETURNING l_str
#               END IF     
#               DISPLAY BY NAME l_str
#               NEXT FIELD l_str
#
#            WHEN INFIELD(hrat03)
#             CALL cl_init_qry_var()
#             LET g_qryparam.form ="q_hraa01"
#             LET g_qryparam.default1 = hrat03
#             CALL cl_create_qry() RETURNING hrat03
#             DISPLAY BY NAME hrat03
#             SELECT hraa12 INTO hrat03_name FROM hraa_file WHERE hraa01=hrat03
#             DISPLAY hrat03_name TO hrat03_name
#             NEXT FIELD hrat03
#
#           END CASE
#
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
#
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
#
#        ON ACTION CONTROLF
#           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about
#           CALL cl_about()
#
#        ON ACTION help
#           CALL cl_show_help()
#  END INPUT
#
#  IF INT_FLAG THEN
#     LET INT_FLAG=0
#     CLOSE WINDOW i056_w2
#     RETURN
#  END IF
#  IF cl_null(l_str) THEN
#   LET l_str="-"
#END IF
#  CALL cl_replace_str(l_str,'|',',') RETURNING l_str
#  LET l_msg="ghrp056 F ",b_date," ",e_date," ",type," ",l_str," ",hrat03," "
#  CALL cl_cmdrun_wait(l_msg)
#  CLOSE WINDOW i056_w2
#  CALL i056_b_fill()
#END FUNCTION



FUNCTION i056_dateupdate_group()
DEFINE b_date  LIKE type_file.dat
DEFINE e_date  LIKE type_file.dat
DEFINE type    LIKE type_file.chr1
DEFINE l_msg,l_sql   STRING
DEFINE l_str,l_namet   STRING
DEFINE hrat03  LIKE hrat_file.hrat03
DEFINE hrat03_name LIKE hraa_file.hraa12
DEFINE l_pid  LIKE type_file.chr20
DEFINE l_n,l_a,l_n1    LIKE type_file.num10
DEFINE l_hrat01 LIKE hrat_file.hrat01
  OPEN WINDOW i056_w2  WITH FORM "ghr/42f/ghri056_2"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("ghri056_2")
       
  INPUT BY NAME b_date,e_date,hrat03,type,l_str WITHOUT DEFAULTS

        BEFORE INPUT
           LET b_date=g_today
           LET e_date=g_today
           LET type='1'
           DISPLAY BY NAME b_date,e_date,type
       
        AFTER FIELD hrat03
         IF NOT cl_null(hrat03) THEN
            SELECT hraa12 INTO hrat03_name FROM hraa_file WHERE hraa01=hrat03
            DISPLAY hrat03_name TO hrat03_name
         END IF
        AFTER FIELD b_date
          IF NOT cl_null(b_date) THEN
             IF b_date>g_today THEN
                CALL cl_err('日期不可大于当前日期','!',1)
                NEXT FIELD b_date
             END IF
          END IF
        AFTER FIELD e_date
          IF NOT cl_null(e_date) THEN
             IF e_date>g_today THEN
                CALL cl_err('日期不可大于当前日期','!',1)
                NEXT FIELD e_date
             END IF
             IF  NOT cl_null(b_date) AND b_date>e_date  THEN
                CALL cl_err('开始日期不可大于结束日期','!',1)
                NEXT FIELD b_date
             END IF
          END IF
        ON ACTION controlp
           CASE
            WHEN INFIELD (l_str)
               CALL cl_init_qry_var()
               IF type='1' THEN
                  LET g_qryparam.form = "q_hrat01"
               ELSE
                  LET g_qryparam.form = "q_hrao01"
               END IF
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING l_str
               DISPLAY BY NAME l_str
               NEXT FIELD l_str

            WHEN INFIELD(hrat03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hraa01"
             LET g_qryparam.default1 = hrat03
             CALL cl_create_qry() RETURNING hrat03
             DISPLAY BY NAME hrat03
             SELECT hraa12 INTO hrat03_name FROM hraa_file WHERE hraa01=hrat03
             DISPLAY hrat03_name TO hrat03_name
             NEXT FIELD hrat03

           END CASE

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()
  END INPUT

  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW i056_w2
     RETURN
  END IF
  IF cl_null(l_str) THEN
   LET l_str="-"
END IF
  #CALL cl_replace_str(l_str,'|',',') RETURNING l_str
  CALL cl_replace_str(l_str,'|',''',''') RETURNING l_str
  #add by zhuzw 20151201 start #全选分批次处理
  #IF l_str ='-' THEN
#   #add by zhuzw 20160415 start 强制处理
#   LET l_sql="UPDATE hrcp_file SET hrcp35='N' ",
#          " WHERE hrcp03 BETWEEN '",b_date,"' AND '",e_date,"' "
#   IF NOT cl_null(hrat03) THEN 
#      LET l_sql = l_sql," AND hrat03 = '",hrat03,"' "
#   END IF        
#   PREPARE i056_reset1 FROM l_sql
#   EXECUTE i056_reset1
#   #add by zhuzw 20160415 end 
  #临时测试 str
     LET l_pid = FGL_GETPID()
     IF cl_null(hrat03) THEN 
        LET hrat03 = '-' 
     END IF  
     UPDATE hrat_file SET hrat91 = '' 
     #SELECT ceil((COUNT(*) - mod(COUNT(*),5))/5)INTO l_n FROM hrat_file WHERE hrat25 <= b_date AND  hrat77 >= b_date AND  hratconf = 'Y'      
     #LET l_sql = " SELECT ceil((COUNT(*) - mod(COUNT(*),5))/5) FROM hrat_file WHERE hrat25 <= '",b_date,"' AND  hrat77 >= '",b_date,"' AND  hratconf = 'Y' "
     #modify by nixiang 170630
     LET l_sql = " SELECT ceil((COUNT(*) - mod(COUNT(*),5))/5) FROM hrat_file WHERE hrat25 <= '",b_date,"' AND (hrat77 >= '",b_date,"' or hrat77 IS NULL) AND  hratconf = 'Y' "
     IF l_str="-" THEN 
     ELSE 
      IF type = '1' THEN 
         LET l_sql = l_sql," AND hrat01 IN ('",l_str,"')  "    
      END IF 
      IF type = '2' THEN 
 #        LET l_sql = l_sql," AND hrat03 IN ('",l_str,"')  "      #mark by fangyaunz171220
         LET l_sql = l_sql," AND hrat04 IN ('",l_str,"')  "      #add by fangyuanz171220  
      END IF 
     END IF 
     PREPARE i056_hrat_n FROM l_sql
     EXECUTE i056_hrat_n INTO l_n
     #LET l_sql = " select rownum,hrat01 from hrat_file where hrat25 <= '",b_date,"' AND  hrat77 >= '",b_date,"' AND  hratconf = 'Y' "
     #modify by nixiang 170630
     LET l_sql = " select rownum,hrat01 from hrat_file where hrat25 <= '",b_date,"' AND (hrat77 >= '",b_date,"' or hrat77 IS NULL) AND  hratconf = 'Y' "
     #人员？部门？
     IF l_str="-" THEN 
     ELSE 
      IF type = '1' THEN 
         LET l_sql = l_sql," AND hrat01 IN ('",l_str,"')  "    
      END IF 
      IF type = '2' THEN 
       #  LET l_sql = l_sql," AND hrat03 IN ('",l_str,"')  "     #mark by fangyaunz171220
         LET l_sql = l_sql," AND hrat04 IN ('",l_str,"')  "      #add by fangyuanz171220
      END IF  
     END IF 
     
     #end
     IF l_n = 0 THEN LET l_n = 1 END IF 
     PREPARE i056_hrat FROM l_sql
     DECLARE i056_hrats CURSOR FOR i056_hrat
     FOREACH i056_hrats INTO l_a,l_hrat01
        SELECT ceil(l_a/l_n) INTO l_n1 FROM dual
        IF l_n1 > 5 THEN 
           LET l_n1 = 5 
        END IF 
           UPDATE hrat_file SET hrat91 = l_n1 
            WHERE hrat01 = l_hrat01 
     END FOREACH 
    
     LET l_msg="ghrp056 X ",b_date," ",e_date," ",'3'," ",'1'," ",hrat03," ",l_pid,"  "
     CALL cl_cmdrun(l_msg)   
     LET l_msg="ghrp056 X ",b_date," ",e_date," ",'3'," ",'2'," ",hrat03,"  ",l_pid," "
     CALL cl_cmdrun(l_msg)
     LET l_msg="ghrp056 X ",b_date," ",e_date," ",'3'," ",'3'," ",hrat03,"  ",l_pid," "
     CALL cl_cmdrun(l_msg)
     LET l_msg="ghrp056 X ",b_date," ",e_date," ",'3'," ",'4'," ",hrat03,"  ",l_pid," "
     CALL cl_cmdrun(l_msg)
     LET l_msg="ghrp056 X ",b_date," ",e_date," ",'3'," ",'5'," ",hrat03,"  ",l_pid," "     
     CALL  cl_cmdrun_wait(l_msg)    
   
     #add by zhuzw 20160330 start 检测p处理是否结束
     SLEEP 5
     SELECT COUNT(*) INTO l_n  FROM tc_pid_file
      WHERE tc_pid01 = l_pid
     WHILE l_n >0 
        SELECT COUNT(*) INTO l_n  FROM tc_pid_file
        WHERE tc_pid01 = l_pid
        IF l_n >0 THEN             
           SLEEP 10
           CONTINUE WHILE 
        ELSE 
        	 EXIT WHILE    
        END IF 
     END WHILE 
     #add by zhuzw 20160330 end 
   CALL cl_err('','ghr-033',1)
  CLOSE WINDOW i056_w2
  CALL i056_b_fill()
END FUNCTION




FUNCTION i056_exceltoreport()
DEFINE l_file     LIKE type_file.chr200
DEFINE l_name     LIKE type_file.chr200
DEFINE l_count    LIKE type_file.num10
DEFINE l_sql      STRING
DEFINE xlApp      INTEGER
DEFINE iRes       INTEGER
DEFINE iRow       INTEGER
DEFINE iColumn    INTEGER
DEFINE iDay       INTEGER
DEFINE i,j,k      LIKE type_file.num10
DEFINE l_hrcp     RECORD LIKE hrcp_file.*
DEFINE p_hrcp     RECORD LIKE hrcp_file.*
DEFINE l_cnt      LIKE type_file.num10
DEFINE l_hrboa02  LIKE hrboa_file.hrboa02
DEFINE l_hrboa05  LIKE hrboa_file.hrboa05
DEFINE l_date     LIKE hrcp_file.hrcp03
DEFINE l_hrbo03     LIKE hrbo_file.hrbo03
DEFINE l_err     LIKE type_file.chr200
DEFINE l_hrat01  LIKE hrat_file.hrat01
DEFINE l_hrat04  LIKE hrat_file.hrat04
DEFINE l_hrat87  LIKE hrat_file.hrat87 

    INITIALIZE l_hrcp.* TO NULL
    LET l_hrcp.hrcp07='Y'
    LET l_hrcp.hrcp35='N'
    LET l_hrcp.hrcp36='N'
    LET l_hrcp.hrcpconf='N'
    LET l_hrcp.hrcpacti='Y'
    LET l_hrcp.hrcpuser=g_user
    LET l_hrcp.hrcpgrup=g_grup
    LET l_hrcp.hrcpmodu=g_user
    LET l_hrcp.hrcpdate=g_today
    LET l_hrcp.hrcporig=g_grup
    LET l_hrcp.hrcporiu=g_user

   LET l_sql="SELECT hrboa02,hrboa05 FROM hrboa_file",
             " WHERE hrboa15=? AND hrboa08='001'",
             " ORDER BY hrboa01"
   #PREPARE p_hrcp05_p FROM l_sql
   #DECLARE p_hrcp05_c CURSOR FOR p_hrcp05_p

   LET l_file = cl_browse_file()
   LET l_file = l_file CLIPPED
   IF NOT cl_null(l_file) THEN
      LET l_count=length(l_file)
      IF l_count=0 THEN
         RETURN
      END IF
      LET l_sql=l_file
      CALL ui.interface.frontCall('WinCOM','CreateInstance',['Excel.Application'],[xlApp])
      IF xlApp <> -1 THEN
         CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'WorkBooks.Open',l_sql],[iRes])
         IF iRes<>-1 THEN
            CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
            CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Columns.Count'],[iColumn])
            CALL cl_progress_bar(iROW-2)
            FOR i=3 TO iRow
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[l_hrcp.hrcp02])  #读取员工工号
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[l_name])  #读取员工姓名
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[l_date]) #读取排班月份
                IF (cl_null(l_hrcp.hrcp02) OR l_hrcp.hrcp02=' ') THEN
                   CALL cl_progress_bar(iROW-2)
                   CONTINUE FOR
                END IF
                FOR j=4 TO 34 STEP 1
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells(1,'||j||').Value'],[iDay]) #读取排班日
                   #CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||j||').Value'],[l_hrcp.hrcp04]) #读取排班班次名称
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||j||').Value'],[l_hrbo03]) #读取排班班次名称
#                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||','||j+1||').Value'],[l_hrcp.HRCPUD07]) #读取班次工时
                   select l_date+iDay-1 into l_hrcp.hrcp03 from dual
                   IF (cl_null(l_hrbo03) OR l_hrbo03=' ') AND (cl_null(l_hrcp.hrcp06) OR l_hrcp.hrcp06=' ') THEN
                      CONTINUE FOR
                   END IF
                   SELECT hratid INTO l_hrcp.hrcp02 FROM hrat_file WHERE hrat01=l_hrcp.hrcp02 AND rownum=1  #获取员工ID
                   SELECT count(*) INTO l_cnt FROM hrcp_file WHERE hrcp02=l_hrcp.hrcp02 AND hrcp03=l_hrcp.hrcp03  #查询是否员工当天已经存在考勤汇总记录
                   LET l_hrcp.hrcp05=' '  #初始化班次标准时间
                   IF l_cnt=0 THEN #新插入数据
                      SELECT max(hrcp01)+1 INTO l_hrcp.hrcp01 FROM hrcp_file  #设置记录ID
                      IF cl_null(l_hrcp.hrcp01) THEN LET l_hrcp.hrcp01=1 END IF
                      IF cl_null(l_hrbo03) OR l_hrbo03=' ' THEN   #设置班次标准时间
                         LET l_hrcp.hrcp05=' '
                      ELSE
                         SELECT hrbo02,hrbo15 INTO l_hrcp.hrcp04,l_hrcp.hrcp05 FROM hrbo_file WHERE hrbo03=l_hrbo03
                      END IF
                      IF cl_null(l_hrcp.hrcp04) THEN
                         LET l_err = '班次名称 ',l_hrbo03,' 错误'
                         CALL cl_err(l_err,'!',1)
                        # CALL cl_err('班次名称错误','!',1)
                         CONTINUE FOR
                      END IF
                      LET l_hrcp.hrcp35 = 'N'
                       
####nihuan add start
               SELECT hrat01,hrat04,hrat87 INTO l_hrat01,l_hrat04,l_hrat87
               FROM hrat_file WHERE hratid=l_hrcp.hrcp02
               IF NOT cl_null(l_hrat87) THEN 
                SELECT NVL(hrao12,hrao01) INTO l_hrcp.hrcpgrup FROM hrao_file WHERE hrao01 = l_hrat87
               ELSE 
                SELECT NVL(hrao12,hrao01) INTO l_hrcp.hrcpgrup FROM hrao_file WHERE hrao01 = l_hrat04
               END IF 
               LET l_hrcp.hrcpuser = l_hrat01
####nihuan add end  
                      INSERT INTO hrcp_file VALUES (l_hrcp.*)
                   ELSE #调整有数据
                      SELECT * INTO p_hrcp.* FROM hrcp_file
                       WHERE hrcp02=l_hrcp.hrcp02 AND hrcp03=l_hrcp.hrcp03
                      IF p_hrcp.hrcpconf='Y' THEN
                         CONTINUE FOR
                      ELSE
                         IF NOT (cl_null(l_hrbo03) OR l_hrbo03=' ') THEN
                            SELECT hrbo02,hrbo15 INTO l_hrcp.hrcp04,l_hrcp.hrcp05 FROM hrbo_file WHERE hrbo03=l_hrbo03
                            LET p_hrcp.hrcp04=l_hrcp.hrcp04
                            LET p_hrcp.hrcp05=l_hrcp.hrcp05
                         END IF
                      IF cl_null(l_hrcp.hrcp04) THEN
                         LET l_err = '班次名称 ',l_hrbo03,' 错误'
                         CALL cl_err(l_err,'!',1)
                         CONTINUE FOR
                      END IF
                         IF NOT (cl_null(l_hrcp.hrcp06) OR l_hrcp.hrcp06=' ') THEN
                            LET p_hrcp.hrcp06=l_hrcp.hrcp06
                         END IF
                         IF NOT (cl_null(l_hrcp.HRCPUD07) OR l_hrcp.HRCPUD07=' ') THEN
                            LET p_hrcp.HRCPUD07=l_hrcp.HRCPUD07
                         END IF
                         UPDATE hrcp_file SET hrcp04=p_hrcp.hrcp04,
                                              hrcp05=p_hrcp.hrcp05,
                                              hrcp06=p_hrcp.hrcp06,
                                              hrcp07='Y',
                                              hrcp35='N',
                                              hrcpmodu=g_user,
                                              hrcpdate=g_today,
                                              HRCPUD07=p_hrcp.HRCPUD07
                          WHERE hrcp02=l_hrcp.hrcp02 AND hrcp03=l_hrcp.hrcp03
                      END IF
                   END IF
               END FOR
               CALL cl_progressing(l_name)
            END FOR
            CALL cl_err('导入结束','!',1)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i056_importresult()
DEFINE l_file     LIKE type_file.chr200
DEFINE l_name     LIKE type_file.chr200
DEFINE l_count    LIKE type_file.num10
DEFINE l_sql      STRING
DEFINE xlApp      INTEGER
DEFINE iRes       INTEGER
DEFINE iRow       INTEGER
DEFINE iColumn    INTEGER
DEFINE iDay       INTEGER
DEFINE i,j,k      LIKE type_file.num10
DEFINE l_hrcp     RECORD LIKE hrcp_file.*
DEFINE p_hrcp     RECORD LIKE hrcp_file.*
DEFINE l_cnt      LIKE type_file.num10
DEFINE l_hrboa02  LIKE hrboa_file.hrboa02
DEFINE l_hrboa05  LIKE hrboa_file.hrboa05
DEFINE l_date     LIKE hrcp_file.hrcp03
DEFINE l_hrbo03     LIKE hrbo_file.hrbo03
DEFINE l_err     LIKE type_file.chr200

   LET l_file = cl_browse_file()
   LET l_file = l_file CLIPPED
   IF NOT cl_null(l_file) THEN
      LET l_count=length(l_file)
      IF l_count=0 THEN
         RETURN
      END IF
      LET l_sql=l_file
      CALL ui.interface.frontCall('WinCOM','CreateInstance',['Excel.Application'],[xlApp])
      IF xlApp <> -1 THEN
         CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'WorkBooks.Open',l_sql],[iRes])
         IF iRes<>-1 THEN
            CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
            CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Columns.Count'],[iColumn])
            CALL cl_progress_bar(iROW-1)
            FOR i=2 TO iRow
               INITIALIZE l_hrcp.* TO NULL
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[l_hrcp.hrcp02])  #读取员工工号
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[l_hrcp.hrcp03])  #读取结果日期
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[l_hrcp.hrcp04])  #读取结果班次
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[l_hrcp.hrcp10])  #读取项目1
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[l_hrcp.hrcp11])  #读取时间1
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[l_hrcp.hrcp12])  #读取项目2
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[l_hrcp.hrcp13])  #读取时间2
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[l_hrcp.hrcp14])  #读取项目3
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[l_hrcp.hrcp15])  #读取时间3
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[l_hrcp.hrcp16])  #读取项目4
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[l_hrcp.hrcp17])  #读取时间4
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',13).Value'],[l_hrcp.hrcp18])  #读取项目5
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',14).Value'],[l_hrcp.hrcp19])  #读取时间5
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',15).Value'],[l_hrcp.hrcp20])  #读取项目6
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',16).Value'],[l_hrcp.hrcp21])  #读取时间6
                CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',17).Value'],[l_hrcp.hrcp34])  #读取备注
                SELECT hratid INTO l_hrcp.hrcp02 FROM hrat_file WHERE hrat01=l_hrcp.hrcp02
                IF (cl_null(l_hrcp.hrcp02) OR l_hrcp.hrcp02=' ') THEN
                   CALL cl_progressing(l_hrcp.hrcp02)
                   CONTINUE FOR
                END IF
                SELECT COUNT(*) INTO l_count FROM hrcp_file WHERE hrcp02=l_hrcp.hrcp02 AND hrcp03=l_hrcp.hrcp03
                IF l_count < 1 THEN
                   CALL cl_progressing(l_hrcp.hrcp02)
                   CONTINUE FOR
                END IF
                SELECT hrbo15 INTO l_hrcp.hrcp05 FROM hrbo_file WHERE hrbo02=l_hrcp.hrcp04
                IF (cl_null(l_hrcp.hrcp05) OR l_hrcp.hrcp05=' ') THEN
                   CALL cl_progressing(l_hrcp.hrcp02)
                   CONTINUE FOR
                END IF
                UPDATE hrcp_file SET
                   hrcp04=l_hrcp.hrcp04,
                   hrcp05=l_hrcp.hrcp05,
                   hrcp10=l_hrcp.hrcp10,
                   hrcp11=l_hrcp.hrcp11,
                   hrcp12=l_hrcp.hrcp12,
                   hrcp13=l_hrcp.hrcp13,
                   hrcp14=l_hrcp.hrcp14,
                   hrcp15=l_hrcp.hrcp15,
                   hrcp16=l_hrcp.hrcp16,
                   hrcp17=l_hrcp.hrcp17,
                   hrcp18=l_hrcp.hrcp18,
                   hrcp19=l_hrcp.hrcp19,
                   hrcp20=l_hrcp.hrcp20,
                   hrcp21=l_hrcp.hrcp21,
                   hrcp34=l_hrcp.hrcp34,
                   hrcpconf='Y',
                   hrcpdate=g_today
                WHERE hrcp02=l_hrcp.hrcp02 AND hrcp03=l_hrcp.hrcp03
                CALL cl_progressing(l_hrcp.hrcp02)
             END FOR
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION i056_set_colour(p_ac,p_colour)
  DEFINE　p_ac LIKE type_file.num10
  DEFINE p_colour STRING

 LET g_hrcp_colour[p_ac].check       =p_colour
 LET g_hrcp_colour[p_ac].hrat03      =p_colour
 LET g_hrcp_colour[p_ac].hrcp01      =p_colour
 LET g_hrcp_colour[p_ac].hrat01      =p_colour
 LET g_hrcp_colour[p_ac].hrat02      =p_colour
 LET g_hrcp_colour[p_ac].hrat04      =p_colour
 LET g_hrcp_colour[p_ac].hrao02      =p_colour
 LET g_hrcp_colour[p_ac].hrat87      =p_colour
 LET g_hrcp_colour[p_ac].hrat88      =p_colour
 LET g_hrcp_colour[p_ac].hrat05      =p_colour
 LET g_hrcp_colour[p_ac].hras04      =p_colour
 LET g_hrcp_colour[p_ac].hrat19      =p_colour  #FUN-151118 wangjya
 LET g_hrcp_colour[p_ac].hrat19_name =p_colour  #FUN-151118 wangjya
 LET g_hrcp_colour[p_ac].hrcp03      =p_colour
 LET g_hrcp_colour[p_ac].hrcp04      =p_colour
 LET g_hrcp_colour[p_ac].hrcp04_name =p_colour
 LET g_hrcp_colour[p_ac].hrcp05      =p_colour
 LET g_hrcp_colour[p_ac].hrcp06      =p_colour
 LET g_hrcp_colour[p_ac].hrcp07      =p_colour
 LET g_hrcp_colour[p_ac].hrcp08      =p_colour
 LET g_hrcp_colour[p_ac].hrcp09      =p_colour
 LET g_hrcp_colour[p_ac].hrcp10      =p_colour
 LET g_hrcp_colour[p_ac].hrcp11      =p_colour
 LET g_hrcp_colour[p_ac].hrcp12      =p_colour
 LET g_hrcp_colour[p_ac].hrcp40      =p_colour
 LET g_hrcp_colour[p_ac].hrcp41      =p_colour
 LET g_hrcp_colour[p_ac].hrcp42      =p_colour
 LET g_hrcp_colour[p_ac].hrcp13      =p_colour
 LET g_hrcp_colour[p_ac].hrcp14      =p_colour
 LET g_hrcp_colour[p_ac].hrcp15      =p_colour
 LET g_hrcp_colour[p_ac].hrcp16      =p_colour
 LET g_hrcp_colour[p_ac].hrcp17      =p_colour
 LET g_hrcp_colour[p_ac].hrcp18      =p_colour
 LET g_hrcp_colour[p_ac].hrcp19      =p_colour
 LET g_hrcp_colour[p_ac].hrcp20      =p_colour
 LET g_hrcp_colour[p_ac].hrcp21      =p_colour
 LET g_hrcp_colour[p_ac].hrcp37      =p_colour
 LET g_hrcp_colour[p_ac].hrcp38      =p_colour
 LET g_hrcp_colour[p_ac].hrcp39      =p_colour
 LET g_hrcp_colour[p_ac].hrcp43      =p_colour
 LET g_hrcp_colour[p_ac].hrcp44      =p_colour
 LET g_hrcp_colour[p_ac].hrcp45      =p_colour
 LET g_hrcp_colour[p_ac].hrcp46      =p_colour
 LET g_hrcp_colour[p_ac].hrcp47      =p_colour
 LET g_hrcp_colour[p_ac].hrcp48      =p_colour
 LET g_hrcp_colour[p_ac].hrcp49      =p_colour
 LET g_hrcp_colour[p_ac].hrcp50      =p_colour
 LET g_hrcp_colour[p_ac].hrcp51      =p_colour
 LET g_hrcp_colour[p_ac].hrcp22      =p_colour
 LET g_hrcp_colour[p_ac].hrcp23      =p_colour
 LET g_hrcp_colour[p_ac].hrcp24      =p_colour
 LET g_hrcp_colour[p_ac].hrcp25      =p_colour
 LET g_hrcp_colour[p_ac].hrcp26      =p_colour
 LET g_hrcp_colour[p_ac].hrcp27      =p_colour
 LET g_hrcp_colour[p_ac].hrcp28      =p_colour
 LET g_hrcp_colour[p_ac].hrcp29      =p_colour
 LET g_hrcp_colour[p_ac].hrcp30      =p_colour
 LET g_hrcp_colour[p_ac].hrcp31      =p_colour
 LET g_hrcp_colour[p_ac].hrcp32      =p_colour
 LET g_hrcp_colour[p_ac].hrcp33      =p_colour
 LET g_hrcp_colour[p_ac].hrcp34      =p_colour
 LET g_hrcp_colour[p_ac].hrcpconf    =p_colour
 LET g_hrcp_colour[p_ac].hrcpud03    =p_colour
 LET g_hrcp_colour[p_ac].hrcpud01    =p_colour




END FUNCTION

FUNCTION i056_showtimes(phrat01, phrcp03)
DEFINE l_sql      STRING
DEFINE l_times    STRING
DEFINE phrat01    LIKE hrat_file.hrat01
DEFINE phrcp03    LIKE hrcp_file.hrcp03
DEFINE l_from     LIKE hrat_file.hrat02
DEFINE l_hrby05   LIKE hrby_file.hrby05
DEFINE l_hrby06   LIKE hrby_file.hrby06
DEFINE l_hrby   DYNAMIC ARRAY OF RECORD
                lei LIKE hrat_file.hrat02,
                hrby05   LIKE hrby_file.hrby05,
                hrby06   LIKE hrby_file.hrby06
                END RECORD
DEFINE l_i,l_i1      LIKE type_file.num10
  LET l_sql = "SELECT CASE WHEN hrby12='1' THEN N'刷卡采集' ELSE N'补刷卡' END, hrby05, hrby06 FROM hrby_file ",
              "WHERE hrbyacti='Y' AND hrby09=(SELECT hratid FROM hrat_file WHERE hrat01='",phrat01,"') AND ",
              "hrby05 BETWEEN (to_date('",phrcp03,"','yy/mm/dd') - 1) AND (to_date('",phrcp03,"','yy/mm/dd') + 1) ",
              "AND hrby10 <> '4' ",
              "ORDER BY hrby05,hrby06"
  LET l_i = 1
  CALL l_hrby.clear()
  PREPARE get_hrby_pM FROM l_sql
  DECLARE get_hrby_cM CURSOR FOR get_hrby_pM
  FOREACH get_hrby_cM INTO l_hrby[l_i].*
     LET l_i = l_i +1
  END FOREACH
   #CALL g_hrcp.deleteElement(l_i)
    CALL l_hrby.deleteElement(l_i)
    MESSAGE ""
    LET l_i1 = l_i -1
   OPEN WINDOW i056a_w AT 2,3 WITH FORM "ghr/42f/ghri056_a"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
    DISPLAY l_i1 TO FORMONLY.cn
    DISPLAY ARRAY l_hrby TO s_hrby.* ATTRIBUTE(COUNT=l_i1)
    END DISPLAY
   CLOSE WINDOW i056a_w

END FUNCTION

#add by fanguanz171220----S
FUNCTION i056_dateupdate_group1()
DEFINE b_date  LIKE type_file.dat
DEFINE e_date  LIKE type_file.dat
DEFINE type    LIKE type_file.chr1
DEFINE l_msg,l_sql   STRING
DEFINE l_sql2        STRING #add by zyq 
DEFINE l_sql3        STRING #add by zyq
DEFINE l_sql4        STRING #add by zyq
DEFINE l_sql5        STRING #add by zyq 
DEFINE l_str,l_namet   STRING
DEFINE hrat03  LIKE hrat_file.hrat03
DEFINE hrat03_name LIKE hraa_file.hraa12
DEFINE l_pid  LIKE type_file.chr20
DEFINE l_n,l_a,l_n1    LIKE type_file.num10
DEFINE l_hrat01 LIKE hrat_file.hrat01
DEFINE l_hrcn08      LIKE hrcn_file.hrcn08     #add by zyq  è·ååæ¥å ç­æ¶é¿
DEFINE l_hrcn08j     LIKE hrcn_file.hrcn08     #add by zyq  è·åèæ¥å ç­æ¶é¿
DEFINE l_hrcn08p     LIKE hrcn_file.hrcn08     #add by zyq  ä¼æ¯ç­æ¬¡ä¸ç­æ¶é´
DEFINE l_hrcp02      LIKE hrcp_file.hrcp02     
DEFINE l_hrcp03,l_hrcp03_02      LIKE hrcp_file.hrcp03
DEFINE l_hratid,l_hratid_02      LIKE hrat_file.hratid   
DEFINE l_hrat03_02   LIKE hrat_file.hrat03     #add by zyq 170923 
DEFINE l_hrat19_02   LIKE hrat_file.hrat19     #add by zyq 170925     
DEFINE l_hrat01_hu LIKE hrat_file.hrat01  #add by huna20170927
DEFINE l_hrcp35    LIKE hrcp_file.hrcp35  #add by huna20170927
  OPEN WINDOW i056_w3 WITH FORM "ghr/42f/ghri056_2"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("ghri056_2")
       
  INPUT BY NAME b_date,e_date,hrat03,type,l_str WITHOUT DEFAULTS

        BEFORE INPUT
           LET b_date=g_today
           LET e_date=g_today
           LET type='1'
           DISPLAY BY NAME b_date,e_date,type
       
        AFTER FIELD hrat03
         IF NOT cl_null(hrat03) THEN
            SELECT hraa12 INTO hrat03_name FROM hraa_file WHERE hraa01=hrat03
            DISPLAY hrat03_name TO hrat03_name
         END IF
       AFTER FIELD b_date
          IF NOT cl_null(b_date) THEN
             IF b_date>g_today THEN
                CALL cl_err('日期不可大于当前日期','!',1)
                NEXT FIELD b_date
             END IF
          END IF
        AFTER FIELD e_date
          IF NOT cl_null(e_date) THEN
             IF e_date>g_today THEN
                CALL cl_err('日期不可大于当前日期','!',1)
                NEXT FIELD e_date
             END IF
             IF  NOT cl_null(b_date) AND b_date>e_date  THEN
                CALL cl_err('开始日期不可大于结束日期','!',1)
                NEXT FIELD b_date
             END IF
          END IF
        ON ACTION controlp
           CASE
            WHEN INFIELD (l_str)
               CALL cl_init_qry_var()
               IF type='1' THEN
                  LET g_qryparam.form = "q_hrat01"
               ELSE
                  LET g_qryparam.form = "q_hrao01"
               END IF
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING l_str
               DISPLAY BY NAME l_str
               NEXT FIELD l_str

            WHEN INFIELD(hrat03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hraa01"
             LET g_qryparam.default1 = hrat03
             CALL cl_create_qry() RETURNING hrat03
             DISPLAY BY NAME hrat03
             SELECT hraa12 INTO hrat03_name FROM hraa_file WHERE hraa01=hrat03
             DISPLAY hrat03_name TO hrat03_name
             NEXT FIELD hrat03

           END CASE

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()
     END INPUT

     IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW i056_w3
        RETURN
     END IF
    IF cl_null(l_str) THEN LET l_str="-"  END IF

    CALL cl_replace_str(l_str,'|',''',''') RETURNING l_str
    
    LET l_str = "'",l_str,"'"

    LET l_msg="ghrp056 X ",b_date," ",e_date," ",type," ",l_str," ",hrat03," "
    CALL cl_cmdrun_wait(l_msg)
  CLOSE WINDOW i056_w3
  CALL i056_b_fill()
END FUNCTION
#end------ add by dengsy171010
#add by fanguanz171220----E