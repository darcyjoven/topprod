# Prog. Version..: '5.30.03-13.04.08(00010)'     #
#
# Pattern name...: ghri006.4gl
# Descriptions...: 人员信息维护作业
# Date & Author..: 13/04/08 By yougs
# MODIFY.........:by zhuzw 20140627 增加编制内审核处理逻辑
# MODIFY.........:by dt 20150616 增加课别/组别逻辑
# MODIFY.........:by baojz 20150803 自动编号功能增加逻辑，避免在录入时意外为空值。
                                    #增加组别自动带出部门
                                    #增加若部门编号为AM开头，则认为是直接
# MODIFY.........:FUN-151113 wangjya 新增字段 考勤方式  hrat90
# MODIFY.........:FUN-151113 wangjya 新增 按钮 i006_p_get()
# MODIFY.........:FUN-151124 wangjya 新增字段 薪资类别  hrat91/hrat91_name
# MODIFY.........:FUN-151201 wangjya 新增字段 分析类别  hrat93/hrat93_name



DATABASE ds                                               #建立與資料庫的連線



GLOBALS "../../config/top.global"                         #存放的為TIPTOP GP系統整體全域變數定義

DEFINE g_hrat                 RECORD LIKE hrat_file.*
DEFINE g_hrat_t               RECORD LIKE hrat_file.*     #備份舊值
DEFINE g_hrag                 RECORD LIKE hrag_file.*
DEFINE g_hrat01_t             LIKE hrat_file.hrat01       #Key值備份
DEFINE g_wc                   STRING                      #儲存 user 的查詢條件
DEFINE g_sql                  STRING                      #組 sql 用
DEFINE g_forupd_sql           STRING                      #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done    LIKE type_file.num5         #判斷是否已執行 Before Input指令
DEFINE g_chr                  LIKE hrat_file.hratacti
DEFINE g_cnt                  LIKE type_file.num10
DEFINE g_i                    LIKE type_file.num5         #count/index for any purpose
DEFINE g_msg                  STRING
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10        #總筆數
DEFINE g_jump                 LIKE type_file.num10        #查詢指定的筆數
DEFINE l_master               LIKE type_file.num5         #部门主管人数
DEFINE g_no_ask               LIKE type_file.num5         #是否開啟指定筆視窗
DEFINE g_flag                 LIKE type_file.chr1         #员工自动编号返回的一个值，判断是否可以手工修改
DEFINE g_hrat78               LIKE hraq_file.hraq02       #职称类别
DEFINE g_hrat79               LIKE hrag_file.hrag07       #职称级别
DEFINE g_hraqa04              LIKE hraqa_file.hraqa02     #职称等级代码
DEFINE g_hraqa03              LIKE hraqa_file.hraqa03
DEFINE g_hrat75_name          VARCHAR(20)                 #招聘负责人名字
DEFINE g_hrar02               LIKE hras_file.hras03       #职务分类编码
DEFINE g_hrat05_name          LIKE hrap_file.hrap06       #主职位名称
DEFINE g_hrat05_name1         LIKE hrag_file.hrag07       #职务类别
DEFINE g_hrat93_name          LIKE hrag_file.hrag07       #职务类别
DEFINE g_hrat06_name1         LIKE hrag_file.hrag07       #直接主管职务类别 #FUN-151202 wangjya
DEFINE g_chr2                 LIKE type_file.chr2
DEFINE l_hrag07               LIKE hrag_file.hrag07
DEFINE g_hras06               LIKE hras_file.hras06
DEFINE g_hrbf           RECORD LIKE hrbf_file.*
DEFINE g_hrat87_name           LIKE hrao_file.hrao02
DEFINE g_hrat88_name           LIKE hrao_file.hrao02

#DEFINE g_argv1                LIKE hrjn_file.hrjn01        #can shu

FUNCTION sghri006()
   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔

   INITIALIZE g_hrat.* TO NULL
#   LET g_argv1 = ARG_VAL(1)
#   IF NOT cl_null(g_argv1) THEN 
#     CALL i006_a()
#   ELSE 
     LET g_forupd_sql = "SELECT * FROM hrat_file WHERE hratid = ? FOR UPDATE "
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
     DECLARE i006_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

     LET g_action_choice = ""
     CALL i006_menu()                                         #進入選單 Menu
#   END IF 

END FUNCTION


FUNCTION i006_curs()
    DEFINE  l_wc    string  #20160614
    CLEAR FORM
    INITIALIZE g_hrat.* TO NULL
    CONSTRUCT BY NAME g_wc ON         #螢幕上取條件
            #FUN-160111 wjy
            hrat08,hrat01,hrat95,hrat02,hrat12,hrat13,hrat14,hrat89,
            hrat35,hrat15,hrat16,hrat17,hrat76,hrat18,hrat46,
            hrat45,hrat30,hrat49,hrat51,hrat24,hrat28,hrat29,
            hrat22,hrat23,hrat34,hrat10,hrat43,hrat44,hrat25,
            hrat66,hrat96,hrat19,hrat20,hrat68,hrat97,hrat03,hrat94,hrat04,hrat87,
            hrat88,hrat05,hrat06,hrat21,hrat91,hrat93,hrat90,
            hrat26,hrat77,hrat07,
            hrat09,hrat11,ta_hrat01,ta_hrat02,ta_hrat03,hratconf,
            hrat36,hrat38,hrat39,hrat37,hrat69,hrat70,hrat75,
            hrat73,hrat50,hrat47,hrat80,hrat85,hrat81,hrat82,
            hrat83,hrat33,hrat54,hrat53,hrat67,hrat78,hrat74,
            hrat52,hrat72,hrat71,hrat79,hrat48,hrat40,hrat41,
            hrat42,hrat55,hrat57,hrat56,hrat58,hrat59,hrat60,
            hrat62,hrat61,hrat65,hratuser,hratgrup,hratoriu,
            hratorig,hratmodu,hratacti,hratdate,hrat84
            #FUN-160111 wjy
