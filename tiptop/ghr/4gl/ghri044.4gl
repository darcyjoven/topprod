# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri044.4gl
# Descriptions...: 请假作业
# Date & Author..: 13/05/09 By yangjian
# Modify.........: 130729_1 By Exia 调整结束日期的必输和默认值的设置,同时在结束日期存在的情况下不能小于开始日期
# Modify.........: 130730_1 BY Exia 增加结束时间的控制
# Modify.........: 130911 1309/09/11 By wangxh 	用户在录入请假时长时须要控制
# Modify.........: 130912 13/09/12 By wangxh 开始不显示“选择”列审核或者取消审核完成后也要隐藏“选择”列
# Modify.........: 109311 14/08/25 By hujingjue  增加显示是否撤销假


DATABASE ds

GLOBALS "../../config/top.global"


DEFINE go_hrcd  RECORD  LIKE hrcd_file.*
DEFINE
     g_hrcd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        chk          LIKE type_file.chr1,     #选择
        hrcd01       LIKE hrcd_file.hrcd01,   #请假项目编号
        hrcd01_name  LIKE hrbm_file.hrbm04,   #项目名称
        hrcd11       LIKE hrcd_file.hrcd11,   #假勤类别
        hrcd09       LIKE hrcd_file.hrcd09,   #员工ID
        hrcd09_name  LIKE hrat_file.hrat02,   #员工姓名
        hrat04       LIKE hrat_file.hrat04,
        hrat04_name  LIKE hrao_file.hrao02,
        hrcd02       LIKE hrcd_file.hrcd02,   #开始日期
        hrcd03       LIKE hrcd_file.hrcd03,   #开始时间
        hrcd04       LIKE hrcd_file.hrcd04,   #结束日期
        hrcd05       LIKE hrcd_file.hrcd05,   #结束时间
        hrcd06       LIKE hrcd_file.hrcd06,   #请假时长
        hrcd07       LIKE hrcd_file.hrcd07,   #单位
        hrcd08       LIKE hrcd_file.hrcd08,   #规律时段假
        hrcdconf     LIKE hrcd_file.hrcdconf, #审核码
        hrcd10       LIKE hrcd_file.hrcd10,   #请假单号
        hrcd12       LIKE hrcd_file.hrcd12,   #备注
        hrcdud01     LIKE hrcd_file.hrcdud01, #
        hrcdud02     LIKE hrcd_file.hrcdud02, #
        hrcdud03     LIKE hrcd_file.hrcdud03, #
        hrcdud04     LIKE hrcd_file.hrcdud04, #
        hrcdud05     LIKE hrcd_file.hrcdud05, #
        hrcdud06     LIKE hrcd_file.hrcdud06, #
        hrcdud07     LIKE hrcd_file.hrcdud07, #
        hrcdud08     LIKE hrcd_file.hrcdud08, #
        hrcdud09     LIKE hrcd_file.hrcdud09, #
        hrcdud10     LIKE hrcd_file.hrcdud10, #
        hrcdud11     LIKE hrcd_file.hrcdud11, #
        hrcdud12     LIKE hrcd_file.hrcdud12, #
        hrcdud13     LIKE hrcd_file.hrcdud13, #
        hrcdud14     LIKE hrcd_file.hrcdud14, #
        hrcdud15     LIKE hrcd_file.hrcdud15  #
                    END RECORD,
    g_hrcd_t         RECORD                 #程式變數 (舊值)
        chk          LIKE type_file.chr1,     #选择
        hrcd01       LIKE hrcd_file.hrcd01,   #请假项目编号
        hrcd01_name  LIKE hrbm_file.hrbm04,   #项目名称
        hrcd11       LIKE hrcd_file.hrcd11,   #假勤类别
        hrcd09       LIKE hrcd_file.hrcd09,   #员工ID
        hrcd09_name  LIKE hrat_file.hrat02,   #员工姓名
        hrat04       LIKE hrat_file.hrat04,
        hrat04_name  LIKE hrao_file.hrao02,
        hrcd02       LIKE hrcd_file.hrcd02,   #开始日期
        hrcd03       LIKE hrcd_file.hrcd03,   #开始时间
        hrcd04       LIKE hrcd_file.hrcd04,   #结束日期
        hrcd05       LIKE hrcd_file.hrcd05,   #结束时间
        hrcd06       LIKE hrcd_file.hrcd06,   #请假时长
        hrcd07       LIKE hrcd_file.hrcd07,   #单位
        hrcd08       LIKE hrcd_file.hrcd08,   #规律时段假
        hrcdconf     LIKE hrcd_file.hrcdconf, #审核码
        hrcd10       LIKE hrcd_file.hrcd10,   #请假单号
        hrcd12       LIKE hrcd_file.hrcd12,   #备注
        hrcdud01     LIKE hrcd_file.hrcdud01, #
        hrcdud02     LIKE hrcd_file.hrcdud02, #
        hrcdud03     LIKE hrcd_file.hrcdud03, #
        hrcdud04     LIKE hrcd_file.hrcdud04, #
        hrcdud05     LIKE hrcd_file.hrcdud05, #
        hrcdud06     LIKE hrcd_file.hrcdud06, #
        hrcdud07     LIKE hrcd_file.hrcdud07, #
        hrcdud08     LIKE hrcd_file.hrcdud08, #
        hrcdud09     LIKE hrcd_file.hrcdud09, #
        hrcdud10     LIKE hrcd_file.hrcdud10, #
        hrcdud11     LIKE hrcd_file.hrcdud11, #
        hrcdud12     LIKE hrcd_file.hrcdud12, #
        hrcdud13     LIKE hrcd_file.hrcdud13, #
        hrcdud14     LIKE hrcd_file.hrcdud14, #
        hrcdud15     LIKE hrcd_file.hrcdud15#

                    END RECORD,
     g_dhrcda   DYNAMIC ARRAY OF RECORD
        hrcda05      LIKE hrcda_file.hrcda05,
        hrcda06      LIKE hrcda_file.hrcda06,
        hrcda07      LIKE hrcda_file.hrcda07,
        hrcda08      LIKE hrcda_file.hrcda08,
        hrcda09      LIKE hrcda_file.hrcda09,
        hrcda10      LIKE hrcda_file.hrcda10,
        hrcda15      LIKE hrcda_file.hrcda15,
        hrcda16     LIKE hrcda_file.hrcda16       #增加日撤销选项
                    END RECORD,
     g_mhrcda   DYNAMIC ARRAY OF RECORD
        hrcda05      LIKE hrcda_file.hrcda05,
        hrcda06      LIKE hrcda_file.hrcda06,
        hrcda07      LIKE hrcda_file.hrcda07,
        hrcda08      LIKE hrcda_file.hrcda08,
        hrcda09      LIKE hrcda_file.hrcda09,
        hrcda10      LIKE hrcda_file.hrcda10,
        hrcda15      LIKE hrcda_file.hrcda15,
        hrcda16      LIKE hrcda_file.hrcda16       #增加月撤销选项
                    END RECORD,
     g_shrcda   DYNAMIC ARRAY OF RECORD
        hrcda05      LIKE hrcda_file.hrcda05,
        hrcda06      LIKE hrcda_file.hrcda06,
        hrcda07      LIKE hrcda_file.hrcda07,
        hrcda08      LIKE hrcda_file.hrcda08,
        hrcda09      LIKE hrcda_file.hrcda09,
        hrcda10      LIKE hrcda_file.hrcda10,
        hrcda15      LIKE hrcda_file.hrcda15,
        hrcda16      LIKE hrcda_file.hrcda16        #增加季度撤销选项
                    END RECORD,
     g_yhrcda   DYNAMIC ARRAY OF RECORD
        hrcda05      LIKE hrcda_file.hrcda05,
        hrcda06      LIKE hrcda_file.hrcda06,
        hrcda07      LIKE hrcda_file.hrcda07,
        hrcda08      LIKE hrcda_file.hrcda08,
        hrcda09      LIKE hrcda_file.hrcda09,
        hrcda10      LIKE hrcda_file.hrcda10,
        hrcda15      LIKE hrcda_file.hrcda15,
        hrcda16      LIKE hrcda_file.hrcda16        #增加年撤销选项
                    END RECORD,
     g_hrcda   DYNAMIC ARRAY OF RECORD
        hrcda01      LIKE hrcda_file.hrcda01,
        hrcda02      LIKE hrcda_file.hrcda02,
        hrcda03      LIKE hrcda_file.hrcda03,
        hrcda03_name LIKE hrbm_file.hrbm04,
        hrcda04      LIKE hrcda_file.hrcda04,
        hrcda04_name LIKE hrat_file.hrat02,
        hrcda05      LIKE hrcda_file.hrcda05,
        hrcda06      LIKE hrcda_file.hrcda06,
        hrcda07      LIKE hrcda_file.hrcda07,
        hrcda08      LIKE hrcda_file.hrcda08,
        hrcda09      LIKE hrcda_file.hrcda09,
        hrcda10      LIKE hrcda_file.hrcda10,
        hrcda11      LIKE hrcda_file.hrcda11,
        hrcda12      LIKE hrcda_file.hrcda12,
        hrcda13      LIKE hrcda_file.hrcda13,
        hrcda14      LIKE hrcda_file.hrcda14,
        hrcda15      LIKE hrcda_file.hrcda15,
        hrcda16      LIKE hrcda_file.hrcda16
                    END RECORD,
     g_wc2,g_sql    string,  #No.FUN-580092 HCN
     g_rec_b         LIKE type_file.num5,      #單身筆數
     l_ac,l_ac1            LIKE type_file.num5       #目前處理的ARRAY CNT
DEFINE g_h,g_m   LIKE  type_file.num5
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i             LIKE type_file.num5
DEFINE l_table           STRING
DEFINE g_str             STRING
DEFINE g_hratid          LIKE hrat_file.hratid
DEFINE g_hrat01          LIKE hrat_file.hrat01  -- zhoumj 20160115 --

MAIN
DEFINE p_row,p_col   LIKE type_file.num5
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i044_w AT p_row,p_col WITH FORM "ghr/42f/ghri044"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
    CALL cl_set_comp_visible("chk",FALSE) #130912 add by wangxh
    CALL cl_set_label_justify("i044_w","right")

    LET g_wc2 = '1=1'
#    CALL i044_b_fill(g_wc2)
#    CALL i044_b_fill2()
    CREATE TEMP TABLE TEMP1
    ( d1 DATE,
      t1 DEC(10),
      t2 DEC(10)
      )
    CALL i044_menu()
    CLOSE WINDOW i044_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i044_menu()

   WHILE TRUE
      CALL i044_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i044_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i044_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "close"
            EXIT PROGRAM
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcd),'','')
            END IF
         WHEN "import"
            IF cl_chk_act_auth() THEN
                 CALL i044_import()
            END IF
         WHEN "modifyhrcd01"
            IF cl_chk_act_auth() THEN
              CALL i044_modifyhrcd01()
            END IF
         WHEN "ghr_confirm"
            IF cl_chk_act_auth() THEN
              CALL i044_y()
            END IF
         WHEN "ghr_undo_confirm"
            IF cl_chk_act_auth() THEN
              CALL i044_z()
            END IF
         WHEN "ghri044_e"
            IF cl_chk_act_auth() THEN
              CALL i044_revoke()
              CALL i044_b_fill2()
            END IF
         WHEN "ghri044_a"
            IF cl_chk_act_auth() THEN
             CALL i044_p1()
            END IF
         WHEN "ghri044_b"
            IF cl_chk_act_auth() THEN
             CALL i044_p2()
            END IF
         WHEN "ghri044_c"
            IF cl_chk_act_auth() THEN
             CALL i044_p3()
            END IF
         WHEN "ghri044_d"
            IF cl_chk_act_auth() THEN
             CALL i044_p4()
            END IF
#         --* zhoumj 20160115 --
#         WHEN "ghri044_f"
#            IF cl_chk_act_auth() THEN
#             CALL i044_p5()
#            END IF
#         -- zhoumj 20160115 *--
         WHEN "txjl"
            IF cl_chk_act_auth() THEN
              CALL i044_tx_fill()
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i044_q()
   CALL i044_b_askkey()
END FUNCTION

FUNCTION i044_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1