#         hrat01,hrat02,hrat12,hrat13,hrat35,hrat14,hrat89,hrat15,hrat16,hrat17,
#         hrat76,hrat18,hrat46,hrat45,hrat30,
#         hrat49,hrat51,hrat24,hrat28,hrat29,hrat22,hrat23,hrat34,hrat10,
#         hrat43,hrat44,hrat25,hrat19,hrat20,hrat66,hrat86,hrat68,hrat03,
#         hrat04,hrat40,hrat41,hrat42,hrat05,hrat64,hrat06,hrat21,hrat26,hrat77,
#         hrat91,hrat93,
#         hrat71,hrat79,hrat74,hrat80,hrat83,hrat85,hrat81,hrat82,hrat72,
#         hrat58,hrat50,hrat47,hrat48,hrat90,hrat36,hrat69,hrat75,hrat73,hrat38,
#         hrat39,hrat37,hrat70,hrat52,hrat67,hrat78,hrat54,hrat53,
#         hrat33,hrat55,hrat56,hrat59,hrat60,hrat62,hrat61,hrat65,hratuser,
#         hratgrup,hratoriu,hratorig,hratmodu,hratacti,hratdate,hrat84,hratconf,
#         hrat07,hrat09,hrat11,hrat87,hrat88
#         ,ta_hrat01,ta_hrat02,ta_hrat03    -- zhoumj 20160104 --

        BEFORE CONSTRUCT                                    #預設查詢條件
           CALL cl_qbe_init()                               #讀回使用者存檔的預設條件

        ON ACTION controlp
           CASE
              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03  
            #######################start########################

              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '1'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
              #FUN-151201 wangjya
              #内部推荐人
              WHEN INFIELD(hrat44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat44
                 NEXT FIELD hrat44
            #FUN-151201 wangjya

            #课别开窗
             WHEN INFIELD(hrat87)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '2'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat87
                 NEXT FIELD hrat87
            #组别开窗
             WHEN INFIELD(hrat88)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg2 = '3'
                 LET g_qryparam.form = "cq_hrao01_1_1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat88
                 NEXT FIELD hrat88

             #######################start########################

              WHEN INFIELD(hrat05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat05
                 NEXT FIELD hrat05
              WHEN INFIELD(hrat06)
                 {CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
               # LET g_qryparam.where = "hrat07 = 'Y' "
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat06
                 NEXT FIELD hrat06  }
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
               # LET g_qryparam.where = "hrat07 = 'Y' "
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat06
                 NEXT FIELD hrat06

              WHEN INFIELD(hrat40)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraf01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat40
                 NEXT FIELD hrat40
              WHEN INFIELD(hrat42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrai031"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat42
                 NEXT FIELD hrat42
              WHEN INFIELD(hrat52)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat52
                 NEXT FIELD hrat52
#              WHEN INFIELD(hrat64)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_hrar06"
#                 LET g_qryparam.state = "c"
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 DISPLAY g_qryparam.multiret TO hrat64
#                 NEXT FIELD hrat64
              WHEN INFIELD(hrat12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '314'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat12
                 NEXT FIELD hrat12
              WHEN INFIELD(hrat17)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '333'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat17
                 NEXT FIELD hrat17
              WHEN INFIELD(hrat19)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrad02"
#                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_hrat.hrat19
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat19
                 NEXT FIELD hrat19
              WHEN INFIELD(hrat20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '313'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat20
                 NEXT FIELD hrat20
              WHEN INFIELD(hrat21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '337'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat21
                 NEXT FIELD hrat21
              WHEN INFIELD(hrat73)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '341'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat73
                 NEXT FIELD hrat73
              WHEN INFIELD(hrat78)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hraq01"
                  LET g_qryparam.default1 = g_hrat.hrat78
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrat78
                  NEXT FIELD hrat78
              WHEN INFIELD(hrat79)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '206'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.default1 = g_hrat.hrat79
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat79
                 NEXT FIELD hrat79
              WHEN INFIELD(hrat66)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '326'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat66
                 NEXT FIELD hrat66
               WHEN INFIELD(hrat68)
                 CALL cl_init_qry_var()
#                 LET g_qryparam.arg1 = '652'
                 LET g_qryparam.arg1 = '340'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat68
                 NEXT FIELD hrat68
               WHEN INFIELD(hrat97)
                 CALL cl_init_qry_var()
#                 LET g_qryparam.arg1 = '652'
                 LET g_qryparam.arg1 = '340'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat97
                 NEXT FIELD hrat97
               WHEN INFIELD(hrat67)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraqa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat67
                 NEXT FIELD hrat67
              WHEN INFIELD(hrat22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '317'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat22
                 NEXT FIELD hrat22
              WHEN INFIELD(hrat24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '334'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat24
                 NEXT FIELD hrat24
              WHEN INFIELD(hrat28)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '302'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat28
                 NEXT FIELD hrat28
              WHEN INFIELD(hrat29)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '301'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat29
                 NEXT FIELD hrat29
              WHEN INFIELD(hrat30)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '321'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat30
                 NEXT FIELD hrat30
              WHEN INFIELD(hrat34)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '320'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat34
                 NEXT FIELD hrat34
              WHEN INFIELD(hrat75)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrat"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat75
                 NEXT FIELD hrat75
              WHEN INFIELD(hrat41)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '325'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat41
                 NEXT FIELD hrat41
              WHEN INFIELD(hrat43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '319'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat43
                 NEXT FIELD hrat43
#add by zhuzw 20150318 start
           WHEN INFIELD(hrat86)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '615'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrat86
              NEXT FIELD hrat86
#add by zhuzw 20150318 end
#FUN-151113 wangjya
             WHEN INFIELD(hrat90)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_hrag07"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO hrat90
                NEXT FIELD hrat90
              WHEN INFIELD(hrat91)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '345'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat91
                 NEXT FIELD hrat91
              WHEN INFIELD(hrat93)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 = '346'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat93
                 NEXT FIELD hrat93
#FUN-151113 wangjya
              OTHERWISE
                 EXIT CASE
           END CASE

      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()

      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()

      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()

      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()


      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END CONSTRUCT

#    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')  #整合權限過濾設定資料
    CALL  cl_get_hrzxa(g_user)  RETURNING l_wc  #  yj 自己的权限部门判 cl_get_hrzxa20160614                                                                    #若本table無此欄位

#    LET g_sql = "SELECT hratid FROM hrat_file ",                       #組合出 SQL 指令
#                " WHERE ",g_wc CLIPPED, " ORDER BY hrat01"
    LET g_sql = "SELECT hratid FROM hrat_file ",                       #組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, 
                " AND ",l_wc CLIPPED, " ORDER BY hrat01"      #20160614
 #               " ORDER BY hratid"
    PREPARE i006_prepare FROM g_sql
    DECLARE i006_cs                                                  # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i006_prepare

    LET g_sql = "SELECT COUNT(*) FROM hrat_file WHERE ",g_wc CLIPPED," AND ",l_wc CLIPPED
    PREPARE i006_precount FROM g_sql
    DECLARE i006_count CURSOR FOR i006_precount
END FUNCTION


FUNCTION i006_menu()
    DEFINE l_cmd    STRING
DEFINE l_msg STRING
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)

        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i006_a()
            END IF

        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i006_q()
            END IF

        ON ACTION previous
            CALL i006_fetch('P')

        ON ACTION next
            CALL i006_fetch('N')

        ON ACTION jump
            CALL i006_fetch('/')

        ON ACTION first
            CALL i006_fetch('F')

        ON ACTION last
            CALL i006_fetch('L')

        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL i006_u('u')
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL i006_r()
            END IF

       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i006_copy()
            END IF

        ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL i006_confirm('Y')
               CALL i006_show()                   # 重新顯示
            END IF

        ON ACTION unconfirm
            LET g_action_choice="unconfirm"
            IF cl_chk_act_auth() THEN
               CALL i006_confirm('N')
               CALL i006_show()                   # 重新顯示
            END IF

        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i006_x()
            END IF

#        ON ACTION ghri006_a
#            LET g_action_choice="ghri006_a"
#            IF cl_chk_act_auth() THEN
#               IF g_hrat.hrat01 IS NOT NULL THEN
#                   IF g_hrat.hratconf='N' THEN
#                      CALL ghri006_a(g_hrat.hratid) #工作简历
#                   ELSE
#                    	IF cl_null(g_hrat.hrat01) THEN 
#                    	CALL cl_err('',-400,0)
#                    ELSE 
#                      CALL cl_err(g_hrat.hrat01,'9023',0)
#                    END IF   
#                   END IF
#               ELSE
#                   CALL cl_err('','cghr-35',0)
#               END IF
#            END IF
#        ON ACTION ghri006_b
#            LET g_action_choice="ghri006_b"
#            IF cl_chk_act_auth() THEN
#               IF g_hrat.hratconf='N' THEN
#                  CALL ghri006_b(g_hrat.hratid) #培训经历
#               ELSE
#                  IF cl_null(g_hrat.hrat01) THEN 
#                    	CALL cl_err('','cghr-35',0)
#                    ELSE 
#                      CALL cl_err(g_hrat.hrat01,'9023',0)
#                    END IF
#               END IF
#            END IF
#        ON ACTION ghri006_c
#            LET g_action_choice="ghri006_c"
#            IF cl_chk_act_auth() THEN
#               IF g_hrat.hratconf='N' THEN
#                  CALL ghri006_c(g_hrat.hratid) #教育背景
#               ELSE
#                  IF cl_null(g_hrat.hrat01) THEN 
#                    	CALL cl_err('','cghr-35',0)
#                    ELSE 
#                      CALL cl_err(g_hrat.hrat01,'9023',0)
#                    END IF
#               END IF
#            END IF
#
#        ON ACTION ghri006_d
#            LET g_action_choice="ghri006_d"     #家庭关系
#            IF cl_chk_act_auth() THEN
#               IF g_hrat.hratconf='N' THEN
#                  CALL ghri006_d(g_hrat.hratid)
#               ELSE
#                  IF cl_null(g_hrat.hrat01) THEN 
#                    	CALL cl_err('','cghr-35',0)
#                    ELSE 
#                      CALL cl_err(g_hrat.hrat01,'9023',0)
#                    END IF
#               END IF
#            END IF
#
#        ON ACTION ghri006_e
#            LET g_action_choice="ghri006_e"
#            IF cl_chk_act_auth() THEN
#               IF g_hrat.hratconf='N' THEN
#                  CALL ghri006_e(g_hrat.hratid) #语言状况
#               ELSE
#                  IF cl_null(g_hrat.hrat01) THEN 
#                    	CALL cl_err('','cghr-35',0)
#                    ELSE 
#                      CALL cl_err(g_hrat.hrat01,'9023',0)
#                    END IF
#               END IF
#            END IF
#
#        ON ACTION ghri006_f
#            LET g_action_choice="ghri006_f"   #个人档案
#            IF cl_chk_act_auth() THEN
#               IF g_hrat.hratconf='N' THEN
#                  CALL ghri006_f(g_hrat.hratid)
#               ELSE
#                  IF cl_null(g_hrat.hrat01) THEN 
#                    	CALL cl_err('','cghr-35',0)
#                    ELSE 
#                      CALL cl_err(g_hrat.hrat01,'9023',0)
#                    END IF
#               END IF
#            END IF
#
#        ON ACTION ghri006_g
#            LET g_action_choice="ghri006_g"    #职称信息
#            IF cl_chk_act_auth() THEN
#               IF g_hrat.hratconf='N' THEN
#                  CALL ghri006_g(g_hrat.hratid)
#               ELSE
#                  IF cl_null(g_hrat.hrat01) THEN 
#                    	CALL cl_err('','cghr-35',0)
#                    ELSE 
#                      CALL cl_err(g_hrat.hrat01,'9023',0)
#                    END IF
#               END IF
#            END IF
#
#        ON ACTION ghri006_h
#            LET g_action_choice="ghri006_h"
#            IF cl_chk_act_auth() THEN         #紧急联系人
#               IF g_hrat.hratconf='N' THEN
#                  CALL ghri006_h(g_hrat.hratid)
#               ELSE
#                  IF cl_null(g_hrat.hrat01) THEN 
#                    	CALL cl_err('','cghr-35',0)
#                    ELSE 
#                      CALL cl_err(g_hrat.hrat01,'9023',0)
#                    END IF
#               END  IF
#            END IF
#
#     #   ON ACTION ghri006_i
#     #       LET g_action_choice="ghri006_i"
#     #       IF cl_chk_act_auth() THEN
#     #          CALL ghri006_i(g_hrat.hratid)  #兵役状况
#     #       END IF
#
#        ON ACTION ghri006_j
#            LET g_action_choice="ghri006_j"
#            IF cl_chk_act_auth() THEN
#               CALL i0221_assign()
#            END IF
#
#        ON ACTION ghri006_k
#            LET g_action_choice="ghri006_k"
#            IF cl_chk_act_auth() THEN
#               CALL i006_read()  #读取身份证
#            END IF
#
#        ON ACTION ghri006_l
#            LET g_action_choice="ghri006_l"
#            IF cl_chk_act_auth() THEN
#               CALL i006_write()  #记录身份证
#            END IF
        #add by zhuzw 20150317 start
#        ON ACTION ghri006_zz
#            LET g_action_choice="ghri006_zz"
#            IF cl_chk_act_auth() THEN
#               IF NOT cl_null(g_hrat.hratid) THEN
#                  LET l_msg="ghri019 Y ",g_hrat.hratid," "
#                  CALL cl_cmdrun_wait(l_msg)
#               END IF
#            END IF
        #add by zhuzw 20150317 end

        #FUN-151113 wangjya
#        ON ACTION ghri006_bt
#            LET g_action_choice="ghri006_bt"
#            IF cl_chk_act_auth() THEN
#               IF NOT cl_null(g_hrat.hrat09) THEN
#                  CALL i006_p_get()
#               END IF
#            END IF
#
#        ON ACTION ghri006_et
#            LET g_action_choice="ghri006_et"
#            IF cl_chk_act_auth() THEN
#               IF NOT cl_null(g_hrat.hrat09) THEN
#                  CALL i006_tongbu()
#               END IF
#            END IF
         #FUN-151113 wangjya
         #add by zhuzw 20160111 start
        ON ACTION ghri006_rp
            LET g_action_choice="ghri006_rp"
            IF cl_chk_act_auth() THEN
               CALL i006_rp()
            END IF
        #add by zhuzw end
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU

        ON ACTION about
           CALL cl_about()

        ON ACTION close
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU

        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_hrat.hrat01 IS NOT NULL THEN
                 LET g_doc.column1 = "hrat01"
                 LET g_doc.value1 = g_hrat.hrat01
                 CALL cl_doc()
              END IF
           END IF
        ON ACTION ghr_import
            LET g_action_choice="ghr_import"
            IF cl_chk_act_auth() THEN
              #CALL i006_importImg()
              CALL i006_import()
            END IF
        ON ACTION ghr_chaxun
            LET g_action_choice="ghr_chaxun"
            IF cl_chk_act_auth() THEN
              CALL cl_cmdrun_wait("ghrq006")
            END IF
         &include "qry_string.4gl"
    END MENU
    CLOSE i006_cs
END FUNCTION


FUNCTION i006_a()
DEFINE l_hratid  LIKE hrat_file.hratid
DEFINE l_hrag07  LIKE hrag_file.hrag07
DEFINE l_hrat08  LIKE type_file.num10
DEFINE l_ins_chk LIKE type_file.chr1   --* zhoumj 20160105 --
DEFINE l_id      LIKE gca_file.gca01
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_hrat.* LIKE hrat_file.*
    INITIALIZE g_hrat_t.* LIKE hrat_file.*
#    # add by wangwy 20160803 start 
#    IF NOT cl_null(g_argv1) THEN 
#       LET g_hrat.hrat12 = '001'
#       SELECT hrjn02,hrjn03,hrjn04,hrjn05,hrjn07,hrjn09,hrjn11,hrjn12,hrjn13,hrjn14,hrjn17 
#         INTO g_hrat.hrat02,g_hrat.hrat13,g_hrat.hrat15,g_hrat.hrat17,g_hrat.hrat29,g_hrat.hrat18,g_hrat.hrat24,g_hrat.hrat49,g_hrat.hrat51,g_hrat.hrat45,g_hrat.hrat22
#        FROM hrjn_file WHERE hrjn01 = g_argv1
#    END IF 
#    # add by wangwy 20160803 end
    LET g_hrat01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i006_logic_default('A',g_hrat.*) RETURNING g_hrat.*
                #add by zhuzw 20151116 str
        LET g_hrat.hrat90 = '003'
        --* zhoumj 20160105 --
         SELECT hrag07 INTO l_hrag07 FROM hrag_file
           WHERE hrag01='505' AND hrag06=g_hrat.hrat90
         DISPLAY l_hrag07 TO hrat90_name
        -- zhoumj 20160105 *--
        LET g_hrat.hrat21 = '001'
        LET g_hrat.hrat12 = '001'
        #LET g_hrat.hrat22 = '002'   -- zhoumj 20160104 mark due to not need deafult value--
        #LET g_hrat.hrat34 = '002'   -- zhoumj 20160104 mark due to not need deafult value--
        LET g_hrat.hrat19 = '1001'
#        LET g_hrat.hrat20 = '003'
        LET g_hrat.hrat20 = '001'
        #add by zhuzw 20151116 end
#         LET g_hrat.hrat12 = '001' #add by zhuzw 20150317  #FUN-151201 wangjya Mark
         SELECT MAX(to_number(hratid)+1) INTO g_hrat.hratid FROM hrat_file
         IF cl_null(g_hrat.hratid) THEN
            LET g_hrat.hratid = 1
         END IF

         SELECT to_char(g_hrat.hratid,'fm0000000000') INTO g_hrat.hratid FROM DUAL

        CALL i006_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            #add by zhuzw 20160111 start
            LET l_id = 'hratid=',g_hrat.hratid
            DELETE FROM gcb_file WHERE gcb01=(SELECT gca07 FROM gca_file WHERE gca01=l_id)
            DELETE FROM gca_file WHERE gca01=l_id
            #add by zhuzw 20160111 end
            INITIALIZE g_hrat.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_hrat.hratid IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        CALL i006_logic_default('B',g_hrat.*) RETURNING g_hrat.*

        --* zhoumj 20160105 --

     #   IF l_ins_chk = 'Y' THEN
        -- zhoumj 20160105 *--
            INSERT INTO hrat_file VALUES(g_hrat.*)     # DISK WRITE
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","hrat_file",g_hrat.hrat01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660131
                CONTINUE WHILE
            ELSE
            	  #add by zhuzw 20160111 start
                IF NOT cl_null(g_hrat.hrat13)  THEN
                   UPDATE hratz_file  SET hratzud03 = 'Y'
                    WHERE hratz06 = g_hrat.hrat13
                END IF
            	  #add by zhuzw 20160111 end
                SELECT hratid INTO g_hrat.hratid FROM hrat_file WHERE hratid = g_hrat.hratid
            END IF
       # END IF  -- zhoumj 20160105 --
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION


FUNCTION i006_i(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_hraa02      LIKE hraa_file.hraa02
   DEFINE l_hraa03      LIKE hraa_file.hraa03
   DEFINE l_hraa04      LIKE hraa_file.hraa04
   DEFINE l_gem02       LIKE gem_file.gem02
   DEFINE l_n,l_a,l_h   LIKE type_file.num5
   DEFINE l_hrag07      LIKE hrag_file.hrag07
   DEFINE l_count        LIKE type_file.num5
   DEFINE l_year        LIKE type_file.num5
   DEFINE l_month       LIKE type_file.num5
   DEFINE l_day         LIKE type_file.num5
   DEFINE l_mod         LIKE type_file.num5
   DEFINE l_hrat13_18   LIKE type_file.chr1
   DEFINE l_length      LIKE type_file.num5
   DEFINE l_hrat16      LIKE type_file.num5
   DEFINE l_hrat13_1    LIKE type_file.num5
   DEFINE l_hrat13_2    LIKE type_file.num5
   DEFINE l_hrat13_3    LIKE type_file.num5
   DEFINE l_hrat13_4    LIKE type_file.num5
   DEFINE l_hrat13_5    LIKE type_file.num5
   DEFINE l_hrat13_6    LIKE type_file.num5
   DEFINE l_hrat13_7    LIKE type_file.num5
   DEFINE l_hrat13_8    LIKE type_file.num5
   DEFINE l_hrat13_9    LIKE type_file.num5
   DEFINE l_hrat13_10   LIKE type_file.num5
   DEFINE l_hrat13_11   LIKE type_file.num5
   DEFINE l_hrat13_12   LIKE type_file.num5
   DEFINE l_hrat13_13   LIKE type_file.num5
   DEFINE l_hrat13_14   LIKE type_file.num5
   DEFINE l_hrat13_15   LIKE type_file.num5
   DEFINE l_hrat13_16   LIKE type_file.num5
   DEFINE l_hrat13_17   LIKE type_file.num5
   DEFINE l_hraa10      LIKE hraa_file.hraa10
   DEFINE l_hrat04      LIKE hrat_file.hrat04
   DEFINE l_s           LIKE type_file.num5
   DEFINE l_hrao02      LIKE hrao_file.hrao02
   DEFINE l_hrat01      LIKE hrat_file.hrat01
   DEFINE l_hrat02      LIKE hrat_file.hrat02
   DEFINE l_hrat05      LIKE hrat_file.hrat05
   DEFINE l_hraw01      LIKE hraw_file.hraw01
   DEFINE l_sr          STRING
   DEFINE l_hran05      LIKE hran_file.hran05
   DEFINE l_hran06      LIKE hran_file.hran06
   DEFINE l_hrat86_n    LIKE hrag_file.hrag07 #add by zhuzw 20150318
   DEFINE l_hrat68_n    LIKE hrag_file.hrag07 #add by zhuzw 20150318
   DEFINE l_hrat97_n    LIKE hrag_file.hrag07 
   DEFINE l_hrat06_n    LIKE hrat_file.hrat02 #add by zhuzw 20150318
   DEFINE l_hrat87      LIKE hrat_file.hrat87
   DEFINE l_hrat88      LIKE hrat_file.hrat88
   DEFINE l_hrat06      LIKE hrat_file.hrat06,
          l_hrat06_name LIKE hrat_file.hrat02,
          l_hrap01      LIKE hrap_file.hrap01,
          l_hrap05      LIKE hrap_file.hrap05,
          l_hrap07      LIKE hrap_file.hrap07,
          l_des       LIKE type_file.chr100
   DEFINE l_in_year   LIKE type_file.num15_3   -- zhoumj 20160104 --
   #add by zhuzw 20160111 start
   DEFINE l_hratz02   LIKE hratz_file.hratz02
   DEFINE l_hratz03   LIKE hratz_file.hratz03
   DEFINE l_kc,l_ins_chk        LIKE type_file.chr1
   DEFINE l_hh STRING
   DEFINE l_hrat13    LIKE hrat_file.hrat13
   DEFINE l_gca   RECORD LIKE gca_file.*
   DEFINE l_gcb   RECORD LIKE gcb_file.*
   DEFINE l_gca01 LIKE gca_file.gca01
   #add by zhuzw 20160111 end
   DEFINE l_wx    LIKE type_file.num5   #add by wangwy 20170222 姓名重复
   DISPLAY BY NAME
            #FUN-160111 wjy
            g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat95,g_hrat.hrat02,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat89,
            g_hrat.hrat35,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,
            g_hrat.hrat45,g_hrat.hrat30,g_hrat.hrat49,g_hrat.hrat51,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,
            g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat10,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat25,
            g_hrat.hrat66,g_hrat.hrat96,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat68,g_hrat.hrat97,g_hrat.hrat03,g_hrat.hrat94,g_hrat.hrat04,g_hrat.hrat87,
            g_hrat.hrat88,g_hrat.hrat05,g_hrat.hrat06,g_hrat.hrat21,g_hrat.hrat91,g_hrat.hrat93,g_hrat.hrat90,
            g_hrat.hrat26,g_hrat.hrat77,g_hrat.hrat07,g_hrat.hrat64,
            g_hrat.hrat09,g_hrat.hrat11,g_hrat.ta_hrat01,g_hrat.ta_hrat02,g_hrat.ta_hrat03,g_hrat.hratconf,
            g_hrat.hrat36,g_hrat.hrat38,g_hrat.hrat39,g_hrat.hrat37,g_hrat.hrat69,g_hrat.hrat70,g_hrat.hrat75,
            g_hrat.hrat73,g_hrat.hrat50,g_hrat.hrat47,g_hrat.hrat80,g_hrat.hrat85,g_hrat.hrat81,g_hrat.hrat82,
            g_hrat.hrat83,g_hrat.hrat33,g_hrat.hrat54,g_hrat.hrat53,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat74,
            g_hrat.hrat52,g_hrat.hrat72,g_hrat.hrat71,g_hrat.hrat79,g_hrat.hrat48,g_hrat.hrat40,g_hrat.hrat41,
            g_hrat.hrat42,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,
            g_hrat.hrat62,g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,
            g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,g_hrat.hratdate,g_hrat.hrat84
            #FUN-160111 wjy
#      g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat72,g_hrat.hrat05,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat41,g_hrat.hrat40,
#      g_hrat.hrat68,g_hrat.hrat06,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat25,g_hrat.hrat66,g_hrat.hrat26,g_hrat.hrat77,
#      g_hrat.hrat91,g_hrat.hrat93,g_hrat.hrat08,
#      g_hrat.hrat58,g_hrat.hrat42,g_hrat.hrat43,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat35,g_hrat.hrat14,g_hrat.hrat89,
#      g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,
#      g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,g_hrat.hrat45,g_hrat.hrat30,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,
#      g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hratconf,g_hrat.hrat49,g_hrat.hrat50,g_hrat.hrat51,
#      g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat90,g_hrat.hrat36,g_hrat.hrat69,g_hrat.hrat44,g_hrat.hrat75,g_hrat.hrat73,g_hrat.hrat38,g_hrat.hrat39,
#      g_hrat.hrat37,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat71,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat79,g_hrat.hrat74,
#      g_hrat.hrat80,g_hrat.hrat81,g_hrat.hrat82,g_hrat.hrat83,g_hrat.hrat85,
#      g_hrat.hrat54,g_hrat.hrat53,g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat62,
#      g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,
#      g_hrat.hratdate,g_hrat.hrat84,g_hrat.hrat87,g_hrat.hrat88
#      ,g_hrat.ta_hrat01,g_hrat.ta_hrat02,g_hrat.ta_hrat03 -- zhoumj 20160104 add --
      #modify by hourf 2013/6/27

      CALL cl_set_comp_required("hrat01,hrat02,hrat03,hrat04,hrat05,hrat12,hrat13,hrat15,hrat17,hrat19,hrat20,hrat22,hrat24,hrat90", TRUE)   -- zhoumj 20160104 --

      INPUT BY NAME
            #FUN-160111 wjy
            g_hrat.hrat03,g_hrat.hrat01,g_hrat.hrat95,g_hrat.hrat02,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat89,
            g_hrat.hrat35,g_hrat.hrat15,g_hrat.hrat17,g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,
            g_hrat.hrat45,g_hrat.hrat30,g_hrat.hrat49,g_hrat.hrat51,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,
            g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat10,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat25,
            g_hrat.hrat66,g_hrat.hrat96,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat86,g_hrat.hrat68,g_hrat.hrat97,g_hrat.hrat94,g_hrat.hrat04,g_hrat.hrat87,
            g_hrat.hrat88,g_hrat.hrat05,g_hrat.hrat64,g_hrat.hrat06,g_hrat.hrat21,g_hrat.hrat91,g_hrat.hrat93,g_hrat.hrat90,
            g_hrat.hrat26,g_hrat.hrat07,
            g_hrat.hrat09,g_hrat.hrat11,g_hrat.ta_hrat01,g_hrat.ta_hrat02,g_hrat.ta_hrat03,
            g_hrat.hrat36,g_hrat.hrat38,g_hrat.hrat39,g_hrat.hrat37,g_hrat.hrat69,g_hrat.hrat70,g_hrat.hrat75,
            g_hrat.hrat73,g_hrat.hrat50,g_hrat.hrat47,g_hrat.hrat80,g_hrat.hrat85,g_hrat.hrat81,g_hrat.hrat82,
            g_hrat.hrat83,g_hrat.hrat33,g_hrat.hrat54,g_hrat.hrat53,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat74,
            g_hrat.hrat52,g_hrat.hrat72,g_hrat.hrat71,g_hrat.hrat79,g_hrat.hrat48,g_hrat.hrat40,g_hrat.hrat41,
            g_hrat.hrat42,g_hrat.hrat55,g_hrat.hrat56,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,
            g_hrat.hrat62,g_hrat.hrat61,g_hrat.hrat65
            #FUN-160111 wjy
#         g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat91,g_hrat.hrat93,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat35,g_hrat.hrat14,g_hrat.hrat89,
#         g_hrat.hrat15,g_hrat.hrat17,g_hrat.hrat76,g_hrat.hrat18,
#         g_hrat.hrat46,g_hrat.hrat45,g_hrat.hrat30,
#         g_hrat.hrat49,g_hrat.hrat51,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat10,
#         g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat25,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat66,g_hrat.hrat86,g_hrat.hrat68,g_hrat.hrat03,
#         g_hrat.hrat04,g_hrat.hrat87,g_hrat.hrat88,g_hrat.hrat40,g_hrat.hrat41,g_hrat.hrat42,g_hrat.hrat05,g_hrat.hrat64,g_hrat.hrat06,
#         g_hrat.hrat21,g_hrat.hrat26,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,
#         g_hrat.hrat71,g_hrat.hrat79,g_hrat.hrat74,g_hrat.hrat80,g_hrat.hrat83,g_hrat.hrat85,g_hrat.hrat81,g_hrat.hrat82,g_hrat.hrat72,
#         g_hrat.hrat58,g_hrat.hrat50,g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat90,g_hrat.hrat36,g_hrat.hrat69,g_hrat.hrat75,g_hrat.hrat73,g_hrat.hrat38,
#         g_hrat.hrat39,g_hrat.hrat37,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat54,g_hrat.hrat53,
#         g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat56,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat62,g_hrat.hrat61,g_hrat.hrat65
#         ,g_hrat.ta_hrat01,g_hrat.ta_hrat02,g_hrat.ta_hrat03 -- zhoumj 20160104 add --

      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          IF p_cmd = 'a' THEN
          	LET g_hrat.hrat03='1000'
            LET g_hrat.hratconf='N'
            LET g_hrat.hrat07='N'
            LET g_hrat.hrat09='Y'
            LET g_hrat.hrat11='N'
            LET g_hrat.hrat54='Y'
            --* zhoumj 20160104 --
            LET g_hrat.ta_hrat01='N'
            LET g_hrat.ta_hrat02='N'
            LET g_hrat.ta_hrat03='N'
            -- zhoumj 20160104 *--
            LET g_hrat.hrat53='N'
            LET g_hrat.hrat33='N'
            LET g_hrat.hrat58='5'
            LET g_hrat.hrat77='9999/12/31'
            LET l_kc = 'N'
            SELECT to_char(systimestamp,'hh24:mi:ss') INTO g_hrat.hrat84  FROM dual #FUN-151209 wangjya
            DISPLAY g_hrat.hrat84 TO hrat84
#            LET g_hrat.hrat68='029'
            DISPLAY BY NAME g_hrat.hrat03,g_hrat.hratconf,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hrat54,
                            g_hrat.hrat53,g_hrat.hrat33,g_hrat.hrat58,g_hrat.hrat77 #,g_hrat.hrat68
                            ,g_hrat.ta_hrat01,g_hrat.ta_hrat02,g_hrat.ta_hrat03   -- zhoumj 20160104 --

            CALL s_code('314',g_hrat.hrat12) RETURNING g_hrag.*
            IF cl_null(g_hrat.hrat12) THEN
               LET g_hrag.hrag07 = NULL
            END IF
            DISPLAY g_hrag.hrag07 TO hrat12_name

            CALL s_code('302',g_hrat.hrat28) RETURNING g_hrag.*
            IF cl_null(g_hrat.hrat28) THEN
               LET g_hrag.hrag07 = NULL
            END IF
            DISPLAY g_hrag.hrag07 TO hrat28_name

            CALL s_code('301',g_hrat.hrat29) RETURNING g_hrag.*
            IF cl_null(g_hrat.hrat29) THEN
               LET g_hrag.hrag07 = NULL
            END IF
            DISPLAY g_hrag.hrag07 TO hrat29_name
            #FUN-151208 wangjya
            CALL i006_hrat19(g_hrat.*) RETURNING l_des

            CALL s_code('313',g_hrat.hrat20) RETURNING g_hrag.*
            IF cl_null(g_hrat.hrat20) THEN
               LET g_hrag.hrag07 = NULL
            END IF
            DISPLAY g_hrag.hrag07 TO hrat20_name

            CALL s_code('337',g_hrat.hrat21) RETURNING g_hrag.*
            IF cl_null(g_hrat.hrat21) THEN
               LET g_hrag.hrag07 = NULL
            END IF
            DISPLAY g_hrag.hrag07 TO hrat21_name

            CALL s_code('317',g_hrat.hrat22) RETURNING g_hrag.*
            IF cl_null(g_hrat.hrat22) THEN
               LET g_hrag.hrag07 = NULL
            END IF
            DISPLAY g_hrag.hrag07 TO hrat22_name

            CALL s_code('320',g_hrat.hrat34) RETURNING g_hrag.*
            IF cl_null(g_hrat.hrat34) THEN
               LET g_hrag.hrag07 = NULL
            END IF
            DISPLAY g_hrag.hrag07 TO hrat34_name
            #FUN-151208 wangjya
#            CALL s_code('652',g_hrat.hrat68) RETURNING g_hrag.*
#            DISPLAY g_hrag.hrag07 TO hrat68_name
          END IF
          CALL i006_set_entry(p_cmd)
          CALL i006_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_comp_entry("hrat01",FALSE)
          CALL cl_set_comp_required("hrat66",FALSE)
          CALL cl_set_comp_required("hrat03",TRUE)
          CALL cl_set_comp_entry("hrat02,hrat12,hrat13,hrat14,hrat35,hrat89,hrat15,hrat17,hrat76,hrat18,",TRUE)

    #直接主管
    BEFORE FIELD hrat06
      IF cl_null(g_hrat.hrat06) THEN
        LET g_hrat.hrat06=NULL
        #课别不为空 ，取课别的上级部门
        IF NOT cl_null(g_hrat.hrat87)THEN
          select hrat01 INTO g_hrat.hrat06 FROM hrat_file
          left join hrad_file ON hrad02=hrat19
          WHERE (hrat87=g_hrat.hrat87 )
          AND (hrat07='Y' AND hrat07 is not null)
          AND hrad01!='003'
          AND rownum <=1

          IF SQLCA.sqlcode = 100 THEN
            select hrat01 INTO g_hrat.hrat06 from hraw_file
            left join hrat_file on hraw01=hratid
            where(hraw02=g_hrat.hrat87)
            AND (hraw07='Y' AND hraw07 is not null)
            AND hraw05>to_date(g_today,'yyyy-mm-dd')
           END IF
         END IF

         IF NOT cl_null(g_hrat.hrat04) AND cl_null(g_hrat.hrat06) THEN
            select hrat01 INTO g_hrat.hrat06 FROM hrat_file
            left join hrad_file ON hrad02=hrat19
            WHERE (hrat04=g_hrat.hrat04 )
            AND (hrat07='Y' AND hrat07 is not null)
            AND hrad01!='003'
            AND rownum <=1

            IF SQLCA.sqlcode = 100 THEN
            select hrat01 INTO g_hrat.hrat06 from hraw_file
            left join hrat_file on hraw01=hratid
            where(hraw02=g_hrat.hrat04)
            AND (hraw07='Y' AND hraw07 is not null)
            AND hraw05>to_date(g_today,'yyyy-mm-dd')
           END IF
         END IF
      END IF

      AFTER FIELD hrat03
         IF NOT cl_null(g_hrat.hrat03) THEN
            CALL i006_logic_chk_hrat03(g_hrat.*) RETURNING g_hrat.*
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_hrat.hrat03,g_errno,0)
               NEXT FIELD hrat03
            ELSE
               #add by yougs130425 begin
               IF NOT cl_null(g_hrat.hrat03) THEN
                  IF g_hrat_t.hrat03 IS NULL THEN
                     LET l_hraa10 = ''
                     SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01 = g_hrat.hrat03 AND hraaacti = 'Y'
                     IF g_hrat.hrat03='03' THEN   
                       LET g_hrat.hrat68='001'  
                       LET g_hrat.hrat97='001'
                       LET g_hrat.hrat40='A0001'
                       LET g_hrat.hrat41='005'
                       DISPLAY BY NAME g_hrat.hrat68,g_hrat.hrat97,g_hrat.hrat40,g_hrat.hrat41
                     END IF   
                     LET g_flag = 'Y'
                  #   IF cl_null(g_hrat.hrat01) THEN
                        CALL hr_gen_no('hrat_file','hrat01','009',g_hrat.hrat03,l_hraa10) RETURNING g_hrat.hrat01,g_flag
                        DISPLAY g_hrat.hrat01 TO hrat01
             #        END IF
                     IF g_flag = 'Y' THEN
                        CALL cl_set_comp_entry("hrat01",TRUE)
                     ELSE
                        CALL cl_set_comp_entry("hrat01",FALSE)
                     END IF
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_hrat.hrat25) AND NOT cl_null(g_hrat.hrat03) THEN##AND NOT cl_null(g_hrat.hrat21) AND NOT cl_null(g_hrat.hrat03) THEN
#               IF g_hrat.hrat21='001' THEN
               SELECT hran05 INTO l_hran05 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
               IF NOT cl_null(l_hran05) THEN
                  Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran05) INTO g_hrat.hrat26 FROM dual;
                  DISPLAY BY NAME g_hrat.hrat26
                  END IF
#               END IF
#               IF g_hrat.hrat21='002' THEN
#                  SELECT hran06 INTO l_hran06 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
#                  IF NOT cl_null(l_hran06) THEN
#                     Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran06) INTO g_hrat.hrat26 FROM dual;
#                     DISPLAY BY NAME g_hrat.hrat26
#                  END IF
#               END IF
            END IF
         END IF
            
#add by nihuan 20161228 start
        AFTER FIELD hrat49
           IF NOT cl_null(g_hrat.hrat49) THEN 
           	  LET l_h=0 
              SELECT LENGTH(g_hrat.hrat49) INTO l_h FROM DUAL
              IF l_h<>11 THEN 
                 CALL cl_err('号码长度不对','!',1)
                 NEXT FIELD hrat49
              END IF 
           END IF 
           
         AFTER FIELD hrat47
           IF NOT cl_null(g_hrat.hrat47) THEN 
           	  LET l_h=0 
              SELECT LENGTH(g_hrat.hrat47) INTO l_h FROM DUAL
             # IF l_h<>11 THEN 
             #    CALL cl_err('号码长度不对','!',1)
             #    NEXT FIELD hrat47
             # END IF 
           END IF    
         
         AFTER FIELD hrat96
           IF NOT cl_null(g_hrat.hrat96) THEN 
           	  LET l_h=0 
              SELECT LENGTH(g_hrat.hrat96) INTO l_h FROM DUAL
              IF l_h<>11 THEN 
                 CALL cl_err('号码长度不对','!',1)
                 NEXT FIELD hrat96
              END IF 
           END IF    
#add by nihuan 20161228 end
        AFTER FIELD hrat60    #add by wangwy 20170309
           IF NOT cl_null(g_hrat.hrat60) THEN 
           	  SELECT hrar04 INTO g_hrat05_name1 FROM hrar_file WHERE hrar03 = g_hrat.hrat60
           	  DISPLAY g_hrat05_name1 TO hrat05_name1
           	  SELECT hrar06 INTO g_hrat.hrat93 FROM hrar_file WHERE hrar03 = g_hrat.hrat60
           	  DISPLAY g_hrat.hrat93 TO hrat93
           	  SELECT hrag07 INTO g_hrat93_name FROM hrag_file WHERE hrag01='204' AND hrag06=g_hrat.hrat93
           	  DISPLAY g_hrat93_name TO hrat93_name 
           END IF    
#add by zhuzw 20160111 start
        AFTER FIELD hrat02
           IF NOT cl_null(g_hrat.hrat02) THEN
              #检查姓名重复并提醒add by wangwy 20170222 start
              SELECT COUNT(*) INTO l_wx FROM hrat_file WHERE hrat02 = g_hrat.hrat02 AND hrat77 >= g_today - 60
              IF l_wx > 0 AND p_cmd = 'a' THEN 
                CALL cl_err(g_hrat.hrat02,'xm_chk',1)
                NEXT FIELD hrat02
              END IF 
              IF p_cmd = 'u' THEN 
                 LET  l_wx = 0
                 SELECT COUNT(*) INTO l_wx FROM hrat_file WHERE hrat02 = g_hrat.hrat02 AND hrat77 >= g_today - 60    AND hrat01 != g_hrat.hrat01           
                 IF l_wx > 0  THEN 
                   CALL cl_err(g_hrat.hrat02,'xm_chk',1)
                    NEXT FIELD hrat02
                 END IF 
              END IF               #end
              SELECT COUNT(*) INTO l_n FROM hratz_file
               WHERE hratz01 = g_hrat.hrat02
                 AND hratzud03 = 'N'
              IF l_n = 1 THEN
                 SELECT hratz02,hratz03,hratz04,hratz05,hratz06,hratz08
                   INTO l_hratz02,l_hratz03,g_hrat.hrat15,g_hrat.hrat45,g_hrat.hrat13,g_hrat.hrat14
                   FROM hratz_file
                  WHERE hratz01 = g_hrat.hrat02
                    AND hratzud03 = 'N'
                 SELECT hrag06 INTO  g_hrat.hrat17
                  FROM hrag_file
                  WHERE hrag01  = '333'
                    AND hrag07 = l_hratz02
                 SELECT hrag06 INTO  g_hrat.hrat29
                  FROM hrag_file
                  WHERE hrag01  = '301'
                    AND hrag07 = l_hratz02
                 LET g_hrat.hrat76 = g_hrat.hrat45
                 LET g_hrat.hrat12 = '001'
                  SELECT hrag07 INTO l_hrag07
                  FROM hrag_file
                  WHERE hrag01  = '314'
                    AND hrag06 = g_hrat.hrat12
                  SELECT YEAR(SYSDATE)-YEAR(g_hrat.hrat15) into g_hrat.hrat16 FROM dual
                  DISPLAY g_hrat.hrat16 TO hrat16
                 DISPLAY BY NAME  g_hrat.hrat15,g_hrat.hrat45,g_hrat.hrat14,g_hrat.hrat17,g_hrat.hrat29,g_hrat.hrat76,g_hrat.hrat12,g_hrat.hrat13
                 DISPLAY l_hrag07 TO hrat12_name
                 DISPLAY l_hratz02 TO  hrat17_name
                 DISPLAY l_hratz03 TO  hrat29_name
                 #图片储存
                 LET l_gca01 = 'hratz06=',g_hrat.hrat13
                 SELECT * INTO l_gca.* FROM gca_file
                  WHERE gca01 = l_gca01
                    AND gca09 = 'hratzud01'
                IF  NOT cl_null(l_gca.gca01) THEN
                   SELECT * INTO l_gcb.* FROM gcb_file
                    WHERE gcb01 = _gca.gca07
                      AND gcb03 = l_gca.gca09
                    LET l_gca.gca01 = "hratid =",g_hrat.hratid
                    LET l_gca.gca09 = 'hrat32'
                    LET l_gcb.gcb03 = 'hrat32'
                    INSERT INTO gca_file  VALUES(l_gca.*)
                    INSERT INTO gcb_file  VALUES(l_gcb.*)
                END IF
                LET g_doc.column1 = "hratid"
                LET g_doc.value1 = g_hrat.hratid
                CALL cl_get_fld_doc("hrat32")
              END IF
              IF l_n >1 THEN
                 LET l_hh = "存在该姓名多笔身份证信息，是否开窗查询？"
                 IF cl_prompt(0,0,l_hh) THEN
                 LET g_hrat.hrat13 = ''
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_hratz01"
                 LET g_qryparam.default1 = g_hrat.hrat13
                 LET g_qryparam.where = " hratz01 = '",g_hrat.hrat02,"'"
                 LET g_qryparam.construct = 'N'
                 CALL cl_create_qry() RETURNING g_hrat.hrat13
                 LET l_kc = 'Y'
                 NEXT FIELD hrat45
                 ELSE
                 	  NEXT FIELD hrat12
                 END IF
              END IF
           END IF
     BEFORE FIELD hrat45
         IF NOT cl_null(g_hrat.hrat13) AND l_kc = 'Y' THEN
                 SELECT hratz02,hratz03,hratz04,hratz05,hratz06,hratz08
                   INTO l_hratz02,l_hratz03,g_hrat.hrat15,g_hrat.hrat45,g_hrat.hrat13,g_hrat.hrat14
                   FROM hratz_file
                  WHERE hratz01 = g_hrat.hrat02
                    AND hratz06 = g_hrat.hrat13
                    AND hratzud03 = 'N'
                 SELECT hrag06 INTO  g_hrat.hrat17
                  FROM hrag_file
                  WHERE hrag01  = '333'
                    AND hrag07 = l_hratz02
                 SELECT hrag06 INTO  g_hrat.hrat29
                  FROM hrag_file
                  WHERE hrag01  = '301'
                    AND hrag07 = l_hratz02
                 LET g_hrat.hrat76 = g_hrat.hrat45
                 LET g_hrat.hrat12 = '001'
                  SELECT hrag07 INTO l_hrag07
                  FROM hrag_file
                  WHERE hrag01  = '314'
                    AND hrag06 = g_hrat.hrat12
                  SELECT YEAR(SYSDATE)-YEAR(g_hrat.hrat15) into g_hrat.hrat16 FROM dual
                  DISPLAY g_hrat.hrat16 TO hrat16
                 DISPLAY BY NAME  g_hrat.hrat15,g_hrat.hrat45,g_hrat.hrat14,g_hrat.hrat17,g_hrat.hrat29,g_hrat.hrat76,g_hrat.hrat12,g_hrat.hrat13
                 DISPLAY l_hrag07 TO hrat12_name
                 DISPLAY l_hratz02 TO  hrat17_name
                 DISPLAY l_hratz03 TO  hrat29_name
                 #图片储存
                 LET l_gca01 = 'hratz06=',g_hrat.hrat13
                 SELECT * INTO l_gca.* FROM gca_file
                  WHERE gca01 = l_gca01
                    AND gca09 = 'hratzud01'
                IF  NOT cl_null(l_gca.gca01) THEN
                   SELECT * INTO l_gcb.* FROM gcb_file
                    WHERE gcb01 = _gca.gca07
                      AND gcb03 = l_gca.gca09
                    LET l_gca.gca01 = "hratid =",g_hrat.hratid
                    LET l_gca.gca09 = 'hrat32'
                    LET l_gcb.gcb03 = 'hrat32'
                    INSERT INTO gca_file  VALUES(l_gca.*)
                    INSERT INTO gcb_file  VALUES(l_gcb.*)
                END IF
                LET g_doc.column1 = "hratid"
                LET g_doc.value1 = g_hrat.hratid
                CALL cl_get_fld_doc("hrat32")
         END IF
#add by zhuzw 20160111 end
     BEFORE FIELD hrat04
         IF cl_null(g_hrat.hrat03) THEN
            CALL cl_err('','ghr-911',0)
            NEXT FIELD hrat03
         END IF

     AFTER FIELD hrat04
       IF NOT cl_null(g_hrat.hrat04) THEN
         CALL i006_logic_chk_hrat04(g_hrat.*) RETURNING g_hrat.*
         IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_hrat.hrat04,g_errno,1)
              LET g_hrat.hrat04 = ''
              LET g_hrat.hrat05 = ''
              NEXT FIELD hrat04
         END IF
       END IF

      #根据部门默认带出新直接主管
      #FUN-151113 wangjya
      IF NOT cl_null(g_hrat.hrat04) THEN
          SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
            FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat04
           WHERE hrap07='Y'
             AND hrap01 =g_hrat.hrat04
          IF NOT cl_null(l_hrap01) THEN
             SELECT DISTINCT hrat01 INTO l_hrat01 FROM hrat_file
              WHERE hrat04=g_hrat.hrat04
                AND (hrat05=l_hrap05 OR HRAT07='Y')
                AND HRAT77>=SYSDATE

             #如果通过部门找不到就利用兼职部门来带出新直属主管
             IF cl_null(l_hrat01) THEN
                SELECT hrat01 INTO l_hrat01 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                 WHERE hraw02=g_hrat.hrat04
                   AND (hraw03=l_hrap05 OR HRAT07='Y')
                   AND HRAT77>=SYSDATE
                   AND hratconf='Y'
             END IF

             IF l_hrat01=g_hrat.hrat01 THEN 
             ELSE
              LET g_hrat.hrat06 =l_hrat01   
             END IF 
             
             DISPLAY BY NAME g_hrat.hrat06
             IF NOT cl_null(g_hrat.hrat06) THEN
            	  SELECT hrat02 INTO l_hrat06_name FROM hrat_file
            	   WHERE hrat01=g_hrat.hrat06
                  AND hratconf='Y'
            	  DISPLAY l_hrat06_name TO hrat06_name
             END IF
          END IF
      END IF
      #FUN-151113 wangjya

       {IF cl_null(g_hrat.hrat21)THEN
         SELECT SUBSTR(g_hrat.hrat04,0,2) INTO l_hrat04_type FROM dual
         IF l_hrat04_type='AM' THEN
            SELECT hrag06 INTO g_hrat.hrat21
              FROM hrag_file
             WHERE harg01='337' #类型为直/间接
               AND hragacti='Y'
               AND harg07 LIKE '直接%'
               AND rownum<=1
         END IF
        END IF }
      #FUN-151201 wangjya
      AFTER FIELD hrat44
        IF NOT cl_null(g_hrat.hrat44) THEN
           CALL i006_hrat44(p_cmd)
           IF STATUS THEN
              CALL cl_err(g_hrat.hrat44,g_errno,0)
              NEXT FIELD hrat44
           END IF
           LET l_n = 0
           SELECT COUNT(*) INTO l_n FROM hrat_file
            WHERE hrat01 = g_hrat.hrat44
           IF l_n = 0 THEN
              CALL cl_err(g_hrat.hrat44,'aap-038',0)
              NEXT FIELD hrat44
           END IF
        END IF
      #FUN-151201 wangjya
      #课别
      AFTER FIELD hrat87
       IF NOT cl_null(g_hrat.hrat87) THEN
         CALL i006_hrat87(g_hrat.hrat87,'2') RETURNING g_errno,g_hrat87_name
         IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              LET g_hrat.hrat87 = ''
              NEXT FIELD hrat87
         END IF
       ELSE
         LET g_hrat87_name=''
       END IF
       DISPLAY g_hrat87_name TO hrat87_name

      #如果不能通过部门带出新直接主管则通过课别带出
      #FUN-151113 wangjya
      IF NOT cl_null(g_hrat.hrat87) THEN
          SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
            FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat87
           WHERE hrap07='Y'
             AND hrap01 = g_hrat.hrat87
          IF NOT cl_null(l_hrap01) THEN
             SELECT DISTINCT hrat01 INTO l_hrat01 FROM hrat_file
              WHERE hrat04=g_hrat.hrat04
                AND hrat87=g_hrat.hrat87
                AND (hrat05=l_hrap05 OR HRAT07='Y')
                AND HRAT77>=SYSDATE
                AND hratconf='Y'

             IF cl_null(l_hrat01) THEN
                #如果通过课别找不到就利用兼职课别来带出新直属主管
                SELECT hrat01 INTO l_hrat01 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                 WHERE hraw08=g_hrat.hrat87
                   AND (hraw03=l_hrap05 OR HRAT07='Y')
                   AND HRAT77>=SYSDATE
                   AND hratconf='Y'
             END IF

             LET g_hrat.hrat06 =l_hrat01
             DISPLAY BY NAME g_hrat.hrat06
             IF NOT cl_null(g_hrat.hrat06) THEN
            	  SELECT hrat02 INTO l_hrat06_name FROM hrat_file
            	   WHERE hrat01=g_hrat.hrat06
                  AND hratconf='Y'
            	  DISPLAY l_hrat06_name TO hrat06_name
             END IF
          END IF
      END IF
      #FUN-151113 wangjya



{        #若部门为AM开头，则默认主管直接/间接hrat21=直接
        IF cl_null(g_hrat.hrat21)THEN
         SELECT SUBSTR(g_hrat.hrat04,0,2) INTO l_hrat04_type FROM dual
         IF l_hrat04_type='AM' THEN
            SELECT hrag06 INTO g_hrat.hrat21
              FROM hrag_file
             WHERE harg01='337' #类型为直/间接
               AND hragacti='Y'
               AND harg07 LIKE '直接%'
               AND rownum<=1
         END IF
        END IF }

       #组别
     AFTER FIELD hrat88
       IF NOT cl_null(g_hrat.hrat88) THEN
        CALL i006_hrat88(g_hrat.hrat88,'3') RETURNING g_errno,g_hrat88_name
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,1)
              LET g_hrat.hrat88 = ''
              NEXT FIELD hrat88
         END IF
          ELSE
            LET g_hrat88_name=''
       END IF
       DISPLAY g_hrat88_name TO hrat88_name
      #如果不能通过部门课别带出新直接主管则通过组别带出
      #FUN-151113 wangjya
      IF NOT cl_null(g_hrat.hrat88) THEN
          SELECT DISTINCT hrap01,hrap05 INTO l_hrap01,l_hrap05
            FROM hrap_file LEFT OUTER JOIN hrat_file ON hrap01=hrat88
           WHERE hrap07='Y'
             AND hrap01 = g_hrat.hrat88
          IF NOT cl_null(l_hrap01) THEN
             SELECT DISTINCT hrat01 INTO l_hrat01 FROM hrat_file
              WHERE hrat04=g_hrat.hrat04
                AND hrat88=g_hrat.hrat88
                AND (hrat05=l_hrap05 OR HRAT07='Y')
                AND HRAT77>=SYSDATE
                AND hratconf='Y'

             IF cl_null(l_hrat01) THEN
                #如果通过组织找不到就利用兼职组织来带出新直属主管
                SELECT hrat01 INTO l_hrat01 FROM hrat_file LEFT OUTER JOIN hraw_file ON hratid=hraw01
                 WHERE hraw09=g_hrat.hrat88
                   AND (hraw03=l_hrap05 OR HRAT07='Y')
                   AND HRAT77>=SYSDATE
                   AND hratconf='Y'
             END IF

             LET g_hrat.hrat06 =l_hrat01
             DISPLAY BY NAME g_hrat.hrat06
             IF NOT cl_null(g_hrat.hrat06) THEN
            	  SELECT hrat02 INTO l_hrat06_name FROM hrat_file
            	   WHERE hrat01=g_hrat.hrat06
                  AND hratconf='Y'
            	  DISPLAY l_hrat06_name TO hrat06_name
             END IF
          END IF
      END IF
      #FUN-151113 wangjya
{
       #若部门为AM开头，则默认主管直接/间接hrat21=直接
        IF cl_null(g_hrat.hrat21)THEN
         SELECT SUBSTR(g_hrat.hrat04,0,2) INTO l_hrat04_type FROM dual
         IF l_hrat04_type='AM' THEN
            SELECT hrag06 INTO g_hrat.hrat21
              FROM hrag_file
             WHERE harg01='337' #类型为直/间接
               AND hragacti='Y'
               AND harg07 LIKE '直接%'
               AND rownum<=1
         END IF
        END IF

}

#     BEFORE FIELD hrat05
#         IF cl_null(g_hrat.hrat04) THEN
#            CALL cl_err("在录入职位之前请先录入部门编号，谢谢",'!',0)
#            NEXT FIELD hrat04
#         END IF

     AFTER FIELD hrat05
      IF NOT cl_null(g_hrat.hrat05) THEN
         CASE
             #WHEN g_hrat.hrat88 IS NOT NULL
             #    SELECT hrap07 INTO g_hrat.hrat07 
             #    FROM hrap_file WHERE hrap01=g_hrat.hrat88 AND hrap05=g_hrat.hrat05         
             #WHEN g_hrat.hrat87 IS NOT NULL
             #     SELECT hrap07 INTO g_hrat.hrat07 
             #     FROM hrap_file WHERE hrap01=g_hrat.hrat87 AND hrap05=g_hrat.hrat05         
             WHEN g_hrat.hrat04 IS NOT NULL
                  SELECT hrap07 INTO g_hrat.hrat07 
                  FROM hrap_file WHERE hrap01=g_hrat.hrat04 AND hrap05=g_hrat.hrat05         
             OTHERWISE
                 LET l_n=1 #没有填写部门、课、组别就不进行管控
         END CASE      	 
         #SELECT hrap07 INTO g_hrat.hrat07 FROM hrap_file WHERE hrap01=g_hrat.hrat04 AND hrap05=g_hrat.hrat05
         IF g_hrat.hrat07='Y' THEN
            #校验
            CASE
             WHEN g_hrat.hrat88 IS NOT NULL
                 SELECT COUNT(*) INTO l_master FROM hrat_file,hrad_file 
                 WHERE hrat04=g_hrat.hrat88 AND hrat07='Y' AND hrad02 = hrat19 AND hrad01 !='003' 
             WHEN g_hrat.hrat87 IS NOT NULL
                  SELECT COUNT(*) INTO l_master FROM hrat_file,hrad_file 
                  WHERE hrat04=g_hrat.hrat87 AND hrat07='Y' AND hrad02 = hrat19 AND hrad01 !='003'    
             WHEN g_hrat.hrat04 IS NOT NULL
                  SELECT COUNT(*) INTO l_master FROM hrat_file,hrad_file 
                  WHERE hrat04=g_hrat.hrat04 AND hrat07='Y' AND hrad02 = hrat19 AND hrad01 !='003'  
             OTHERWISE
                 LET l_master=0 #没有填写部门、课、组别就不进行管控
         END CASE
            #SELECT COUNT(*) INTO l_master FROM hrat_file,hrad_file WHERE hrat04=g_hrat.hrat04 AND hrat07='Y' AND hrad02 = hrat19 AND hrad01 !='003'
            IF l_master>0 AND g_hrat.hrat05 != g_hrat_t.hrat05  THEN
               LET g_hrat.hrat07='N'
               LET g_hrat.hrat05=''
               CALL cl_err(" ",'ghr-915',1)
            END IF
         END IF
         DISPLAY g_hrat.hrat07 TO hrat07

         CASE
#             WHEN g_hrat.hrat88 IS NOT NULL
#                 SELECT COUNT(*) INTO l_n
#                   FROM hrap_file
#                  WHERE hrap01=g_hrat.hrat88
#                    AND hrap05=g_hrat.hrat05
#             WHEN g_hrat.hrat87 IS NOT NULL
#                  SELECT COUNT(*) INTO l_n
#                   FROM hrap_file
#                  WHERE hrap01=g_hrat.hrat87
#                    AND hrap05=g_hrat.hrat05
             WHEN g_hrat.hrat04 IS NOT NULL
                  SELECT COUNT(*) INTO l_n
                   FROM hrap_file
                  WHERE hrap01=g_hrat.hrat04
                    AND hrap05=g_hrat.hrat05
             OTHERWISE
                 LET l_n=1 #没有填写部门、课、组别就不进行管控
         END CASE
         IF cl_null(l_n) THEN LET l_n=0 END IF
         IF l_n=0 THEN
           CALL cl_err('此职位不属于对应部门、课、组','!',0)
           NEXT FIELD hrat05
         END IF

         CALL i006_logic_chk_hrat05(g_hrat.*) RETURNING g_hrat.*
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_hrat.hrat05,g_errno,1)
                  LET g_hrat.hrat04 = ''
                  LET g_hrat.hrat05 = ''
            NEXT FIELD hrat05
         END IF
      ELSE    
      	  LET g_hrat05_name = ''
          LET g_hrat05_name1=''     	    
      END IF
      IF NOT cl_null(g_hrat.hrat05) THEN
         SELECT hrap06 INTO g_hrat05_name FROM hrap_file WHERE hrap05=g_hrat.hrat05
         SELECT hras03 INTO g_hrar02 FROM hras_file  WHERE hras01=g_hrat.hrat05
         #SELECT hrar04 INTO g_hrat05_name1 FROM hrar_file WHERE hrar03=g_hrar02
         #SELECT hras06 INTO g_hras06 FROM hras_file WHERE hras01=g_hrat.hrat05
         SELECT hras06 INTO g_hrat.hrat64 FROM hras_file WHERE hras01=g_hrat.hrat05
         #SELECT hrag07 INTO g_hrat.hrat64 FROM hrag_file WHERE hrag01='205' AND hrag06=g_hras06
      END IF
      DISPLAY g_hras06 TO hras06
      DISPLAY g_hrat05_name  TO hrat05_name
      #DISPLAY g_hrat05_name1 TO hrat05_name1
      #DISPLAY BY NAME g_hrat.hrat64
      DISPLAY g_hrat.hrat64 TO hrat64

       #FUN-151113 wangjya
       AFTER FIELD hrat90
           IF NOT cl_null(g_hrat.hrat90) THEN
               SELECT hrag07 INTO l_hrag07 FROM hrag_file
                 WHERE hrag01='505' AND hrag06=g_hrat.hrat90
               DISPLAY l_hrag07 TO hrat90_name
           ELSE
               CALL cl_err('','ghr-068',0)
               NEXT FIELD hrat90
           END IF
      #FUN-151113 wangjya

      AFTER FIELD hrat01
          IF g_hrat.hrat01 IS NOT NULL THEN
             IF p_cmd = "a" OR (p_cmd = "u" AND g_hrat.hrat01 != g_hrat01_t) THEN # 若輸入或更改且改KEY
                 CALL i006_logic_chk_hrat01(g_hrat.*) RETURNING g_hrat.*
                 IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_hrat.hrat01,-239,1)
                   LET g_hrat.hrat01 = g_hrat01_t
                   DISPLAY BY NAME g_hrat.hrat01
                   NEXT FIELD hrat01
                 ELSE

                END IF
             END IF
          END IF
#      AFTER FIELD hrat02
#          --* zhoumj 20160104 mark --
#          #IF cl_null(g_hrat.hrat02) THEN
#          #   CALL cl_err('','ghr-918',0)
#          #   NEXT FIELD hrat02
#          #END IF
#          -- zhoumj 20160104 mark *--

#     AFTER FIELD hrat40
#       IF NOT cl_null(g_hrat.hrat40) THEN
#          CALL i006_logic_chk_hrat40(g_hrat.*) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN
#             CALL cl_err(g_hrat.hrat40,g_errno,1)
#             NEXT FIELD hrat40
#          ELSE
#
#          END IF
#        END IF
#add by zhuzw 20150318 start

     AFTER FIELD hrat86
       IF NOT cl_null(g_hrat.hrat86) THEN
          SELECT COUNT(*) INTO l_a FROM  hrag_file
           WHERE hrag01 = '615'
             AND hrag06 = g_hrat.hrat86
          IF l_a = 0  THEN
             CALL cl_err(' ','ghr-916',0)
             NEXT FIELD hrat86
          ELSE
             SELECT hrag07 INTO l_hrat86_n FROM  hrag_file
              WHERE hrag01 = '615'
                AND hrag06 = g_hrat.hrat86
             DISPLAY  l_hrat86_n TO hrat86_n
          END IF
        END IF
#add by zhuzw 20150318 end
     AFTER FIELD hrat68
      IF NOT cl_null(g_hrat.hrat68) THEN                                                #add by hourf  2013/06/28
          CALL i006_logic_chk_hrat68(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat68,g_errno,1)
             NEXT FIELD hrat68
          END IF

          SELECT COUNT(*) INTO l_a FROM  hrag_file
           WHERE hrag01 = '340'
             AND hrag06 = g_hrat.hrat68
          IF l_a = 0  THEN
             CALL cl_err(' ','ghr-917',0)
             NEXT FIELD hrat68
          ELSE
             SELECT hrag07 INTO l_hrat68_n FROM  hrag_file
              WHERE hrag01 = '340'
                AND hrag06 = g_hrat.hrat68
             DISPLAY  l_hrat68_n TO hrat68_name
          END IF
      END IF
    AFTER FIELD hrat97
      IF NOT cl_null(g_hrat.hrat97) THEN                                                #add by hourf  2013/06/28
          #CALL i006_logic_chk_hrat68(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat97,g_errno,1)
             NEXT FIELD hrat97
          END IF

          SELECT COUNT(*) INTO l_a FROM  hrag_file
           WHERE hrag01 = '340'
             AND hrag06 = g_hrat.hrat97
          IF l_a = 0  THEN
             CALL cl_err(' ','ghr-917',0)
             NEXT FIELD hrat97
          ELSE
             SELECT hrag07 INTO l_hrat97_n FROM  hrag_file
              WHERE hrag01 = '340'
                AND hrag06 = g_hrat.hrat97
             DISPLAY  l_hrat97_n TO hrat97_name
          END IF
      END IF 
      
     AFTER FIELD hrat06
       IF NOT cl_null(g_hrat.hrat06) THEN
         CALL i006_logic_chk_hrat06(g_hrat.*) RETURNING g_hrat.*
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_hrat.hrat06,g_errno,1)
             NEXT FIELD hrat06
          END IF

          #如果直接主管是自己提示错误
          IF g_hrat.hrat06 = g_hrat.hrat01 THEN
            CALL cl_err(' ','ghr-910',1)
            NEXT FIELD hrat06
          ELSE
             SELECT HRAT02 INTO l_hrat06_n FROM HRAT_FILE WHERE HRAT01=g_hrat.hrat06
             DISPLAY l_hrat06_n TO hrat06_name
          END IF
       END IF
       #FUN-151202 wangjya
       IF NOT cl_null(g_hrat.hrat06) THEN
          SELECT hrat05 INTO l_hrat05 FROM hrat_file WHERE hrat01=g_hrat.hrat06
          SELECT hras03 INTO g_hrar02 FROM hras_file  WHERE hras01=l_hrat05
          SELECT hrar04 INTO g_hrat06_name1 FROM hrar_file WHERE hrar03=g_hrar02
          SELECT hras06 INTO g_hras06 FROM hras_file WHERE hras01=l_hrat05
       ELSE
          LET g_hrat06_name1 = NULL
       END IF
       DISPLAY g_hrat06_name1 TO hrat06_name1
       #FUN-151202 wangjya

      AFTER FIELD hrat19
       IF NOT cl_null(g_hrat.hrat19) THEN
          CALL i006_logic_chk_hrat19(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat19,g_errno,1)
             NEXT FIELD hrat19
          ELSE
#          #add by zhuzw 20150401 start
#             SELECT hrad01 INTO l_hrad01 FROM hrad_file
#              WHERE hrad002 = g_hrat.hrat19
#             IF l_hrad01 = '002' THEN
#                LET g_hrat.hrat26 = g_hrat.hrat25
#                DISPLAY BY NAME g_hrat.hrat26
#             ELSE
#                 IF  g_hrat.hrat21 = '001' THEN
#                     SELECT hran05 INTO l_hran05 FROM hran_file
#                     WHERE hran01 = g_hrat.hrat03
#                     LET g_hrat.hrat26 = g_hrat.hrat25 + l_hran05*30
#                     DISPLAY BY NAME g_hrat.hrat26
#                 END IF
#                 IF  g_hrat.hrat21 = '002' THEN
#                     SELECT hran06 INTO l_hran06 FROM hran_file
#                     WHERE hran01 = g_hrat.hrat03
#                     LET g_hrat.hrat26 = g_hrat.hrat25 + l_hran06*30
#                     DISPLAY BY NAME g_hrat.hrat26
#                 END IF
#             END IF
#             #add end
          END IF
       END IF

     AFTER FIELD hrat20
        IF NOT cl_null(g_hrat.hrat20) THEN
          CALL i006_logic_chk_hrat20(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat20,g_errno,1)
             NEXT FIELD hrat20
          END IF
          #FUN-151201 wangjya
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='313' AND hrag06=g_hrat.hrat20
          IF l_n = 0 THEN
             CALL cl_err(g_hrat.hrat20,'aap990',1)
             NEXT FIELD hrat20
          END IF
          #FUN-151201 wangjya
        END IF

     AFTER FIELD hrat21
      IF NOT cl_null(g_hrat.hrat21) THEN
         CALL i006_logic_chk_hrat21(g_hrat.*) RETURNING g_hrat.*
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_hrat.hrat21,g_errno,1)
            NEXT FIELD hrat21
         END IF

         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='337' AND hrag06=g_hrat.hrat21
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat21,'aap990',1)
            NEXT FIELD hrat21
         END IF
         #FUN-151201 wangjya

         IF NOT cl_null(g_hrat.hrat25) AND NOT cl_null(g_hrat.hrat21) AND NOT cl_null(g_hrat.hrat03) THEN
            IF g_hrat.hrat21='001' THEN
               SELECT hran05 INTO l_hran05 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
               IF NOT cl_null(l_hran05) THEN
                  Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran05) INTO g_hrat.hrat26 FROM dual;
                  DISPLAY BY NAME g_hrat.hrat26
               END IF
            END IF
            IF g_hrat.hrat21='002' THEN
               SELECT hran06 INTO l_hran06 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
               IF NOT cl_null(l_hran06) THEN
                  Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran06) INTO g_hrat.hrat26 FROM dual;
                  DISPLAY BY NAME g_hrat.hrat26
               END IF
            END IF
         END IF
      END IF

      AFTER FIELD hrat25
        IF NOT cl_null(g_hrat.hrat25) AND NOT cl_null(g_hrat.hrat03) THEN##AND NOT cl_null(g_hrat.hrat21) AND NOT cl_null(g_hrat.hrat03) THEN
            LET g_hrat.hrat36 = g_hrat.hrat25
            DISPLAY BY NAME g_hrat.hrat36
            LET g_hrat.hrat38 = g_hrat.hrat25
            DISPLAY BY NAME g_hrat.hrat38
            LET g_hrat.hrat69 = g_hrat.hrat25
            DISPLAY BY NAME g_hrat.hrat69
#         IF g_hrat.hrat21='001' THEN
            SELECT hran05 INTO l_hran05 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
            IF NOT cl_null(l_hran05) THEN
               SELECT add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran05) INTO g_hrat.hrat26 FROM dual;
               #Select add_months(last_day(to_date(g_hrat.hrat25,'YYYY-MM-DD'))+1,l_hran05-1) INTO g_hrat.hrat26 FROM dual
               
               DISPLAY BY NAME g_hrat.hrat26
            END IF
#         END IF
#          IF g_hrat.hrat21='002' THEN
#            SELECT hran06 INTO l_hran06 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
#            IF NOT cl_null(l_hran06) THEN
#               #Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran06) INTO g_hrat.hrat26 FROM dual;
#               Select add_months(last_day(to_date(g_hrat.hrat25,'YYYY-MM-DD'))+1,l_hran06-1) INTO g_hrat.hrat26 FROM dual
#               DISPLAY BY NAME g_hrat.hrat26
#            END IF
#         END IF
        END IF
        #add by zhuzw 20151116 start
        IF NOT cl_null(g_hrat.hrat25) THEN
           LET g_hrat.hrat38 = g_hrat.hrat25
           DISPLAY BY NAME g_hrat.hrat38
        END IF
        #add by zhuzw 20151116 end
        --* zhoumj 20160104 add --
        IF NOT cl_null(g_hrat.hrat25) THEN
            SELECT ROUND(months_between(TODAY,to_date(g_hrat.hrat25,'yyyy-mm-dd')),1)
              INTO l_in_year
              FROM dual
              IF l_in_year < 0 THEN 
                 LET l_in_year = 0
              END IF 
              DISPLAY BY NAME l_in_year
        END IF
        -- zhoumj 20160104 add *--

      BEFORE FIELD hrat26
        IF cl_null(g_hrat.hrat26) THEN
            IF NOT cl_null(g_hrat.hrat25) AND NOT cl_null(g_hrat.hrat03) THEN##AND NOT cl_null(g_hrat.hrat21) AND NOT cl_null(g_hrat.hrat03) THEN
                LET g_hrat.hrat36 = g_hrat.hrat25
                DISPLAY BY NAME g_hrat.hrat36
                LET g_hrat.hrat38 = g_hrat.hrat25
                DISPLAY BY NAME g_hrat.hrat38
                LET g_hrat.hrat69 = g_hrat.hrat25
                DISPLAY BY NAME g_hrat.hrat69