DEFINE l_hrcd05     LIKE hrcd_file.hrcd05
DEFINE l_count      LIKE type_file.num5
DEFINE l_hrcd03     LIKE hrcd_file.hrcd03
DEFINE l_hrcd04     LIKE hrcd_file.hrcd04
DEFINE l_old_hrcd03 LIKE hrcd_file.hrcd03
DEFINE l_old_hrcd04 LIKE hrcd_file.hrcd04
DEFINE l_new_hrcd05 LIKE hrcd_file.hrcd05
DEFINE l_m ,l_cnt         LIKE type_file.num5
DEFINE l_h,i,l_i          LIKE type_file.num5
DEFINE l_sum_hrcd03 LIKE type_file.num5
DEFINE l_sum_hrcd05 LIKE type_file.num5
DEFINE l_hrbm05     LIKE hrbm_file.hrbm05
DEFINE l_sql        LIKE type_file.chr1000
DEFINE l_msg        LIKE type_file.chr1000
DEFINE l_check      LIKE type_file.chr1000
DEFINE l_r          LIKE type_file.chr2
DEFINE l_hrcdb03    LIKE hrcdb_file.hrcdb03
DEFINE l_hrcdb04    LIKE hrcdb_file.hrcdb04
DEFINE l_hrcdb05    LIKE hrcdb_file.hrcdb05
DEFINE l_hrcdb06    LIKE hrcdb_file.hrcdb06
DEFINE l_hrcd       RECORD LIKE hrcd_file.*
DEFINE l_hrci       RECORD LIKE hrci_file.*
DEFINE l_hrcd03_1,l_hrcd05_1 LIKE type_file.num5
DEFINE l_d          LIKE type_file.dat
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT hrcd10  ",
                       " FROM hrcd_file",
                       " WHERE hrcd10=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i044_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_hrcd WITHOUT DEFAULTS FROM s_hrcd.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               CALL i044_set_entry(p_cmd)
               CALL i044_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
               LET g_hrcd_t.* = g_hrcd[l_ac].*  #BACKUP

               OPEN i044_bcl USING g_hrcd_t.hrcd10
               IF STATUS THEN
                  CALL cl_err("OPEN i044_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i044_bcl INTO g_hrcd[l_ac].hrcd10
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrcd_t.hrcd01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        BEFORE INSERT
           LET g_success = 'Y'
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE
           CALL i044_set_entry(p_cmd)
           CALL i044_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           INITIALIZE g_hrcd[l_ac].* TO NULL      #900423
           LET g_hrcd_t.* = g_hrcd[l_ac].*         #新輸入資料
           LET g_hrcd[l_ac].hrcd02 = g_today
           LET g_hrcd[l_ac].hrcd03 = '00:00'
#           LET g_hrcd[l_ac].hrcd04 = g_today     #130729_1 mark
#           LET g_hrcd[l_ac].hrcd05 = '00:00'     #130729_1 mark
           #LET g_hrcd[l_ac].hrcd08 = 'Y'         #add by yinbq 20141110
           LET g_hrcd[l_ac].hrcd08 = 'N'         #add by yinbq 20141110
           LET g_hrcd[l_ac].hrcdconf = 'N'
           LET g_hrcd[l_ac].hrcd10 = g_today USING 'yyyymmdd'
           CALL cl_show_fld_cont()

           NEXT FIELD hrcd01

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i044_bcl
              CANCEL INSERT
           END IF
           LET g_hratid = NULL
           LET g_hratid = i044_hrat012hratid(g_hrcd[l_ac].hrcd09)
           IF cl_null(g_hratid) THEN
              CALL cl_err('','ghr-131',1)
              CANCEL INSERT
           END IF

##           #添加校验员工同一天是否存在请假
#           LET l_sql="SELECT hrat01||' '||hrat02||' '||to_char(hrcda05,'yyyy-mm-dd')||' '||hrcda06||' '||to_char(hrcda07,'yyyy-mm-dd')||' '||hrcda08||' '||hrcda09||hrag07||' '||hrbm04 ",
#                     " FROM hrcda_file",
#                     " LEFT JOIN hrbm_file ON hrbm_file.hrbm03=hrcda_file.hrcda03",
#                     " LEFT JOIN hrat_file ON hrat_file.hratid=hrcda_file.hrcda04",
#                     " LEFT JOIN hrag_file ON hrag01='504' AND hrag06=hrcda10",
#                     " WHERE hrcda_file.hrcda04='",g_hratid,"' AND (hrcda_file.hrcda05='",g_hrcd[l_ac].hrcd02,"' OR hrcda_file.hrcda07='",g_hrcd[l_ac].hrcd02,"')"
#           PREPARE i044_check FROM l_sql
#           DECLARE i044_check_c CURSOR FOR i044_check
#           LET l_check='-\n'
#           FOREACH i044_check_c INTO l_msg
#              LET l_check=l_check||l_msg||'\n'
#           END FOREACH
#           IF NOT cl_null(l_msg) THEN
#              LET l_check='员工当天已经正在请假\n'||l_check||'\n确定继续吗？'
#              IF NOT cl_confirm(l_check) THEN
#                 INITIALIZE g_hrcd[l_ac].* TO NULL
#                 LET g_hrcd_t.* = g_hrcd[l_ac].*         #新輸入資料
#                 LET g_hrcd[l_ac].hrcd02 = g_today
#                 LET g_hrcd[l_ac].hrcd03 = '00:00'
#                 LET g_hrcd[l_ac].hrcd04 = g_today     #130729_1 mark
#                 LET g_hrcd[l_ac].hrcd05 = '00:00'     #130729_1 mark
#                 LET g_hrcd[l_ac].hrcd08 = 'Y'
#                 LET g_hrcd[l_ac].hrcdconf = 'N'
#                 LET g_hrcd[l_ac].hrcd10 = g_today USING 'yyyymmdd'
#                 CALL cl_show_fld_cont()
#                 NEXT FIELD hrcd01
#                 RETURN
#              END IF
#           END IF
##           #添加校验员工同一天是否存在请假
           BEGIN WORK
           SELECT to_char(MAX(hrcd10)+1,'fm0000000000000') INTO g_hrcd[l_ac].hrcd10 FROM hrcd_file
             # WHERE to_date(substr(hrcd10,1,8),'yyyyMMdd') = g_today
             WHERE substr(hrcd10,1,8) = to_char(g_today,'yyyymmdd')
           IF cl_null(g_hrcd[l_ac].hrcd10) THEN
              LET g_hrcd[l_ac].hrcd10 = g_today USING 'yyyymmdd'||'00001'
           END IF

           #add by pengzb 151112 -------start
            CALL i044_val_trans()

           SELECT count(*) INTO l_cnt
           FROM hrbm_file WHERE hrbm02='006' AND hrbm03=g_hrcd[l_ac].hrcd01
           IF l_cnt>0 AND g_success='Y' THEN  #年假
             #  CALL i044_chk_006(go_hrcd.*)
               IF g_success ='N'  THEN
                   MESSAGE "检查年假失败，无有效可调年检"
                   ROLLBACK WORK
                   CANCEL INSERT
               END IF
           END IF
           SELECT count(*) INTO l_cnt
           FROM hrbm_file WHERE hrbm02='011' AND hrbm03=g_hrcd[l_ac].hrcd01
           IF l_cnt>0 AND g_success='Y' THEN  #调休
               CALL i044_chk_011(go_hrcd.*)
               IF g_success ='N'  THEN
                    MESSAGE "检查调休失败，无有效可调休假"
                    ROLLBACK WORK
                    CANCEL INSERT
               END IF
           END IF
           #add by pengzb 151112 -------end



           INSERT INTO hrcd_file(hrcd01,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd07,hrcd08,
                                 hrcd09,hrcd10,hrcd11,hrcd12,
                                 hrcduser,hrcdgrup,hrcdmodu,hrcddate,hrcdacti,hrcdoriu,hrcdorig,hrcdconf,
                                 hrcdud01,hrcdud02,hrcdud03,hrcdud04,hrcdud05,
                                 hrcdud06,hrcdud07,hrcdud08,hrcdud09,hrcdud10,
                                 hrcdud11,hrcdud12,hrcdud13,hrcdud14,hrcdud15)
                         VALUES(g_hrcd[l_ac].hrcd01,g_hrcd[l_ac].hrcd02,g_hrcd[l_ac].hrcd03,g_hrcd[l_ac].hrcd04,
                                g_hrcd[l_ac].hrcd05,g_hrcd[l_ac].hrcd06,g_hrcd[l_ac].hrcd07,g_hrcd[l_ac].hrcd08,
                                g_hratid,g_hrcd[l_ac].hrcd10,g_hrcd[l_ac].hrcd11,g_hrcd[l_ac].hrcd12,
                                g_user,g_grup,g_user,g_today,'Y',g_user,g_grup,g_hrcd[l_ac].hrcdconf,
                                g_hrcd[l_ac].hrcdud01,g_hrcd[l_ac].hrcdud02,g_hrcd[l_ac].hrcdud03,g_hrcd[l_ac].hrcdud04,
                                g_hrcd[l_ac].hrcdud05,g_hrcd[l_ac].hrcdud06,g_hrcd[l_ac].hrcdud07,g_hrcd[l_ac].hrcdud08,
                                g_hrcd[l_ac].hrcdud09,g_hrcd[l_ac].hrcdud10,g_hrcd[l_ac].hrcdud11,g_hrcd[l_ac].hrcdud12,
                                g_hrcd[l_ac].hrcdud13,g_hrcd[l_ac].hrcdud14,g_hrcd[l_ac].hrcdud15)
           IF SQLCA.sqlcode THEN
               ROLLBACK WORK
               CALL cl_err3("ins","hrcd_file",g_hrcd[l_ac].hrcd10,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
             #IF g_hrcd[l_ac].hrcd11 = '1' OR g_hrcd[l_ac].hrcd11 = '4' THEN
              IF  g_hrcd[l_ac].hrcd11 = '1' OR g_hrcd[l_ac].hrcd11 = '4' OR g_hrcd[l_ac].hrcd11 = '2'  THEN
                 CALL sghri044__splitWithExpand(g_hrcd[l_ac].hrcd10)
              END IF 
                 IF g_success = 'Y' THEN
                   COMMIT WORK
                   MESSAGE 'INSERT O.K'
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2

                 ELSE
                   ROLLBACK WORK
                   CANCEL INSERT
                 END IF
              #END IF
           END IF

        AFTER FIELD hrcd01
            IF NOT cl_null(g_hrcd[l_ac].hrcd01) THEN
               IF g_hrcd[l_ac].hrcd01 != g_hrcd_t.hrcd01 OR
                  g_hrcd_t.hrcd01 IS NULL THEN
                  CALL i044_hrcd01('a') RETURNING g_hrcd[l_ac].hrcd11,g_hrcd[l_ac].hrcd01_name,g_hrcd[l_ac].hrcd07
                  IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_hrcd[l_ac].hrcd01,g_errno,0)
                    NEXT FIELD hrcd01
                  END IF
               END IF
               SELECT count(*) INTO l_cnt
               FROM hrbm_file WHERE hrbm02 IN ('006','011') AND hrbm03=g_hrcd[l_ac].hrcd01
               IF l_cnt>0 THEN
                    CALL cl_set_comp_required("hrcd03,hrcd04,hrcd05,hrcd06",TRUE)
                    LET g_hrcd[l_ac].hrcd04=g_hrcd[l_ac].hrcd02+1
                    LET g_hrcd[l_ac].hrcd05='00:00'
                    LET g_hrcd[l_ac].hrcd06=g_hrcd[l_ac].hrcd04-g_hrcd[l_ac].hrcd02
               ELSE
                    CALL cl_set_comp_required("hrcd03,hrcd04,hrcd05,hrcd06",FALSE)
               END IF
               CALL cl_set_comp_entry("hrcd07",TRUE)
            END IF

       AFTER FIELD hrcd03
           IF NOT cl_null(g_hrcd[l_ac].hrcd03) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcd[l_ac].hrcd03[1,2]
               LET g_m=g_hrcd[l_ac].hrcd03[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD hrcd03
               END IF
               #130730_1 add
               IF cl_null(g_hrcd[l_ac].hrcd03[5,5])OR cl_null(g_hrcd[l_ac].hrcd03[1,1]) OR cl_null(g_hrcd[l_ac].hrcd03[2,2]) OR cl_null(g_hrcd[l_ac].hrcd03[4,4]) THEN
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD hrcd03
               END IF
               #add by zhuzw 20150119 start
               SELECT substr(g_hrcd[l_ac].hrcd03,2,2) INTO l_r FROM dual
               IF l_r = '::' THEN
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD hrcd03
               END IF
               #add by zhuzw 20150119 end
               #比较时间
#               IF NOT cl_null(g_hrcd[l_ac].hrcd04) AND NOT cl_null(g_hrcd[l_ac].hrcd05) THEN
#                  IF g_hrcd[l_ac].hrcd02 = g_hrcd[l_ac].hrcd04 THEN
#                     LET l_h=g_hrcd[l_ac].hrcd03[1,2]
#                     LET l_m=g_hrcd[l_ac].hrcd03[4,5]
#                     LET l_sum_hrcd03 = l_h*60 + l_m
#                     LET l_h=g_hrcd[l_ac].hrcd05[1,2]
#                     LET l_m=g_hrcd[l_ac].hrcd05[4,5]
#                     LET l_sum_hrcd05 = l_h*60 + l_m
#                     IF l_sum_hrcd03 > l_sum_hrcd05 THEN
#                        CALL cl_err("开始时间不能大于结束时间","!",0)
#                        NEXT FIELD hrcd03
#                     END IF
#                  END IF
#               END IF
               #130730_1 end
            END IF

       AFTER FIELD hrcd05
           IF NOT cl_null(g_hrcd[l_ac].hrcd05) THEN
               #130730_1 add
               #如果结束日期为空,则将时间清空
               IF cl_null(g_hrcd[l_ac].hrcd04) THEN
                  LET g_hrcd[l_ac].hrcd05 = ''
                  NEXT FIELD hrcd04
               END IF
               #130730_1 end
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcd[l_ac].hrcd05[1,2]
               LET g_m=g_hrcd[l_ac].hrcd05[4,5]
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD hrcd05
               END IF
               #130730_1 add
               IF cl_null(g_hrcd[l_ac].hrcd05[5,5])OR cl_null(g_hrcd[l_ac].hrcd05[1,1]) OR cl_null(g_hrcd[l_ac].hrcd05[2,2]) OR cl_null(g_hrcd[l_ac].hrcd05[4,4]) THEN
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD hrcd05
               END IF
               #add by zhuzw 20150119 start
               SELECT substr(g_hrcd[l_ac].hrcd03,2,2) INTO l_r FROM dual
               IF l_r = '::' THEN
                  CALL cl_err('','aec-053',0)
                  NEXT FIELD hrcd03
               END IF
               #add by zhuzw 20150119 end
               #比较时间
               IF NOT cl_null(g_hrcd[l_ac].hrcd02) AND NOT cl_null(g_hrcd[l_ac].hrcd03) THEN
                  IF g_hrcd[l_ac].hrcd02 = g_hrcd[l_ac].hrcd04 THEN
                     LET l_h=g_hrcd[l_ac].hrcd03[1,2]
                     LET l_m=g_hrcd[l_ac].hrcd03[4,5]
                     LET l_sum_hrcd03 = l_h*60 + l_m
                     LET l_h=g_hrcd[l_ac].hrcd05[1,2]
                     LET l_m=g_hrcd[l_ac].hrcd05[4,5]
                     LET l_sum_hrcd05 = l_h*60 + l_m
                     IF l_sum_hrcd03 > l_sum_hrcd05 THEN
                        CALL cl_err("开始时间不能大于结束时间","!",0)
                        NEXT FIELD hrcd03
                     END IF
                  END IF
               END IF
               #130730_1 end
            END IF
 #130911 add by wangxh --str--
         AFTER FIELD hrcd06
             IF NOT cl_null(g_hrcd[l_ac].hrcd06) THEN
                SELECT hrbm05 INTO l_hrbm05 FROM hrbm_file WHERE hrbm03=g_hrcd[l_ac].hrcd01
                IF g_hrcd[l_ac].hrcd06 MOD l_hrbm05<>0 THEN
                   CALL cl_err('','ghr-199',0)
                   NEXT FIELD hrcd06
                END IF
             END IF

 #130911 add by wangxh --str--
       #add by zhuzw 20160125 start
         AFTER FIELD hrcd08
             IF NOT cl_null(g_hrcd[l_ac].hrcd08) THEN
                 DELETE FROM TEMP1
                 SELECT TO_NUMBER(SUBSTR(g_hrcd[l_ac].hrcd03, 1, 2)) * 60 + TO_NUMBER(SUBSTR(g_hrcd[l_ac].hrcd03, 4, 2)),TO_NUMBER(SUBSTR(g_hrcd[l_ac].hrcd05, 1, 2)) * 60 + TO_NUMBER(SUBSTR(g_hrcd[l_ac].hrcd05, 4, 2)) INTO l_hrcd03_1,l_hrcd05_1
                   FROM dual 
                LET l_i = g_hrcd[l_ac].hrcd04 - g_hrcd[l_ac].hrcd02 +1   
                IF g_hrcd[l_ac].hrcd08 = 'N' THEN  
                   FOR i = 1 TO  l_i                  
                      IF l_i = 1 THEN 
                         INSERT INTO TEMP1 VALUES(g_hrcd[l_ac].hrcd02,l_hrcd03_1,l_hrcd05_1)                    
                      ELSE 
                      	  IF i = 1 THEN 
                      	     INSERT INTO TEMP1 VALUES(g_hrcd[l_ac].hrcd02,l_hrcd03_1,1440)
                      	  END IF 
                      	  IF i = l_i THEN 
                      	     INSERT INTO TEMP1 VALUES(g_hrcd[l_ac].hrcd04,0,l_hrcd05_1)
                      	  END IF 
                      	  IF i < l_i AND i > 1 THEN 
                      	     LET l_d = g_hrcd[l_ac].hrcd02 +i -1  
                      	     INSERT INTO TEMP1 VALUES(l_d,0,1440)
                      	  END IF                   	  
                      END IF 	 
                   END FOR   
                ELSE 
                   FOR i = 1 TO  l_i   
                         LET l_d = g_hrcd[l_ac].hrcd02 +i -1                
                         INSERT INTO TEMP1 VALUES(l_d,l_hrcd03_1,l_hrcd05_1)	 
                   END FOR                	
                END IF  	
#                SELECT COUNT(*) INTO l_n FROM hrcda_file,TEMP1 
#                 WHERE hrcda16 = 'N'
#                   AND hrcda04 = g_hratid
#              #     AND hrcda05 = t1 AND  
#                #   ( (TO_NUMBER(SUBSTR(hrcda06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrcda06, 4, 2)<= t1 and ((TO_NUMBER(SUBSTR(hrcda08, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrcda08, 4, 2) > t1 and d1 =  hrcda07 ) or hrcda07 = d1 +1  )) OR  
#               #      (TO_NUMBER(SUBSTR(hrcda06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrcda06, 4, 2)> t1 and ((TO_NUMBER(SUBSTR(hrcda06, 1, 2)) * 60 + TO_NUMBER(SUBSTR(hrcda06, 4, 2) < t2 and d1 =  hrcda07 ) or hrcda07 = d1 +1  )))              
#                IF l_n > 0 THEN 
#                   CALL cl_err('请假存在交集，请检查','!',1)
#                   NEXT FIELD hrcd02
#                END IF 
             END IF             
       #add by zhuzw 20160125 end 
       AFTER FIELD hrcd09
            IF NOT cl_null(g_hrcd[l_ac].hrcd09) THEN
               IF g_hrcd[l_ac].hrcd09 != g_hrcd_t.hrcd09 OR
                  g_hrcd_t.hrcd09 IS NULL THEN
                  CALL i044_hrcd09('a') RETURNING g_hrcd[l_ac].hrcd09_name
                  SELECT hrat04.hrao02 INTO g_hrcd[l_ac].hrat04,g_hrcd[l_ac].hrat04_name FROM hrat_file left join hrao_file ON hrao01=hrat04
                  WHERE hrat01=g_hrcd[l_ac].hrcd09
                  IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_hrcd[l_ac].hrcd09,g_errno,0)
                    NEXT FIELD hrcd09
                  END IF
               END IF
            END IF

       AFTER FIELD hrcd02
          IF NOT cl_null(g_hrcd[l_ac].hrcd02) THEN
             #130729_1 调整
             #IF g_hrcd[l_ac].hrcd04 IS NULL OR g_hrcd[l_ac].hrcd04 < g_hrcd[l_ac].hrcd02 THEN
             IF NOT cl_null(g_hrcd[l_ac].hrcd04) AND g_hrcd[l_ac].hrcd04 < g_hrcd[l_ac].hrcd02 THEN
             #130729_1 end
                LET g_hrcd[l_ac].hrcd04 = g_hrcd[l_ac].hrcd02
             END IF
          END IF

       AFTER FIELD hrcd04
          IF NOT cl_null(g_hrcd[l_ac].hrcd04) THEN
             IF g_hrcd[l_ac].hrcd04 < g_hrcd[l_ac].hrcd02 THEN
                CALL cl_err('','ghr-107',0)
                NEXT FIELD hrcd04
             END IF
          END IF

        BEFORE DELETE                            #是否取消單身
            IF g_hrcd_t.hrcd10 IS NOT NULL THEN
              IF g_hrcd[l_ac].hrcdconf = 'Y' THEN
                 CALL cl_err('',9003,0)
                 LET g_hrcd[l_ac].* = g_hrcd_t.*
                 EXIT INPUT
               END IF
               IF g_hrcd[l_ac].hrcdconf = 'X' THEN
                  CALL cl_err('',9004,0)
                  LET g_hrcd[l_ac].* = g_hrcd_t.*
                 EXIT INPUT
               END IF
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "hrcd10"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_hrcd[l_ac].hrcd10      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                DELETE FROM hrcd_file WHERE hrcd10 = g_hrcd_t.hrcd10
                IF SQLCA.sqlcode THEN
                    ROLLBACK WORK
                     CALL cl_err3("del","hrcd_file",g_hrcd_t.hrcd10,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
                    EXIT INPUT
                END IF
                DELETE FROM hrcda_file WHERE hrcda02 = g_hrcd_t.hrcd10
                IF SQLCA.sqlcode THEN
                    ROLLBACK WORK
                     CALL cl_err3("del","hrcda_file",g_hrcd_t.hrcd10,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
                    EXIT INPUT
                END IF
                #add by zhuzw 20151118 start
#                IF g_hrcd_t.hrcd11 = '2' THEN  #删除年假回滚
#                    LET l_sql = " select hrcdb03,hrcdb04,hrcdb05,hrcdb06 FROM hrcdb_file ",
#                                "  where hrcdb01 = '",g_hrcd_t.hrcd10,"' "
#                      PREPARE i044_del2 FROM l_sql
#                      DECLARE i044_hrcdbs CURSOR FOR i044_del2
#                   FOREACH i044_hrcdbs INTO l_hrcdb03,l_hrcdb04,l_hrcdb05,l_hrcdb06
#                      IF  l_hrcdb05 = '003' THEN  LET l_hrcdb04 = l_hrcdb04/8 END IF
#                      IF l_hrcdb06 = '1' THEN
#                         UPDATE hrch_file SET hrch17 = hrch17 + l_hrcdb04,hrch21 = hrch21 + l_hrcdb04
#                          WHERE hrch19 = l_hrcdb03
#                      ELSE
#                         UPDATE hrch_file SET hrch17 = hrch17 + l_hrcdb04,hrch20 = hrch20 + l_hrcdb04
#                          WHERE hrch19 = l_hrcdb03
#                      END IF
#                      
#                   END FOREACH
#                END IF                
#                #删除调休假回滚
#                IF l_hrcd.hrcd11 = '3' THEN
#                    LET l_sql = " select hrcdb03,hrcdb04,hrcdb05 FROM hrcdb_file ",
#                                "  where hrcdb01 = '",g_hrcd_t.hrcd10,"' "
#                      PREPARE i044_del21 FROM l_sql
#                      DECLARE i044_hrcdbs1 CURSOR FOR i044_del21
#                   FOREACH i044_hrcdbs1 INTO l_hrcdb03,l_hrcdb04,l_hrcdb05
#                      IF  l_hrcdb05 = '003' THEN  LET l_hrcdb04 = l_hrcdb04/8 END IF
#                         UPDATE hrci_file SET hrci08 = l_hrci.hrci08 -  l_hrcdb04,hrci09 = l_hrci.hrci09 +  l_hrcdb04
#                          WHERE hrci01 = l_hrcdb03                     
#                   END FOREACH
#                END IF

#                SELECT * INTO l_hrcd.* FROM hrcd_file
#                 WHERE hrcd10 = g_hrcd_t.hrcd10
#                IF l_hrcd.hrcd11 = '3' THEN
#                   LET l_sql = " select * from hrci_file where hrci08 >0 and  hrci10 >= '",l_hrcd.hrcd02,"' and hrci02 = '",l_hrcd.hrcd09,"' ",
#                                " order by hrciud13 desc"
#                   PREPARE i044_del1 FROM l_sql
#                   DECLARE i044_del1s CURSOR FOR i044_del1
#                   FOREACH i044_del1s INTO l_hrci.*
#                      IF l_hrci.hrci08 >= l_hrcd.hrcd06 THEN
#                         UPDATE hrci_file SET hrci08 = l_hrci.hrci08 -  l_hrcd.hrcd06,hrci09 = l_hrci.hrci09 +  l_hrcd.hrcd06
#                          WHERE hrci01 = l_hrci.hrci01
#                            AND hrci02 = l_hrci.hrci02
#                            AND hrci03 = l_hrci.hrci03
#                         EXIT FOREACH
#                      ELSE
#                         UPDATE hrci_file SET hrci08 = 0,hrci09 = l_hrci.hrci09 +  l_hrci.hrci08
#                          WHERE hrci01 = l_hrci.hrci01
#                            AND hrci02 = l_hrci.hrci02
#                            AND hrci03 = l_hrci.hrci03
#                         LET l_hrcd.hrcd06 = l_hrcd.hrcd06 - l_hrci.hrci08
#                      END IF
#                   END FOREACH
#                END IF
                DELETE FROM hrcdb_file WHERE hrcdb01 = g_hrcd_t.hrcd10
                #add by zhuzw 20151118 end
                CALL g_mhrcda.clear()
                CALL g_shrcda.clear()
                CALL g_yhrcda.clear()
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cnt
                COMMIT WORK
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrcd[l_ac].* = g_hrcd_t.*
              CLOSE i044_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
        #mark by zhanghui 2017/05/09 ---start
           #IF g_hrcd[l_ac].hrcd11 MATCHES '[231]' THEN
           #   CALL cl_err('','ghr-146',1)
           #   LET g_hrcd[l_ac].* = g_hrcd_t.*
           #   EXIT INPUT
           #END IF
        #mark by zhanghui 2017/05/09 ---edd
        
           IF g_hrcd[l_ac].hrcdconf = 'Y' THEN
              CALL cl_err('',9003,0)
              LET g_hrcd[l_ac].* = g_hrcd_t.*
              EXIT INPUT
           END IF
           IF g_hrcd[l_ac].hrcdconf = 'X' THEN
               CALL cl_err('',9004,0)
               LET g_hrcd[l_ac].* = g_hrcd_t.*
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrcd[l_ac].hrcd10,-263,0)
               LET g_hrcd[l_ac].* = g_hrcd_t.*
           ELSE
               LET g_hratid = NULL
               LET g_hratid = i044_hrat012hratid(g_hrcd[l_ac].hrcd09)
               IF cl_null(g_hratid) THEN
                  CALL cl_err('','ghr-131',1)
                  ROLLBACK WORK
                  EXIT INPUT
               END IF

#           #add by pengzb 151112 -------start
#           CALL i044_val_trans()
#
#           SELECT count(*) INTO l_cnt
#           FROM hrbm_file WHERE hrbm02='006' AND hrbm03=g_hrcd[l_ac].hrcd01
#           IF l_cnt>0 AND g_success='Y' THEN  #年假
#               CALL i044_chk_006(go_hrcd.*)
#               IF g_success ='N'  THEN
#                   MESSAGE "检查年假失败，无有效可调年检"
#                    ROLLBACK WORK
#                    EXIT INPUT
#               END IF
#           END IF
#           SELECT count(*) INTO l_cnt
#           FROM hrbm_file WHERE hrbm02='011' AND hrbm03=g_hrcd[l_ac].hrcd01
#           IF l_cnt>0 AND g_success='Y' THEN  #调休
#               CALL i044_chk_011(go_hrcd.*)
#               IF g_success ='N'  THEN
#                    MESSAGE "检查调休失败，无有效可调休假"
#                    ROLLBACK WORK
#                    EXIT INPUT
#               END IF
#           END IF
#           #add by pengzb 151112 -------end

               UPDATE hrcd_file SET hrcd01=g_hrcd[l_ac].hrcd01,
                                    hrcd02=g_hrcd[l_ac].hrcd02,
                                    hrcd03=g_hrcd[l_ac].hrcd03,
                                    hrcd04=g_hrcd[l_ac].hrcd04,
                                    hrcd05=g_hrcd[l_ac].hrcd05,
                                    hrcd06=g_hrcd[l_ac].hrcd06,
                                    hrcd07=g_hrcd[l_ac].hrcd07,
                                    hrcd08=g_hrcd[l_ac].hrcd08,
                                    hrcd09=g_hratid,
                                    hrcd10=g_hrcd[l_ac].hrcd10,
                                    hrcd11=g_hrcd[l_ac].hrcd11,
                                    hrcd12=g_hrcd[l_ac].hrcd12,
                                    hrcdud01=g_hrcd[l_ac].hrcdud01,
                                    hrcdud02=g_hrcd[l_ac].hrcdud02,
                                    hrcdud03=g_hrcd[l_ac].hrcdud03,
                                    hrcdud04=g_hrcd[l_ac].hrcdud04,
                                    hrcdud05=g_hrcd[l_ac].hrcdud05,
                                    hrcdud06=g_hrcd[l_ac].hrcdud06,
                                    hrcdud07=g_hrcd[l_ac].hrcdud07,
                                    hrcdud08=g_hrcd[l_ac].hrcdud08,
                                    hrcdud09=g_hrcd[l_ac].hrcdud09,
                                    hrcdud10=g_hrcd[l_ac].hrcdud10,
                                    hrcdud11=g_hrcd[l_ac].hrcdud11,
                                    hrcdud12=g_hrcd[l_ac].hrcdud12,
                                    hrcdud13=g_hrcd[l_ac].hrcdud13,
                                    hrcdud14=g_hrcd[l_ac].hrcdud14,
                                    hrcdud15=g_hrcd[l_ac].hrcdud15,
                                    hrcdmodu=g_user,
                                    hrcddate=g_today
                  WHERE hrcd10 = g_hrcd[l_ac].hrcd10
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","hrcd_file",g_hrcd_t.hrcd10,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrcd[l_ac].* = g_hrcd_t.*
               ELSE
                  CALL sghri044__splitWithExpand(g_hrcd[l_ac].hrcd10)
                  IF g_success = 'Y' THEN
                    COMMIT WORK
                     MESSAGE 'UPDATE O.K'
                  ELSE
                    ROLLBACK WORK
                    EXIT INPUT
                  END IF
               END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增

           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_hrcd[l_ac].* = g_hrcd_t.*
              END IF
              CLOSE i044_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i044_bcl
           COMMIT WORK

       ON ACTION controlp
           CASE WHEN INFIELD(hrcd01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_hrbm033"
                   LET g_qryparam.default1 = g_hrcd[l_ac].hrcd01
                   LET g_qryparam.arg1 = "('004','006','010','011')"
                  # LET g_qryparam.arg1 = "('004','006','011')"
                   CALL cl_create_qry() RETURNING g_hrcd[l_ac].hrcd01
                   DISPLAY g_hrcd[l_ac].hrcd01 TO hrcd01
                WHEN INFIELD(hrcd09)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_hrat"
                   LET g_qryparam.default1 = g_hrcd[l_ac].hrcd09
                   CALL cl_create_qry() RETURNING g_hrcd[l_ac].hrcd09
                   #FUN-151117 wangjya #单选
#                   CALL q_hrat(FALSE, "q_hrat","")  RETURNING  g_hrcd[l_ac].hrcd09
#                   CALL q_hrat2(TRUE, "q_hrat","")  RETURNING  g_hrcd[l_ac].hrcd09
                   DISPLAY g_hrcd[l_ac].hrcd09 TO hrcd09
                   #FUN-151117 wangjya
                OTHERWISE
                   EXIT CASE
            END CASE

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(hrcd01) AND l_ac > 1 THEN
                LET g_hrcd[l_ac].* = g_hrcd[l_ac-1].*
                NEXT FIELD hrcd01
            END IF

        ON ACTION CONTROLR
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

    END INPUT
    CLOSE i044_bcl
    COMMIT WORK
    CALL i044_b_fill2()
END FUNCTION

FUNCTION i044_b_askkey()
 DEFINE p_row,p_col  LIKE type_file.num5
 DEFINE l_wc      STRING

   #LET p_row = 5 LET p_col = 22
   #OPEN WINDOW i044_w_q AT p_row,p_col WITH FORM "ghr/42f/ghri044_q"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CLEAR FORM
   CALL cl_ui_init()
  # CALL cl_set_label_justify("i044_w_q","right")

    CONSTrUCT g_wc2 ON hrcd01,hrcd09,hrat04,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd07,hrcd08,hrcdconf,hrcd10,hrcd11,hrcd12,
                       hrcdud01,hrcdud02,hrcdud03,hrcdud04,hrcdud05,hrcdud06,hrcdud07,hrcdud08,
                       hrcdud09,hrcdud10,hrcdud11,hrcdud12,hrcdud13,hrcdud14,hrcdud15
         FROM s_hrcd[1].hrcd01,  s_hrcd[1].hrcd09,s_hrcd[1].hrat04,  s_hrcd[1].hrcd02,  s_hrcd[1].hrcd03,  s_hrcd[1].hrcd04,
              s_hrcd[1].hrcd05,  s_hrcd[1].hrcd06,  s_hrcd[1].hrcd07,  s_hrcd[1].hrcd08,  s_hrcd[1].hrcdconf,s_hrcd[1].hrcd10,
              s_hrcd[1].hrcd11,
              s_hrcd[1].hrcd12,  s_hrcd[1].hrcdud01,s_hrcd[1].hrcdud02,s_hrcd[1].hrcdud03,s_hrcd[1].hrcdud04,
              s_hrcd[1].hrcdud05,s_hrcd[1].hrcdud06,s_hrcd[1].hrcdud07,s_hrcd[1].hrcdud08,
              s_hrcd[1].hrcdud09,s_hrcd[1].hrcdud10,s_hrcd[1].hrcdud11,s_hrcd[1].hrcdud12,s_hrcd[1].hrcdud13,
              s_hrcd[1].hrcdud14,s_hrcd[1].hrcdud15

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              ON ACTION controlp
                CASE WHEN INFIELD(hrcd01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_hrbm03"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO s_hrcd[1].hrcd01
                     WHEN INFIELD(hrcd09)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_hrat"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        #FUN-151117 wangjya #多选
#                        CALL q_hrat(TRUE, "q_hrat","")  RETURNING  g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO s_hrcd[1].hrcd09
                        #FUN-151117 wangjya
                     WHEN INFIELD(hrat04)
                        CALL cl_init_qry_var()
                        LET g_qryparam.arg2 = '1'
                        LET g_qryparam.form = "cq_hrao01_1_1"
                        LET g_qryparam.state = "c"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO hrat04
                        NEXT FIELD hrat04
                     OTHERWISE
                        EXIT CASE
                 END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121

      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
       CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrcduser', 'hrcdgrup') #FUN-980030

   #CLOSE WINDOW i044_w_q
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

   CALL g_hrcd.clear()
   CALL cl_replace_str(g_wc2,"hrcd09","hrat01") RETURNING g_wc2
   
#    CALL cl_get_hrzxa(g_user) RETURNING l_wc 
#    LET g_wc2 = g_wc2 CLIPPED," AND ",l_wc CLIPPED 
   CALL i044_b_fill(g_wc2)
   CALL i044_b_fill2()
END FUNCTION

FUNCTION i044_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   #No.FUN-680102 VARCHAR(200)

    LET g_sql =
        "SELECT 'N',hrcd01,hrbm04,hrcd11,hrat01,hrat02,hrat04,'',hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd07,",
        "       hrcd08,hrcdconf,hrcd10,hrcd12,",
        "       hrcdud01,hrcdud02,hrcdud03,hrcdud04,hrcdud05,",
        "       hrcdud06,hrcdud07,hrcdud08,hrcdud09,hrcdud10,",
        "       hrcdud11,hrcdud12,hrcdud13,hrcdud14,hrcdud15 ",
        "  FROM hrcd_file,hrbm_file,hrat_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hrcd01 = hrbm03(+) ",
        "   AND hrcd09 = hratid(+) ",
        " ORDER BY hrcd01,hrat01,hrcd02"
    PREPARE i044_pb FROM g_sql
    DECLARE hrcd_curs CURSOR FOR i044_pb

    CALL g_hrcd.clear()
    CALL cl_set_comp_visible("chk",FALSE)    #130912 add by wangxh
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrcd_curs INTO g_hrcd[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrao02 INTO g_hrcd[g_cnt].hrat04_name FROM hrao_file WHERE hrao01=g_hrcd[g_cnt].hrat04
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i044_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_hrcd TO s_hrcd.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE ROW
            LET l_ac = ARR_CURR()
            IF l_ac > 0 THEN
              CALL i044_msy_fill(g_hrcd[l_ac].hrcd09,g_hrcd[l_ac].hrcd10)
            END IF
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      END DISPLAY

      DISPLAY ARRAY g_hrcda TO s_hrcda.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE ROW
#            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY

      DISPLAY ARRAY g_dhrcda TO s_dhrcda.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION txjl
         LET g_action_choice="txjl"
         EXIT DIALOG
      END DISPLAY

      DISPLAY ARRAY g_mhrcda TO s_mhrcda.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE ROW
#            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY

      DISPLAY ARRAY g_shrcda TO s_shrcda.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE ROW
#            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY

      DISPLAY ARRAY g_yhrcda TO s_yhrcda.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE ROW
#            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      END DISPLAY

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

#      ON ACTION modifyhrcd01
#         LET g_action_choice="modifyhrcd01"
#         EXIT DIALOG

      ON ACTION ghr_confirm
         LET g_action_choice="ghr_confirm"
         EXIT DIALOG
      ON ACTION ghr_undo_confirm
         LET g_action_choice="ghr_undo_confirm"
         EXIT DIALOG
      ON ACTION ghri044_a
         LET g_action_choice="ghri044_a"
         EXIT DIALOG
      ON ACTION ghri044_b
         LET g_action_choice="ghri044_b"
         EXIT DIALOG
      ON ACTION ghri044_c
         LET g_action_choice="ghri044_c"
         EXIT DIALOG
      ON ACTION ghri044_d
         LET g_action_choice="ghri044_d"
         EXIT DIALOG
      ON ACTION ghri044_e
         LET g_action_choice="ghri044_e"
         EXIT DIALOG
      ON ACTION import
         LET g_action_choice="import"
         EXIT DIALOG 
      --* zhoumj 20160115 --
#      ON ACTION ghri044_f
#         LET g_action_choice="ghri044_f"
#         EXIT DIALOG
      -- zhoumj 20160115 *--
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION close
         LET g_action_choice="close"
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG

   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION



FUNCTION i044_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)

   CALL cl_set_comp_required("hrcd07",TRUE)
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("hrcd01,hrcd03,hrcd05",TRUE)
   END IF


END FUNCTION

FUNCTION i044_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-680102 VARCHAR(01)

   CALL cl_set_comp_entry("hrcd11,chk",FALSE)
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("hrcd01",FALSE)
   END IF

END FUNCTION

FUNCTION i044_hrcd01(p_cmd)
 DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_hrbm02    LIKE hrbm_file.hrbm02
   DEFINE l_hrbm04    LIKE hrbm_file.hrbm04
   DEFINE l_hrbm06    LIKE hrbm_file.hrbm06
   DEFINE l_hrbm07    LIKE hrbm_file.hrbm07
   DEFINE l_n         LIKE type_file.num5

   LET g_errno = NULL
   SELECT hrbm02,hrbm04,hrbm06,hrbm07 INTO l_hrbm02,l_hrbm04,l_hrbm06,l_hrbm07 FROM hrbm_file
    WHERE hrbm03=g_hrcd[l_ac].hrcd01
     #AND hrbm02 IN('004','006','010','011')
     # AND hrbm02 IN('004')
      AND hrbm02 IN('004','006','010')  #modi by nixiang170724  '010'为特殊假，'011'并未实际使用
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='ghr-072'
                                 LET l_hrbm02=NULL LET l_hrbm04=NULL  LET l_hrbm06=NULL

        WHEN l_hrbm07='N'      LET g_errno='9028'
                                 LET l_hrbm02=NULL LET l_hrbm04=NULL  LET l_hrbm06=NULL
        OTHERWISE
             LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    CASE l_hrbm02
      WHEN '004'  LET l_hrbm02 = '4'
      WHEN '006'  LET l_hrbm02 = '2'
      WHEN '010'  LET l_hrbm02 = '1' 
     #WHEN '011'  LET l_hrbm02 = '3' #mark by nixiang170724
      OTHERWISE     LET l_hrbm02 = NULL
    END CASE
    RETURN l_hrbm02,l_hrbm04,l_hrbm06
END FUNCTION

FUNCTION i044_hrcd09(p_cmd)
 DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_hrat02    LIKE hrat_file.hrat02
   DEFINE l_hratconf  LIKE hrat_file.hratconf
   DEFINE l_n         LIKE type_file.num5

   LET g_errno = NULL
   SELECT hrat02,hratconf INTO l_hrat02,l_hratconf FROM hrat_file
    WHERE hrat01=g_hrcd[l_ac].hrcd09
    CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='ghr-047'
                                 LET l_hrat02=NULL
        WHEN l_hratconf='N'      LET g_errno='9029'
                                 LET l_hrat02=NULL
        OTHERWISE
             LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    RETURN l_hrat02
END FUNCTION

FUNCTION i044_msy_fill(p_hrcda04,p_hrcda02)
 DEFINE p_hrcda04  LIKE  hrcda_file.hrcda04
 DEFINE p_hrcda02  LIKE  hrcda_file.hrcda02
 DEFINE l_hrcd01   LIKE  hrcd_file.hrcd01

   CALL g_mhrcda.clear()
   CALL g_shrcda.clear()
   CALL g_yhrcda.clear()
   CALL g_dhrcda.clear()
   LET p_hrcda04 = i044_hrat012hratid(p_hrcda04)
   IF cl_null(p_hrcda04) THEN RETURN END IF
   LET g_sql = "SELECT hrcda05,hrcda06,hrcda07,hrcda08,hrcda09,hrcda10,hrcda15,hrcda16 FROM hrcda_file ",  #增加是否撤销假
               " WHERE hrcda04 = '",p_hrcda04,"' ",
               "   AND hrcda16 = 'N' "

   PREPARE i044_d_prep FROM g_sql||" AND hrcda02 = '"||p_hrcda02||"'  ORDER BY 1,2,3,4 "
   PREPARE i044_m_prep FROM g_sql||" AND (TO_CHAR(hrcda05,'yyyy') = TO_CHAR(SYSDATE,'yyyy') OR TO_CHAR(hrcda07,'yyyy') = TO_CHAR(SYSDATE,'yyyy')) "||
                            " AND (TO_CHAR(hrcda05,'MM') = TO_CHAR(SYSDATE,'MM') OR TO_CHAR(hrcda07,'MM') = TO_CHAR(SYSDATE,'MM'))  "||
                            " ORDER BY 1,2,3,4"
   PREPARE i044_s_prep FROM g_sql||" AND (TO_CHAR(hrcda05,'yyyy') = TO_CHAR(SYSDATE,'yyyy') OR TO_CHAR(hrcda07,'yyyy') = TO_CHAR(SYSDATE,'yyyy')) "||
                            " AND (TO_CHAR(hrcda05,'Q') = TO_CHAR(SYSDATE,'Q') OR TO_CHAR(hrcda07,'Q') = TO_CHAR(SYSDATE,'Q'))  "||
                            " AND NOT (TO_CHAR(hrcda05,'MM') = TO_CHAR(SYSDATE,'MM') OR TO_CHAR(hrcda07,'MM') = TO_CHAR(SYSDATE,'MM')) "||
                            " ORDER BY 1,2,3,4"
   PREPARE i044_y_prep FROM g_sql||" AND (TO_CHAR(hrcda05,'yyyy') = TO_CHAR(SYSDATE,'yyyy') OR TO_CHAR(hrcda07,'yyyy') = TO_CHAR(SYSDATE,'yyyy')) "||
                            " AND NOT (TO_CHAR(hrcda05,'Q') = TO_CHAR(SYSDATE,'Q') OR TO_CHAR(hrcda07,'Q') = TO_CHAR(SYSDATE,'Q'))  "||
                            " ORDER BY 1,2,3,4"
   DECLARE i044_d_cs CURSOR FOR i044_d_prep
   DECLARE i044_m_cs CURSOR FOR i044_m_prep
   DECLARE i044_s_cs CURSOR FOR i044_s_prep
   DECLARE i044_y_cs CURSOR FOR i044_y_prep

   LET g_cnt = 1
   FOREACH i044_d_cs INTO g_dhrcda[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#130912 add by wangxh --str--
      IF NOT cl_null(g_dhrcda[g_cnt].hrcda10) THEN
        CASE g_dhrcda[g_cnt].hrcda10
             WHEN '001'  LET g_dhrcda[g_cnt].hrcda10='天'
             WHEN '002'  LET g_dhrcda[g_cnt].hrcda10='半天'
             WHEN '003'  LET g_dhrcda[g_cnt].hrcda10='小时'
             WHEN '004'  LET g_dhrcda[g_cnt].hrcda10='分钟'
             WHEN '005'  LET g_dhrcda[g_cnt].hrcda10='次'
         END CASE
       END IF
#130912 add by wangxh --end--
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_dhrcda.deleteElement(g_cnt)

   LET g_cnt = 1
   FOREACH i044_m_cs INTO g_mhrcda[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#130912 add by wangxh --str--
       IF NOT cl_null(g_mhrcda[g_cnt].hrcda10) THEN
        CASE g_mhrcda[g_cnt].hrcda10
             WHEN '001'  LET g_mhrcda[g_cnt].hrcda10='天'
             WHEN '002'  LET g_mhrcda[g_cnt].hrcda10='半天'
             WHEN '003'  LET g_mhrcda[g_cnt].hrcda10='小时'
             WHEN '004'  LET g_mhrcda[g_cnt].hrcda10='分钟'
             WHEN '005'  LET g_mhrcda[g_cnt].hrcda10='次'
         END CASE
       END IF
 #130912 add by wangxh --end--
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_mhrcda.deleteElement(g_cnt)

   LET g_cnt = 1
   FOREACH i044_s_cs INTO g_shrcda[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#130912 add by wangxh --str--
        IF NOT cl_null(g_shrcda[g_cnt].hrcda10) THEN
        CASE g_shrcda[g_cnt].hrcda10
             WHEN '001'  LET g_shrcda[g_cnt].hrcda10='天'
             WHEN '002'  LET g_shrcda[g_cnt].hrcda10='半天'
             WHEN '003'  LET g_shrcda[g_cnt].hrcda10='小时'
             WHEN '004'  LET g_shrcda[g_cnt].hrcda10='分钟'
             WHEN '005'  LET g_shrcda[g_cnt].hrcda10='次'
         END CASE
       END IF
#130912 add by wangxh --end--
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_shrcda.deleteElement(g_cnt)

   LET g_cnt = 1
   FOREACH i044_y_cs INTO g_yhrcda[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#130912 add by wangxh --str--
        IF NOT cl_null(g_yhrcda[g_cnt].hrcda10) THEN
        CASE g_yhrcda[g_cnt].hrcda10
             WHEN '001'  LET g_yhrcda[g_cnt].hrcda10='天'
             WHEN '002'  LET g_yhrcda[g_cnt].hrcda10='半天'
             WHEN '003'  LET g_yhrcda[g_cnt].hrcda10='小时'
             WHEN '004'  LET g_yhrcda[g_cnt].hrcda10='分钟'
             WHEN '005'  LET g_yhrcda[g_cnt].hrcda10='次'
         END CASE
       END IF
 #130912 add by wangxh --end--
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_yhrcda.deleteElement(g_cnt)
END FUNCTION

FUNCTION i044_b_fill2()

   CALL g_hrcda.clear()
   LET g_cnt = 1
   LET g_sql = "SELECT hrcda01,hrcda02,hrcda03,hrbm04,hrat01,hrat02,hrcda05,hrcda06,hrcda07,hrcda08,",
               "       hrcda09,hrcda10,hrcda11,hrcda12,hrcda13,hrcda14,hrcda15,hrcda16 ",
               "  FROM hrcda_file,hrbm_file,hrat_file",
               " WHERE 1=1 ",
               "   AND hrcda03 = hrbm03(+) ",
               "   AND hrcda04 = hratid(+) ",
               "   AND hrcda16 = 'N' ",
               " ORDER BY hrcda02 DESC,hrcda01 DESC"
   PREPARE i044_fill2_prep FROM g_sql
   DECLARE i044_fill2_cs CURSOR FOR i044_fill2_prep
   FOREACH i044_fill2_cs INTO g_hrcda[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#130912 add by wangxh --str--
        IF NOT cl_null(g_hrcda[g_cnt].hrcda10) THEN
        CASE g_hrcda[g_cnt].hrcda10
             WHEN '001'  LET g_hrcda[g_cnt].hrcda10='天'
             WHEN '002'  LET g_hrcda[g_cnt].hrcda10='半天'
             WHEN '003'  LET g_hrcda[g_cnt].hrcda10='小时'
             WHEN '004'  LET g_hrcda[g_cnt].hrcda10='分钟'
             WHEN '005'  LET g_hrcda[g_cnt].hrcda10='次'
         END CASE
       END IF
#130912 add by wangxh --end--
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_hrcda.deleteElement(g_cnt)
END FUNCTION

FUNCTION i044_revoke()
   CALL s_showmsg_init()
   CALL sghri044_revoke(FALSE,FALSE)
END FUNCTION

FUNCTION i044_y()
 DEFINE l_hrcd    RECORD  LIKE  hrcd_file.*
 DEFINE l_forupd_sql  STRING
 DEFINE l_num      LIKE type_file.num10
 DEFINE l_date    LIKE hrcda_file.hrcda05
 DEFINE i,l_i,l_cnt,l_n         LIKE type_file.num5

  #IF l_ac = 0 OR l_ac IS NULL THEN RETURN END IF
   INPUT ARRAY g_hrcd WITHOUT DEFAULTS FROM s_hrcd.*
       ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_set_comp_visible("chk",TRUE) #130912 add by wangxh
            CALL cl_set_comp_entry("chk",TRUE)
           # CALL cl_set_comp_entry("hrcd01,hrcd11,hrcd09,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd07,hrcd08,hrcd12",FALSE)
            CALL cl_set_comp_entry("hrcd01,hrcd11,hrcd09,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd08,hrcd12",FALSE)

        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增

           IF INT_FLAG THEN
              EXIT INPUT
           END IF

        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON ACTION sel_all
           LET g_action_choice="sel_all"
           LET l_i = 0
           FOR l_i = 1 TO g_rec_b
               LET g_hrcd[l_i].chk = 'Y'
           END FOR
        ON ACTION sel_none
           LET g_action_choice="sel_none"
           LET l_i = 0
           FOR l_i = 1 TO g_rec_b
               LET g_hrcd[l_i].chk = 'N'
              # DISPLAY BY NAME g_hrcn[l_i].sel
           END FOR
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   END INPUT
   CALL cl_set_comp_visible("chk",FALSE)    #130912 add by wangxh
   CALL cl_set_comp_entry("hrcd01,hrcd11,hrcd09,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd07,hrcd08,hrcd12",TRUE)

   IF INT_FLAG THEN
   	  LET INT_FLAG = FALSE
   	  RETURN
   END IF

   IF NOT cl_confirm('axm-108') THEN RETURN END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()
   LET l_forupd_sql = "SELECT * FROM hrcd_file WHERE hrcd10 = ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE i044_forupd_cl CURSOR FROM l_forupd_sql

   BEGIN WORK
   FOR i=1 TO g_rec_b
      IF g_hrcd[i].chk = 'Y' THEN
      	 INITIALIZE l_hrcd.* TO NULL
         SELECT * INTO l_hrcd.* FROM hrcd_file WHERE hrcd10 = g_hrcd[i].hrcd10
         LET l_n=0
         FOR l_num=l_hrcd.hrcd02 TO l_hrcd.hrcd04
          LET l_date=l_num 
          SELECT COUNT(*) INTO l_n FROM hrcda_file WHERE hrcda04=l_hrcd.hrcd09
          AND hrcda05=l_date and hrcda06<=l_hrcd.hrcd03 
          AND hrcda07=l_date and hrcda08>=l_hrcd.hrcd03
         END FOR 
         IF l_n>1 THEN 
         	  CALL s_errmsg("hrcd10",l_hrcd.hrcd10,'','ghr-250',1)
            LET g_success='N'
            CONTINUE FOR 
         END IF 
         IF cl_null(l_hrcd.hrcd10) THEN
      	    CALL s_errmsg("hrcd10",l_hrcd.hrcd10,'',-400,1)
      	    LET g_success = 'N'
            CONTINUE FOR
         END IF
         IF l_hrcd.hrcdconf = 'X' THEN
            LET g_success = 'N'
            CALL s_errmsg('hrcd10',l_hrcd.hrcd10,'','9024',1)
            CONTINUE FOR
         END IF
         IF l_hrcd.hrcdconf = 'Y' THEN
            LET g_success = 'N'
            CALL s_errmsg('hrcd10',l_hrcd.hrcd10,'','9023',1)
            CONTINUE FOR
         END IF
         IF l_hrcd.hrcdacti = 'N' THEN
            LET g_success = 'N'
            CALL s_errmsg('hrcd10',l_hrcd.hrcd10,'','mfg0301',1)
            CONTINUE FOR
         END IF
           SELECT count(*) INTO l_cnt  #使用年假冲抵
           FROM hrbm_file WHERE hrbm03=g_hrcd[l_ac].hrcd01 AND hrbmud06='Y'
           IF l_cnt>0 AND NOT cl_null(g_hrcd[l_ac].hrcd09) THEN
                CALL i044_YOV(l_hrcd.*)
           END IF
        OPEN i044_forupd_cl USING l_hrcd.hrcd10
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('hrcd10',g_hrcd[i].hrcd10,'',SQLCA.sqlcode,1)
           CONTINUE FOR
        END IF
        UPDATE hrcd_file SET hrcdconf = 'Y',
                             hrcdmodu = g_user,
                             hrcddate = g_today
         WHERE hrcd10 = l_hrcd.hrcd10
#130912_2 add by wangxh --str--
        UPDATE hrcp_file SET hrcp35='N',
                             hrcpmodu=g_user,
                             hrcpdate=g_today
          WHERE hrcp02=l_hrcd.hrcd09 AND hrcp03 BETWEEN l_hrcd.hrcd02 AND l_hrcd.hrcd04
#130912_2 add by wangxh --end--
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('hrcd10',g_hrcd[i].hrcd10,'upd hrcd_file','abm-984',1)
           LET g_success = 'N'
        END IF
      END IF
   END FOR
   IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_err('','abm-983',0)
   ELSE
       ROLLBACK WORK
       CALL s_showmsg()
   END IF
   IF NOT cl_null(g_wc2) AND g_wc2<>'' THEN
       CALL i044_b_fill(g_wc2)
   END IF

END FUNCTION

FUNCTION i044_z()
 DEFINE l_hrcd    RECORD  LIKE  hrcd_file.*
 DEFINE l_forupd_sql  STRING
 DEFINE i         LIKE type_file.num5
 DEFINE l_hrcdb03    LIKE hrcdb_file.hrcdb03
 DEFINE l_hrcdb04    LIKE hrcdb_file.hrcdb04
 DEFINE l_hrcdb05    LIKE hrcdb_file.hrcdb05
 DEFINE l_hrcdb06    LIKE hrcdb_file.hrcdb06
 DEFINE l_sql     STRING

  #IF l_ac = 0 OR l_ac IS NULL THEN RETURN END IF
   INPUT ARRAY g_hrcd WITHOUT DEFAULTS FROM s_hrcd.*
       ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

        BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_set_comp_visible("chk",TRUE) #130612 add by wangxh130912
            CALL cl_set_comp_entry("chk",TRUE)
            #CALL cl_set_comp_entry("hrcd01,hrcd11,hrcd09,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd07,hrcd08,hrcd12",FALSE)
            CALL cl_set_comp_entry("hrcd01,hrcd11,hrcd09,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd08,hrcd12",FALSE)

        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增

           IF INT_FLAG THEN
              EXIT INPUT
           END IF

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   END INPUT
   CALL cl_set_comp_visible("chk",FALSE)    #130912 add by wangxh
   CALL cl_set_comp_entry("hrcd01,hrcd11,hrcd09,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd07,hrcd08,hrcd12",TRUE)

   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      RETURN
   END IF

   IF NOT cl_confirm('axm-108') THEN RETURN END IF

   CALL s_showmsg_init()
   LET g_success = 'Y'
   LET l_forupd_sql = "SELECT * FROM hrcd_file WHERE hrcd10 = ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE i044_forupd_cl2 CURSOR FROM l_forupd_sql

   BEGIN WORK
   FOR i=1 TO g_rec_b
      IF g_hrcd[i].chk = 'Y' THEN
      	 INITIALIZE l_hrcd.* TO NULL
         SELECT * INTO l_hrcd.* FROM hrcd_file WHERE hrcd10 = g_hrcd[i].hrcd10
         IF cl_null(l_hrcd.hrcd10) THEN
      	    CALL s_errmsg('hrcd10',l_hrcd.hrcd10,'',-400,1)
      	    LET g_success = 'N'
            CONTINUE FOR
         END IF
         IF l_hrcd.hrcdconf = 'X' THEN
         	  LET g_success = 'N'
         	  CALL s_errmsg('hrcd10',l_hrcd.hrcd10,'','9024',1)
            CONTINUE FOR
         END IF
         IF l_hrcd.hrcdconf = 'N' THEN
            CONTINUE FOR
         END IF
         IF l_hrcd.hrcdacti = 'N' THEN
         	  LET g_success = 'N'
         	  CALL s_errmsg('hrcd10',l_hrcd.hrcd10,'','mfg0301',1)
            CONTINUE FOR
         END IF
        OPEN i044_forupd_cl2 USING l_hrcd.hrcd10
        IF SQLCA.sqlcode THEN
           LET g_success = 'N'
           CALL s_errmsg('hrcd10',l_hrcd.hrcd10,'',SQLCA.sqlcode,1)
           CONTINUE FOR
        END IF
        UPDATE hrcd_file SET hrcdconf = 'N',
                             hrcdmodu = g_user,
                             hrcddate = g_today
         WHERE hrcd10 = l_hrcd.hrcd10
         
                 IF l_hrcd.hrcd11 = '2' THEN  #年假回滚
                    LET l_sql = " select hrcdb03,hrcdb04,hrcdb05,hrcdb06 FROM hrcdb_file ",
                                "  where hrcdb01 = '",l_hrcd.hrcd10,"' "
                      PREPARE i044_del2 FROM l_sql
                      DECLARE i044_hrcdbs CURSOR FOR i044_del2
                   FOREACH i044_hrcdbs INTO l_hrcdb03,l_hrcdb04,l_hrcdb05,l_hrcdb06
                      IF  l_hrcdb05 = '003' THEN  LET l_hrcdb04 = l_hrcdb04/8 END IF
                      IF l_hrcdb06 = '1' THEN
                         UPDATE hrch_file SET hrch17 = hrch17 + l_hrcdb04,hrch21 = hrch21 + l_hrcdb04
                          WHERE hrch19 = l_hrcdb03
                      ELSE
                         UPDATE hrch_file SET hrch17 = hrch17 + l_hrcdb04,hrch20 = hrch20 + l_hrcdb04
                          WHERE hrch19 = l_hrcdb03
                      END IF
                      
                   END FOREACH
                END IF     
                           
                #调休假回滚
                IF l_hrcd.hrcd11 = '3' THEN
                    LET l_sql = " select hrcdb03,hrcdb04,hrcdb05 FROM hrcdb_file ",
                                "  where hrcdb01 = '",l_hrcd.hrcd10,"' "
                      PREPARE i044_del21 FROM l_sql
                      DECLARE i044_hrcdbs1 CURSOR FOR i044_del21
                   FOREACH i044_hrcdbs1 INTO l_hrcdb03,l_hrcdb04,l_hrcdb05
                      IF  l_hrcdb05 = '003' THEN  LET l_hrcdb04 = l_hrcdb04/8 END IF
                         UPDATE hrci_file SET hrci08 = l_hrci.hrci08 -  l_hrcdb04,hrci09 = l_hrci.hrci09 +  l_hrcdb04
                          WHERE hrci01 = l_hrcdb03                     
                   END FOREACH
                END IF
         
         
         
 #130912_2 add by wangxh --str--
        UPDATE hrcp_file SET hrcp35='N',
                             hrcpmodu=g_user,
                             hrcpdate=g_today
          WHERE hrcp02=l_hrcd.hrcd09 AND hrcp03 BETWEEN l_hrcd.hrcd02 AND l_hrcd.hrcd04
#130912_2 add by wangxh --end--
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('hrcd10',l_hrcd.hrcd10,'upd hrcd_file','ghr-115',1)
           LET g_success = 'N'
        ELSE

        END IF
      END IF
   END FOR
   IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_err('','abm-983',0)
   ELSE
       ROLLBACK WORK
       CALL s_showmsg()
   END IF
   CALL i044_b_fill(g_wc2)
END FUNCTION


FUNCTION i044_hrat012hratid(p_hrat01)
   DEFINE p_hrat01  LIKE  hrat_file.hrat01
   DEFINE l_hratid  LIKE  hrat_file.hratid

   SELECT hratid INTO l_hratid FROM hrat_file
    WHERE hrat01  = p_hrat01
   IF SQLCA.sqlcode THEN
      LET l_hratid = NULL
   END IF
   RETURN l_hratid
END FUNCTION

FUNCTION i044_p1()
   CALL sghri044_p1()
   CALL i044_b_fill(g_wc2)
   CALL i044_b_fill2()
END FUNCTION

FUNCTION i044_p2()
   CALL sghri044_p2()
   CALL i044_b_fill(g_wc2)
   CALL i044_b_fill2()
END FUNCTION

FUNCTION i044_p3()
   CALL sghri044_p3()
   CALL i044_b_fill(g_wc2)
   CALL i044_b_fill2()
END FUNCTION

FUNCTION i044_p4()
   CALL sghri044_p4()
   CALL i044_b_fill(g_wc2)
   CALL i044_b_fill2()
END FUNCTION
FUNCTION i044_tx_fill()
DEFINE l_sql STRING
DEFINE l_i,l_rec_b   LIKE type_file.num5
DEFINE l_hrci    DYNAMIC ARRAY OF RECORD
                  sure   LIKE type_file.chr1,
                  hrci01 LIKE hrci_file.hrci01,
                  hrat01 LIKE hrat_file.hrat01,
                  hrat02 LIKE hrat_file.hrat02,
                  hrat04 LIKE hrat_file.hrat04,
                  hrao02 LIKE hrao_file.hrao02,
                  hrat05 LIKE hrat_file.hrat05,
                  hras04 LIKE hras_file.hras04,
                  hrci03 LIKE hrci_file.hrci03,
                  hrci04 LIKE hrci_file.hrci04,
                  hrci05 LIKE hrci_file.hrci05,
                  hrci06 LIKE hrci_file.hrci06,
                  hrci07 LIKE hrci_file.hrci07,
                  hrci08 LIKE hrci_file.hrci08,
                  hrci09 LIKE hrci_file.hrci09,
                  hrci10 LIKE hrci_file.hrci10,
                  hrci11 LIKE hrci_file.hrci11,
                  hrciconf LIKE hrci_file.hrciconf
               END RECORD
DEFINE    l_hrcdb02 LIKE hrcdb_file.hrcdb02
     IF l_ac = 0 OR l_ac1 = 0 THEN
        RETURN
     END IF
     IF g_hrcd[l_ac].hrcd01 !='025' THEN
        CALL cl_err("非调休假无明细", '!', 1)
        RETURN
     END IF
     OPEN WINDOW i0441_w
     WITH FORM "ghr/42f/ghri049"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    CALL cl_set_act_visible("accept,cancel", FALSE)
    CALL cl_set_comp_visible("sure",FALSE)
    SELECT hrcda01 INTO l_hrcdb02 FROM hrcda_file
     WHERE hrcda02= g_hrcd[l_ac].hrcd10 AND hrcda05 = g_dhrcda[l_ac1].hrcda05
       AND hrcda06 = g_dhrcda[l_ac1].hrcda06
    LET l_sql = "  SELECT 'N',hrci01,hrat01,hrat02,hrat04,hrao02,hrat05,hras04,hrci03,hrci04,hrci05,hrci06,hrci07,hrci08,hrci09,hrci10,hrci11,hrciconf ",
                "    FROM hrci_file left join hrat_file on hrci02 = hratid   ",
                "         left join hrao_file on hrat04 = hrao02   ",
                "         left join hras_file on hras01 = hrao05   ",
                "   WHERE  hrci01 in (SELECT hrcdb03 FROM hrcdb_file WHERE hrcdb01 = '",g_hrcd[l_ac].hrcd10,"' and hrcdb02  = '",l_hrcdb02,"'  and hrcdb06 = ' ') ",
                "   ORDER BY hrat01,hrci03"

    PREPARE i044_1_q FROM l_sql
    DECLARE i044_1_s CURSOR FOR i044_1_q
    LET l_i=1
    FOREACH i044_1_s INTO l_hrci[l_i].*
       LET l_i=l_i+1
       IF l_i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
       END IF
    END FOREACH
    CALL l_hrci.deleteElement(l_i)
    LET l_rec_b = l_i - 1
    DISPLAY l_rec_b TO cn2
    DISPLAY ARRAY l_hrci TO s_hrci.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
#         ON ACTION xx
#            LET w = ui.Window.getCurrent()
#            LET f = w.getForm()
#            LET page = f.FindNode("Page","page1")
#            CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrat),'','')
    END DISPLAY
    CLOSE WINDOW i0441_w
END FUNCTION



FUNCTION i044_chk_006(p_hrcd) #检查年检 add by pengzb 151112
  DEFINE p_hrcd  RECORD  LIKE hrcd_file.*
  DEFINE l_hrcf  RECORD  LIKE hrcf_file.*
  DEFINE  l_hrch    DYNAMIC ARRAY OF RECORD
             ptype   LIKE type_file.chr1,
             hrch01  LIKE hrch_file.hrch01,
             hrch02  LIKE hrch_file.hrch02,
             hrch03  LIKE hrch_file.hrch03,
#130912 add by wangxh--str--
             hrch06  LIKE hrch_file.hrch06,
             hrch17  LIKE hrch_file.hrch17,
#130912 add by wangxh--end--
             hrch19  LIKE hrch_file.hrch19,
             l_day_umf  LIKE hrcc_file.hrcc03,
             l_day_unit LIKE hrcc_file.hrcc10
        END RECORD
  DEFINE l_hrch_1  DYNAMIC ARRAY OF RECORD
            hrch01   LIKE  hrch_file.hrch01,
            hrch02   LIKE  hrch_file.hrch02,
            hrch03   LIKE  hrch_file.hrch03
             END RECORD
  DEFINE l_no  DYNAMIC ARRAY OF RECORD
            no    LIKE  hrcdb_file.hrcdb03,
            day   LIKE  hrcdb_file.hrcdb04,
            unit  LIKE  hrcdb_file.hrcdb05,
            ytype LIKE type_file.chr1
             END RECORD
  DEFINE l_n,i     LIKE  type_file.num5
  DEFINE l_nday  LIKE  type_file.num5
  DEFINE l_day   LIKE  type_file.dat
  DEFINE l_msg   STRING
  DEFINE l_hrat01  LIKE  hrat_file.hrat01
  DEFINE l_hrat02  LIKE  hrat_file.hrat02
  DEFINE l_hrch20  LIKE  hrch_file.hrch20
  DEFINE l_hrch21  LIKE  hrch_file.hrch21
  DEFINE l_hrch22  LIKE  hrch_file.hrch22
  DEFINE l_type    LIKE  type_file.chr1
  DEFINE l_res     BOOLEAN
  DEFINE l_end     LIKE  type_file.num5
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06
  DEFINE l_avl_day  LIKE hrcd_file.hrcd06

   SELECT hrcf_file.* INTO l_hrcf.* FROM hrcf_file,hrat_file
    WHERE hrcf01 = hrat03
      AND hrcf02 = hrat04
      AND hratid = p_hrcd.hrcd09
   IF SQLCA.sqlcode = 100 THEN
      SELECT hrcf_file.* INTO l_hrcf.* FROM hrcf_file,hrat_file
       WHERE hrcf01 = hrat03
         AND hrcf02 = ' '
         AND hratid = p_hrcd.hrcd09
   END IF
   LET l_end = p_hrcd.hrcd04 - p_hrcd.hrcd02
   FOR l_n = 0 TO l_end STEP 1
      CALL l_hrch.clear()
      LET l_day = p_hrcd.hrcd02 + l_n
      CALL sghri044_p3_insertday_chk(p_hrcd.hrcd09,l_day,p_hrcd.hrcd06,p_hrcd.hrcd07,'') RETURNING l_res,l_hrch
      IF NOT l_res THEN
          SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = p_hrcd.hrcd09
          LET l_msg = l_day
          CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-141',1)
          LET g_success = 'N'
          EXIT FOR
      ELSE
          CALL l_no.clear()
          FOR i =1  TO l_hrch.getLength()
             IF l_hrch[i].hrch19 IS NOT NULL THEN
                LET l_no[i].no = l_hrch[i].hrch19
                LET l_no[i].day = l_hrch[i].l_day_umf
                LET l_no[i].unit = l_hrch[i].l_day_unit
                LET l_no[i].ytype = l_hrch[i].ptype
             END IF
          END FOR
          IF l_no.getLength() > 0 THEN
             CALL sghri044__split(p_hrcd.*,l_day,l_no)
          END IF
          FOR i = 1 TO l_hrch.getLength()
             IF l_hrch[i].hrch19 IS NOT NULL THEN
                CALL sghri044__umf(l_hrch[i].l_day_umf,l_hrch[i].l_day_unit,'001') RETURNING l_umf_day
                CASE l_hrch[i].ptype
                   WHEN '1'
                      UPDATE hrch_file SET hrch17 = hrch17 - l_umf_day,hrch06 = hrch06 - l_umf_day
                       WHERE hrch01 = l_hrch[i].hrch01
                         AND hrch02 = l_hrch[i].hrch02
                         AND hrch03 = l_hrch[i].hrch03
                   WHEN '2'
                      LET l_hrch20=0   LET l_hrch21=0   LET l_hrch22=0
                      LET l_avl_day = l_umf_day
                      SELECT hrch20,hrch21,hrch22 INTO l_hrch20,l_hrch21,l_hrch22
                        FROM hrch_file
                       WHERE hrch01 = l_hrch[i].hrch01
                         AND hrch02 = l_hrch[i].hrch02
                         AND hrch03 = l_hrch[i].hrch03
                      WHILE TRUE
                         IF l_avl_day <=0 THEN EXIT WHILE END IF
                         #法定假
                         IF l_hrch20 >0 AND l_hrch20 >= l_avl_day THEN
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch20 = hrch20 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch20,hrch20 = hrch20 - l_hrch20
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_hrch20 = 0
                            LET l_avl_day = l_avl_day - l_hrch20
                         END IF
                         #福利假
                         IF l_hrch21 >0 AND l_hrch21 >= l_avl_day THEN
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch21 = hrch21 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch21,hrch21 = hrch21 - l_hrch21
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_hrch21 = 0
                            LET l_avl_day = l_avl_day - l_hrch20
                         END IF
                         #调整调
                         IF l_hrch22 >0 AND l_hrch22 >= l_avl_day THEN
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch22 = hrch22 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch22,hrch22 = hrch22 - l_hrch22
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_hrch22 = 0
                            LET l_avl_day = l_avl_day - l_hrch22
                         END IF
                         IF l_avl_day > 0 THEN
                         	  SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = p_hrcd.hrcd09
                             LET l_msg = l_day
                             CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-141',1)
                             LET g_success = 'N'
                             EXIT WHILE
                         ELSE
                             EXIT WHILE
                         END IF
                      END WHILE
                END CASE
                IF l_hrcf.hrcf26 = 'Y' THEN
                   CALL l_hrch_1.appendElement()
                   LET l_hrch_1[l_hrch_1.getLength()].hrch01 = l_hrch[i].hrch01
                   LET l_hrch_1[l_hrch_1.getLength()].hrch02 = l_hrch[i].hrch02
                   LET l_hrch_1[l_hrch_1.getLength()].hrch03 = l_hrch[i].hrch03
                END IF
             END IF
          END FOR
      END IF
   END FOR
   FOR l_n = 1 TO l_hrch_1.getLength()
       UPDATE hrch_file SET hrch06 = 0,hrch20=0,hrch21=0,hrch22=0
        WHERE hrch01 = l_hrch_1[l_n].hrch01
          AND hrch02 = l_hrch_1[l_n].hrch02
          AND hrch03 = l_hrch_1[l_n].hrch03
   END FOR

END  FUNCTION



FUNCTION i044_chk_011(p_hrcd) #检查调休 add by pengzb 151112
  DEFINE p_hrcd  RECORD  LIKE hrcd_file.*
  DEFINE  l_hrci    DYNAMIC ARRAY OF RECORD
             hrci01  LIKE hrci_file.hrci01,
             hrci02  LIKE hrci_file.hrci02,
             hrci03  LIKE hrci_file.hrci03,
             hrci04  LIKE hrci_file.hrci04,
             hrci05  LIKE hrci_file.hrci05,
             hrci06  LIKE hrci_file.hrci06,
             hrci07  LIKE hrci_file.hrci07,
             hrci08  LIKE hrci_file.hrci08,
             hrci09  LIKE hrci_file.hrci09,
             l_day_umf  LIKE hrcc_file.hrcc03,    #这里指小时，分钟数
             l_day_unit LIKE hrcc_file.hrcc10     #'003','004'
          END RECORD
  DEFINE l_hrci_1  DYNAMIC ARRAY OF RECORD
            hrci01   LIKE  hrci_file.hrci01,
            hrci02   LIKE  hrci_file.hrci02,
            hrci03   LIKE  hrci_file.hrci03
             END RECORD
  DEFINE l_no  DYNAMIC ARRAY OF RECORD
            no   LIKE  hrcdb_file.hrcdb03,
            day  LIKE  hrcdb_file.hrcdb04,
            unit LIKE  hrcdb_file.hrcdb05,
            ytype LIKE hrcdb_file.hrcdb06
             END RECORD
  DEFINE l_n,i     LIKE  type_file.num5
  DEFINE l_day   LIKE  type_file.dat
  DEFINE l_msg   STRING
  DEFINE l_hrat01  LIKE  hrat_file.hrat01
  DEFINE l_hrat02  LIKE  hrat_file.hrat02
  DEFINE l_res     BOOLEAN
  DEFINE l_end     LIKE type_file.num5
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06

   LET l_end = p_hrcd.hrcd04 - p_hrcd.hrcd02
   FOR l_n = 0 TO l_end STEP 1
      CALL l_hrci.clear()
      LET l_day = p_hrcd.hrcd02 + l_n
      CALL sghri044_p4_insertday_chk(p_hrcd.hrcd09,l_day,p_hrcd.hrcd06,p_hrcd.hrcd07,'') RETURNING l_res,l_hrci
      IF NOT l_res THEN
         SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = p_hrcd.hrcd09
         LET l_msg = l_day
         CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-142',1)
         LET g_success = 'N'
         EXIT FOR
      END IF
      CALL l_no.clear()
      FOR i =1  TO l_hrci.getLength()
         IF l_hrci[i].hrci01 IS NOT NULL THEN
            LET l_no[i].no = l_hrci[i].hrci01
            LET l_no[i].day = l_hrci[i].l_day_umf
            LET l_no[i].unit = l_hrci[i].l_day_unit
            LET l_no[i].ytype = NULL
         END IF
      END FOR
      IF l_no.getLength() > 0 THEN
         CALL sghri044__split(p_hrcd.*,l_day,l_no)
      END IF
      FOR i = 1 TO l_hrci.getLength()
         IF l_hrci[i].hrci01 IS NOT NULL THEN
            CALL sghri044__umf(l_hrci[i].l_day_umf,l_hrci[i].l_day_unit,'003') RETURNING l_umf_day
            UPDATE hrci_file SET hrci08=hrci08+l_umf_day,hrci09=hrci09-l_umf_day
             WHERE hrci01 = l_hrci[i].hrci01
               AND hrci02 = l_hrci[i].hrci02
               AND hrci03 = l_hrci[i].hrci03
         END IF
      END FOR
#      IF l_hrci.hrci06 = 'Y' THEN
#         CALL l_hrci_1.appendElement()
#         LET l_hrci_1[l_hrci_1.getLength()].hrci01 = l_hrci.hrci01
#         LET l_hrci_1[l_hrci_1.getLength()].hrci02 = l_hrci.hrci02
#         LET l_hrci_1[l_hrci_1.getLength()].hrci03 = l_hrci.hrci03
#      END IF
   END FOR
#   FOR l_n = 1 TO l_hrci_1.getLength()
#       UPDATE hrci_file SET hrci09 = 0
#        WHERE hrci02 = l_hrci_1[l_n].hrci01
#          AND hrci04 = l_hrci_1[l_n].hrci02
#          AND hrci07 = l_hrci_1[l_n].hrci03
#   END FOR

END  FUNCTION

FUNCTION i044_val_trans() #add by pengzb 151112

    #CALL go_hrcd.clear()
    INITIALIZE go_hrcd.* TO NULL


    LET go_hrcd.hrcd01  =      g_hrcd[l_ac].hrcd01
    LET go_hrcd.hrcd11  =      g_hrcd[l_ac].hrcd11
    LET go_hrcd.hrcd09  =      g_hratid
    LET go_hrcd.hrcd02  =      g_hrcd[l_ac].hrcd02
    LET go_hrcd.hrcd03  =      g_hrcd[l_ac].hrcd03
    LET go_hrcd.hrcd04  =      g_hrcd[l_ac].hrcd04
    LET go_hrcd.hrcd05  =      g_hrcd[l_ac].hrcd05
    LET go_hrcd.hrcd06  =      g_hrcd[l_ac].hrcd06
    LET go_hrcd.hrcd07  =      g_hrcd[l_ac].hrcd07
    LET go_hrcd.hrcd08  =      g_hrcd[l_ac].hrcd08
    LET go_hrcd.hrcdconf  =      g_hrcd[l_ac].hrcdconf
    LET go_hrcd.hrcd10  =      g_hrcd[l_ac].hrcd10
    LET go_hrcd.hrcd12  =      g_hrcd[l_ac].hrcd12
    LET go_hrcd.hrcdud01  =      g_hrcd[l_ac].hrcdud01
    LET go_hrcd.hrcdud02  =      g_hrcd[l_ac].hrcdud02
    LET go_hrcd.hrcdud03  =      g_hrcd[l_ac].hrcdud03
    LET go_hrcd.hrcdud04  =      g_hrcd[l_ac].hrcdud04
    LET go_hrcd.hrcdud05  =      g_hrcd[l_ac].hrcdud05
    LET go_hrcd.hrcdud06  =      g_hrcd[l_ac].hrcdud06
    LET go_hrcd.hrcdud07  =      g_hrcd[l_ac].hrcdud07
    LET go_hrcd.hrcdud08  =      g_hrcd[l_ac].hrcdud08
    LET go_hrcd.hrcdud09  =      g_hrcd[l_ac].hrcdud09
    LET go_hrcd.hrcdud10  =      g_hrcd[l_ac].hrcdud10
    LET go_hrcd.hrcdud11  =      g_hrcd[l_ac].hrcdud11
    LET go_hrcd.hrcdud12  =      g_hrcd[l_ac].hrcdud12
    LET go_hrcd.hrcdud13  =      g_hrcd[l_ac].hrcdud13
    LET go_hrcd.hrcdud14  =      g_hrcd[l_ac].hrcdud14
    LET go_hrcd.hrcdud15  =      g_hrcd[l_ac].hrcdud15




END  FUNCTION





FUNCTION i044_YOV(p_hrcd) #冲抵年假处理，add by pengzb151113
 DEFINE p_hrcd    RECORD  LIKE  hrcd_file.*
  DEFINE l_hrcf  RECORD  LIKE hrcf_file.*
  DEFINE  l_hrch    DYNAMIC ARRAY OF RECORD
             ptype   LIKE type_file.chr1,
             hrch01  LIKE hrch_file.hrch01,
             hrch02  LIKE hrch_file.hrch02,
             hrch03  LIKE hrch_file.hrch03,
#130912 add by wangxh--str--
             hrch06  LIKE hrch_file.hrch06,
             hrch17  LIKE hrch_file.hrch17,
#130912 add by wangxh--end--
             hrch19  LIKE hrch_file.hrch19,
             l_day_umf  LIKE hrcc_file.hrcc03,
             l_day_unit LIKE hrcc_file.hrcc10
        END RECORD
  DEFINE l_hrch_1  DYNAMIC ARRAY OF RECORD
            hrch01   LIKE  hrch_file.hrch01,
            hrch02   LIKE  hrch_file.hrch02,
            hrch03   LIKE  hrch_file.hrch03
             END RECORD
  DEFINE    l_hrcda       RECORD LIKE hrcda_file.*
  DEFINE l_no  DYNAMIC ARRAY OF RECORD
            no    LIKE  hrcdb_file.hrcdb03,
            day   LIKE  hrcdb_file.hrcdb04,
            unit  LIKE  hrcdb_file.hrcdb05,
            ytype LIKE type_file.chr1
             END RECORD
  DEFINE l_n,i     LIKE  type_file.num5
  DEFINE l_nday  LIKE  type_file.num5
  DEFINE l_day   LIKE  type_file.dat
  DEFINE l_msg   STRING
  DEFINE l_hrat01  LIKE  hrat_file.hrat01
  DEFINE l_hrat02  LIKE  hrat_file.hrat02
  DEFINE l_hrch20  LIKE  hrch_file.hrch20
  DEFINE l_hrch21  LIKE  hrch_file.hrch21
  DEFINE l_hrch22  LIKE  hrch_file.hrch22
  DEFINE l_type    LIKE  type_file.chr1
  DEFINE l_res,l_flag ,l_isAsked    BOOLEAN
  DEFINE l_end,l_i     LIKE  type_file.num5
  DEFINE l_umf_day  LIKE hrcd_file.hrcd06
  DEFINE l_avl_day  LIKE hrcd_file.hrcd06

  #LET p_hrcd.hrcd09 = i044_hrat012hratid(p_hrcd.hrcd09)
 #1 检查是否可休，可休继续，不可修跳出
   LET g_sql = "SELECT *   FROM hrcda_file ",
               " WHERE hrcda02 = '",p_hrcd.hrcd10,"' "
   PREPARE sghri044_p3_fill_prep FROM g_sql
   DECLARE sghri044_p3_fill_cs CURSOR FOR sghri044_p3_fill_prep

   LET l_isAsked=FALSE
   LET p_hrcd.hrcdud06='Y'
   FOREACH sghri044_p3_fill_cs INTO l_hrcda.*

         IF  l_hrcda.hrcda10='003' AND (l_hrcda.hrcda09 = 4 OR l_hrcda.hrcda09 = 8) THEN
               LET l_hrcda.hrcda10='001'
               LET l_hrcda.hrcda09=l_hrcda.hrcda09/8   #小时折算成天
         END IF

         IF l_hrcda.hrcda10<>'001' THEN RETURN  END IF #单位不为天，不冲抵

         CALL i044_chk_year(p_hrcd.hrcd09, l_hrcda.hrcda05, l_hrcda.hrcda09, l_hrcda.hrcda10)  #编码，起始、数量、单位
                 RETURNING l_flag,l_hrch
         IF  NOT l_flag THEN RETURN END IF

#         IF NOT l_isAsked  THEN
#             IF NOT cl_confirm('pzb-018') THEN RETURN  END IF
#             LET l_isAsked=TRUE
#         END IF


          CALL l_no.clear()
          FOR i =1  TO l_hrch.getLength()
             IF l_hrch[i].hrch19 IS NOT NULL THEN
                LET l_no[i].no = l_hrch[i].hrch19
                LET l_no[i].day = l_hrch[i].l_day_umf
                LET l_no[i].unit = l_hrch[i].l_day_unit
                LET l_no[i].ytype = l_hrch[i].ptype
             END IF
          END FOR
          IF l_no.getLength() > 0 THEN
             CALL sghri044__split(p_hrcd.*,l_day,l_no)
          END IF
          FOR i = 1 TO l_hrch.getLength()
             IF l_hrch[i].hrch19 IS NOT NULL THEN
                CALL sghri044__umf(l_hrch[i].l_day_umf,l_hrch[i].l_day_unit,'001') RETURNING l_umf_day
                CASE l_hrch[i].ptype
                   WHEN '1'
                      UPDATE hrch_file SET hrch17 = hrch17 - l_umf_day,hrch06 = hrch06 - l_umf_day
                       WHERE hrch01 = l_hrch[i].hrch01
                         AND hrch02 = l_hrch[i].hrch02
                         AND hrch03 = l_hrch[i].hrch03
                   WHEN '2'
                      LET l_hrch20=0   LET l_hrch21=0   LET l_hrch22=0
                      LET l_avl_day = l_umf_day
                      SELECT hrch20,hrch21,hrch22 INTO l_hrch20,l_hrch21,l_hrch22
                        FROM hrch_file
                       WHERE hrch01 = l_hrch[i].hrch01
                         AND hrch02 = l_hrch[i].hrch02
                         AND hrch03 = l_hrch[i].hrch03
                      WHILE TRUE
                         IF l_avl_day <=0 THEN EXIT WHILE END IF
                         #法定假
                         IF l_hrch20 >0 AND l_hrch20 >= l_avl_day THEN
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch20 = hrch20 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch20,hrch20 = hrch20 - l_hrch20
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_hrch20 = 0
                            LET l_avl_day = l_avl_day - l_hrch20
                         END IF
                         #福利假
                         IF l_hrch21 >0 AND l_hrch21 >= l_avl_day THEN
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch21 = hrch21 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch21,hrch21 = hrch21 - l_hrch21
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_hrch21 = 0
                            LET l_avl_day = l_avl_day - l_hrch20
                         END IF
                         #调整调
                         IF l_hrch22 >0 AND l_hrch22 >= l_avl_day THEN
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_avl_day,hrch22 = hrch22 - l_avl_day
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_avl_day = 0
                         ELSE
         	                  UPDATE hrch_file SET hrch17 = hrch17 - l_hrch22,hrch22 = hrch22 - l_hrch22
                             WHERE hrch01 = l_hrch[i].hrch01
                               AND hrch02 = l_hrch[i].hrch02
                               AND hrch03 = l_hrch[i].hrch03
                            LET l_hrch22 = 0
                            LET l_avl_day = l_avl_day - l_hrch22
                         END IF
                         IF l_avl_day > 0 THEN
                         	  SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = p_hrcd.hrcd09
                             LET l_msg = l_day
                             CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-141',1)
                             LET g_success = 'N'
                             EXIT WHILE
                         ELSE
                             EXIT WHILE
                         END IF
                      END WHILE
                END CASE
                IF l_hrcf.hrcf26 = 'Y' THEN
                   CALL l_hrch_1.appendElement()
                   LET l_hrch_1[l_hrch_1.getLength()].hrch01 = l_hrch[i].hrch01
                   LET l_hrch_1[l_hrch_1.getLength()].hrch02 = l_hrch[i].hrch02
                   LET l_hrch_1[l_hrch_1.getLength()].hrch03 = l_hrch[i].hrch03
                END IF
             END IF
          END FOR

   FOR l_n = 1 TO l_hrch_1.getLength()
       UPDATE hrch_file SET hrch06 = 0,hrch20=0,hrch21=0,hrch22=0
        WHERE hrch01 = l_hrch_1[l_n].hrch01
          AND hrch02 = l_hrch_1[l_n].hrch02
          AND hrch03 = l_hrch_1[l_n].hrch03
   END FOR

   END FOREACH
   #add by zhuzw 20151118 start
   IF g_success = 'Y' THEN
      UPDATE hrcd_file SET hrcdud06 ='Y',hrcd01 = '010'
       WHERE hrcd10 = p_hrcd.hrcd10
      UPDATE hrcda_file SET hrcda03 = '010'
        WHERE hrcda02 = p_hrcd.hrcd10
   END IF
   #add by zhuzw 20151118 end

END  FUNCTION



FUNCTION i044_chk_year(l_hrcd09,l_day,l_hrcd06,l_hrcd07) #检查是否有年假
  DEFINE l_res     BOOLEAN
  DEFINE  l_hrch    DYNAMIC ARRAY OF RECORD
             ptype   LIKE type_file.chr1,
             hrch01  LIKE hrch_file.hrch01,
             hrch02  LIKE hrch_file.hrch02,
             hrch03  LIKE hrch_file.hrch03,
#130912 add by wangxh--str--
             hrch06  LIKE hrch_file.hrch06,
             hrch17  LIKE hrch_file.hrch17,
#130912 add by wangxh--end--
             hrch19  LIKE hrch_file.hrch19,
             l_day_umf  LIKE hrcc_file.hrcc03,
             l_day_unit LIKE hrcc_file.hrcc10
        END RECORD
  DEFINE l_day   LIKE  type_file.dat
DEFINE l_hrcd09 LIKE hrcd_file.hrcd09,
       l_hrcd06 LIKE hrcd_file.hrcd06,
       l_hrcd07 LIKE hrcd_file.hrcd07


      CALL sghri044_p3_insertday_chk(l_hrcd09,l_day,l_hrcd06,l_hrcd07,'')  #编码，起始、数量、单位
              RETURNING l_res,l_hrch
      IF NOT l_res THEN  #无可冲年假，返回假
          RETURN FALSE,l_hrch
      ELSE
          RETURN TRUE,l_hrch
      END IF

END  FUNCTION

FUNCTION i044_modifyhrcd01()
DEFINE l_hrcd01 LIKE hrcd_file.hrcd01
DEFINE l_name  varchar(255)
DEFINE l_cnt LIKE type_file.num5


   IF cl_null(l_ac) OR l_ac=0 THEN RETURN END IF

    OPEN WINDOW i044_w_s1 AT 5,22 WITH FORM "ghr/42f/ghri044_s1"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    INPUT l_hrcd01 WITHOUT DEFAULTS FROM   hrcd01


    AFTER FIELD hrcd01
      IF NOT cl_null(l_hrcd01) THEN
         SELECT count(*) INTO l_cnt
         FROM  hrbm_file WHERE hrbm03=l_hrcd01 AND hrbm07='Y'
         IF l_cnt=0 THEN
             MESSAGE "请假项目编号不存在，请重新录入！"
             NEXT FIELD hrcd01
         END IF
         SELECT hrbm04 INTO  l_name FROM hrbm_file WHERE hrbm03=l_hrcd01
         DISPLAY l_name TO hrcd01_name
      END IF


    ON ACTION controlp
                CASE WHEN INFIELD(hrcd01)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_hrbm033"
                        #LET g_qryparam.state = "c"
                        LET g_qryparam.arg1 = "('004','006','011')"
                        CALL cl_create_qry() RETURNING l_hrcd01
                        DISPLAY l_hrcd01 TO hrcd01
         SELECT hrbm04 INTO  l_name FROM hrbm_file WHERE hrbm03=l_hrcd01
         DISPLAY l_name TO hrcd01_name
        END CASE

     ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

#      ON ACTION generate_link
#         CALL cl_generate_shortcut()

      ON ACTION help
         CALL cl_show_help()

    END INPUT

    CLOSE WINDOW i044_w_s1

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

    UPDATE hrcd_file SET hrcd01=l_hrcd01 WHERE hrcd10=g_hrcd[l_ac].hrcd10
    update hrcda_file set hrcda03 = l_hrcd01 where hrcda02 = g_hrcd[l_ac].hrcd10
    IF status OR sqlca.sqlerrd[3]=0 THEN
         CALL cl_err('UPDATE hrcd_file',status,1)
         RETURN
    END IF


    LET g_hrcd[l_ac].hrcd01=l_hrcd01
    DISPLAY BY NAME g_hrcd[l_ac].hrcd01
    SELECT hrbm04 INTO  g_hrcd[l_ac].hrcd01_name FROM hrbm_file WHERE hrbm03=g_hrcd[l_ac].hrcd01
    DISPLAY BY NAME g_hrcd[l_ac].hrcd01_name

END  FUNCTION

#--* zhoumj 20160115 --
#FUNCTION i044_p5()
#   CALL sghri044_p5() RETURNING g_hrat01
#
#   IF NOT cl_null(g_hrat01) THEN     
#       LET g_wc2 =" hrat01 ='",g_hrat01 CLIPPED,"'"
#   END IF
#   
#   CALL i044_b_fill(g_wc2)
#   CALL i044_b_fill2()
#END FUNCTION
#-- zhoumj 20160115 *--

#add by nihuan 20160622----------------------------------start ---------------------------
#=================================================================#
# Function name...: i044_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 131022 shenran 
#=================================================================#
FUNCTION i044_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       l_hrcd10 LIKE hrcd_file.hrcd10,
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrcd01  LIKE hrcd_file.hrcd01,
         hrcd09  LIKE hrcd_file.hrcd09,
         hrcd02  LIKE hrcd_file.hrcd02,
         hrcd03  LIKE hrcd_file.hrcd03,
         hrcd04  LIKE hrcd_file.hrcd04,
         hrcd05  LIKE hrcd_file.hrcd05,
         hrcd06  LIKE hrcd_file.hrcd06,
         hrcd07  LIKE hrcd_file.hrcd07,
         hrcd08  LIKE hrcd_file.hrcd08,
         hrcd11  LIKE hrcd_file.hrcd11,
         hrcd12  LIKE hrcd_file.hrcd12,
         hrcdconf  LIKE hrcd_file.hrcdconf
         
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 
DEFINE   l_hrcd  RECORD  LIKE hrcd_file.*
DEFINE  l_hrch_1    DYNAMIC ARRAY OF RECORD    
             ptype   LIKE type_file.chr1,
             hrch01  LIKE hrch_file.hrch01,
             hrch02  LIKE hrch_file.hrch02,
             hrch03  LIKE hrch_file.hrch03,
#130912 add by wangxh--str--
             hrch06  LIKE hrch_file.hrch06,
             hrch17  LIKE hrch_file.hrch17,
#130912 add by wangxh--end--
             hrch19  LIKE hrch_file.hrch19,
             l_day_umf  LIKE hrcc_file.hrcc03,
             l_day_unit LIKE hrcc_file.hrcc10
        END RECORD
DEFINE l_day   LIKE  type_file.dat
DEFINE l_res     BOOLEAN
DEFINE l_hrat01  LIKE  hrat_file.hrat01
DEFINE l_hrat02  LIKE  hrat_file.hrat02
DEFINE l_msg   STRING
DEFINE l_end     LIKE  type_file.num5
DEFINE   l_mh       LIKE hrat_file.hratconf

   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow                                                                   
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrcd01])   #假勤编号
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hrcd09])   #员工id
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrcd02])   #开始日期
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrcd03])   #开始时间
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrcd04])   #结束日期
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrcd05])   #结束时间
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrcd06])  #请假时长
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[sr.hrcd07])  #请假单位
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[sr.hrcd08])  #规律时段
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[sr.hrcd12])  #备注
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[sr.hrcdconf])  #审核
                    LET sr.hrcd11=4
                IF NOT cl_null(sr.hrcd01) AND NOT cl_null(sr.hrcd09) AND NOT cl_null(sr.hrcd02)THEN
                   SELECT hratid,hrat02 INTO sr.hrcd09,l_hrat02 FROM hrat_file WHERE hrat01=sr.hrcd09
                   SELECT to_char(MAX(hrcd10)+1,'fm0000000000000') INTO l_hrcd10 FROM hrcd_file
                     # WHERE to_date(substr(hrcd10,1,8),'yyyyMMdd') = g_today
                     WHERE substr(hrcd10,1,8) = to_char(g_today,'yyyymmdd')
                   IF cl_null(l_hrcd10) THEN
                      LET l_hrcd10 = g_today USING 'yyyymmdd'||'00001'
                   END IF 
                   IF i > 1 THEN
                   	LET l_mh=''
                   	SELECT substr(sr.hrcd03) INTO l_mh FROM dual 
                   	IF l_mh!=':' THEN
                   	   CALL cl_err('开始时间格式不对 ',l_hrat02,1)
                   		 LET g_success  = 'N'
                       CONTINUE FOR 
                   	END IF  
                   	
                   	LET l_mh=''
                   	SELECT substr(sr.hrcd05) INTO l_mh FROM dual 
                   	IF l_mh!=':' THEN
                   	   CALL cl_err('开始时间格式不对 ',l_hrat02,1)
                   		 LET g_success  = 'N'
                       CONTINUE FOR 
                   	END IF
                   	
                   	IF sr.hrcd02=sr.hrcd04 AND sr.hrcd03>sr.hrcd05 THEN 
                   		 CALL cl_err('结束时间小于开始时间 ',l_hrat02,1)
                   		 LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF    
                   	
                   	
                   	IF sr.hrcd01='010' THEN LET sr.hrcd11=2 END IF 
                    INSERT INTO hrcd_file(hrcd10,hrcd01,hrcd02,hrcd03,hrcd04,hrcd05,hrcd06,hrcd07,hrcd08,hrcd09,hrcd11,hrcd12,hrcdconf,hrcdacti,hrcduser,hrcdgrup,hrcddate,hrcdorig,hrcdoriu)
                      VALUES (l_hrcd10,sr.hrcd01,sr.hrcd02,sr.hrcd03,sr.hrcd04,sr.hrcd05,sr.hrcd06,sr.hrcd07,sr.hrcd08,sr.hrcd09,sr.hrcd11,sr.hrcd12,sr.hrcdconf,'Y',g_user,g_grup,g_today,g_grup,g_user)
                      
                      IF (sr.hrcd01='010' AND cl_null(sr.hrcd06) ) OR (sr.hrcd01='025' AND cl_null(sr.hrcd06) ) THEN 
                         CALL cl_err("年假&调休时长不能为空",'',1)    
                         LET g_success  = 'N'
                         CONTINUE FOR 
                      END IF
                      SELECT * INTO l_hrcd.* FROM hrcd_file WHERE hrcd10=l_hrcd10  AND hrcd01=sr.hrcd01 AND hrcd02=sr.hrcd02 AND hrcd09=sr.hrcd09
                      IF l_hrcd.hrcd01='010' THEN 
                      	IF l_hrcd.hrcdconf !='Y' OR cl_null(l_hrcd.hrcdconf) THEN 
                      	 CALL sghri044__splitWithExpand(l_hrcd.hrcd10)
                      	    LET l_end = l_hrcd.hrcd04 - l_hrcd.hrcd02  	 
                      	    FOR l_n = 0 TO l_end STEP 1
                              CALL l_hrch_1.clear()
                              LET l_day = l_hrcd.hrcd02 + l_n
                              CALL sghri044_p3_insertday_chk(l_hrcd.hrcd09,l_day,l_hrcd.hrcd06,l_hrcd.hrcd07,'') RETURNING l_res,l_hrch_1
                              IF NOT l_res THEN
                                  SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid = l_hrcd.hrcd09
                                  LET l_msg = l_day
                                  CALL s_errmsg('hrat01',l_hrat01||l_hrat02,l_msg,'ghr-141',1)
                                  LET g_success = 'N'
                                  EXIT FOR 
                              END IF 
                            END FOR 
                        ELSE 
                         CALL sghri044_p3_insert_chk(l_hrcd.*)
                        END IF           
                      ELSE IF l_hrcd.hrcd01='025' THEN 
                      	      CALL sghri044_p4_insert_chk(l_hrcd.*)
                      	   END IF    
                      END IF 
                      SELECT COUNT(*) INTO l_n FROM hrcda_file WHERE hrcda02=l_hrcd.hrcd10 AND hrcda04=l_hrcd.hrcd09 AND hrcda05=l_hrcd.hrcd02 AND hrcda06=l_hrcd.hrcd03
                       IF l_n=0 AND l_hrcd.hrcd01!='010' AND l_hrcd.hrcd01!='025' THEN 
                          CALL sghri044__splitWithExpand(l_hrcd10)
                       END IF 
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrcd_file",sr.hrcd01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF 
                   END IF 
                END IF 
                   #LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
              CALL cl_err( '打开工作簿失败','!', 1 )
          END IF
       ELSE
           DISPLAY 'NO EXCEL'
           CALL cl_err( '打开文件失败','!', 1 )
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
#       SELECT * INTO g_hrcd.* FROM hrcd_file
#       WHERE hrcdid=l_hrcdid
#       
#       CALL i044_show()
   END IF 

END FUNCTION 
#add by nihuan 20160622----------------------------------end ---------------------------