#             IF g_hrat.hrat21='001' THEN
                SELECT hran05 INTO l_hran05 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
                IF cl_null(l_hran05) THEN SELECT hran05 INTO l_hran05 FROM hran_file WHERE hran01='0000' AND hranacti='Y' END IF
                IF NOT cl_null(l_hran05) THEN

                   SELECT add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran05) INTO g_hrat.hrat26 FROM dual;
                   #Select add_months(last_day(to_date(g_hrat.hrat25,'YYYY-MM-DD'))+1,l_hran05-1) INTO g_hrat.hrat26 FROM dual
                   DISPLAY BY NAME g_hrat.hrat26
                END IF
#             END IF
#              IF g_hrat.hrat21='002' THEN
#                SELECT hran06 INTO l_hran06 FROM hran_file WHERE hran01=g_hrat.hrat03 AND hranacti='Y'
#                IF cl_null(l_hran06) THEN SELECT hran06 INTO l_hran06 FROM hran_file WHERE hran01='0000' AND hranacti='Y' END IF
#                IF NOT cl_null(l_hran06) THEN
#                   #Select add_months(to_date(g_hrat.hrat25,'YYYY-MM-DD'),l_hran06) INTO g_hrat.hrat26 FROM dual;
#                   Select add_months(last_day(to_date(g_hrat.hrat25,'YYYY-MM-DD'))+1,l_hran06-1) INTO g_hrat.hrat26 FROM dual
#                   DISPLAY BY NAME g_hrat.hrat26
#                END IF
#             END IF
            END IF
        END IF


      ON CHANGE hrat37
          LET g_hrat.hrat37 = cl_digcut(g_hrat.hrat37,1)

      ON CHANGE hrat39
          LET g_hrat.hrat39 = cl_digcut(g_hrat.hrat39,1)

#      AFTER FIELD hrat08
#        IF NOT cl_null(g_hrat.hrat18) THEN
#          CALL i006_logic_chk_hrat08(g_hrat.*,g_hrat_t.hrat01) RETURNING g_hrat.*
#          IF NOT cl_null(g_errno) THEN
#             CALL cl_err(g_hrat.hrat08,g_errno,0)
#             NEXT FIELD hrat13
#          ELSE
#
#          END IF
#        END IF

      AFTER FIELD hrat15
        IF NOT cl_null(g_hrat.hrat15) THEN
          CALL i006_logic_chk_hrat15(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat15,g_errno,0)
             NEXT FIELD hrat15
          ELSE
             DISPLAY BY NAME g_hrat.hrat16
          END IF

          #处理阴历出生日期信息
#          SELECT f_GetLunar(g_hrat.hrat15) INTO g_hrat.hrat10 FROM dual
#          DISPLAY g_hrat.hrat10 TO hrat10
        END IF


      AFTER FIELD hrat13
        IF NOT cl_null(g_hrat.hrat13) THEN
           CALL i006_logic_chk_hrat13(g_hrat.*,g_hrat_t.hrat01) RETURNING g_hrat.*,l_hrag07
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_hrat.hrat13,g_errno,0)
              NEXT FIELD hrat13
           ELSE
##add by zhuzw 20150914 start
#              LET g_flag = 'Y'
#              CALL hr_gen_no('hrat_file','hrat01','009','0000','') RETURNING g_hrat.hrat01,g_flag
#              DISPLAY g_hrat.hrat01 TO hrat01
#              IF g_flag = 'Y' THEN
#                 CALL cl_set_comp_entry("hrat01",TRUE)
#              ELSE
#                 CALL cl_set_comp_entry("hrat01",FALSE)
#              END IF
##add by zhuzw 20150914 end
             #add by zhuzw 20160112 start
             IF p_cmd = 'a' OR (p_cmd='u' AND g_hrat.hrat13 != g_hrat_t.hrat13) THEN 
             	LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hrat_file 
                 WHERE hrat13 = g_hrat.hrat13
                   AND hrat19 NOT LIKE '3%'
                   #AND hrat03 = g_hrat.hrat03 #add by nihuan 20161010

                IF l_n >0 THEN 
                   CALL cl_err('身份证已被使用，请检查','!',1)
                   NEXT FIELD hrat13
                END IF                     
             END IF  
             #add by zhuzw 20160112 end 
             DISPLAY g_hrat.hrat15 TO hrat15
             DISPLAY g_hrat.hrat16 TO hrat16
             DISPLAY g_hrat.hrat17 TO hrat17
             DISPLAY g_hrat.hrat18 TO hrat18
#             DISPLAY l_hrag07 TO hrat17_name

             #处理阴历出生日期信息
#             SELECT f_GetLunar(g_hrat.hrat15) into g_hrat.hrat10 FROM dual
#             DISPLAY g_hrat.hrat10 TO hrat10
          END IF
        ELSE
           --* zhoumj 20160104 mark--
           #IF cl_null(g_hrat.hrat13) THEN
           #   CALL cl_err('','ghr-914 ',1)
           #   NEXT FIELD hrat13
           #END IF
           -- zhoumj 20160104 *--
        END IF

    AFTER  FIELD  hrat14
        IF NOT cl_null(g_hrat.hrat35) AND NOT cl_null(g_hrat.hrat14) THEN
           SELECT YEAR(g_hrat.hrat14)-YEAR(g_hrat.hrat35) INTO g_hrat.hrat89 FROM dual
           DISPLAY g_hrat.hrat89 TO hrat89
        END IF

     AFTER FIELD hrat42
       IF NOT cl_null(g_hrat.hrat42) THEN
          CALL i006_logic_chk_hrat42(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat42,g_errno,1)
             NEXT FIELD hrat42
          END IF

          #FUN-151201 wangjya
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hrai_file WHERE hrai03=g_hrat.hrat42
          IF l_n = 0 THEN
             CALL cl_err(g_hrat.hrat42,'mfg1318',0)
             NEXT FIELD hrat42
          END IF
          #FUN-151201 wangjya
       END IF

     AFTER FIELD hrat52
       IF NOT cl_null(g_hrat.hrat52) THEN
          CALL i006_logic_chk_hrat52(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat52,g_errno,1)
             NEXT FIELD hrat52
          END IF
          #FUN-151201 wangjya
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrat.hrat52
          IF l_n = 0 THEN
             CALL cl_err(g_hrat.hrat52,'aap-038',0)
             NEXT FIELD hrat52
          END IF

          SELECT hratconf INTO g_hrat.hratconf FROM hrat_file WHERE hrat01=g_hrat.hrat52
          IF g_hrat.hratconf = "N" THEN
             CALL cl_err(g_hrat.hrat52,'aim-305',0)
             NEXT FIELD hrat52
          END IF
          #FUN-151201 wangjya
       END IF

     AFTER FIELD hrat64
          IF cl_null(g_hrat.hrat05) THEN
          	LET g_hrat.hrat64 = NULL 
            CALL cl_err('请先录入职位','!',1)
            NEXT FIELD hrat05
          ELSE

          END IF

     AFTER FIELD hrat12
        IF NOT cl_null(g_hrat.hrat12) THEN
          CALL i006_logic_chk_hrat12(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat12,g_errno,1)
             NEXT FIELD hrat12
          ELSE
          CALL cl_set_comp_entry("hrat13",TRUE)
          END IF

         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='314' AND hrag06=g_hrat.hrat12
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat12,'aap990',1)
            NEXT FIELD hrat12
         END IF
         #FUN-151201 wangjya
        END IF

     AFTER FIELD hrat17
        IF NOT cl_null(g_hrat.hrat17) THEN
          CALL i006_logic_chk_hrat17(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat17,g_errno,1)
             NEXT FIELD hrat17
          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='333' AND hrag06=g_hrat.hrat17
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat17,'aap990',1)
            NEXT FIELD hrat17
         END IF
         #FUN-151201 wangjya
         END IF


     AFTER FIELD hrat22
       IF NOT cl_null(g_hrat.hrat22) THEN
          CALL i006_logic_chk_hrat22(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat22,g_errno,1)
             NEXT FIELD hrat22
          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='317' AND hrag06=g_hrat.hrat22
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat22,'aap990',1)
            NEXT FIELD hrat22
         END IF
         #FUN-151201 wangjya
       END IF


     AFTER FIELD hrat24
      IF NOT cl_null(g_hrat.hrat24) THEN
          CALL i006_logic_chk_hrat24(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat24,g_errno,1)
             NEXT FIELD hrat24
          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='334' AND hrag06=g_hrat.hrat24
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat24,'aap990',1)
            NEXT FIELD hrat24
         END IF
         #FUN-151201 wangjya
      END IF


     AFTER FIELD hrat28
      IF NOT cl_null(g_hrat.hrat28) THEN
          CALL i006_logic_chk_hrat28(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat28,g_errno,1)
             NEXT FIELD hrat28
          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='302' AND hrag06=g_hrat.hrat28
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat28,'aap990',1)
            NEXT FIELD hrat28
         END IF
         #FUN-151201 wangjya
      END IF

     AFTER FIELD hrat29
      IF NOT cl_null(g_hrat.hrat29) THEN
          CALL i006_logic_chk_hrat29(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat29,g_errno,1)
             NEXT FIELD hrat29
          ELSE

          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='301' AND hrag06=g_hrat.hrat29
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat29,'aap990',1)
            NEXT FIELD hrat29
         END IF
         #FUN-151201 wangjya
      END IF

     AFTER FIELD hrat30
      IF NOT cl_null(g_hrat.hrat30) THEN
          CALL i006_logic_chk_hrat30(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat30,g_errno,1)
             NEXT FIELD hrat30
          ELSE

          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='321' AND hrag06=g_hrat.hrat30
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat30,'aap990',1)
            NEXT FIELD hrat30
         END IF
         #FUN-151201 wangjya
      END IF

     AFTER FIELD hrat66
      IF NOT cl_null(g_hrat.hrat66) THEN
          CALL i006_logic_chk_hrat66(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat66,g_errno,1)
             NEXT FIELD hrat66
          ELSE

          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='326' AND hrag06=g_hrat.hrat66
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat66,'aap990',1)
            NEXT FIELD hrat66
         END IF
         #FUN-151201 wangjya
      END IF

     AFTER FIELD hrat67
       IF NOT cl_null(g_hrat.hrat67) THEN
         SELECT hraq01,hraqa02,hraqa04,hrag07,hraqa03 INTO g_hrat.hrat78,g_hrat78,g_hrat.hrat79,g_hrat79,g_hraqa04 FROM hraqa_file
         LEFT JOIN hraq_file ON hraq02=hraqa02
         LEFT JOIN hrag_file ON hrag01='206' AND hrag06=hraqa04
         WHERE hraqa06=g_hrat.hrat67
         DISPLAY g_hraqa04,g_hrat.hrat78,g_hrat78,g_hrat.hrat79,g_hrat79,g_hraqa04 TO hraqa04,hrat78,hrat78_name,hrat79,hrat79_name,hraqa04
#          SELECT hraqa04 INTO g_hraqa04
#            FROM hraqa_file
#           WHERE hraqa06=g_hrat.hrat67
#           SELECT hraqa03 INTO g_hraqa03
#            FROM hraqa_file
#           WHERE hraqa06=g_hrat.hrat67
#          SELECT hraqa02 INTO g_hrat78
#            FROM hraqa_file
#           WHERE hraqa06=g_hrat.hrat67
#          SELECT hrag07 INTO g_hrat79
#            FROM hrag_file
#           WHERE hrag01='206'
#             AND hrag06=g_hraqa04
       END IF
#       DISPLAY g_hraqa03,g_hrat78,g_hrat79 TO hraqa04,hraqa02,hrag07
       #FUN-151201 wangjya
       IF NOT cl_null(g_hrat.hrat67) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hraqa_file
            LEFT JOIN hraq_file ON hraq02=hraqa02
            LEFT JOIN hrag_file ON hrag01='206' AND hrag06=hraqa04
           WHERE hraqa06=g_hrat.hrat67
           IF l_n = 0 THEN
              CALL cl_err(g_hrat.hrat67,'ghr-038',0)
              NEXT FIELD hrat67
           END IF
       END IF
       #FUN-151201 wangjya

     AFTER FIELD hrat34
      IF NOT cl_null(g_hrat.hrat34) THEN
          CALL i006_logic_chk_hrat34(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat34,g_errno,1)
             NEXT FIELD hrat34
          ELSE

          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='320' AND hrag06=g_hrat.hrat34
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat34,'aap990',1)
            NEXT FIELD hrat34
         END IF
         #FUN-151201 wangjya
      END IF

     AFTER FIELD hrat41
       IF NOT cl_null(g_hrat.hrat41) THEN
          CALL i006_logic_chk_hrat41(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat41,g_errno,1)
             NEXT FIELD hrat41
          ELSE

          END IF
         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='325' AND hrag06=g_hrat.hrat41
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat41,'aap990',1)
            NEXT FIELD hrat41
         END IF
         #FUN-151201 wangjya
       END IF

     AFTER FIELD hrat43
      IF NOT cl_null(g_hrat.hrat43) THEN
          CALL i006_logic_chk_hrat43(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat43,g_errno,1)
             NEXT FIELD hrat43
          ELSE

          END IF
#         #FUN-151201 wangjya
#         LET l_n = 0
#         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='319' AND hrag06=g_hrat.hrat41
#         IF l_n = 0 THEN
#            CALL cl_err(g_hrat.hrat41,'aap990',1)
#            NEXT FIELD hrat41
#         END IF
#         #FUN-151201 wangjya
      END IF
     AFTER FIELD hrat73
      IF NOT cl_null(g_hrat.hrat73) THEN
          CALL i006_logic_chk_hrat73(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat73,g_errno,1)
             NEXT FIELD hrat73
          ELSE

          END IF

         #FUN-151201 wangjya
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='341' AND hrag06=g_hrat.hrat41
         IF l_n = 0 THEN
            CALL cl_err(g_hrat.hrat41,'aap990',1)
            NEXT FIELD hrat41
         END IF
         #FUN-151201 wangjya
      END IF

     AFTER FIELD hrat75
          IF NOT cl_null(g_hrat.hrat75) THEN
             SELECT hrat02 INTO g_hrat75_name
               FROM hrat_file
              WHERE hrat01=g_hrat.hrat75
          END IF
          DISPLAY g_hrat75_name TO hrat75_name

     AFTER FIELD hrat76
          IF cl_null(g_hrat.hrat45) THEN
             LET g_hrat.hrat45=g_hrat.hrat76     #户口地址
          END IF
          IF cl_null(g_hrat.hrat46) THEN
             LET g_hrat.hrat46=g_hrat.hrat76     #现住地址
          END IF
     #FUN-1511124 wangjya
     AFTER FIELD hrat91
        IF NOT cl_null(g_hrat.hrat91) THEN
          CALL i006_logic_chk_hrat91(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat91,g_errno,1)
             NEXT FIELD hrat91
          ELSE

          END IF
          #FUN-151201 wangjya
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='345' AND hrag06=g_hrat.hrat91
          IF l_n = 0 THEN
             CALL cl_err(g_hrat.hrat91,'aap990',1)
             NEXT FIELD hrat91
          END IF
          #FUN-151201 wangjya
         END IF
      #FUN-1511124 wangjya

     #FUN-151201 wangjya
     AFTER FIELD hrat93
        IF NOT cl_null(g_hrat.hrat93) THEN
          CALL i006_logic_chk_hrat93(g_hrat.*) RETURNING g_hrat.*
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_hrat.hrat93,g_errno,1)
             NEXT FIELD hrat93
          END IF

          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='346' AND hrag06=g_hrat.hrat93
          IF l_n = 0 THEN
             CALL cl_err(g_hrat.hrat93,'aap990',1)
             NEXT FIELD hrat93
          END IF
         END IF
      #FUN-151201 wangjya

      AFTER INPUT
          LET g_hrat.hratuser = s_get_data_owner("hrat_file")
          LET g_hrat.hratgrup = s_get_data_group("hrat_file")
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
          #判断部门、组、课必须有一项不能为空
          # IF NOT INT_FLAG THEN
          #  IF cl_null(g_hrat.hrat04) AND cl_null(g_hrat.hrat87) AND cl_null(g_hrat.hrat88) THEN
          #    CALL cl_err('',-1006,0)
          #    NEXT FIELD hrat04
          #  END IF
          # END IF
          #add by zhuzw 20160111 start

             #add by zhuzw 20160112 start
             IF p_cmd = 'a' OR (p_cmd='u' AND g_hrat.hrat13 != g_hrat_t.hrat13) THEN 
                SELECT COUNT(*) INTO l_n FROM hrat_file 
                 WHERE hrat13 = g_hrat.hrat13
                   AND hrat19 NOT LIKE '3%'
                IF l_n >0 THEN 
                   CALL cl_err('身份证已被使用，请检查','!',1)
                   NEXT FIELD hrat13
                END IF                     
                SELECT COUNT(*) INTO l_n FROM hrbj_file
                 WHERE hrbj05 =  g_hrat.hrat13
                   AND hrbjud03 = '002'
                   AND hrbjacti = 'Y'
                IF l_n>0 THEN
                   CALL cl_err('该员工身份信息存在于黑名单中，请检查','!',0)
                   NEXT FIELD hrat13
                END IF
             END IF  
             #add by zhuzw 20160112 end 
          IF  p_cmd='a' THEN
             SELECT COUNT(*) INTO l_n FROM hrat_file
              WHERE hrat01 = g_hrat.hrat01
             IF l_n>0 THEN
                CALL cl_err('工号已被使用，请检查','!',0)
                NEXT FIELD hrat01
             END IF
             #add by zhuzw 20160112 start
#            #人员编制检查
#            LET l_ins_chk = 'Y' #add by zhuzw 20160112 
#            IF g_hrat.hrat09 = 'Y' THEN  #add by zhuzw 20160112 
#                  CALL i006_HR_chk(g_hrat.hrat03,g_hrat.hrat05,g_hrat.hrat04) RETURNING l_ins_chk                 
#                  CALL cl_err('',g_errno,1)
#                  IF l_ins_chk = 'N' THEN 
#                     NEXT FIELD hrat05
#                  END IF 
#           END IF              
#             #add by zhuzw 20160112 end 
          END IF
           #add by zhuzw 20160111 end
           IF p_cmd='u' AND NOT cl_null(g_hrat_t.hrat01) THEN
              LET g_hrat.hrat01=g_hrat_t.hrat01
           END IF

           IF p_cmd='a' OR (p_cmd='u' AND cl_null(g_hrat_t.hrat01) ) THEN
              #避免意外为空
             IF cl_null(g_hrat.hrat01) AND NOT cl_null(g_hrat.hrat03) THEN
                     LET l_hraa10 = ''
                     SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01 = g_hrat.hrat03 AND hraaacti = 'Y'
                     LET g_flag = 'Y'
                     CALL hr_gen_no('hrat_file','hrat01','009',g_hrat.hrat03,l_hraa10) RETURNING g_hrat.hrat01,g_flag
                     DISPLAY g_hrat.hrat01 TO hrat01
                     IF g_flag = 'Y' THEN
                        CALL cl_set_comp_entry("hrat01",TRUE)
                     ELSE
                        CALL cl_set_comp_entry("hrat01",FALSE)
                     END IF
               END IF
            END IF


           IF p_cmd='a' THEN
               IF cl_null(l_hraa10) THEN
                  SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01 = g_hrat.hrat03 AND hraaacti = 'Y'
               END IF

               CALL hr_gen_no('hrat_file','hrat01','009',g_hrat.hrat03,l_hraa10) RETURNING l_hrat01,g_flag
               IF l_hrat01 != g_hrat.hrat01 AND NOT cl_null(g_hrat.hrat01) THEN
                 CALL cl_err('','ghr-921',1)
                 NEXT FIELD hrat01
               ELSE
                 IF NOT cl_null(l_hrat01) AND cl_null(g_hrat.hrat01) THEN
                   LET g_hrat.hrat01=l_hrat01
                 END IF
                 IF cl_null(l_hrat01) AND cl_null(g_hrat.hrat01) THEN
                   CALL cl_err('','ghr-920',1)
                   NEXT FIELD hrat01
                 END IF
               END IF
           END IF
           ######end#########
           LET l_s='0'
           LET l_sr=' '

           IF g_hrat.hrat07='Y' THEN
              SELECT COUNT(*) INTO l_s FROM hraw_file WHERE hraw02=g_hrat.hrat04 AND hraw07='Y' AND hrawacti = 'Y' AND hraw05>today
              IF l_s >'0'THEN
                 SELECT hrao02 INTO l_hrao02 FROM hrao_file WHERE hrao01 = g_hrat.hrat04
                 SELECT hraw01 INTO l_hraw01 FROM hraw_file WHERE hraw02= g_hrat.hrat04 AND hraw07='Y'
                 SELECT hrat01,hrat02 INTO l_hrat01,l_hrat02 FROM hrat_file WHERE hratid=l_hraw01
#                 LET l_sr=l_hrao02,"部门主管已指定为",l_hrat01,l_hrat02
                  CALL cl_err3("sel","hrat_file",l_hrao02,"","ghr-919",l_hrat01,l_hrat02,0)
              END IF
              SELECT COUNT(*) INTO l_s FROM hrat_file,hrad_file WHERE hrat04=g_hrat.hrat04 AND hrat07='Y' AND hrad02 = hrat19 AND hrad01 !='003'
              IF l_s >'0' AND g_hrat.hrat01 != g_hrat_t.hrat01  THEN
                 SELECT hrat01,hrat02,hrat04 INTO l_hrat01,l_hrat02,l_hrat04 FROM hrat_file WHERE hrat04=g_hrat.hrat04 AND hrat07='Y'
#                 LET l_sr=l_sr,l_hrat04,"部门主管已指定为",l_hrat01,l_hrat02
                 CALL cl_err3("sel","hrat_file",l_hrat04,"","ghr-919",l_hrat01,l_hrat02,0)
              END IF
           END IF
#           IF cl_null(g_hrat.hrat13) THEN LET l_sr=l_sr,"身份证信息不能为空!" END IF
#           IF NOT cl_null(l_sr) THEN
#              CALL cl_err(l_sr,'!',1)
#              NEXT FIELD hrat01
#           END IF

      ON ACTION controlp
        CASE
           WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = g_hrat.hrat03
              CALL cl_create_qry() RETURNING g_hrat.hrat03
              DISPLAY BY NAME g_hrat.hrat03
              NEXT FIELD hrat03
              #部门
           WHEN INFIELD(hrat04)
              {CALL cl_init_qry_var()
              IF NOT cl_null(g_hrat.hrat03) THEN
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.arg1 = g_hrat.hrat03
              ELSE
                LET g_qryparam.form = "q_hrao01_1"
              END IF
              LET g_qryparam.default1 = g_hrat.hrat04
              CALL cl_create_qry() RETURNING g_hrat.hrat04
              DISPLAY BY NAME g_hrat.hrat04
              NEXT FIELD hrat04}

              CALL cl_init_qry_var()

              IF NOT cl_null(g_hrat.hrat03) THEN
               LET g_qryparam.arg1 = g_hrat.hrat03
               LET g_qryparam.arg2 = '1'
               LET g_qryparam.form = "cq_hrao01_0_1"
              ELSE
              LET g_qryparam.arg2 = '1'
               LET g_qryparam.form = "cq_hrao01_1_1"
              END IF

              LET g_qryparam.default1 = g_hrat.hrat04
              CALL cl_create_qry() RETURNING g_hrat.hrat04
              DISPLAY BY NAME g_hrat.hrat04
              NEXT FIELD hrat04
               #######################start########################

            #######################start########################
#add by zhuzw 20160111 start
           WHEN INFIELD(hrat02)
              LET l_hrat13 = ''
              CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_hratz"
              LET g_qryparam.default1 = g_hrat.hrat02
              LET g_qryparam.default2 = l_hrat13
              CALL cl_create_qry() RETURNING g_hrat.hrat02,l_hrat13
              IF NOT cl_null(l_hrat13) THEN
                LET g_hrat.hrat13 = l_hrat13
                LET l_kc = 'Y'
                NEXT FIELD hrat45
              ELSE
              	NEXT FIELD hrat02
              END IF
#add by zhuzw 20160111 end
            #FUN-151201 wangjya
            #内部推荐人
            WHEN INFIELD(hrat44)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.default1 = g_hrat.hrat44
              CALL cl_create_qry() RETURNING g_hrat.hrat44
              DISPLAY BY NAME g_hrat.hrat44
              NEXT FIELD hrat44
            #FUN-151201 wangjya
            #组别
              WHEN INFIELD(hrat87)
              CALL cl_init_qry_var()
              IF NOT cl_null(g_hrat.hrat03) THEN
                 CASE
                   WHEN NOT cl_null(g_hrat.hrat04)
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hrat.hrat03
                     LET g_qryparam.arg2 = '2'
                     LET g_qryparam.arg3 = g_hrat.hrat04
                    WHEN cl_null(g_hrat.hrat04)
                     LET g_qryparam.arg1 = g_hrat.hrat03
                     LET g_qryparam.arg2 = '2'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
              ELSE
                LET g_qryparam.form = "cq_hrao01_1_1"
                LET g_qryparam.arg2 = '2'
              END IF
              LET g_qryparam.default1 = g_hrat.hrat87
              CALL cl_create_qry() RETURNING g_hrat.hrat87
              DISPLAY BY NAME g_hrat.hrat87
              NEXT FIELD hrat87
            

            
              
            WHEN INFIELD(hrat88)
              CALL cl_init_qry_var()
              IF NOT cl_null(g_hrat.hrat03) THEN
                 CASE
                   WHEN NOT cl_null(g_hrat.hrat87)
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hrat.hrat03
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.arg3 = g_hrat.hrat87
                   WHEN NOT cl_null(g_hrat.hrat04)
                     LET g_qryparam.form = "cq_hrao01_0"
                     LET g_qryparam.arg1 = g_hrat.hrat03
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.arg3 = g_hrat.hrat04
                    WHEN cl_null(g_hrat.hrat04)
                     LET g_qryparam.arg1 = g_hrat.hrat03
                     LET g_qryparam.arg2 = '3'
                     LET g_qryparam.form = "cq_hrao01_0_1"
                 END CASE
              ELSE
                LET g_qryparam.form = "cq_hrao01_1_1"
                LET g_qryparam.arg2 = '3'
              END IF
              LET g_qryparam.default1 = g_hrat.hrat88
              CALL cl_create_qry() RETURNING g_hrat.hrat88
              DISPLAY BY NAME g_hrat.hrat88
              NEXT FIELD hrat88
            #######################start########################


               WHEN INFIELD(hrat68)
                 CALL cl_init_qry_var()
#                 LET g_qryparam.arg1 = '652'
                 LET g_qryparam.arg1 = '340'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.default1 = g_hrat.hrat68
                 CALL cl_create_qry() RETURNING g_hrat.hrat68
              #   DISPLAY g_qryparam.multiret TO hrat68
                  DISPLAY BY NAME g_hrat.hrat68
                 NEXT FIELD hrat68
               WHEN INFIELD(hrat97)
                 CALL cl_init_qry_var()
#                 LET g_qryparam.arg1 = '652'
                 LET g_qryparam.arg1 = '340'
                 LET g_qryparam.form = "q_hrag06"
                 LET g_qryparam.default1 = g_hrat.hrat97
                 CALL cl_create_qry() RETURNING g_hrat.hrat97
              #   DISPLAY g_qryparam.multiret TO hrat68
                  DISPLAY BY NAME g_hrat.hrat97
                 NEXT FIELD hrat97                 
           WHEN INFIELD(hrat05)
              CALL cl_init_qry_var()
              #判断主部门开窗是否在最小单位下
              CASE
                #WHEN g_hrat.hrat88 IS NOT NULL
                #    LET g_qryparam.form = "q_hrap01"
                #    LET g_qryparam.arg1 = g_hrat.hrat88
                #WHEN g_hrat.hrat87 IS NOT NULL
                #    LET g_qryparam.form = "q_hrap01"
                #    LET g_qryparam.arg1 = g_hrat.hrat87
                WHEN g_hrat.hrat04 IS NOT NULL
                    LET g_qryparam.form = "q_hrap01"
                    LET g_qryparam.arg1 = g_hrat.hrat04
                OTHERWISE
                LET g_qryparam.form = "q_hrap01_1"
                END CASE
              LET g_qryparam.default1 = g_hrat.hrat05
              CALL cl_create_qry() RETURNING g_hrat.hrat05
              DISPLAY BY NAME g_hrat.hrat05
              NEXT FIELD hrat05

           WHEN INFIELD(hrat06)
              {CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat06"
              LET g_qryparam.default1 = g_hrat.hrat06
              LET g_qryparam.arg1 = g_hrat.hrat01
              CALL cl_create_qry() RETURNING g_hrat.hrat06
              DISPLAY BY NAME g_hrat.hrat06
              NEXT FIELD hrat06   }
             CALL cl_init_qry_var()
              LET g_qryparam.form = "cq_hrat06"
              LET g_qryparam.default1 = g_hrat.hrat06
              LET g_qryparam.arg1 = g_hrat.hrat01
              CALL cl_create_qry() RETURNING g_hrat.hrat06
              DISPLAY BY NAME g_hrat.hrat06
              NEXT FIELD hrat06

           WHEN INFIELD(hrat42)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrai031"
              LET g_qryparam.default1 = g_hrat.hrat42
              CALL cl_create_qry() RETURNING g_hrat.hrat42
              DISPLAY BY NAME g_hrat.hrat42
              NEXT FIELD hrat42
              
           WHEN INFIELD(hrat60)     #开窗选职务add by wangwy 20170309
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrar03_zw"
              LET g_qryparam.default1 = g_hrat.hrat60
              CALL cl_create_qry() RETURNING g_hrat.hrat60
              DISPLAY BY NAME g_hrat.hrat60
              NEXT FIELD hrat60
           
           WHEN INFIELD(hrat52)
              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_hrat06"
              LET g_qryparam.form = "q_hrat01"
              LET g_qryparam.arg1 = g_hrat.hrat01
              LET g_qryparam.default1 = g_hrat.hrat52
              CALL cl_create_qry() RETURNING g_hrat.hrat52
              DISPLAY BY NAME g_hrat.hrat52
              NEXT FIELD hrat52
#           WHEN INFIELD(hrat64)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_hrar06"
#              LET g_qryparam.default1 = g_hrat.hrat64
#              CALL cl_create_qry() RETURNING g_hrat.hrat64
#              DISPLAY BY NAME g_hrat.hrat64
#              NEXT FIELD hrat64
           WHEN INFIELD(hrat12)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '314'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat12
              CALL cl_create_qry() RETURNING g_hrat.hrat12
              DISPLAY BY NAME g_hrat.hrat12
              NEXT FIELD hrat12
           WHEN INFIELD(hrat17)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '333'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat17
              CALL cl_create_qry() RETURNING g_hrat.hrat17
              DISPLAY BY NAME g_hrat.hrat17
              NEXT FIELD hrat17
           WHEN INFIELD(hrat19)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrad02"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat19
              CALL cl_create_qry() RETURNING g_hrat.hrat19
              DISPLAY BY NAME g_hrat.hrat19
              NEXT FIELD hrat19
           WHEN INFIELD(hrat20)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '313'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat20
              CALL cl_create_qry() RETURNING g_hrat.hrat20
              DISPLAY BY NAME g_hrat.hrat20
              NEXT FIELD hrat20
           WHEN INFIELD(hrat21)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '337'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat21
              CALL cl_create_qry() RETURNING g_hrat.hrat21
              DISPLAY BY NAME g_hrat.hrat21
              NEXT FIELD hrat21
           WHEN INFIELD(hrat66)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '326'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat66
              CALL cl_create_qry() RETURNING g_hrat.hrat66
              DISPLAY BY NAME g_hrat.hrat66
              NEXT FIELD hrat66
           WHEN INFIELD(hrat73)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '341'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat73
              CALL cl_create_qry() RETURNING g_hrat.hrat73
              DISPLAY BY NAME g_hrat.hrat73
              NEXT FIELD hrat73
           WHEN INFIELD(hrat78)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraq01"
               LET g_qryparam.default1 = g_hrat.hrat78
               CALL cl_create_qry() RETURNING g_hrat.hrat78
               DISPLAY BY NAME g_hrat.hrat78
               SELECT hraq02 INTO g_hrat78 FROM hraq_file WHERE hraq01=g_hrat.hrat78
               DISPLAY g_hrat78 TO hrat78_name
               NEXT FIELD hrat78
           WHEN INFIELD(hrat79)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '206'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat79
              CALL cl_create_qry() RETURNING g_hrat.hrat79
              DISPLAY BY NAME g_hrat.hrat79
              SELECT hrag07 INTO g_hrat79 FROM hrag_file WHERE hrag01='206' AND hrag06=g_hrat.hrat79
              DISPLAY g_hrat79 TO hrat79_name
              NEXT FIELD hrat79
           WHEN INFIELD(hrat22)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '317'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat22
              CALL cl_create_qry() RETURNING g_hrat.hrat22
              DISPLAY BY NAME g_hrat.hrat22
              NEXT FIELD hrat22
           WHEN INFIELD(hrat24)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '334'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat24
              CALL cl_create_qry() RETURNING g_hrat.hrat24
              DISPLAY BY NAME g_hrat.hrat24
              NEXT FIELD hrat24
           WHEN INFIELD(hrat28)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '302'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat28
              CALL cl_create_qry() RETURNING g_hrat.hrat28
              DISPLAY BY NAME g_hrat.hrat28
              NEXT FIELD hrat28
           WHEN INFIELD(hrat29)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '301'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat29
              CALL cl_create_qry() RETURNING g_hrat.hrat29
              DISPLAY BY NAME g_hrat.hrat29
              NEXT FIELD hrat29
           WHEN INFIELD(hrat30)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '321'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat30
              CALL cl_create_qry() RETURNING g_hrat.hrat30
              DISPLAY BY NAME g_hrat.hrat30
              NEXT FIELD hrat30
           WHEN INFIELD(hrat67)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraqa"
              LET g_qryparam.default1 = g_hrat.hrat67
              CALL cl_create_qry() RETURNING g_hrat.hrat67
              DISPLAY BY NAME g_hrat.hrat67
              NEXT FIELD hrat67
           WHEN INFIELD(hrat34)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '320'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat34
              CALL cl_create_qry() RETURNING g_hrat.hrat34
              DISPLAY BY NAME g_hrat.hrat34
              NEXT FIELD hrat34
           WHEN INFIELD(hrat40)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraf01"
              LET g_qryparam.default1 = g_hrat.hrat40
              CALL cl_create_qry() RETURNING g_hrat.hrat40
              DISPLAY BY NAME g_hrat.hrat40
              NEXT FIELD hrat40
           WHEN INFIELD(hrat41)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '325'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat41
              CALL cl_create_qry() RETURNING g_hrat.hrat41
              DISPLAY BY NAME g_hrat.hrat41
              NEXT FIELD hrat41
           WHEN INFIELD(hrat43)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '319'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat43
              CALL cl_create_qry() RETURNING g_hrat.hrat43
              DISPLAY BY NAME g_hrat.hrat43
              NEXT FIELD hrat43
           WHEN INFIELD(hrat75)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat"
              LET g_qryparam.default1 = g_hrat.hrat75
              CALL cl_create_qry() RETURNING g_hrat.hrat75
              DISPLAY BY NAME g_hrat.hrat75
              NEXT FIELD hrat75
#add by zhuzw 20150318 start
           WHEN INFIELD(hrat86)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '615'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat86
              CALL cl_create_qry() RETURNING g_hrat.hrat86
              DISPLAY BY NAME g_hrat.hrat86
              NEXT FIELD hrat86
#add by zhuzw 20150318 end
#FUN-151113 wangjya
          WHEN INFIELD(hrat90)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrag07"
             LET g_qryparam.construct = 'N'
             LET g_qryparam.default1 = g_hrat.hrat90
             CALL cl_create_qry() RETURNING g_hrat.hrat90
             DISPLAY g_hrat.hrat90 TO hrat90
             NEXT FIELD hrat90
           WHEN INFIELD(hrat91)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '345'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = g_hrat.hrat91
              CALL cl_create_qry() RETURNING g_hrat.hrat91
              DISPLAY g_hrat.hrat91 TO hrat91
              NEXT FIELD hrat91
           WHEN INFIELD(hrat93)
              CALL cl_init_qry_var()
              LET g_qryparam.arg1 = '346'
              LET g_qryparam.form = "q_hrag06"
              LET g_qryparam.default1 = g_hrat.hrat93
              CALL cl_create_qry() RETURNING g_hrat.hrat93
              DISPLAY g_hrat.hrat93 TO hrat93
              NEXT FIELD hrat93
#FUN-151113 wangjya
           OTHERWISE
              EXIT CASE
           END CASE
         #add by zhuzw 20160111 start
        ON ACTION ghri006_rp
           CALL i006_rp()
        #add by zhuzw end
      ON ACTION update
           IF NOT cl_null(g_hrat.hrat01) THEN
              --* zhoumj 20160104 --
        #      LET g_doc.column1 = "hrat01"
        #      LET g_doc.value1 = g_hrat.hrat01
              LET g_doc.column1 = "hratid"
              LET g_doc.value1 = g_hrat.hratid
              -- zhoumj 20160104 *--
              CALL cl_fld_doc("hrat32")
            END IF
#        #add by zhuzw 20150318 start
#        ON ACTION ghri006_m
#           CALL cl_set_comp_entry("hrat02,hrat12,hrat13,hrat14,hrat35,hrat89,hrat15,hrat17,hrat76,hrat18,",TRUE)
#        #add by zhuzw 20150318 end
      ON ACTION ghri006_k
         CALL i006_read()

      ON ACTION ghri006_l
         CALL i006_write()

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


      ON ACTION help
         CALL cl_show_help()
   END INPUT
END FUNCTION

FUNCTION i006_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_hrat.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i006_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i006_count
    FETCH i006_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i006_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
        INITIALIZE g_hrat.* TO NULL
    ELSE
        CALL i006_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION



FUNCTION i006_fetch(p_flhrat)
    DEFINE p_flhrat         LIKE type_file.chr1

    CASE p_flhrat
        WHEN 'N' FETCH NEXT     i006_cs INTO g_hrat.hratid
        WHEN 'P' FETCH PREVIOUS i006_cs INTO g_hrat.hratid
        WHEN 'F' FETCH FIRST    i006_cs INTO g_hrat.hratid
        WHEN 'L' FETCH LAST     i006_cs INTO g_hrat.hratid
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()

                  ON ACTION about
                     CALL cl_about()


                  ON ACTION help
                     CALL cl_show_help()

                  ON ACTION controlg
                     CALL cl_cmdask()

               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i006_cs INTO g_hrat.hratid
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
        INITIALIZE g_hrat.* TO NULL
        LET g_hrat.hrat01 = NULL
        RETURN
    ELSE
      CASE p_flhrat
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF

    SELECT * INTO g_hrat.* FROM hrat_file    # 重讀DB,因TEMP有不被更新特性
       WHERE hratid = g_hrat.hratid
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","hrat_file",g_hrat.hrat01,"",SQLCA.sqlcode,"","",0)
    ELSE
        LET g_data_owner=g_hrat.hratuser           #FUN-4C0044權限控管
        LET g_data_group=g_hrat.hratgrup
        CALL i006_show()                   # 重新顯示
    END IF
END FUNCTION



FUNCTION i006_show()
DEFINE l_hrag07    LIKE hrag_file.hrag07
DEFINE l_des       LIKE type_file.chr100

   LET g_hrat_t.* = g_hrat.*
   DISPLAY BY NAME
            #FUN-160111 wjy
            g_hrat.hrat08,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat14,g_hrat.hrat89,
            g_hrat.hrat35,g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,
            g_hrat.hrat45,g_hrat.hrat30,g_hrat.hrat49,g_hrat.hrat51,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,
            g_hrat.hrat22,g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat10,g_hrat.hrat43,g_hrat.hrat44,g_hrat.hrat25,
            g_hrat.hrat66,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat68,g_hrat.hrat97,g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat87,
            g_hrat.hrat88,g_hrat.hrat05,g_hrat.hrat06,g_hrat.hrat21,g_hrat.hrat91,g_hrat.hrat93,g_hrat.hrat90,
            g_hrat.hrat26,g_hrat.hrat77,g_hrat.hrat07,
            g_hrat.hrat09,g_hrat.hrat11,g_hrat.ta_hrat01,g_hrat.ta_hrat02,g_hrat.ta_hrat03,g_hrat.hratconf,
            g_hrat.hrat36,g_hrat.hrat38,g_hrat.hrat39,g_hrat.hrat37,g_hrat.hrat69,g_hrat.hrat70,g_hrat.hrat75,
            g_hrat.hrat73,g_hrat.hrat50,g_hrat.hrat47,g_hrat.hrat80,g_hrat.hrat85,g_hrat.hrat81,g_hrat.hrat82,
            g_hrat.hrat83,g_hrat.hrat33,g_hrat.hrat54,g_hrat.hrat53,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat74,
            g_hrat.hrat52,g_hrat.hrat72,g_hrat.hrat71,g_hrat.hrat79,g_hrat.hrat48,g_hrat.hrat40,g_hrat.hrat41,
            g_hrat.hrat42,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat58,g_hrat.hrat59,g_hrat.hrat60,
            g_hrat.hrat62,g_hrat.hrat61,g_hrat.hrat65,g_hrat.hrat94,g_hrat.hrat95,g_hrat.hrat96,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,
            g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,g_hrat.hratdate,g_hrat.hrat84
            #FUN-160111 wjy
#      g_hrat.hrat03,g_hrat.hrat04,g_hrat.hrat72,g_hrat.hrat05,g_hrat.hrat01,g_hrat.hrat02,g_hrat.hrat10,g_hrat.hrat41,g_hrat.hrat40,
#      g_hrat.hrat68,g_hrat.hrat06,g_hrat.hrat19,g_hrat.hrat20,g_hrat.hrat21,g_hrat.hrat25,g_hrat.hrat66,g_hrat.hrat26,g_hrat.hrat77,
#      g_hrat.hrat91,g_hrat.hrat93,g_hrat.hrat08,
#      g_hrat.hrat58,g_hrat.hrat42,g_hrat.hrat43,g_hrat.hrat12,g_hrat.hrat13,g_hrat.hrat35,g_hrat.hrat14,g_hrat.hrat89,
#      g_hrat.hrat15,g_hrat.hrat16,g_hrat.hrat17,
#      g_hrat.hrat76,g_hrat.hrat18,g_hrat.hrat46,g_hrat.hrat45,g_hrat.hrat30,g_hrat.hrat24,g_hrat.hrat28,g_hrat.hrat29,g_hrat.hrat22,
#      g_hrat.hrat23,g_hrat.hrat34,g_hrat.hrat07,g_hrat.hrat09,g_hrat.hrat11,g_hrat.hratconf,g_hrat.hrat49,g_hrat.hrat50,g_hrat.hrat51,
#      g_hrat.hrat47,g_hrat.hrat48,g_hrat.hrat90,g_hrat.hrat36,g_hrat.hrat69,g_hrat.hrat44,g_hrat.hrat75,g_hrat.hrat73,g_hrat.hrat38,g_hrat.hrat39,
#      g_hrat.hrat37,g_hrat.hrat70,g_hrat.hrat52,g_hrat.hrat71,g_hrat.hrat67,g_hrat.hrat78,g_hrat.hrat79,g_hrat.hrat74,
#      g_hrat.hrat54,g_hrat.hrat53,g_hrat.hrat33,g_hrat.hrat55,g_hrat.hrat57,g_hrat.hrat56,g_hrat.hrat59,g_hrat.hrat60,g_hrat.hrat62,
#      g_hrat.hrat80,g_hrat.hrat81,g_hrat.hrat82,g_hrat.hrat83,g_hrat.hrat85,g_hrat.hrat86,
#      g_hrat.hrat61,g_hrat.hrat65,g_hrat.hratuser,g_hrat.hratgrup,g_hrat.hratoriu,g_hrat.hratorig,g_hrat.hratmodu,g_hrat.hratacti,
#      g_hrat.hratdate,g_hrat.hrat84,g_hrat.hrat87,g_hrat.hrat88
#      ,g_hrat.ta_hrat01,g_hrat.ta_hrat02,g_hrat.ta_hrat03    -- zhoumj 20160104 --
#   g_hrat.hratmodu,g_hrat.hratdate,g_hrat.hratacti

    CALL i006_s() #各个栏位显示带出值

    LET g_doc.column1 = "hratid"
    LET g_doc.value1 = g_hrat.hratid
    CALL cl_get_fld_doc("hrat32")

    #判断是否审核
    IF g_hrat.hratconf = 'Y' THEN
       LET g_chr2='Y'
    ELSE
       LET g_chr2='N'
    END IF
    CALL cl_set_field_pic(g_hrat.hratconf,g_chr2,"","","","")  #显示审核图片
    CALL cl_show_fld_cont()
END FUNCTION

#FUN-151202 wangjya
FUNCTION i006_s()
DEFINE l_hrag07    LIKE hrag_file.hrag07
DEFINE l_des       LIKE type_file.chr100
DEFINE l_hrat05    LIKE hrat_file.hrat05
DEFINE l_n         LIKE type_file.num5

   SELECT ROUND(months_between(TODAY,to_date(g_hrat.hrat25,'yyyy-mm-dd')),1) INTO l_n FROM dual 
   DISPLAY l_n to l_in_year

   CALL i006_hrat03(g_hrat.*) RETURNING l_des
   CALL i006_hrat04(g_hrat.*) RETURNING l_des
   CALL i006_hrat05(g_hrat.*) RETURNING l_des
   CALL i006_hrat06(g_hrat.*) RETURNING l_des
   CALL i006_hrat19(g_hrat.*) RETURNING l_des
   CALL i006_hrat40(g_hrat.*) RETURNING l_des
   CALL i006_hrat42(g_hrat.*) RETURNING l_des
   CALL i006_hrat52(g_hrat.*) RETURNING l_des
   #CALL i006_hrat87(g_hrat.*) RETURNING l_des
   #CALL i006_hrat88(g_hrat.*) RETURNING l_des
   CALL s_code('314',g_hrat.hrat12) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat12) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat12_name
   
   SELECT hrar04 INTO g_hrat05_name1 FROM hrar_file WHERE hrar03 = g_hrat.hrat60
   DISPLAY g_hrat05_name1 TO hrat05_name1
   
   

   CALL s_code('333',g_hrat.hrat17) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat17) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat17_name
   
   CALL s_code('204',g_hrat.hrat93) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat93) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat93_name

   CALL s_code('345',g_hrat.hrat91) RETURNING g_hrag.*  #FUN-151124 wangjya
   IF cl_null(g_hrat.hrat91) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat91_name                 #FUN-151124 wangjya

#   CALL s_code('346',g_hrat.hrat93) RETURNING g_hrag.*  #FUN-151201 wangjya
#   IF cl_null(g_hrat.hrat93) THEN
#      LET g_hrag.hrag07 = NULL
#   END IF
#   DISPLAY g_hrag.hrag07 TO hrat93_name                 #FUN-151201 wangjya

   CALL s_code('313',g_hrat.hrat20) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat20) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat20_name

   CALL s_code('340',g_hrat.hrat68) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat68) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat68_name

   
   CALL s_code('340',g_hrat.hrat97) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat97) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat97_name

   CALL s_code('337',g_hrat.hrat21) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat21) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat21_name

   CALL s_code('326',g_hrat.hrat66) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat66) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat66_name

   CALL s_code('317',g_hrat.hrat22) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat22) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat22_name

   CALL s_code('334',g_hrat.hrat24) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat24) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat24_name

   CALL s_code('302',g_hrat.hrat28) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat28) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat28_name

   CALL s_code('301',g_hrat.hrat29) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat29) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat29_name

   CALL s_code('321',g_hrat.hrat30) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat30) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat30_name

   CALL s_code('320',g_hrat.hrat34) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat34) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat34_name

   CALL s_code('325',g_hrat.hrat41) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat41) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat41_name

   CALL s_code('319',g_hrat.hrat43) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat43) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat43_name

   CALL s_code('341',g_hrat.hrat73) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat73) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat73_name

   CALL s_code('615',g_hrat.hrat86) RETURNING g_hrag.*
   IF cl_null(g_hrat.hrat86) THEN
      LET g_hrag.hrag07 = NULL
   END IF
   DISPLAY g_hrag.hrag07 TO hrat86_n

   LET g_doc.column1 = "hrat01"
   LET g_doc.value1 = g_hrat.hrat01
   CALL cl_get_fld_doc("hrat32")
   CALL cl_show_fld_cont()
 #  CALL cl_set_comp_comment("i006_w")
   SELECT hraqa03 INTO g_hraqa04 FROM hraqa_file WHERE hraqa06=g_hrat.hrat67
   DISPLAY g_hraqa04 TO hraqa04
   SELECT hraq02 INTO g_hrat78 FROM hraq_file WHERE hraq01=g_hrat.hrat78
   DISPLAY g_hrat78 TO hrat78_name
   SELECT hrag07 INTO g_hrat79 FROM hrag_file WHERE hrag01='206' AND hrag06=g_hrat.hrat79
   DISPLAY g_hrat79 TO hrat79_name

   CALL i006_hrat87(g_hrat.hrat87,'2') RETURNING g_errno,g_hrat87_name
   DISPLAY g_hrat87_name TO hrat87_name
   CALL i006_hrat88(g_hrat.hrat88,'3') RETURNING g_errno,g_hrat88_name
   DISPLAY g_hrat88_name TO hrat88_name

   #FUN-151113 wangjya
   CALL i006_hrat44('d') #FUN-151201 wangjya
   SELECT hrag07 INTO l_hrag07 FROM hrag_file
     WHERE hrag01='505' AND hrag06=g_hrat.hrat90
   IF NOT cl_null(g_hrat.hrat90) THEN
      DISPLAY l_hrag07 TO hrat90_name
   ELSE
      LET l_hrag07 = NULL
      DISPLAY l_hrag07 TO hrat90_name
   END IF
   #FUN-151113 wangjya

   LET g_hrat05_name = ''
   LET g_hrat05_name1=''
   IF NOT cl_null(g_hrat.hrat05) THEN
          SELECT hrap06 INTO g_hrat05_name
          FROM hrap_file
          WHERE hrap05=g_hrat.hrat05
          SELECT hras03 INTO g_hrar02
          FROM hras_file
          WHERE hras01=g_hrat.hrat05
          SELECT hrar04 INTO g_hrat05_name1
          FROM hrar_file
          WHERE hrar03=g_hrar02
          SELECT hras06 INTO g_hras06
          FROM hras_file
          WHERE hras01=g_hrat.hrat05
#          SELECT hrag07 INTO g_hrat.hrat64
#          FROM hrag_file
#          WHERE hrag01='205'
#            AND hrag06=g_hras06
    ELSE
    	LET g_hrat05_name = ''
      LET g_hrat05_name1=''
#      LET g_hrat.hrat64=''
   END IF
   DISPLAY g_hras06 TO hras06
   DISPLAY g_hrat05_name TO hrat05_name
   #DISPLAY g_hrat05_name1 TO hrat05_name1
   DISPLAY BY NAME g_hrat.hrat64

   #FUN-151202 wangjya
   #直接主管职务
   LET g_hrat06_name1=''
   IF NOT cl_null(g_hrat.hrat06) THEN
      SELECT hrat05 INTO l_hrat05 FROM hrat_file WHERE hrat01=g_hrat.hrat06
      SELECT hras03 INTO g_hrar02 FROM hras_file  WHERE hras01=l_hrat05
      SELECT hrar04 INTO g_hrat06_name1 FROM hrar_file WHERE hrar03=g_hrar02
      SELECT hras06 INTO g_hras06 FROM hras_file WHERE hras01=l_hrat05
   ELSE
      LET g_hrat06_name1 = NULL
   END IF
   DISPLAY g_hrat06_name1 TO hrat06_name1
   #FUN-151202 wangjya

    LET g_hrat75_name=''
    IF NOT cl_null(g_hrat.hrat75) THEN
       SELECT hrat02 INTO g_hrat75_name
         FROM hrat_file
        WHERE hrat01=g_hrat.hrat75
       ELSE
       LET  g_hrat75_name=''
    END IF
    DISPLAY g_hrat75_name TO hrat75_name     #显示招聘负责人姓名
    #--* zhoumj 20160105 --
    SELECT hrag07 INTO l_hrag07 FROM hrag_file
      WHERE hrag01='505' AND hrag06=g_hrat.hrat90
    DISPLAY l_hrag07 TO hrat90_name
    -- zhoumj 20160105 *--
END FUNCTION
#FUN-151202 wangjya

FUNCTION i006_u(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1
    IF g_hrat.hratid IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid=g_hrat.hratid
    IF g_hrat.hratacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    IF g_hrat.hratconf = 'Y' THEN
       CALL cl_err(g_hrat.hrat01,'aap-005',0)
       RETURN
    END IF
    CALL cl_opmsg('u')
    LET g_hrat01_t = g_hrat.hrat01
    BEGIN WORK

    OPEN i006_cl USING g_hrat.hratid
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 1)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_hrat.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_hrat.hratmodu=g_user                  #修改者
    LET g_hrat.hratdate = g_today               #修改日期
    CALL i006_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i006_i(p_cmd)                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_hrat.*=g_hrat_t.*
            CALL i006_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF

        UPDATE hrat_file SET hrat_file.* = g_hrat.*    # 更新DB
            #WHERE hrat01 = g_hrat.hrat01     #MOD-BB0113 mark
            WHERE hratid = g_hrat_t.hratid    #MOD-BB0113 add
        #add by zhuzw 20160111 start
        IF NOT cl_null(g_hrat.hrat13)  THEN
           UPDATE hratz_file  SET hratzud03 = 'Y'
            WHERE hratz06 = g_hrat.hrat13
        END IF
        #add by zhuzw 20160111 end
        #FUN-151209 wangjya
        SELECT to_char(systimestamp, 'hh24:mi:ss') INTO g_hrat.hrat84  FROM dual
        UPDATE hrat_file
           SET hrat84 = g_hrat.hrat84
         WHERE hratid = g_hrat_t.hratid
        DISPLAY g_hrat.hrat84 TO hrat84
        #FUN-151209 wangjya

        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","hrat_file",g_hrat.hrat01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        CALL i006_show()
        EXIT WHILE
    END WHILE
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION


FUNCTION i006_confirm(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_sr       STRING
DEFINE l_str      LIKE ze_file.ze01
DEFINE l_n,i,t    LIKE type_file.num5
DEFINE l_hraa10   LIKE hraa_file.hraa10
DEFINE l_hrbwud03 LIKE hrbw_file.hrbwud03
DEFINE l_hrat92   LIKE hrat_file.hrat92

DEFINE l_hrcb01   LIKE hrcb_file.hrcb01,
       l_hrcb02   LIKE hrcb_file.hrcb02,
       l_hrcb03   LIKE hrcb_file.hrcb03,
       l_hrcb04   LIKE hrcb_file.hrcb04

DEFINE l_hrdq      RECORD LIKE hrdq_file.*,
       l_hrdq01    LIKE hrdq_file.hrdq01,
       l_hrbk03    LIKE hrbk_file.hrbk03,
       l_hrbk04    LIKE hrbk_file.hrbk04,
       l_hrbk05    LIKE hrbk_file.hrbk05,
       l_hrbk05a   LIKE hrbk_file.hrbk05,
       l_hratid    LIKE hrat_file.hratid,
       l_hrdq04    LIKE hrdq_file.hrdq04,
       l_x         LIKE type_file.num5,
       l_n0        LIKE type_file.num5,
       l_n1        LIKE type_file.num5,
       l_n2        LIKE type_file.num5,
       l_n3        LIKE type_file.num5,
       l_n4        LIKE type_file.num5,
       l_n5        LIKE type_file.num5,
       l_n6        LIKE type_file.num5,
       l_n7        LIKE type_file.num5,
       l_n8        LIKE type_file.num5,
       l_n9        LIKE type_file.num5
#       ,
#       sr          RECORD
#                    hratid LIKE hrat_file.hratid,
#                    hrat25 LIKE hrat_file.hrat25,
#                    hrat03 LIKE hrat_file.hrat03,
#                    hrbk03 LIKE hrbk_file.hrbk03,
#                    hrbk04 LIKE hrbk_file.hrbk04,
#                    hrbk05 LIKE hrbk_file.hrbk05,
#                    hrbo02 LIKE hrbo_file.hrbo02,
#                    hrbo03 LIKE hrbo_file.hrbo03,
#                    hrbo16 LIKE hrbo_file.hrbo16
#                   END RECORD

    IF g_hrat.hratid IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    SELECT * INTO g_hrat.* FROM hrat_file
     WHERE hratid = g_hrat.hratid

    IF p_cmd = 'Y' THEN
       IF g_hrat.hratconf = 'Y' THEN
          CALL cl_err(g_hrat.hrat01,'axm1163',0)
          RETURN
       END IF
       #审核数据检查数据完整性
      IF g_hrat.hrat25 IS NULL THEN
         DISPLAY BY NAME g_hrat.hrat25
#         LET  l_sr = l_sr,"入司日期不能为空!\n"
          CALL cl_err('','ghr-921',0)
          RETURN
      END IF
      IF g_hrat.hrat19 IS NULL THEN
         DISPLAY BY NAME g_hrat.hrat19
#         LET  l_sr = l_sr,"员工状态不能为空!\n"
         CALL cl_err('','ghr-922',0)
         RETURN
      END IF
      IF g_hrat.hrat20 IS NULL THEN
         DISPLAY BY NAME g_hrat.hrat20
#         LET  l_sr = l_sr,"员工属性不能为空!\n"
          CALL cl_err('','ghr-924',0)
          RETURN
      END IF
#      IF g_hrat.hrat86 IS NULL THEN
#         DISPLAY BY NAME g_hrat.hrat86
#         LET  l_sr = l_sr,"参保类型不能为空!\n"
#          CALL cl_err('','ghr-925',0)
#      END IF
      IF g_hrat.hrat68 IS NULL THEN
         IF g_hrat.hrat86 = '002' OR g_hrat.hrat86 = '004' THEN
            DISPLAY BY NAME g_hrat.hrat68
#            LET  l_sr = l_sr,"社保缴交地不能为空!\n"
            CALL cl_err('','ghr-926',0)
            RETURN
         END IF
      END IF
      IF g_hrat.hrat03 IS NULL THEN
         DISPLAY BY NAME g_hrat.hrat03
#         LET  l_sr = l_sr,"所属公司不能为空!\n"
         CALL cl_err('','ghr-921',0)
         RETURN
      END IF
      IF g_hrat.hrat04 IS NULL THEN
         DISPLAY BY NAME g_hrat.hrat04
#         LET  l_sr = l_sr,"所属部门不能为空!\n"
         CALL cl_err('','ghr-928',0)
         RETURN
      END IF
      IF g_hrat.hrat05 IS NULL THEN
         DISPLAY BY NAME g_hrat.hrat05
#         LET  l_sr = l_sr,"担任职位不能为空!\n"
         CALL cl_err('','ghr-929',0)
         RETURN
      END IF
#       IF cl_null(g_hrat.hrat42) THEN
#         DISPLAY BY NAME g_hrat.hrat42
##           LET  l_sr = l_sr,'成本中心为空不能为空!\n'
#         CALL cl_err('','ghr-930',0)
#       END IF
      #明细校验
     # SELECT COUNT(hrbc02) INTO l_n FROM hrbc_file
     #  WHERE hrbc01 = g_hrat.hratid
     #    AND hrbc02 NOT IN (SELECT hrasd02 FROM hrasd_file WHERE hrasd01 = g_hrat.hrat05)
#      SELECT COUNT(hrasd02) INTO l_n FROM hrasd_file
#        LEFT JOIN hrbc_file ON hrbc01=g_hrat.hratid AND hrasd04=hrbc02
#      WHERE hrasd01=g_hrat.hrat05 AND hrbc01 IS NULL
#      IF l_n >0 THEN
#          LET  l_sr = l_sr,'所需证照不符合条件!\n'
#      END IF
      #add by zhuzw 20150318 end
#      SELECT COUNT(*) INTO l_n FROM hrath_file WHERE hrath01 = g_hrat.hratid
#      IF l_n = 0 THEN
#         LET  l_sr = l_sr,'紧急联系人不能为空!\n'
#      END IF
#      SELECT COUNT(*) INTO l_n FROM hratc_file WHERE hratc01 = g_hrat.hratid
#      IF l_n = 0 THEN
#         LET  l_sr = l_sr,'教育背景不能为空!\n'
#      END IF
#      IF g_hrat.hrat20='003' OR g_hrat.hrat20='004' OR g_hrat.hrat20='005' THEN
#         SELECT COUNT(*) INTO l_n FROM hrbf_file WHERE hrbf02 = g_hrat.hratid
#         IF l_n = 0 THEN
#            LET  l_sr = l_sr,'合同信息不能为空!\n'
#         END IF
#      END IF
#      IF NOT cl_null(l_sr) THEN
#         CALL cl_err(l_sr,'!',1)
#         RETURN
#      END IF

       IF g_hrat.hratacti = 'N' THEN
          CALL cl_err(g_hrat.hrat01,'alm-674',0)
          RETURN
       END IF
       #add by zhuzw 20140627 start
#       IF g_hrat.hrat09 = 'Y' THEN
#          SELECT hrap10 - hrap11 INTO l_n FROM hrap_file
#           WHERE hrap01 = g_hrat.hrat04
#             AND hrap05 = g_hrat.hrat05
#          IF l_n = 0 THEN
#             CALL cl_err(g_hrat.hrat05,'ghr-261',1)
#             RETURN
#          END IF
#       END IF
       #add by zhuzw 20140627 end
#       IF cl_null(g_hrat.hrat66) THEN
#          CALL cl_err('入司时间为空不能审核','!',0)
#          RETURN
#       END IF
#       IF cl_null(g_hrat.hrat42) THEN
#           CALL cl_err('','ghr-931',0)
#          RETURN
#       END IF
       LET l_str = 'aim-301'
    ELSE
       IF g_hrat.hratconf = 'N' THEN
          CALL cl_err(g_hrat.hrat01,'9025',0)
          RETURN
       END IF
       IF g_hrat.hratacti = 'N' THEN
          CALL cl_err(g_hrat.hrat01,'aec-027',0)
          RETURN
       END IF
       LET l_str = 'aim-302'
    END IF

    BEGIN WORK

    CALL i006_show()
    IF  cl_confirm(l_str) THEN

        UPDATE hrat_file
           SET hratconf=p_cmd
         WHERE hratid=g_hrat.hratid

        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
            ROLLBACK WORK
        #add by zhuzw 20140627 start
        ELSE
        
##add by nihuan 20160919 for guan li &zhuan ye ren yuan cha ru qun zu 3001-------start----------------
#          IF g_hrat.hrat20='001' OR g_hrat.hrat20='002' THEN 
#          IF p_cmd='Y' THEN 
#             SELECT hrcb01,hrcb02,hrcb03,MAX(hrcb04)+1 INTO l_hrcb01,l_hrcb02,l_hrcb03,l_hrcb04
#              FROM hrcb_file WHERE hrcb01='3001' group by hrcb01,hrcb02,hrcb03
#              SELECT COUNT(*) INTO l_n FROM hrcb_file WHERE hrcb01='3001' AND hrcb05=g_hrat.hratid
#              IF l_n=0 THEN 
#             INSERT INTO hrcb_file (hrcb01,hrcb02,hrcb03,hrcb04,hrcb05,hrcb06,hrcb07,hrcbacti,
#                                    hrcbuser,hrcbgrup,hrcbmodu,hrcbdate,hrcborig,hrcboriu) 
#                            VALUES (l_hrcb01,l_hrcb02,l_hrcb03,l_hrcb04,g_hrat.hratid,g_today,'2099/12/31','Y',
#                                    g_user,g_grup,g_user,g_today,g_grup,g_user)     
#              END IF                              
#          ELSE 
#          #mark by nihuan 201020 只加不删
#             #DELETE FROM hrcb_file WHERE hrcb01='3001' AND hrcb05=g_hrat.hratid
#          END IF 
#          END IF         
##add by nihuan 20160919 for guan li &zhuan ye ren yuan cha ru qun zu 3001-------end-------------------    
#            
          IF p_cmd = 'Y' THEN
#add by zhuzw 20151116 start
             SELECT COUNT(*) INTO l_n FROM hrbn_file #生成考勤
              WHERE hrbn01 = g_hrat.hratid
             IF  l_n = 0 AND NOT cl_null(g_hrat.hrat90) THEN
                 INSERT INTO hrbn_file(hrbn01,hrbn02,hrbn03,hrbn04,hrbn05,hrbn06)
                  VALUES(g_hrat.hratid,g_hrat.hrat90,g_today,g_hrat.hrat25,'2099/12/31','ghr-932')
             END IF
             IF  l_n = 1 AND NOT cl_null(g_hrat.hrat90) THEN
                 UPDATE hrbn_file SET hrbn04 = g_hrat.hrat25,hrbn02 = g_hrat.hrat90
                  WHERE hrbn01 = g_hrat.hratid
             END IF
             SELECT COUNT(*) INTO l_n FROM hrbw_file #生成卡片
              WHERE hrbw01 = g_hrat.hratid
             IF  l_n = 0  THEN
             	   LET l_hrbwud03 = g_hrat.hrat01
                 IF  NOT cl_null(g_hrat.hrat48) THEN
                    INSERT INTO hrbw_file(hrbw01,hrbw02,hrbw03,hrbw04,hrbw05,hrbw06,hrbwacti,hrbw08,hrbwud02,hrbwud03)
                    VALUES(g_hrat.hratid,g_hrat.hrat48,g_today,g_user,g_hrat.hrat25,'2099/12/31','Y','2','1',l_hrbwud03)
                 ELSE
                    INSERT INTO hrbw_file(hrbw01,hrbw02,hrbw03,hrbw04,hrbw05,hrbw06,hrbwacti,hrbw08,hrbwud02,hrbwud03)
                    VALUES(g_hrat.hratid,g_hrat.hrat01,g_today,g_user,g_hrat.hrat25,'2099/12/31','Y','2','1',l_hrbwud03)
                 END IF
             END IF
             IF  l_n = 1  THEN
                    IF  NOT cl_null(g_hrat.hrat48) THEN
                       UPDATE hrbw_file SET hrbw02= g_hrat.hrat48 , hrbw05 = g_hrat.hrat25
                        WHERE hrbw01 = g_hrat.hratid
                    ELSE
                       UPDATE hrbw_file SET hrbw02= g_hrat.hrat01 , hrbw05 = g_hrat.hrat25
                        WHERE hrbw01 = g_hrat.hratid
                    END IF
             END IF
#add by zhuzw 20151116 end
          #add by zhuzw 20150318 start
             IF  cl_null(g_hrat.hrat01) THEN
                 LET l_hraa10 = ''
                 SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01 = g_hrat.hrat03 AND hraaacti = 'Y'
                 LET g_flag = 'Y'
                 CALL hr_gen_no('hrat_file','hrat01','009',g_hrat.hrat03,l_hraa10) RETURNING g_hrat.hrat01,g_flag
                 select regexp_substr(' g_hrat.hrat01','[^0][0-9]*') into  g_hrat.hrat01 FROM DUAL

                 DISPLAY g_hrat.hrat01 TO hrat01
                 UPDATE hrat_file
                    SET hrat01=g_hrat.hrat01
                  WHERE hratid=g_hrat.hratid
#                 IF g_flag = 'Y' THEN
#                    CALL cl_set_comp_entry("hrat01",TRUE)
#                 ELSE
#                    CALL cl_set_comp_entry("hrat01",FALSE)
#                 END IF
             END IF
          #add by zhuzw 20150318 end
             IF g_hrat.hrat09 = 'Y' THEN
                UPDATE hrap_file
                   SET hrap11 = hrap11 +1 ,
                       hrap12 = hrap12 +1
                WHERE hrap01 = g_hrat.hrat04
                  AND hrap05 = g_hrat.hrat05
                UPDATE hrap_file
                   SET
                       hrap14 = hrap14 +1 ,
                       hrap15 = hrap15 +1
                WHERE hrap01 = g_hrat.hrat04
             ELSE
                UPDATE hrap_file
                   SET hrap12 = hrap12 +1
                WHERE hrap01 = g_hrat.hrat04
                  AND hrap05 = g_hrat.hrat05
                UPDATE hrap_file
                   SET
                       hrap15 = hrap15 +1
                WHERE hrap01 = g_hrat.hrat04
             END IF
          ELSE
             IF g_hrat.hrat09 = 'Y' THEN
                UPDATE hrap_file
                   SET hrap11 = hrap11 -1 ,
                       hrap12 = hrap12 -1
                WHERE hrap01 = g_hrat.hrat04
                  AND hrap05 = g_hrat.hrat05
                UPDATE hrap_file
                   SET
                       hrap14 = hrap14 -1 ,
                       hrap15 = hrap15 -1
                WHERE hrap01 = g_hrat.hrat04
             ELSE
                UPDATE hrap_file
                   SET hrap12 = hrap12 -1
                WHERE hrap01 = g_hrat.hrat04
                  AND hrap05 = g_hrat.hrat05
                UPDATE hrap_file
                   SET
                       hrap15 = hrap15 -1
                WHERE hrap01 = g_hrat.hrat04
             END IF
          END IF
        #add by zhuzw 20140627 end
        END IF

#        IF NOT cl_null(g_hrat.hrat90) THEN
#           CALL i006_p_get()
#           CALL i006_tongbu()
#        END IF
#        #
#        LET t = 0
#        LET l_n = 0
#        SELECT COUNT(*) INTO l_n FROM hrdq_file WHERE hrdq03=g_hrat.hratid
#        IF l_n > 0 THEN
##           CALL cl_err('ghri084','ghr-913',0)
#        ELSE
#           LET g_sql =" SELECT DISTINCT hratid,hrat25,hrat03,hrbk03,hrbk04,hrbk05,hrbo02,hrbo03,hrbo16",
#                      "   FROM hrat_file LEFT OUTER JOIN hrbk_file ON hrbk03>=hrat25 AND hrbk05 ='001' AND hrbk03<=hrat25+3 ",
#                      "                  LEFT OUTER JOIN hrbo_file ON hrbo01=hrat03 AND hrbo16='Y'",
#                      "  WHERE hrat03 = '",g_hrat.hrat03,"'",
#                      "    AND hratid = '",g_hrat.hratid,"'",
#                      "  ORDER BY hrbk03"
#
#           PREPARE i006_pt FROM g_sql
#           DECLARE i006_ct CURSOR FOR i006_pt
#           FOREACH i006_ct INTO sr.*
#              IF STATUS THEN
#                 CALL cl_err('foreach:',STATUS,1)
#                 EXIT FOREACH
#              END IF
#
#              IF sr.hrbo16 = 'Y' THEN
#                 SELECT MAX(hrdq01)+1 INTO l_hrdq01 FROM hrdq_file
#                 IF cl_null(l_hrdq01) THEN LET l_hrdq01=1 END IF
#                 LET l_hrdq.hrdq01=l_hrdq01 USING '&&&&&&&&&&'
#                 LET l_hrdq.hrdq02 = 1
#                 LET l_hrdq.hrdq03 = sr.hratid
#                 SELECT hrat02 INTO l_hrdq04 FROM hrat_file WHERE hratid=l_hrdq.hrdq03
#                 IF cl_null(l_hrdq04) THEN
#                    LET l_hrdq04 =' '
#                 ELSE
#                    LET l_hrdq.hrdq04 = l_hrdq04
#                 END IF
#                 LET l_hrdq.hrdq06 = sr.hrbo02
#                 LET l_hrdq.hrdq07 = sr.hrbo03
#                 LET l_hrdq.hrdq11 = sr.hrat03
#                 LET l_hrdq.hrdq05 = sr.hrbk03
#                 LET l_hrdq.hrdq12 = sr.hrbk05
#                 LET l_hrdq.hrdq13 = sr.hrbk04
#                 LET l_hrdq.hrdqoriu = g_user
#                 LET l_hrdq.hrdqorig = g_grup
#                 LET l_hrdq.hrdquser = g_user    #資料所有者
#                 LET l_hrdq.hrdqgrup = g_grup    #資料所有者所屬群
#                 LET l_hrdq.hrdqmodu = g_user    #資料修改日期
#                 LET l_hrdq.hrdqdate = g_today   #資料建立日期
#
#                 INSERT INTO hrdq_file VALUES(l_hrdq.*)
#                 IF SQLCA.sqlcode THEN
#                    CALL cl_err3("ins","hrdq_file",l_hrdq.hrdq01,"",SQLCA.sqlcode,"","",0)
#                    RETURN
#                 END IF
#              ELSE
#                  CALL cl_err('ghri033','ghr-912',0)
#                  EXIT FOREACH
#              END IF
#          END FOREACH
#        END IF

    END IF
    COMMIT WORK
    SELECT hratconf INTO g_hrat.hratconf FROM hrat_file
     WHERE hratid = g_hrat.hratid
     DISPLAY BY NAME g_hrat.hratconf
     #FUN-151202 wangjya
     IF g_hrat.hratconf = 'N' THEN
        UPDATE hrat_file SET hrat92 =''
         WHERE hratid = g_hrat.hratid
     ELSE
        SELECT COUNT(*) INTO l_n0 FROM hrat_file WHERE hrat92='0' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n1 FROM hrat_file WHERE hrat92='1' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n2 FROM hrat_file WHERE hrat92='2' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n3 FROM hrat_file WHERE hrat92='3' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n4 FROM hrat_file WHERE hrat92='4' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n5 FROM hrat_file WHERE hrat92='5' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n6 FROM hrat_file WHERE hrat92='6' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n7 FROM hrat_file WHERE hrat92='7' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n8 FROM hrat_file WHERE hrat92='8' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'
        SELECT COUNT(*) INTO l_n9 FROM hrat_file WHERE hrat92='9' AND hratconf = 'Y' AND hrat19 NOT LIKE '3%'

        LET l_x = l_n0
        IF l_x = l_n0 THEN LET l_hrat92 = 0 END IF
        IF l_x > l_n1 THEN LET l_hrat92 = 1 LET l_x = l_n1 END IF
        IF l_x > l_n2 THEN LET l_hrat92 = 2 LET l_x = l_n2 END IF
        IF l_x > l_n3 THEN LET l_hrat92 = 3 LET l_x = l_n3 END IF
        IF l_x > l_n4 THEN LET l_hrat92 = 4 LET l_x = l_n4 END IF
        IF l_x > l_n5 THEN LET l_hrat92 = 5 LET l_x = l_n5 END IF
        IF l_x > l_n6 THEN LET l_hrat92 = 6 LET l_x = l_n6 END IF
        IF l_x > l_n7 THEN LET l_hrat92 = 7 LET l_x = l_n7 END IF
        IF l_x > l_n8 THEN LET l_hrat92 = 8 LET l_x = l_n8 END IF
        IF l_x > l_n9 THEN LET l_hrat92 = 9 LET l_x = l_n9 END IF

        UPDATE hrat_file SET hrat92 = l_hrat92
         WHERE hratid = g_hrat.hratid
     END IF
     #FUN-151202 wangjya
END FUNCTION

FUNCTION i006_x()

    IF g_hrat.hratid IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = g_hrat.hratid
    IF g_hrat.hratconf = 'Y' THEN
       CALL cl_err(g_hrat.hrat01,'art-050',0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i006_cl USING g_hrat.hratid
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 1)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_hrat.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i006_show()
    IF cl_exp(0,0,g_hrat.hratacti) THEN
        LET g_chr = g_hrat.hratacti
        IF g_hrat.hratacti='Y' THEN
            LET g_hrat.hratacti='N'
        ELSE
            LET g_hrat.hratacti='Y'
        END IF
        UPDATE hrat_file
            SET hratacti=g_hrat.hratacti
            WHERE hratid=g_hrat.hratid
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
            LET g_hrat.hratacti = g_chr
        END IF
        DISPLAY BY NAME g_hrat.hratacti
    END IF
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION

FUNCTION i006_r()
DEFINE l_id   LIKE gca_file.gca01

    IF g_hrat.hratid IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = g_hrat.hratid
    IF g_hrat.hratconf = 'Y' THEN
       CALL cl_err(g_hrat.hrat01,'alm-028',0)
       RETURN
    END IF
    BEGIN WORK

    OPEN i006_cl USING g_hrat.hratid
    IF STATUS THEN
       CALL cl_err("OPEN i006_cl:", STATUS, 0)
       CLOSE i006_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i006_cl INTO g_hrat.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrat.hrat01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i006_show()
    IF cl_delete() THEN
       LET g_doc.column1 = "hrat01"
       LET g_doc.value1 = g_hrat.hrat01

       CALL cl_del_doc()
       DELETE FROM hrat_file WHERE hratid = g_hrat.hratid
       IF SQLCA.SQLCODE THEN
          CALL cl_err("del hrat_file:",SQLCA.SQLCODE,0)
          CLOSE i006_cl
          ROLLBACK WORK
          RETURN
       ELSE
          #add by zhuzw 20160111 start
          IF NOT cl_null(g_hrat.hrat13)  THEN
             UPDATE hratz_file  SET hratzud03 = 'N'
              WHERE hratz06 = g_hrat.hrat13
          END IF
          #add by zhuzw 20160111 end
       END IF
#add by yinbq 20150408 for 删除员工后,同时删除员工的照片信息
       LET l_id = 'hratid=',g_hrat.hratid
       DELETE FROM gcb_file WHERE gcb01=(SELECT gca07 FROM gca_file WHERE gca01=l_id)
       DELETE FROM gca_file WHERE gca01=l_id
#add by yinbq 20150408 for 删除员工后,同时删除员工的照片信息
       CLEAR FORM
       OPEN i006_count
       IF STATUS THEN
          CLOSE i006_cl
          CLOSE i006_count
          COMMIT WORK
          RETURN
       END IF
       FETCH i006_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i006_cl
          CLOSE i006_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt

       OPEN i006_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i006_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE                 #No.FUN-6A0066
          CALL i006_fetch('/')
       END IF
    END IF
    CLOSE i006_cl
    COMMIT WORK
END FUNCTION



FUNCTION i006_copy()

    DEFINE l_newno         LIKE hrat_file.hrat01
    DEFINE l_oldno         LIKE hrat_file.hrat01
    DEFINE p_cmd           LIKE type_file.chr1
    DEFINE l_hratid        LIKE hrat_file.hratid
    DEFINE l_hrat08        LIKE type_file.num10
    DEFINE l_hraa10        LIKE hraa_file.hraa10

    IF g_hrat.hratid IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT MAX(to_number(hratid)+1) INTO l_hratid FROM hrat_file
    IF cl_null(l_hratid) THEN
       LET l_hratid = 1
    END IF

    SELECT to_char(l_hratid,'fm0000000000') INTO l_hratid FROM DUAL

    SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = g_hrat.hratid
    SELECT hraa10 INTO  l_hraa10 FROM hraa_file WHERE hraa01=g_hrat.hrat03
    CALL hr_gen_no('hrat_file','hrat01','009',g_hrat.hrat03,l_hraa10) RETURNING g_hrat.hrat01,g_flag
    LET g_hrat.hratid = l_hratid
    LET g_hrat.hrat02='-'
    LET g_hrat.hrat13=''
    LET g_hrat.hrat14=''
    LET g_hrat.hrat35=''
    LET g_hrat.hrat15=''
    LET g_hrat.hrat17=''
    LET g_hrat.hrat76=''
    LET g_hrat.hrat18=''
    LET g_hrat.hrat46=''
    LET g_hrat.hrat45=''
    LET g_hrat.hrat30=''

    SELECT to_char(systimestamp, 'hh24:mi:ss') INTO g_hrat.hrat84  FROM dual #FUN-151209 wangjya
    DISPLAY g_hrat.hrat84 TO hrat84

    INSERT INTO hrat_file VALUES(g_hrat.*)
    CALL i006_u("u")
    DELETE FROM hrat_file WHERE hrat02='-'

#    LET g_before_input_done = FALSE
#    CALL i006_set_entry('a')
#    LET g_before_input_done = TRUE
#
#    INPUT l_newno FROM hrat01
#        BEFORE INPUT
#           #add by yougs130425 begin
#           IF NOT cl_null(g_hrat.hrat03) THEN
#              LET l_hraa10 = ''
#              SELECT hraa10 INTO l_hraa10 FROM hraa_file WHERE hraa01 = g_hrat.hrat03 AND hraaacti = 'Y'
#              LET g_flag = 'Y'
#              CALL hr_gen_no('hrat_file','hrat01','009',g_hrat.hrat03,l_hraa10) RETURNING l_newno,g_flag
#             select regexp_substr(' g_hrat.hrat01','[^0][0-9]*') into  g_hrat.hrat01 FROM DUAL
#            DISPLAY l_newno TO hrat01
#              IF g_flag = 'Y' THEN
#                 CALL cl_set_comp_entry("hrat01",TRUE)
#              ELSE
#                 CALL cl_set_comp_entry("hrat01",FALSE)
#              END IF
#           END IF
#           #add by yougs130425 end
#
#
#        AFTER FIELD hrat01
#           IF l_newno IS NOT NULL THEN
#              SELECT count(*) INTO g_cnt FROM hrat_file WHERE hrat01 = l_newno
#              IF g_cnt > 0 THEN
#                 CALL cl_err(l_newno,-239,0)
#                 NEXT FIELD hrat01
#              END IF
#           END IF
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#
#      ON ACTION about
#         CALL cl_about()
#
#      ON ACTION help
#         CALL cl_show_help()
#
#      ON ACTION controlg
#         CALL cl_cmdask()
#    END INPUT
#
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        DISPLAY BY NAME g_hrat.hrat01
#        RETURN
#    END IF
#    DROP TABLE x
#    SELECT * FROM hrat_file
#        WHERE hrat01=g_hrat.hrat01
#        INTO TEMP x
#    SELECT MAX(to_number(hratid)+1) INTO l_hratid FROM hrat_file
#    IF cl_null(l_hratid) THEN
#       LET l_hratid = 1
#    END IF
#    SELECT to_char(l_hratid,'fm0000000000') INTO l_hratid FROM DUAL
#    SELECT MAX(to_number(hrat08)+1) INTO l_hrat08 FROM hrat_file
#    IF cl_null(l_hrat08) THEN
#       LET l_hrat08 = 1
#    END IF
#    SELECT to_char(l_hrat08) INTO l_hrat08 FROM DUAL
#    UPDATE x
#        SET hrat01=l_newno,    #資料鍵值
#            hratacti='Y',      #資料有效碼
#            hratconf = 'N',
#            hratoriu = g_user,
#            hratorig = g_grup,
#            hratuser=g_user,   #資料所有者
#            hratgrup=g_grup,   #資料所有者所屬群
#            hratmodu=NULL,     #資料修改日期
#            hratdate=g_today,  #資料建立日期
#            hratid=l_hratid,
#            hrat08=l_hrat08,
#            hrat12='',
#            hrat13=''
#
#    INSERT INTO hrat_file SELECT * FROM x
#    IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","hrat_file",g_hrat.hrat01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660131
#    ELSE
#        MESSAGE 'ROW(',l_newno,') O.K'
#        LET l_oldno = g_hrat.hrat01
#        LET g_hrat.hrat01 = l_newno
#        SELECT hrat_file.* INTO g_hrat.* FROM hrat_file
#               WHERE hrat01 = l_newno
#        CALL i006_u('c')
#        SELECT hrat_file.* INTO g_hrat.* FROM hrat_file
#               WHERE hrat01 = l_oldno
#    END IF
#    LET g_hrat.hrat01 = l_oldno
    CALL i006_show()
END FUNCTION


 FUNCTION i006_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF p_cmd <> 'c' THEN
      CALL cl_set_comp_entry("hrat01",TRUE)
   END IF
#   #add by wangwy 20170210 <xiu gai shi yuan gong shu xing bu ke lu ru>
#   IF p_cmd = 'u' THEN
#      CALL cl_set_comp_entry("hrat20",FALSE)
#   ELSE
#      CALL cl_set_comp_entry("hrat20",TRUE)
#   END IF 
#   #add by wangwy 20170210 end
END FUNCTION


 FUNCTION i006_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
   #add by zhuzw 20150318 start
   #CALL cl_set_comp_entry("hrat01,hrat02,hrat12,hrat13,hrat14,hrat15,hrat17,hrat76,hrat18,hrat46,hrat45,hrat30,",FALSE) #add by zhuzw 20150317
   CALL cl_set_comp_entry("hrat01,hrat02,hrat12,hrat13,hrat14,hrat35,hrat15,hrat17,hrat76,hrat18,",FALSE) #add by zhuzw 20150317
   #add by zhuzw 20150318 end
   IF p_cmd = 'c' THEN
      CALL cl_set_comp_entry("hrat01",FALSE)
   END IF
END FUNCTION
#--->No:100823 begin <---shenran-----
#=================================================================#
# Function name...: i006_import()
# Descriptions...: 打开文件选择窗口允许用户打开本地TXT，EXCEL文件并
# ...............  导入数据到dateBase中
# Input parameter: p_argv1 文件类型 0-TXT 1-EXCEL
# RETURN code....: 'Y' FOR TRUE  : 数据操作成功
#                  'N' FOR FALSE : 数据操作失败
# Date & Author..: 131022 shenran
#=================================================================#
FUNCTION i006_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql,l_msg    STRING,
       l_data   VARCHAR(300),
       l_hrat08 LIKE hrat_file.hrat08,
       l_hratid LIKE hrat_file.hratid,
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD
          hrat03    LIKE hrat_file.hrat03,
          hrat04    LIKE hrat_file.hrat04,
          hrat05    LIKE hrat_file.hrat05,
          hrat01    LIKE hrat_file.hrat01,
          hrat02    LIKE hrat_file.hrat02,
          hrat06    LIKE hrat_file.hrat06,
          hrat07    LIKE hrat_file.hrat07,
          hrat09    LIKE hrat_file.hrat09,
          hrat10    LIKE hrat_file.hrat10,
          hrat11    LIKE hrat_file.hrat11,
          hrat12    LIKE hrat_file.hrat12,
          hrat13    LIKE hrat_file.hrat13,
          hrat76    LIKE hrat_file.hrat76,
          hrat14    LIKE hrat_file.hrat14,
          hrat15    LIKE hrat_file.hrat15,
          hrat17    LIKE hrat_file.hrat17,
          hrat18    LIKE hrat_file.hrat18,
          hrat19    LIKE hrat_file.hrat19,
          hrat20    LIKE hrat_file.hrat20,
          hrat21    LIKE hrat_file.hrat21,
          hrat22    LIKE hrat_file.hrat22,
          hrat23    LIKE hrat_file.hrat23,
          hrat24    LIKE hrat_file.hrat24,
          hrat25    LIKE hrat_file.hrat25,
          hrat68    LIKE hrat_file.hrat68,
          hrat26    LIKE hrat_file.hrat26,
          hrat27    LIKE hrat_file.hrat27,
          hrat28    LIKE hrat_file.hrat28,
          hrat29    LIKE hrat_file.hrat29,
          hrat30    LIKE hrat_file.hrat30,
          hrat33    LIKE hrat_file.hrat33,
          hrat34    LIKE hrat_file.hrat34,
          hrat35    LIKE hrat_file.hrat35,
          hrat36    LIKE hrat_file.hrat36,
          hrat37    LIKE hrat_file.hrat37,
          hrat38    LIKE hrat_file.hrat38,
          hrat39    LIKE hrat_file.hrat39,
          hrat40    LIKE hrat_file.hrat40,
          hrat41    LIKE hrat_file.hrat41,
          hrat42    LIKE hrat_file.hrat42,
          hrat43    LIKE hrat_file.hrat43,
          hrat45    LIKE hrat_file.hrat45,
          hrat46    LIKE hrat_file.hrat46,
          hrat47    LIKE hrat_file.hrat47,
          hrat48    LIKE hrat_file.hrat48,
          hrat90    LIKE hrat_file.hrat90,
          hrat49    LIKE hrat_file.hrat49,
          hrat50    LIKE hrat_file.hrat50,
          hrat51    LIKE hrat_file.hrat51,
          hrat52    LIKE hrat_file.hrat52,
          hrat53    LIKE hrat_file.hrat53,
          hrat54    LIKE hrat_file.hrat54,
          hrat59    LIKE hrat_file.hrat59,
          hrat16    LIKE hrat_file.hrat16,
          hrat55    LIKE hrat_file.hrat55,
          hrat56    LIKE hrat_file.hrat56,
          hrat91    LIKE hrat_file.hrat91,
          hrat86    LIKE hrat_file.hrat86,
          hrat97    LIKE hrat_file.hrat97,
          hrat74    LIKE hrat_file.hrat74,
          hrat77    LIKE hrat_file.hrat77,
          hrat60    LIKE hrat_file.hrat60,
          hrat62    LIKE hrat_file.hrat62,
          hrat61    LIKE hrat_file.hrat61,
          hrat65    LIKE hrat_file.hrat65,
          hrat64    LIKE hrat_file.hrat64,
          hrat66    LIKE hrat_file.hrat66,
          hrat87    LIKE hrat_file.hrat87,
          hrat88    LIKE hrat_file.hrat88,
          hrat89    LIKE hrat_file.hrat89,
          hrat94    LIKE hrat_file.hrat94,
          hrat95    LIKE hrat_file.hrat95,
          hrat96    LIKE hrat_file.hrat96,
          hrath02   LIKE hrath_file.hrath02,
          hrath03   LIKE hrath_file.hrath03,
          hrath04   LIKE hrath_file.hrath04,
          hratconf  LIKE hrat_file.hratconf         
          --* zhoumj 20160104 --
         #,ta_hrat01 LIKE hrat_file.hrat01,
         #ta_hrat02 LIKE hrat_file.hrat02,
         #ta_hrat03 LIKE hrat_file.hrat03
          -- zhoumj 21060104 *--

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
DEFINE l_hrat RECORD LIKE hrat_file.*
DEFINE l_hrag07 LIKE hrag_file.hrag07
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
                CALL cl_progress_bar(iRow)
                FOR i = 2 TO iRow
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[l_hrat.hrat03])     #公司编号 
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[l_hrat.hrat01])    #工号  
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[l_hrat.hrat02])    #姓名 
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[l_hrat.hrat17])    #性别编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[l_hrat.hrat28])    #国家地区
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[l_hrat.hrat29])    #民族
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[l_hrat.hrat04])     #部门编号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[l_hrat.hrat05])    #职位编号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',14).Value'],[l_hrat.hrat24])    #婚姻状况编号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',16).Value'],[l_hrat.hrat59])    #
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',17).Value'],[l_hrat.hrat22])    #学历编号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',19).Value'],[l_hrat.hrat23])    #学历编号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',20).Value'],[l_hrat.hrat34])    #学历编号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',21).Value'],[l_hrat.hrat95])    #学历编号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',22).Value'],[l_hrat.hrat49])    #手机号码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',23).Value'],[l_hrat.hrat47])    #手机号码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',24).Value'],[l_hrat.hrat94])    #手机号码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',25).Value'],[l_hrat.hrat96])    #手机号码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',26).Value'],[l_hrat.hrat25])    #入司日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',27).Value'],[l_hrat.hrat12])    #证件类型编号
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',29).Value'],[l_hrat.hrat50])    #入司日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',30).Value'],[l_hrat.hrat13])    #证件号码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',31).Value'],[l_hrat.hrat15])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',32).Value'],[l_hrat.hrat16])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',33).Value'],[l_hrat.hrat30])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',34).Value'],[l_hrat.hrat18])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',35).Value'],[l_hrat.hrat36])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',36).Value'],[l_hrat.hrat39])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',37).Value'],[l_hrat.hrat76])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',38).Value'],[l_hrat.hrat46])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',39).Value'],[l_hrat.hrat55])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',40).Value'],[l_hrat.hrat56])    #出生日期
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',41).Value'],[l_hrat.hrat20])    #员工属性编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',43).Value'],[l_hrat.hrat43])    #员工属性编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',44).Value'],[l_hrat.hrat19])    #员工状态编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',45).Value'],[l_hrat.hrat91])    #员工状态编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',46).Value'],[l_hrat.hrat86])    #员工状态编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',47).Value'],[l_hrat.hrat90])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',49).Value'],[l_hrat.hrat06])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',50).Value'],[l_hrat.hrat68])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',51).Value'],[l_hrat.hrat97])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',52).Value'],[l_hrat.hrat26])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',53).Value'],[l_hrat.hrat74])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',54).Value'],[l_hrat.hrat14])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',55).Value'],[l_hrat.hrat77])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',56).Value'],[l_hrat.hrat64])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',57).Value'],[l_hrat.hrat60])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',58).Value'],[l_hrat.hrat62])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',59).Value'],[l_hrat.hrat61])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',60).Value'],[l_hrat.hrat51])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',61).Value'],[l_hrat.hrat65])    #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',62).Value'],[l_hrat.hratconf])  #考勤类型
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',63).Value'],[l_hrat.hrat60])    #职务编码
                  CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',65).Value'],[l_hrat.hrat42])    #费用归属
                  

                IF NOT cl_null(l_hrat.hrat03) AND NOT cl_null(l_hrat.hrat04) AND NOT cl_null(l_hrat.hrat05) AND NOT cl_null(l_hrat.hrat01) AND NOT cl_null(l_hrat.hrat02) AND NOT cl_null(l_hrat.hrat25)
                   AND NOT cl_null(l_hrat.hrat22) AND NOT cl_null(l_hrat.hrat12) AND NOT cl_null(l_hrat.hrat13)  AND NOT cl_null(l_hrat.hrat17)
                   AND NOT cl_null(l_hrat.hrat19) AND NOT cl_null(l_hrat.hrat20) THEN
                   SELECT MAX(to_number(hrat08)+1) INTO l_hrat08 FROM hrat_file
                   IF cl_null(l_hrat08) THEN
                      LET l_hrat08 = 1
                   END IF
                   SELECT to_char(l_hrat08) INTO l_hrat08 FROM DUAL
                   SELECT MAX(to_number(hratid)+1) INTO l_hratid FROM hrat_file
                   IF cl_null(l_hratid) THEN
                      LET l_hratid = 1
                   END IF
               #    LET l_hrat.hratconf = 'N'
                   SELECT to_char(l_hratid,'fm0000000000') INTO l_hratid FROM DUAL
                   LET l_hrat.hrat77='2099/12/31'
                   SELECT hras06 INTO l_hrat.hrat64 FROM hras_file WHERE hras01=l_hrat.hrat05
                   CALL i006_logic_chk_hrat13(l_hrat.*,'') RETURNING l_hrat.*,l_hrag07
                   LET l_n = 0
{
                   SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat13 = l_hrat.hrat13
                   IF l_n >0 THEN 
                      LET l_msg = ''
                      LET l_msg = l_hrat.hrat02,l_hrat.hrat13,'身份证号码重复，请检查'
                       CALL  cl_err(l_msg,'!',1) 
                   END  IF
} #导入暂屏蔽身份证重  
                    LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat02 = l_hrat.hrat02 AND ( hrat77 >= g_today - 60 OR hrat77 = '2099/12/31')
                   IF l_n >0 THEN 
                       LET l_msg = ''
                       LET l_msg = l_hrat.hrat02,l_hrat.hrat13,'姓名重复，请检查'
                       CALL  cl_err(l_msg,'!',1) 
                   END  IF  
                   sELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01 = l_hrat.hrat01                  
                   IF l_n >0 THEN 
                       LET l_msg = ''
                       LET l_msg = l_hrat.hrat01,l_hrat.hrat02,'工号重复，请检查'
                       CALL  cl_err(l_msg,'!',1) 
                   END  IF
                   SELECT hrar06 INTO l_hrat.hrat93 FROM hrar_file WHERE hrar03 = l_hrat.hrat60
                   IF i > 1 THEN
 
                     
                    INSERT INTO hrat_file(hratid,hrat03,hrat04,hrat05,hrat01,hrat02,
                                          hrat06,hrat07,hrat08,hrat09,hrat10,hrat11,
                                          hrat12,hrat13,hrat76,hrat14,hrat15,hrat17,
                                          hrat18,hrat19,hrat20,hrat21,hrat22,hrat23,
                                          hrat24,hrat25,hrat68,hrat26,hrat27,hrat28,
                                          hrat29,hrat30,hrat33,hrat34,hrat35,hrat36,
                                          hrat37,hrat38,hrat39,hrat40,hrat41,hrat42,
                                          hrat43,hrat45,hrat46,hrat47,hrat48,hrat90,
                                          hrat49,hrat50,hrat51,hrat52,hrat53,hrat54,
                                          hrat66,hrat87,hrat88,hrat89,hrat94,hrat95,
                                          hrat96,hrat64,hratacti,hratuser,hratgrup,
                                          hratdate,hratorig,hratoriu,hrat60,hrat93,hratconf,hrat16)
                      VALUES (l_hratid,l_hrat.hrat03,l_hrat.hrat04,l_hrat.hrat05,l_hrat.hrat01,l_hrat.hrat02,
                              l_hrat.hrat06,'N',l_hrat08,l_hrat.hrat09,l_hrat.hrat10,l_hrat.hrat11,
                              l_hrat.hrat12,l_hrat.hrat13,l_hrat.hrat76,l_hrat.hrat14,l_hrat.hrat15,l_hrat.hrat17,
                              l_hrat.hrat18,l_hrat.hrat19,l_hrat.hrat20,l_hrat.hrat21,l_hrat.hrat22,l_hrat.hrat23,
                              l_hrat.hrat24,l_hrat.hrat25,l_hrat.hrat68,l_hrat.hrat26,l_hrat.hrat27,l_hrat.hrat28,
                              l_hrat.hrat29,l_hrat.hrat30,l_hrat.hrat33,l_hrat.hrat34,l_hrat.hrat35,l_hrat.hrat36,
                              l_hrat.hrat37,l_hrat.hrat38,l_hrat.hrat39,l_hrat.hrat40,l_hrat.hrat41,l_hrat.hrat42,
                              l_hrat.hrat43,l_hrat.hrat45,l_hrat.hrat46,l_hrat.hrat47,l_hrat.hrat48,l_hrat.hrat90,
                              l_hrat.hrat49,l_hrat.hrat50,l_hrat.hrat51,l_hrat.hrat52,l_hrat.hrat53,l_hrat.hrat54,
                              l_hrat.hrat66,l_hrat.hrat87,l_hrat.hrat88,l_hrat.hrat89,l_hrat.hrat94,l_hrat.hrat95,
                              l_hrat.hrat96,l_hrat.hrat64,'Y',g_user,g_grup,
                              g_today,g_grup,g_user,l_hrat.hrat60,l_hrat.hrat93,l_hrat.hratconf,l_hrat.hrat16)
                              

                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("ins","hrat_file",l_hrat.hrat01,'',SQLCA.sqlcode,"","",1)
                       LET g_success  = 'N'
                       CONTINUE FOR
                    END IF
                   END IF
                   CALL cl_progressing(l_hrat.hrat02)
                END IF
                END FOR
                CALL cl_close_progress_bar()
                IF g_success = 'N' THEN
                   ROLLBACK WORK
                   CALL s_showmsg()
                ELSE IF g_success = 'Y' THEN
                        COMMIT WORK
                        CALL cl_err( '','ghr-933', 1 )
                     END IF
                END IF
            END IF
          ELSE
              DISPLAY 'NO FILE'
          END IF
       ELSE
           DISPLAY 'NO EXCEL'
       END IF
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes])

       SELECT * INTO g_hrat.* FROM hrat_file
       WHERE hratid=l_hratid

       CALL i006_show()
   END IF

END FUNCTION

FUNCTION i0221_assign()
   DEFINE l_hrbf08    LIKE  hrbf_file.hrbf08
   DEFINE l_hrbe02    LIKE hrbe_file.hrbe02
   DEFINE l_hrag07    LIKE hrag_file.hrag07
   IF cl_null(g_hrat.hratid) THEN
      RETURN
   END IF

   SELECT MAX(hrbf09) INTO l_hrbf08 FROM hrbf_file where hrbf02=g_hrat.hratid
   IF cl_null(l_hrbf08) THEN
      LET g_hrbf.hrbf03 = '1'
      LET g_hrbf.hrbf08 = g_hrat.hrat25
      LET g_hrbf.hrbf05 = '2'    #三年
      SELECT trunc(add_months(g_hrat.hrat25,36)) into g_hrbf.hrbf09 FROM dual
      DISPLAY g_hrbf.hrbf08 TO hrbf08
      DISPLAY g_hrbf.hrbf09 TO hrbf09
      DISPLAY g_hrbf.hrbf05 TO hrbf05
   ELSE
      LET g_hrbf.hrbf03 = '2'
      LET g_hrbf.hrbf04 = '2'    #三年
      SELECT l_hrbf08 + 1 into g_hrbf.hrbf08 FROM dual
      SELECT trunc(add_months(g_hrbf.hrbf08,36)) INTO g_hrbf.hrbf09 FROM dual
      DISPLAY g_hrbf.hrbf08 TO hrbf08
      DISPLAY g_hrbf.hrbf09 TO hrbf09
      DISPLAY g_hrbf.hrbf05 TO hrbf05
   END IF


   OPEN WINDOW i0221_w1 WITH FORM "ghr/42f/ghri0221"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()
   LET g_hrbf.hrbf02 = g_hrat.hratid
#   LET g_hrbf.hrbf05 = 'N'
   LET g_hrbf.hrbf07 = 'N'
   LET g_hrbf.hrbf10 = g_today
   LET g_hrbf.hrbfacti = 'Y'
   LET g_hrbf.hrbfuser = g_user
   LET g_hrbf.hrbfgrup = g_grup
   LET g_hrbf.hrbfmodu = g_user
   LET g_hrbf.hrbfdate = g_today
   LET g_hrbf.hrbforiu = g_user
   LET g_hrbf.hrbforig = g_grup
   WHILE TRUE
      DISPLAY BY NAME g_hrbf.hrbf03,g_hrbf.hrbf04,g_hrbf.hrbf05,
                    g_hrbf.hrbf08,g_hrbf.hrbf09,g_hrbf.hrbf10,
                    g_hrbf.hrbf11,g_hrbf.hrbf07,g_hrbf.hrbf12

      INPUT BY NAME g_hrbf.hrbf03,g_hrbf.hrbf04,g_hrbf.hrbf05,
                    g_hrbf.hrbf08,g_hrbf.hrbf09,g_hrbf.hrbf10,
                    g_hrbf.hrbf11,g_hrbf.hrbf07,g_hrbf.hrbf12
                    WITHOUT DEFAULTS
         BEFORE INPUT
        call cl_set_comp_entry("hrbf03",true)
            ON ACTION controlp
               CASE
                  WHEN INFIELD(hrbf04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_hrbe01"
                     LET g_qryparam.construct='N'
                     CALL cl_create_qry() RETURNING g_hrbf.hrbf04
                     DISPLAY g_hrbf.hrbf04 TO hrbf04
                     NEXT FIELD hrbf04
                  WHEN INFIELD(hrbf11)
                     CALL cl_init_qry_var()
                     LET g_qryparam.arg1 = '339'
                     LET g_qryparam.form ="q_hrag06"
                     LET g_qryparam.construct='N'
                     CALL cl_create_qry() RETURNING g_hrbf.hrbf11
                     DISPLAY g_hrbf.hrbf11 TO hrbf11
                     NEXT FIELD hrbf11
               END CASE
            AFTER FIELD hrbf04
               IF NOT cl_null(g_hrbf.hrbf04) THEN
                  SELECT hrbe02 INTO l_hrbe02 FROM hrbe_file
                     WHERE hrbe01=g_hrbf.hrbf04
                  DISPLAY l_hrbe02 TO hrbf04_name
               END IF
            AFTER FIELD hrbf05
#               IF g_hrbf.hrbf05 = 'Y' THEN
               IF g_hrbf.hrbf05 = '4' THEN
                  LET g_hrbf.hrbf09 = '9999-12-31'
                  DISPLAY BY NAME g_hrbf.hrbf09
                  CALL cl_set_comp_required("hrbf09",FALSE)
                  CALL cl_set_comp_entry("hrbf09",FALSE)
               ELSE
                  SELECT trunc(add_months(g_hrat.hrat25,36)) INTO g_hrbf.hrbf09 FROM dual
                  DISPLAY BY NAME g_hrbf.hrbf09
                  CALL cl_set_comp_required("hrbf09",TRUE)
                  CALL cl_set_comp_entry("hrbf09",TRUE)
               END IF

            AFTER FIELD hrbf08
               IF NOT cl_null(g_hrbf.hrbf08) AND cl_null(g_hrbf.hrbf09) THEN
                  SELECT trunc(add_months(g_hrat.hrat25,36)) into g_hrbf.hrbf09 FROM dual
                  DISPLAY BY NAME g_hrbf.hrbf09
               END IF

            AFTER FIELD hrbf11
               IF NOT cl_null(g_hrbf.hrbf11) THEN
                  select hrag07 into l_hrag07 from hrag_file
                     where hrag01='339' and hrag06=g_hrbf.hrbf11
                  DISPLAY l_hrag07 TO hrbf11_name
               END IF

            ON ACTION locale
               CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               LET g_action_choice = "locale"
               EXIT INPUT

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT

            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121

            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121

            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121

            ON ACTION exit
               LET INT_FLAG = 1

            #ON ACTION accept
            #EXIT INPUT
            IF g_action_choice = "locale" THEN
               LET g_action_choice = ""
               CALL cl_dynamic_locale()
               CONTINUE WHILE
            END IF
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               CLOSE WINDOW i0221_w1
               RETURN
            END IF
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW i0221_w1
            RETURN
         END IF
      EXIT WHILE
   END WHILE
   IF g_hrbf.hrbf08 > g_hrbf.hrbf09 THEN
      CALL cl_err('',-9913,0)
      LET INT_FLAG = 0
      #CONTINUE WHILE
   ELSE
      SELECT TO_CHAR(MAX(to_number(hrbf01))+1,'fm0000000000') INTO g_hrbf.hrbf01 FROM hrbf_file
      IF cl_null(g_hrbf.hrbf01) THEN LET g_hrbf.hrbf01 = '0000000001' END IF
      INSERT INTO hrbf_file VALUES(g_hrbf.*)
   END IF
   CLOSE WINDOW i0221_w1
END FUNCTION

FUNCTION i006_read()
        DEFINE ls_str STRING
        DEFINE li_status    SMALLINT
        DEFINE ls_cmd       STRING
        LET ls_cmd="\"D:\\Integration\\CVR100A_U_DSDK.exe\""
        CALL ui.Interface.frontCall( "standard", "shellexec", [ls_cmd], [li_status])
END FUNCTION


FUNCTION i006_write()
   DEFINE gr_gca        RECORD LIKE gca_file.*
   DEFINE gr_gca07      LIKE gca_file.gca07
   DEFINE gr_gcb        RECORD LIKE gcb_file.*
   DEFINE ls_str,ls_str1,ls_str2,ls_str3,ls_str4,ls_str5,ls_str6,ls_str7 LIKE type_file.chr1000
   DEFINE li_status     SMALLINT
   DEFINE ls_location,ls_fname   STRING
   DEFINE ls_sql,gs_mode,ls_time STRING
   DEFINE l_n           LIKE type_file.num5
   DEFINE ls_file          STRING
   DEFINE ls_loc           STRING
   DEFINE l_channel        base.Channel
   DEFINE l_s              LIKE type_file.chr1000
   DEFINE day_now          DATETIME YEAR TO DAY
   DEFINE time_now         DATETIME HOUR TO FRACTION(5)

   IF NOT cl_null(g_hrat.hratid) THEN  #员工工号不为空时处理

      CALL ui.interface.frontCall('standard','cbget',[],[ls_str]) #获取剪切板中的身份证件信息
      SELECT substr(ls_str,1,INSTR(ls_str,'@',1,1)-1),
               substr(ls_str,INSTR(ls_str,'@',1,1)+1,INSTR(ls_str,'@',1,2)-INSTR(ls_str,'@',1,1)-1),
               substr(ls_str,INSTR(ls_str,'@',1,2)+1,INSTR(ls_str,'@',1,3)-INSTR(ls_str,'@',1,2)-1),
               substr(ls_str,INSTR(ls_str,'@',1,3)+1,INSTR(ls_str,'@',1,4)-INSTR(ls_str,'@',1,3)-1),
               substr(ls_str,INSTR(ls_str,'@',1,4)+1,INSTR(ls_str,'@',1,5)-INSTR(ls_str,'@',1,4)-1),
               substr(ls_str,INSTR(ls_str,'@',1,5)+1,INSTR(ls_str,'@',1,6)-INSTR(ls_str,'@',1,5)-1),
               substr(ls_str,INSTR(ls_str,'@',1,6)+1,INSTR(ls_str,'@',1,7)-INSTR(ls_str,'@',1,6)-1)
         INTO ls_str1,ls_str2,ls_str3,ls_str4,ls_str5,ls_str6,ls_str7
      FROM dual
      SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hratid <> g_hrat.hratid AND hrat13=ls_str6
      IF l_n > 0 THEN
         CALL cl_err(g_hrat.hrat01,'ghr-934',1)
         RETURN
      END IF
      #处理身份证生效日期
      SELECT to_date(substr(ls_str7,1,10),'yyyy.mm.dd') into g_hrat.hrat35 FROM dual
      DISPLAY g_hrat.hrat35 TO hrat35

      #处理身份证失效日期
      SELECT to_date(substr(ls_str7,12,10),'yyyy.mm.dd') into g_hrat.hrat14 FROM dual
      IF g_hrat.hrat14 < g_today THEN
         CALL cl_err( g_hrat.hrat01,'ghr-935',1)
      END IF

      SELECT YEAR(g_hrat.hrat14)-YEAR(g_hrat.hrat35) INTO g_hrat.hrat89 FROM dual
      DISPLAY g_hrat.hrat89 TO hrat89
      DISPLAY g_hrat.hrat14 TO hrat14
      #处理身份证姓名信息
      LET g_hrat.hrat02=ls_str1
      DISPLAY g_hrat.hrat02 TO hrat02
      #处理身份证性别信息
      SELECT hrag06 into g_hrat.hrat17 FROM hrag_file WHERE  hragacti='Y' and  hrag01 =333 AND hrag07=ls_str2
      DISPLAY g_hrat.hrat17 TO hrat17
      DISPLAY ls_str2 TO hrat17_name
      #处理身份证民族信息
      SELECT hrag06 into g_hrat.hrat29 FROM hrag_file WHERE  hragacti='Y' and  hrag01 =301 AND hrag07=ls_str3||'族'
      DISPLAY g_hrat.hrat29 TO hrat29
      DISPLAY ls_str3||'族' TO hrat29_name
      #处理身份证出生日期信息
      SELECT to_date(ls_str4,'yyyy-mm-dd') into g_hrat.hrat15 FROM dual
      DISPLAY g_hrat.hrat15 TO hrat15
      #处理阴历出生日期信息
      SELECT f_GetLunar(g_hrat.hrat15) into g_hrat.hrat10 FROM dual
      DISPLAY g_hrat.hrat10 TO hrat10
      #处理身份证年龄信息
      SELECT YEAR(SYSDATE)-YEAR(g_hrat.hrat15) into g_hrat.hrat16 FROM dual
      DISPLAY g_hrat.hrat16 TO hrat16
      #处理身份证地址信息
      LET g_hrat.hrat76=ls_str5
      DISPLAY g_hrat.hrat76 TO hrat76
      #处理步履步户口所在地信息
      LET g_hrat.hrat45=ls_str5
      DISPLAY g_hrat.hrat45 TO hrat45
      #处理身份证号码信息
      LET g_hrat.hrat13=ls_str6
      DISPLAY g_hrat.hrat13 TO hrat13
      #处理国家&地区信息
      SELECT hrag07 into g_hrat.hrat28 FROM hrag_file WHERE hrag06='CN' AND  hragacti='Y' AND hrag01='302'
      DISPLAY g_hrat.hrat28 TO hrat28_name
      LET g_hrat.hrat28='CN'
      DISPLAY g_hrat.hrat28 TO hrat28
      #处理证件类型信息
      SELECT hrag07 into g_hrat.hrat12 FROM hrag_file WHERE hrag06='001' AND  hragacti='Y' AND hrag01='314'
      DISPLAY g_hrat.hrat12 TO hrat12_name
      LET g_hrat.hrat12='001'
      DISPLAY g_hrat.hrat12 TO hrat12
      #处理籍贯信息
      SELECT hraj02 into g_hrat.hrat18 FROM hraj_file WHERE hraj01=substr(ls_str6,1,6)
      DISPLAY g_hrat.hrat18 TO hrat18
      #初始化缓存表gca_file
      LET ls_sql = "SELECT gca_file.* FROM gca_file WHERE ",
                     " gca01 = 'hratid=", g_hrat.hratid,"'",
                     " AND gca08 = 'FLD'",
                     " AND gca09 = 'hrat32'",
                     " AND gca11 = 'Y'"
      PREPARE fld_doc_pre FROM ls_sql
      EXECUTE fld_doc_pre INTO gr_gca.*
      CASE SQLCA.SQLCODE
         WHEN 0
            LET gs_mode = "modify"
         WHEN NOTFOUND
            LET gs_mode = "insert"
            INITIALIZE gr_gca.* TO NULL
            INITIALIZE gr_gcb.* TO NULL
         OTHERWISE
            CALL cl_err(" ",'ghr-936',0)
      END CASE
      #处理身份证件照片信息
      LET ls_time=TIME
      LET ls_location="D:\\Integration\\zp.bmp"
      IF cl_null(gr_gca.gca07) THEN
         LET gr_gca07="FLD-",FGL_GETPID() USING "<<<<<<<<<<", "-",TODAY USING "YYYYMMDD", "-",ls_time.subString(1,2), ls_time.subString(4,5), ls_time.subString(7,8)
      ELSE
         LET gr_gca07=gr_gca.gca07
      END IF
      LET ls_fname="/u1/out/",gr_gca07
      #上传照片
      IF NOT cl_upload_file(ls_location, ls_fname) THEN
         CALL cl_err(" ", "ghr-937", 1)
         RETURN
      END IF
      #回写数据
      IF gs_mode = "modify" THEN
         LOCATE gr_gcb.gcb09 IN MEMORY
         SELECT gcb_file.* INTO gr_gcb.* FROM gcb_file
         WHERE gcb01 = gr_gca.gca07 AND gcb02 = gr_gca.gca08 AND gcb03 = gr_gca.gca09 AND gcb04 = gr_gca.gca10
         FREE gr_gcb.gcb09
         LOCATE gr_gcb.gcb09 IN FILE ls_fname
         LET gr_gcb.gcb07 = "zp.bmp"
         LET gr_gcb.gcb08 = "D"
         LET gr_gcb.gcb10 = ls_location
         LET gr_gca.gca15 = gr_gcb.gcb16 := g_user CLIPPED
         LET gr_gca.gca16 = gr_gcb.gcb17 := g_grup CLIPPED
         LET gr_gca.gca17 = gr_gcb.gcb18 := g_today CLIPPED

         LET ls_sql = "UPDATE gca_file",
                        "   SET gca15 = '", gr_gca.gca15 CLIPPED, "',",
                        "       gca16 = '", gr_gca.gca16 CLIPPED, "',",
                        "       gca17 = '", gr_gca.gca17 CLIPPED, "'",
                        " WHERE gca01='hratid=", g_hrat.hratid,"' AND ",
                        "       gca06 = ", gr_gca.gca06
         EXECUTE IMMEDIATE ls_sql

         UPDATE gcb_file
            SET gcb07 = gr_gcb.gcb07,
                  gcb08 = gr_gcb.gcb08,
                  gcb09 = gr_gcb.gcb09,
                  gcb10 = gr_gcb.gcb10,
                  gcb16 = gr_gcb.gcb16,
                  gcb17 = gr_gcb.gcb17,
                  gcb18 = gr_gcb.gcb18
         WHERE gcb01 = gr_gcb.gcb01 AND
               gcb02 = gr_gcb.gcb02 AND
               gcb03 = gr_gcb.gcb03 AND
               gcb04 = gr_gcb.gcb04
      ELSE
         LET gr_gca.gca01 = "hratid=",g_hrat.hratid
         LET gr_gca.gca02 = ' '
         LET gr_gca.gca03 = ' '
         LET gr_gca.gca04 = ' '
         LET gr_gca.gca05 = ' '
         LET gr_gca.gca06 = -1
         LET gr_gca.gca07 = gr_gcb.gcb01 := gr_gca07
         LET gr_gca.gca08 = gr_gcb.gcb02 := "FLD"
         LET gr_gca.gca09 = gr_gcb.gcb03 := "hrat32"
         LET gr_gca.gca10 = gr_gcb.gcb04 := "001"
         LET gr_gca.gca11 = 'Y'
         LET gr_gca.gca12 = gr_gcb.gcb13 := g_user CLIPPED
         LET gr_gca.gca13 = gr_gcb.gcb14 := g_grup CLIPPED
         LET gr_gca.gca14 = gr_gcb.gcb15 := g_today CLIPPED

         LOCATE gr_gcb.gcb09 IN FILE ls_fname
         LET gr_gcb.gcb07 = "zp.bmp"
         LET gr_gcb.gcb08 = "D"
         LET gr_gcb.gcb10 = ls_location
         LET gr_gcb.gcb11 = "O"
         LET gr_gcb.gcb12 = "U"

         INSERT INTO gca_file VALUES (gr_gca.*)
         INSERT INTO gcb_file VALUES (gr_gcb.*)
      END IF
      #照片显示
      LET g_doc.column1 = "hratid"
      LET g_doc.value1 = g_hrat.hratid
      CALL cl_get_fld_doc("hrat32")
      CALL cl_show_fld_cont()
   ELSE
      CALL cl_err('','ghr-938',1)
   END IF
END FUNCTION

#FUN-151113 wangjya
FUNCTION i006_p_get()
   INSERT INTO hrbn_file (hrbn01,hrbn02,hrbn03,hrbn04,hrbn05,hrbnuser,hrbndate,hrbnorig,hrbnoriu)
   SELECT hratid,CASE WHEN hrar03 IN ('0001','003','004','028','031','046') THEN '002' ELSE '003' END,trunc(SYSDATE),hrat25,NVL(hrat77,to_date('20991231','yyyymmdd')),'tiptop',trunc(SYSDATE),hrat04,'tiptop'
   FROM hrat_file
   LEFT JOIN hras_file ON hras01=hrat05
   LEFT JOIN hrar_file ON hrar03=hras03
   WHERE NOT EXISTS(SELECT 1 FROM hrbn_file WHERE hrbn01=hratid)
   UPDATE hrcp_file SET hrcp35='N' WHERE EXISTS(SELECT 1 FROM hrbn_file where hrbn03=TRUNC(SYSDATE) AND hrbn01=hrcp02) AND hrcp03 >= TRUNC(SYSDATE)
END FUNCTION

FUNCTION i006_tongbu()
DEFINE l_hrbt04  LIKE hrbt_file.hrbt04
DEFINE l_sql     STRING
DEFINE l_hrbw01  LIKE hrbw_file.hrbw01
DEFINE l_hrbw02  LIKE hrbw_file.hrbw02
DEFINE l_hrbw05  LIKE hrbw_file.hrbw05
DEFINE l_hrbw06  LIKE hrbw_file.hrbw06
DEFINE l_hrat48  LIKE hrbw_file.hrbw02
DEFINE l_hrbwud03  LIKE hrbw_file.hrbwud03
DEFINE g_flay    LIKE type_file.chr1

    LET g_flay='Y'
	 SELECT  hrbt04 INTO l_hrbt04 FROM hrbt_file
	 IF l_hrbt04 = 'Y' THEN
   	 BEGIN WORK
   	 LET l_hrbw01=''
   	 LET l_hrbw02=''
   	 LET l_hrbw05=''
   	 LET l_hrbw06=''
   	 LET l_sql= " SELECT HRATID, HRAT01, HRAT25, HRAT77,case when hrat03='SH002' then '9'||LPAD(hrat01,6,'0') else hrat01 end,NVL(hrat48,hrat01)
                     FROM HRAT_FILE
                    WHERE HRATID NOT IN (SELECT HRBW01 FROM HRBW_FILE WHERE HRBWACTI = 'Y')
                     /*AND HRATCONF = 'Y'*/
                   ORDER BY HRATID "

         PREPARE i006_sr_tb FROM l_sql
         DECLARE hrbw_tb_curs CURSOR FOR i006_sr_tb
         FOREACH hrbw_tb_curs INTO l_hrbw01,l_hrbw02,l_hrbw05,l_hrbw06,l_hrbwud03,l_hrat48
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            EXIT FOREACH
         END IF
         IF cl_null(l_hrat48) THEN LET l_hrbw02 = l_hrat48 END IF

         INSERT INTO hrbw_file(hrbw01,hrbw02,hrbw03,hrbw04,hrbw05,hrbw06,hrbw07,hrbwacti,hrbw08,hrbwud02,hrbwud03)
                        VALUES(l_hrbw01,l_hrbw02,g_today,g_user,l_hrbw05,l_hrbw06,'','Y','2','1',l_hrbwud03)
         IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrbw_file",l_hrbw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              LET g_flay= 'N'
              RETURN
         END IF
         END FOREACH
         IF g_flay= 'Y' THEN
         	 COMMIT WORK
         	 ELSE
         	 ROLLBACK WORK
         END IF
    ELSE
    	 CALL cl_err('','ghr-939',0)
    	 RETURN
	 END  IF
END FUNCTION
#FUN-151113 wangjya

FUNCTION i006_importImg()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING
DEFINE l_count  LIKE type_file.num5
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE l_hrat13 LIKE hrat_file.hrat13

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
    LET l_filename = l_file
    CALL ui.interface.frontCall('WinCOM','CreateInstance',['Excel.Application'],[xlApp])
    IF xlApp <> -1 THEN
      LET l_sql = "SELECT SUBSTR('",l_file,"',1,INSTR('",l_file,"','/',-1,1)) FROM dual"
      PREPARE i006_01 FROM l_sql
      EXECUTE i006_01 INTO l_filename

      #CALL cl_replace_str(l_file,'/','\\') RETURNING l_file
      CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'WorkBooks.Open',l_file],[iRes])
      IF iRes <> -1 THEN
        CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
      END IF
      IF iRow > 0 THEN
        CALL s_showmsg_init()
        CALL cl_progress_bar(iRow-1)
        FOR i = 2 TO iRow
          CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[l_hrat13])
          LET l_file = l_filename,l_hrat13
          LET l_sql = "SELECT SUBSTR('",l_hrat13,"',1,INSTR('",l_hrat13,"','/',-1,1)) FROM dual"
          PREPARE i006_02 FROM l_sql
          EXECUTE i006_02 INTO l_filename
        END FOR
      END IF
    END IF
  END IF
END FUNCTION

#课别带出栏位
FUNCTION i006_hrat87(p_hrat87,p_hraoud05)
    DEFINE p_hrat87 LIKE hrat_file.hrat87
    DEFINE p_hraoud05 LIKE hrao_file.hraoud05
    DEFINE l_no STRING
    DEFINE l_hrao02 LIKE hrao_file.hrao02
    DEFINE l_n LIKE type_file.num5
    LET l_n=''
    LET l_hrao02=''
    #判断是否存在
    SELECT COUNT (*) INTO l_n FROM  hrao_file WHERE hrao01=p_hrat87 AND hraoud05=p_hraoud05
    AND hraoacti='Y'
    IF l_n=0 OR l_n IS NULL THEN
      LET l_no= 'ghr-940'
      RETURN l_no,l_hrao02
    END IF
    #带出栏位
    SELECT hrao02 INTO l_hrao02 FROM  hrao_file WHERE hrao01=p_hrat87

    RETURN l_no,l_hrao02
END FUNCTION

#组别带出栏位
FUNCTION i006_hrat88(p_hrat88,p_hraoud05)
    DEFINE p_hrat88 LIKE hrat_file.hrat88
    DEFINE p_hraoud05 LIKE hrao_file.hraoud05
    DEFINE l_no STRING
    DEFINE l_hrao02 LIKE hrao_file.hrao02
    DEFINE l_n LIKE type_file.num5
    LET l_n=''
    LET l_hrao02=''
    #判断是否存在
    SELECT COUNT (*) INTO l_n FROM  hrao_file WHERE hrao01=p_hrat88 AND hraoud05=p_hraoud05
    AND hraoacti='Y'
    IF l_n=0 OR l_n IS NULL THEN
      LET l_no= 'ghr-941'
      RETURN l_no,l_hrao02
    END IF

    #带出栏位
    SELECT hrao02 INTO l_hrao02 FROM  hrao_file WHERE hrao01=p_hrat88

    RETURN l_no,l_hrao02
END FUNCTION

#FUN-151201 wangjya
FUNCTION i006_hrat44(p_cmd)
DEFINE p_cmd       LIKE  type_file.chr1,
       l_hrat02    LIKE  hrat_file.hrat02

   LET g_errno = ''
   SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01 = g_hrat.hrat44

   CASE WHEN SQLCA.SQLCODE = 100
             LET g_errno = 'wag-087'
             LET  l_hrat02 = NULL
   OTHERWISE
        LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd MATCHES '[aud]' THEN
      DISPLAY l_hrat02 TO hrat44_name
   END IF
END FUNCTION
#FUN-151201 wangjya

#TQC-AC0326 add --------------------end-----------------------

{#获取上级部门
FUNCTION i006_get_hrao06(p_hrao00,p_hrao01,p_hraoud05)
  DEFINE p_hrao00 LIKE hrao_file.haro00
  DEFINE p_hrao01 LIKE hrao_file.haro01
  DEFINE p_hraoud05 LIKE hrao_file.haroud05
  DEFINE l_hrao06 LIKE hrao_file.haro06

  IF NOT cl_null(p_hrao00) AND NOT cl_null(p_hrao01) THEN

  END IF


END FUNCTION }

#--* zhoumj 20160105 --
##公司,职位,部门
#FUNCTION i006_HR_chk(p_hrat03,P_hrat05,p_hrat04)
#DEFINE   lr_tc_hrao  RECORD LIKE tc_hrao_file.*,
#         p_hrat03    LIKE hrat_file.hrat03,
#         p_hrat04    LIKE hrat_file.hrat04,
#         P_hrat05    LIKE hrat_file.hrat05,
#         l_hrap10    LIKE hrap_file.hrap10,
#         l_n         LIKE type_file.num5,
#         l_num_chk   LIKE type_file.num5,
#         l_ins_chk   LIKE type_file.chr1
#
#    LET g_errno = NULL
#    LET l_ins_chk = 'Y'
#
#    #找到人力编制管控要求
#    SELECT * INTO lr_tc_hrao.*
#      FROM tc_hrao_file
#     WHERE tc_hrao01 = p_hrat03
#       AND tc_hraoacti = 'Y'
#    IF cl_null(lr_tc_hrao.tc_hrao01) THEN
#        SELECT * INTO lr_tc_hrao.*
#          FROM tc_hrao_file
#         WHERE tc_hrao01 = '0000'
#           AND tc_hraoacti = 'Y'
#    END IF
#
#    #找到该人员所属职位的编制数
#    SELECT hrap10 INTO l_hrap10 FROM hrap_file
#     WHERE hrap01 = p_hrat04
#       AND hrap05 = P_hrat05
#       AND hrap03 = p_hrat03
#       AND hrapacti ='Y'
#
#    #计算当前职位有效的在编人数
#    LET l_n = 0
#    SELECT COUNT(*) INTO l_n FROM hrat_file
#     WHERE hrat03 = p_hrat03
#       AND hrat04 = p_hrat04
#       AND hrat05 = P_hrat05
#       AND hrat19 IN('1001','2001')
#       AND hratacti = 'Y'
#       AND hrat09 = 'Y'
#
#    LET l_num_chk = l_hrap10 - (l_n+1)
#    IF lr_tc_hrao.tc_hrao02 = 'Y' THEN
#        LET g_errno = NULL
#    END IF
#
#    IF lr_tc_hrao.tc_hrao03 = 'Y' THEN
#        IF l_num_chk >=0 THEN
#        ELSE
#            LET g_errno = 'cghr-37'
#        END IF
#    END IF
#
#    IF lr_tc_hrao.tc_hrao04 = 'Y' THEN
#        IF l_num_chk >=0 THEN
#        ELSE
#            LET g_errno = 'cghr-38'
#            LET l_ins_chk = 'N'
#        END IF
#    END IF
#
#    RETURN l_ins_chk
#END FUNCTION
#-- zhoumj 20160105 *--
#add by zhuzw 20160111 start
FUNCTION i006_rp()
DEFINE l_id LIKE gca_file.gca01
DEFINE l_n  LIKE type_file.num5
       
    IF g_hrat.hratid IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_hrat.hratconf = 'Y' THEN
        CALL cl_err('','alm-028',1)
        RETURN
    END IF
    LET l_id = 'hratid=',g_hrat.hratid
    SELECT count(*) into l_n  from gca_file where gca01=l_id AND gca09 ='hrat32'
    if l_n>0 then
    DELETE FROM gcb_file WHERE gcb01=(SELECT gca07 FROM gca_file WHERE gca01=l_id) AND gcb03 ='hrat32'
    DELETE FROM gca_file WHERE gca01=l_id AND gca09 ='hrat32'
    CALL cl_err('删除完成','!',1)
    else 
    call cl_err('照片不存在','!',1)
    end if 
    LET g_doc.column1 = "hratid"
    LET g_doc.value1 = g_hrat.hratid
    CALL cl_get_fld_doc("hrat32")
END FUNCTION
#add by zhuzw 20160111 end

