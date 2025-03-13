# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axri090.4gl
# Descriptions...: 預設會計科目維護作業
# Date & Author..: 94/12/14 By Danny
# Modify.........: No.FUN-4C0100 04/12/22 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-5C0032 06/02/07 by Yiting aag02每次都要重新display
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670047 06/08/15 By Ray 增加多帳套功能
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0042 06/11/14 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-690136 06/12/08 By Smapmin 增加待驗收入科目
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730073 07/04/03 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-740061 07/04/12 By Ray 修正FUN-730073的檢查第二帳科目的錯誤邏輯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850038 08/05/16 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-840052 08/09/22 By dxfwo  CR報表
# Modify.........: No.MOD-910238 09/01/22 By Sarah 報表輸出資料與維護畫面不符
# Modify.........: No.TQC-940035 09/04/09 By chenl  修正curs錯誤。
# Modify.........: No.FUN-960141 09/06/23 By dongbg GP5.2修改:增加券借方科目等欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AB0034 10/11/08 by wujie  增加ool36，ool361
# Modify.........: No.FUN-B10050 11/01/25 By Carrier 科目查询自动过滤
# Modify.........: No.FUN-B40032 11/04/13 By baogc 增加健康捐科目和健康捐科目二欄位
# Modify.........: No.FUN-B50170 11/05/30 By baogc 在報表列印中增加健康捐科目和健康捐科目二欄位
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C10108 12/01/30 By pauline 畫面"健康捐"科目欄位,加入顯示判斷, aza26='0' 時才顯示 
# Modify.........: No.TQC-C30222 12/03/13 By yinhy 畫面"健康捐"科目二欄位也應aza26='0' 時才顯示
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-C90078 12/09/17 By minpp 增加ool40,ool401
# Modify.........: No.MOD-D20126 13/02/22 By yinhy 根據oaz107是否勾選決定ool43，ool44欄位顯示
# Modify.........: No.FUN-D70029 13/07/05 By wangrr 增加"帳扣科目""帳扣科目二"欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ool   RECORD  LIKE ool_file.*,
    g_ool_t RECORD  LIKE ool_file.*,
    g_ool01_t       LIKE ool_file.ool01,
    g_aag02         LIKE aag_file.aag02,
    g_wc,g_sql      string                         #No.FUN-580092 HCN
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt        LIKE type_file.num10            #No.FUN-680123 INTEGER
DEFINE g_i          LIKE type_file.num5             #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE g_msg        LIKE type_file.chr1000          #No.FUN-680123 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10            #No.FUN-680123 INTEGER
DEFINE g_curs_index LIKE type_file.num10            #No.FUN-680123 INTEGER
DEFINE g_jump       LIKE type_file.num10            #No.FUN-680123 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5             #No.FUN-680123 SMALLINT
DEFINE g_argv1     LIKE ool_file.ool01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE l_table      STRING                          #No.FUN-840052                                                             
DEFINE l_sql        STRING                          #No.FUN-840052                                                             
DEFINE g_str        STRING                          #No.FUN-840052
 
MAIN
    DEFINE
        p_row,p_col LIKE type_file.num10,           #No.FUN-680123 SMALLINT,
        l_sql       LIKE type_file.chr1000         #No.FUN-680123 VARCHAR(200),
#       l_time        LIKE type_file.chr8          #No.FUN-6A0095
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-840052---Begin 
#str MOD-910238 mod
   LET g_sql = "ool01.ool_file.ool01,ool02.ool_file.ool02,",
               "ool11.ool_file.ool11,ool12.ool_file.ool12,",
               "ool13.ool_file.ool13,ool14.ool_file.ool14,",
               "ool41.ool_file.ool41,ool42.ool_file.ool42,",
               "ool43.ool_file.ool43,ool44.ool_file.ool44,",
               "ool51.ool_file.ool51,ool52.ool_file.ool52,",
               "ool53.ool_file.ool53,ool54.ool_file.ool54,",
               "ool21.ool_file.ool21,ool22.ool_file.ool22,",
               "ool23.ool_file.ool23,ool24.ool_file.ool24,",
               "ool25.ool_file.ool25,ool26.ool_file.ool26,",
               "ool27.ool_file.ool27,ool28.ool_file.ool28,",
               "ool45.ool_file.ool45,ool46.ool_file.ool46,",
               "ool47.ool_file.ool47,ool15.ool_file.ool15,",
   # FUN-B50170 - ADD - BEGIN ------------------------------------------
               "ool31.ool_file.ool31,ool32.ool_file.ool32,",
               "ool33.ool_file.ool33,ool34.ool_file.ool34,",
               "ool35.ool_file.ool35,ool36.ool_file.ool36,",
               "ool40.ool_file.ool40,ool55.ool_file.ool55,", #FUN-C90078 add-ool40
               "ool56.ool_file.ool56,",  #FUN-D70029
   # FUN-B50170 - ADD -  END  ------------------------------------------
               "ool111.ool_file.ool111,ool121.ool_file.ool121,",
               "ool131.ool_file.ool131,ool141.ool_file.ool141,",
               "ool411.ool_file.ool411,ool421.ool_file.ool421,",
               "ool431.ool_file.ool431,ool441.ool_file.ool441,",
               "ool511.ool_file.ool511,ool521.ool_file.ool521,",
               "ool531.ool_file.ool531,ool541.ool_file.ool541,",
               "ool211.ool_file.ool211,ool221.ool_file.ool221,",
               "ool231.ool_file.ool231,ool241.ool_file.ool241,",
               "ool251.ool_file.ool251,ool261.ool_file.ool261,",
               "ool271.ool_file.ool271,ool281.ool_file.ool281,",
               "ool451.ool_file.ool451,ool461.ool_file.ool461,",
               "ool471.ool_file.ool471,ool151.ool_file.ool151,",
   # FUN-B50170 - ADD - BEGIN ------------------------------------------
               "ool311.ool_file.ool311,ool321.ool_file.ool321,",
               "ool331.ool_file.ool331,ool341.ool_file.ool341,",
               "ool351.ool_file.ool351,ool361.ool_file.ool361,",
               "ool401.ool_file.ool401,ool551.ool_file.ool551,",   #FUN-C90078 add-ool401
               "ool561.ool_file.ool561,",  #FUN-D70029
   # FUN-B50170 - ADD -  END  ------------------------------------------
               "l_ool11.aag_file.aag02,l_ool12.aag_file.aag02,",
               "l_ool13.aag_file.aag02,l_ool14.aag_file.aag02,",
               "l_ool41.aag_file.aag02,l_ool42.aag_file.aag02,",
               "l_ool43.aag_file.aag02,l_ool44.aag_file.aag02,",
               "l_ool51.aag_file.aag02,l_ool52.aag_file.aag02,",
               "l_ool53.aag_file.aag02,l_ool54.aag_file.aag02,",
               "l_ool21.aag_file.aag02,l_ool22.aag_file.aag02,",
               "l_ool23.aag_file.aag02,l_ool24.aag_file.aag02,",
               "l_ool25.aag_file.aag02,l_ool26.aag_file.aag02,",
               "l_ool27.aag_file.aag02,l_ool28.aag_file.aag02,",
               "l_ool45.aag_file.aag02,l_ool46.aag_file.aag02,",
               "l_ool47.aag_file.aag02,l_ool15.aag_file.aag02,",
   # FUN-B50170 - ADD - BEGIN ------------------------------------------
               "l_ool31.aag_file.aag02,l_ool32.aag_file.aag02,",
               "l_ool33.aag_file.aag02,l_ool34.aag_file.aag02,",
               "l_ool35.aag_file.aag02,l_ool36.aag_file.aag02,",
               "l_ool40.aag_file.aag02,l_ool55.aag_file.aag02,", #FUN-C90078 add-ool40
               "l_ool56.aag_file.aag02,", #FUN-D70029
   # FUN-B50170 - ADD -  END  ------------------------------------------
               "l_ool111.aag_file.aag02,l_ool121.aag_file.aag02,",
               "l_ool131.aag_file.aag02,l_ool141.aag_file.aag02,",
               "l_ool411.aag_file.aag02,l_ool421.aag_file.aag02,",
               "l_ool431.aag_file.aag02,l_ool441.aag_file.aag02,",
               "l_ool511.aag_file.aag02,l_ool521.aag_file.aag02,",
               "l_ool531.aag_file.aag02,l_ool541.aag_file.aag02,",
               "l_ool211.aag_file.aag02,l_ool221.aag_file.aag02,",
               "l_ool231.aag_file.aag02,l_ool241.aag_file.aag02,",
               "l_ool251.aag_file.aag02,l_ool261.aag_file.aag02,",
               "l_ool271.aag_file.aag02,l_ool281.aag_file.aag02,",
               "l_ool451.aag_file.aag02,l_ool461.aag_file.aag02,",
          #    "l_ool471.aag_file.aag02,l_ool151.aag_file.aag02"     #FUN-B50170 MARK
               "l_ool471.aag_file.aag02,l_ool151.aag_file.aag02,",   #FUN-B50170 ADD
   # FUN-B50170 - ADD - BEGIN ------------------------------------------
               "l_ool311.aag_file.aag02,l_ool321.aag_file.aag02,",
               "l_ool331.aag_file.aag02,l_ool341.aag_file.aag02,",
               "l_ool351.aag_file.aag02,l_ool361.aag_file.aag02,",
               "l_ool401.aag_file.aag02,l_ool551.aag_file.aag02"     #FUN-C90078 add-ool401
              ,",l_ool561.aag_file.aag02" #FUN-D70029
   # FUN-B50170 - ADD -  END  ------------------------------------------
#end MOD-910238 mod
   LET l_table = cl_prt_temptable('axrt090',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,? )"  #FUN-B50170 ADD #FUN-D70029 add 4?
                  #     ?,?,?,?,?,  ?,?,? )"    #FUN-B50170 MARK
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-840052---End
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
    INITIALIZE g_ool.* TO NULL
    INITIALIZE g_ool_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM ool_file WHERE ool01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i090_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET l_sql ="SELECT aag02 FROM aag_file ",
              " WHERE aag01 = ? AND aag00 = '",g_aza.aza81,"'"
    PREPARE l_aag02 FROM l_sql
    DECLARE aag02 CURSOR FOR l_aag02
    IF SQLCA.SQLCODE THEN
       CALL cl_err('aag02',SQLCA.SQLCODE,1)
    END IF
 
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW i090_w AT p_row,p_col
         WITH FORM "axr/42f/axri090"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL i090_ool43()   #No.MOD-D20126
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i090_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i090_a()
            END IF
         OTHERWISE        
            CALL i090_q() 
      END CASE
   END IF
   #--
 
    #No.FUN-670047 --begin
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("page02",TRUE)
    ELSE
       CALL cl_set_comp_visible("page02",FALSE)
    END IF
    #No.FUN-670047 --end

    #TQC-C10108 add START
    IF g_aza.aza26 = 0 THEN
       CALL cl_set_comp_visible("ool55",TRUE)
       CALL cl_set_comp_visible("ool551",TRUE)  #TQC-C30222
    ELSE
       CALL cl_set_comp_visible("ool55",FALSE)
       CALL cl_set_comp_visible("ool551",FALSE) #TQC-C30222
    END IF
    #TQC-C10108 add END
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i090_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i090_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN
 
FUNCTION i090_curs()
    CLEAR FORM
   INITIALIZE g_ool.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" ool01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        ool01,ool02,ool11,ool12,ool13,ool14,ool41,ool42,ool43,ool44,ool51,
        #ool52,ool53,ool54,ool21,ool22,ool23,ool24,ool25,ool26,ool27,ool28, #FUN-960141
    #   ool52,ool53,ool54,ool31,ool33,ool35,ool21,ool22,ool23,ool24,ool25,ool26,ool27,ool28,  #FUN-960141  #FUN-B40032 MARK
        ool52,ool53,ool54,ool31,ool33,ool35,ool55,ool56,ool21,ool22,ool23,ool24,ool25,ool26,ool27,ool28,  #FUN-960141  #FUN-B40032 ADD ool55 #FUN-D70029 add ool56
        #ool45,ool46,ool47,   #MOD-690136
        #ool45,ool46,ool47,ool15,  #MOD-690136  #FUN-960141 
        ool45,ool46,ool47,ool15,ool32,ool34,ool36,ool40,  #MOD-690136  #FUN-960141 #FUN-AB0034 add ool36  #FUN-C90078-add--ool40
        #No.FUN-670047 --begin
        ool111,ool121,ool131,ool141,ool411,ool421,ool431,ool441,ool511,
       #ool521,ool531,ool541,ool211,ool221,ool23,ool24,ool25,ool26,ool27,ool28,           #No.TQC-940035
       #ool521,ool531,ool541,ool211,ool221,ool231,ool241,ool251,ool261,ool271,ool281,     #No.TQC-940035   #FUN-960141
    #   ool521,ool531,ool541,ool311,ool331,ool351,ool211,ool221,ool231,ool241,ool251,ool261,ool271,ool281,     #No.TQC-940035   #FUN-960141 #FUN-B40032 MARK
        ool521,ool531,ool541,ool311,ool331,ool351,ool551,ool561,ool211,ool221,ool231,ool241,ool251,ool261,ool271,ool281,     #FUN-B40032 ADD ool551  #FUN-D70029 add ool561
        #ool451,ool461,ool471   #MOD-690136
        #ool451,ool461,ool471,ool151,  #MOD-690136  #FUN-960141
        ool451,ool461,ool471,ool151,ool321,ool341,ool361,ool401, #MOD-690136   #FUN-960141#FUN-AB0034 add ool361  #FUN-C90078 add-ool401
        #No.FUN-670047 --end
        #FUN-850038   ---start---
        oolud01,oolud02,oolud03,oolud04,oolud05,
        oolud06,oolud07,oolud08,oolud09,oolud10,
        oolud11,oolud12,oolud13,oolud14,oolud15
        #FUN-850038    ----end----
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ool11)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool11
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool11
              WHEN INFIELD(ool12)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool12
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool12
              WHEN INFIELD(ool13)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool13
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool13
              WHEN INFIELD(ool14)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool14
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='[2]' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool14
              WHEN INFIELD(ool21)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool21
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool21
              WHEN INFIELD(ool22)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool22
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool22
              WHEN INFIELD(ool23)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool23
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool23
              WHEN INFIELD(ool24)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool24
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool24
              WHEN INFIELD(ool25)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool25
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool25
              WHEN INFIELD(ool26)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool26
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool26
              WHEN INFIELD(ool27)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool27
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool27
              WHEN INFIELD(ool28)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool28
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool28
              WHEN INFIELD(ool41)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool41
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool41
              WHEN INFIELD(ool42)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool42
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool42
              WHEN INFIELD(ool43)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool43
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool43
              WHEN INFIELD(ool44)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool44
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool44
              WHEN INFIELD(ool51)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool51
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool51
              WHEN INFIELD(ool52)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool52
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool52
              WHEN INFIELD(ool53)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool53
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool53
              WHEN INFIELD(ool54)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool54
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool54
              WHEN INFIELD(ool45)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool45
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool45
              WHEN INFIELD(ool46)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool46
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool46
              WHEN INFIELD(ool47)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool47
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool47
              #-----MOD-690136---------
              WHEN INFIELD(ool15)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool15
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool15
              #-----END MOD-690136-----
              #No.FUN-670047 --begin
              WHEN INFIELD(ool111)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool111
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool111
              WHEN INFIELD(ool121)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool121
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool121
              WHEN INFIELD(ool131)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool131
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool131
              WHEN INFIELD(ool141)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool141
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='[2]' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool141
              WHEN INFIELD(ool211)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool211
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool211
              WHEN INFIELD(ool221)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool221
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool221
              WHEN INFIELD(ool231)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool231
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool231
              WHEN INFIELD(ool241)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool241
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool241
              WHEN INFIELD(ool251)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool251
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool251
              WHEN INFIELD(ool261)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool261
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool261
              WHEN INFIELD(ool271)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool271
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool271
              WHEN INFIELD(ool281)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool281
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool281
              WHEN INFIELD(ool411)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool411
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool411
              WHEN INFIELD(ool421)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool421
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool421
              WHEN INFIELD(ool431)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool431
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool431
              WHEN INFIELD(ool441)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool441
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool441
              WHEN INFIELD(ool511)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool511
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool511
              WHEN INFIELD(ool521)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool521
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool521
              WHEN INFIELD(ool531)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool531
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool531
              WHEN INFIELD(ool541)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool541
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool541
              WHEN INFIELD(ool451)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool451
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool451
              WHEN INFIELD(ool461)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool461
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool461
              WHEN INFIELD(ool471)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool471
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool471
              #-----MOD-690136---------
              WHEN INFIELD(ool151)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool151
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool151
              #-----END MOD-690136-----
              #No.FUN-670047 --end
              #FUN-960141 add begin
              WHEN INFIELD(ool31)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool31
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool31
              WHEN INFIELD(ool32)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool32
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool32
              WHEN INFIELD(ool33)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool33
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool33
              WHEN INFIELD(ool34)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool34
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool34
#No.FUN-Ab0034 --begin
              WHEN INFIELD(ool36)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool36
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool36
#No.FUN-Ab0034 --end
              #FUN-C90078--ADD--STR
              WHEN INFIELD(ool40)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool40
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool40
              #FUN-C90078--add--end
              WHEN INFIELD(ool35)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool35
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool35
###-FUN-B40032- ADD - BEGIN --------------------------------------------------
              WHEN INFIELD(ool55)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool55
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool55
###-FUN-B40032- ADD -  END  --------------------------------------------------
              WHEN INFIELD(ool311)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool311
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool311
              WHEN INFIELD(ool321)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool321
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool321
              WHEN INFIELD(ool331)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool331
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool331
              WHEN INFIELD(ool341)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool341
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool341
#No.FUN-Ab0034 --begin
              WHEN INFIELD(ool361)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool361
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool361
#No.FUN-Ab0034 --end
              #FUN-C90078--add---str
              WHEN INFIELD(ool401)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool401
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool401
              #FUN-C90078--add--end
              WHEN INFIELD(ool351)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool351
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool351
###-FUN-B40032- ADD - BEGIN --------------------------------------------------
              WHEN INFIELD(ool551)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool551
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool551
###-FUN-B40032- ADD -  END  --------------------------------------------------
              #FUN-960141 add end 
              #FUN-D70029--add--str--
              WHEN INFIELD(ool56)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool56
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool56
              WHEN INFIELD(ool561)
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_ool.ool561
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ool561
              #FUN-D70029--add--end
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
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   END IF  #FUN-7C0050
 
    LET g_sql="SELECT ool01 FROM ool_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED, " ORDER BY ool01"
    PREPARE i090_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i090_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i090_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM ool_file WHERE ",g_wc CLIPPED
    PREPARE i090_precount FROM g_sql
    DECLARE i090_count CURSOR FOR i090_precount
END FUNCTION
 
FUNCTION i090_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i090_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i090_q()
            END IF
          # NEXT OPTION "next"
        ON ACTION next
            CALL i090_fetch('N')
        ON ACTION previous
            CALL i090_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i090_u()
            END IF
        ON ACTION reproduce
            LET g_action_choice="reproduce" 
            IF cl_chk_act_auth() THEN
                 CALL i090_copy()
            END IF
 
          # NEXT OPTION "next"
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i090_r()
            END IF
          # NEXT OPTION "next"
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i090_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i090_fetch('/')
        ON ACTION first
            CALL i090_fetch('F')
        ON ACTION last
            CALL i090_fetch('L')
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
     
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
       #No.FUN-6B0042-------add--------str----
       ON ACTION related_document       #相關文件
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
              IF g_ool.ool01 IS NOT NULL THEN
                 LET g_doc.column1 = "ool01"
                 LET g_doc.value1 = g_ool.ool01
                 CALL cl_doc()
              END IF
          END IF
       #No.FUN-6B0042-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
      #FUN-810046
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i090_cs
END FUNCTION
 
 
FUNCTION i090_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM
    INITIALIZE g_ool.* TO NULL
    LET g_ool01_t = NULL
    LET g_ool_t.*=g_ool.*
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i090_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_ool.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ool.ool01 IS NULL THEN   # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ool_file(ool01,ool02,ool11,ool12,ool13,ool14,ool21,ool22,       #No.FUN-670047
                             ool23,ool24,ool25,ool26,ool27,ool28,ool41,
                             ool42,ool43,ool44,ool51,ool52,ool53,ool54,
                             #FUN-960141 add begin
                             ool31,ool32,ool33,ool34,ool36,ool40,ool35,   #No.FUN-AB0034 add ool36 #FUN-C90078 add--ool40
                         #   ool311,ool321,ool331,ool341,ool361,ool351,    #No.FUN-AB0034 add ool361   #FUN-B40032 MARK
                             ool55,ool311,ool321,ool331,ool341,ool361,ool401,ool351,ool551,    #FUN-B40032 ADD ool55,ool551  #FUN-C90078 add-ool401
                             #FUN-960141 add end 
                             #ool45,ool46,ool47,   #MOD-690136
                             ool45,ool46,ool47,ool15,   #MOD-690136
                             #No.FUN-670047 --begin
                             ool111,ool121,ool131,ool141,ool211,ool221,
                             ool231,ool241,ool251,ool261,ool271,ool281,ool411,
                             ool421,ool431,ool441,ool511,ool521,ool531,ool541,
                             #ool451,ool461,ool471)   #MOD-690136
                             ool451,ool461,ool471,ool151,   #MOD-690136
                             #No.FUN-670047 --end
                             ool56,ool561,    #FUN-D70029
                             #FUN-850038 --start--
                             oolud01,oolud02,oolud03,
                             oolud04,oolud05,oolud06,
                             oolud07,oolud08,oolud09,
                             oolud10,oolud11,oolud12,
                             oolud13,oolud14,oolud15)
                             #FUN-850038 --end--
                      VALUES(g_ool.ool01,g_ool.ool02,g_ool.ool11,g_ool.ool12, #No.FUN-670047
                             g_ool.ool13,g_ool.ool14,g_ool.ool21,g_ool.ool22,
                             g_ool.ool23,g_ool.ool24,g_ool.ool25,g_ool.ool26,
                             g_ool.ool27,g_ool.ool28,g_ool.ool41,g_ool.ool42,
                             g_ool.ool43,g_ool.ool44,g_ool.ool51,g_ool.ool52,
                             g_ool.ool53,g_ool.ool54,
                             #FUN-960141 add begin 
                             g_ool.ool31,g_ool.ool32,g_ool.ool33,g_ool.ool34,g_ool.ool36,g_ool.ool40,g_ool.ool35,    #No.FUN-AB0034 add ool36 #FUN-C90078 add ool40
                         #   g_ool.ool311,g_ool.ool321,g_ool.ool331,g_ool.ool341,g_ool.ool361,g_ool.ool351,    #No.FUN-AB0034 add ool361 #FUN-B40032 MARK
                             g_ool.ool55,g_ool.ool311,g_ool.ool321,g_ool.ool331,g_ool.ool341,g_ool.ool361,g_ool.ool401,g_ool.ool351,g_ool.ool551,     #FUN-B40032 ADD #FUN-C90078 add ool401
                             #FUN-960141 add end 
                             g_ool.ool45,g_ool.ool46,
                             #g_ool.ool47,g_ool.ool111,g_ool.ool121, #No.FUN-670047   #MOD-690136
                             g_ool.ool47,g_ool.ool15,g_ool.ool111,g_ool.ool121, #No.FUN-670047   #MOD-690136
                             #No.FUN-670047 --begin
                             g_ool.ool131,g_ool.ool141,g_ool.ool211,g_ool.ool221,
                             g_ool.ool231,g_ool.ool241,g_ool.ool251,g_ool.ool261,
                             g_ool.ool271,g_ool.ool281,g_ool.ool411,g_ool.ool421,
                             g_ool.ool431,g_ool.ool441,g_ool.ool511,g_ool.ool521,
                             g_ool.ool531,g_ool.ool541,g_ool.ool451,g_ool.ool461,
                             #g_ool.ool471)   #MOD-690136
                             g_ool.ool471,g_ool.ool151,   #MOD-690136
                             #No.FUN-670047 --end
                             g_ool.ool56,g_ool.ool561,    #FUN-D70029
                             #FUN-850038 --start--
                             g_ool.oolud01,g_ool.oolud02,g_ool.oolud03,
                             g_ool.oolud04,g_ool.oolud05,g_ool.oolud06,
                             g_ool.oolud07,g_ool.oolud08,g_ool.oolud09,
                             g_ool.oolud10,g_ool.oolud11,g_ool.oolud12,
                             g_ool.oolud13,g_ool.oolud14,g_ool.oolud15)
                             #FUN-850038 --end--
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)   #No.FUN-660116
            CALL cl_err3("ins","ool_file",g_ool.ool01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
        ELSE
            LET g_ool_t.* = g_ool.*                # 保存上筆資料
            SELECT ool01 INTO g_ool.ool01 FROM ool_file
                WHERE ool01 = g_ool.ool01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i090_i(p_cmd)
    DEFINE
        p_cmd     LIKE type_file.chr1,             #No.FUN-680123 VARCHAR(1),
        l_n       LIKE type_file.num5              #No.FUN-680123 SMALLINT
    INPUT BY NAME g_ool.ool01,g_ool.ool02,g_ool.ool11,g_ool.ool12,
                  g_ool.ool13,g_ool.ool14,g_ool.ool41,g_ool.ool42,
                  g_ool.ool43,g_ool.ool44,g_ool.ool51,g_ool.ool52,
                  #FUN-960141 modify begin 
                  #g_ool.ool53,g_ool.ool54,g_ool.ool21,g_ool.ool22,
                  g_ool.ool53,g_ool.ool54,g_ool.ool31,g_ool.ool33,
              #   g_ool.ool35,g_ool.ool21,g_ool.ool22,                #FUN-B40032 MARK
                  g_ool.ool35,g_ool.ool55,g_ool.ool56,g_ool.ool21,g_ool.ool22,    #FUN-B40032 ADD #FUN-D70029 add ool56
                  #FUN-960141 modify end
                  g_ool.ool23,g_ool.ool24,g_ool.ool25,g_ool.ool26,
                  g_ool.ool27,g_ool.ool28,g_ool.ool45,g_ool.ool46,
                  #g_ool.ool47,g_ool.ool111,g_ool.ool121,      #No.FUN-670047   #MOD-690136
                  g_ool.ool47,g_ool.ool15,
                  g_ool.ool32,g_ool.ool34,        #FUN-960141 add
                  g_ool.ool36,                    #No.FUN-AB0034
                  g_ool.ool40,                    #FUN-C90078
                  g_ool.ool111,g_ool.ool121,      #No.FUN-670047   #MOD-690136
                  #No.FUN-670047 --begin
                  g_ool.ool131,g_ool.ool141,g_ool.ool411,g_ool.ool421,
                  g_ool.ool431,g_ool.ool441,g_ool.ool511,g_ool.ool521,
                  g_ool.ool531,g_ool.ool541,
              #   g_ool.ool311,g_ool.ool331,g_ool.ool351,       #FUN-960141 add     ##FUN-B40032 MARK
                  g_ool.ool311,g_ool.ool331,g_ool.ool351,g_ool.ool551,g_ool.ool561, ##FUN-B40032 ADD #FUN-D70029 add ool561
                  g_ool.ool211,g_ool.ool221,
                  g_ool.ool231,g_ool.ool241,g_ool.ool251,g_ool.ool261,
                  g_ool.ool271,g_ool.ool281,g_ool.ool451,g_ool.ool461,
                  #g_ool.ool471 WITHOUT DEFAULTS   #MOD-690136
                  g_ool.ool471,g_ool.ool151, 
                  g_ool.ool321,g_ool.ool341,       #FUN-960141 add 
                  g_ool.ool361,                    #No.FUN-AB0034
                  g_ool.ool401,                    #FUN-C90078
                  #FUN-850038     ---start---
                  g_ool.oolud01,g_ool.oolud02,g_ool.oolud03,g_ool.oolud04,
                  g_ool.oolud05,g_ool.oolud06,g_ool.oolud07,g_ool.oolud08,
                  g_ool.oolud09,g_ool.oolud10,g_ool.oolud11,g_ool.oolud12,
                  g_ool.oolud13,g_ool.oolud14,g_ool.oolud15 
                  #FUN-850038     ----end----
                  WITHOUT DEFAULTS   #MOD-690136
                  #No.FUN-670047 --end
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i090_set_entry(p_cmd)
            CALL i090_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
             
        AFTER FIELD ool01
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_ool.ool01 != g_ool01_t) THEN
                SELECT count(*) INTO l_n FROM ool_file
                    WHERE ool01 = g_ool.ool01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_ool.ool01,-239,0)
                    LET g_ool.ool01 = g_ool01_t
                    DISPLAY BY NAME g_ool.ool01
                    NEXT FIELD ool01
                END IF
            END IF
 
#-- FUN-5C0032 start---
       BEFORE FIELD ool11
         MESSAGE ''
         IF NOT cl_null(g_ool.ool11) THEN
            SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool11
                                                      AND aag00=g_aza.aza81  #No.FUN-730073 
            MESSAGE g_aag02 CLIPPED
         END IF
#-- FUN-5C0032 end------
 
        AFTER FIELD ool11
          MESSAGE ''
          IF NOT cl_null(g_ool.ool11) THEN
#            CALL i090_ool11(g_ool.ool11)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool11,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool11,'0') RETURNING g_ool.ool11
                DISPLAY BY NAME g_ool.ool11
                #No.FUN-B10050  --End  
                NEXT FIELD ool11
             ELSE
                MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
#-- FUN-5C0032 start---
       BEFORE FIELD ool12
         MESSAGE ''
         IF NOT cl_null(g_ool.ool12) THEN
            SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool12
                                                      AND aag00=g_aza.aza81  #No.FUN-730073 
            MESSAGE g_aag02 CLIPPED
         END IF
#-- FUN-5C0032 END---
 
        AFTER FIELD ool12
          MESSAGE ''
          IF NOT cl_null(g_ool.ool12) THEN
#            CALL i090_ool11(g_ool.ool12)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool12,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0)
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool12,'0') RETURNING g_ool.ool12
                DISPLAY BY NAME g_ool.ool12
                #No.FUN-B10050  --End
                NEXT FIELD ool12
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool13
          MESSAGE ''
          IF NOT cl_null(g_ool.ool13) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool13
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool13
          MESSAGE ''
          IF NOT cl_null(g_ool.ool13) THEN
#            CALL i090_ool11(g_ool.ool13)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool13,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool13,'0') RETURNING g_ool.ool13
                DISPLAY BY NAME g_ool.ool13
                #No.FUN-B10050  --End
                NEXT FIELD ool13
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool14
          MESSAGE ''
          IF NOT cl_null(g_ool.ool14) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool14
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool14
          MESSAGE ''
          IF NOT cl_null(g_ool.ool14) THEN
#            CALL i090_ool11(g_ool.ool14)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool14,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool14,'0') RETURNING g_ool.ool14
                DISPLAY BY NAME g_ool.ool14
                #No.FUN-B10050  --End
                NEXT FIELD ool14
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool21
          MESSAGE ''
          IF NOT cl_null(g_ool.ool21) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool21
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool21
          MESSAGE ''
          IF NOT cl_null(g_ool.ool21) THEN
#            CALL i090_ool11(g_ool.ool21)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool21,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool21,'0') RETURNING g_ool.ool21
                DISPLAY BY NAME g_ool.ool21
                #No.FUN-B10050  --End
                NEXT FIELD ool21
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool22
          MESSAGE ''
          IF NOT cl_null(g_ool.ool22) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool22
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool22
          MESSAGE ''
          IF NOT cl_null(g_ool.ool22) THEN
#            CALL i090_ool11(g_ool.ool22)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool22,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool22,'0') RETURNING g_ool.ool22
                DISPLAY BY NAME g_ool.ool22
                #No.FUN-B10050  --End
                NEXT FIELD ool22
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool23
          MESSAGE ''
          IF NOT cl_null(g_ool.ool23) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool23
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool23
          MESSAGE ''
          IF NOT cl_null(g_ool.ool23) THEN
#            CALL i090_ool11(g_ool.ool23)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool23,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool23,'0') RETURNING g_ool.ool23
                DISPLAY BY NAME g_ool.ool23
                #No.FUN-B10050  --End
                NEXT FIELD ool23
             ELSE
                MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool24
          MESSAGE ''
          IF NOT cl_null(g_ool.ool24) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool24
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool24
          MESSAGE ''
          IF NOT cl_null(g_ool.ool24) THEN
#            CALL i090_ool11(g_ool.ool24)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool24,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool24,'0') RETURNING g_ool.ool24
                DISPLAY BY NAME g_ool.ool24
                #No.FUN-B10050  --End
                NEXT FIELD ool24
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool25
          MESSAGE ''
          IF NOT cl_null(g_ool.ool25) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool25
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool25
          MESSAGE ''
          IF NOT cl_null(g_ool.ool25) THEN
#            CALL i090_ool11(g_ool.ool25)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool25,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool25,'0') RETURNING g_ool.ool25
                DISPLAY BY NAME g_ool.ool25
                #No.FUN-B10050  --End
                NEXT FIELD ool25
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool26
          MESSAGE ''
          IF NOT cl_null(g_ool.ool26) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool26
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool26
          MESSAGE ''
          IF NOT cl_null(g_ool.ool26) THEN
#            CALL i090_ool11(g_ool.ool26)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool26,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool26,'0') RETURNING g_ool.ool26
                DISPLAY BY NAME g_ool.ool26
                #No.FUN-B10050  --End
                NEXT FIELD ool26
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool27
          MESSAGE ''
          IF NOT cl_null(g_ool.ool27) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool27
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool27
          MESSAGE ''
          IF NOT cl_null(g_ool.ool27) THEN
#            CALL i090_ool11(g_ool.ool27)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool27,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool27,'0') RETURNING g_ool.ool27
                DISPLAY BY NAME g_ool.ool27
                #No.FUN-B10050  --End
                NEXT FIELD ool27
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool28
          MESSAGE ''
          IF NOT cl_null(g_ool.ool28) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool28
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool28
          MESSAGE ''
          IF NOT cl_null(g_ool.ool28) THEN
#            CALL i090_ool11(g_ool.ool28)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool28,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool28,'0') RETURNING g_ool.ool28
                DISPLAY BY NAME g_ool.ool28
                #No.FUN-B10050  --End
                NEXT FIELD ool28
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool41
          MESSAGE ''
          IF NOT cl_null(g_ool.ool41) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool41
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool41
          MESSAGE ''
          IF NOT cl_null(g_ool.ool41) THEN
#            CALL i090_ool11(g_ool.ool41)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool41,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool41,'0') RETURNING g_ool.ool41
                DISPLAY BY NAME g_ool.ool41
                #No.FUN-B10050  --End
                NEXT FIELD ool41
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool42
          MESSAGE ''
          IF NOT cl_null(g_ool.ool42) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool42
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool42
          MESSAGE ''
          IF NOT cl_null(g_ool.ool42) THEN
#            CALL i090_ool11(g_ool.ool42)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool42,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool42,'0') RETURNING g_ool.ool42
                DISPLAY BY NAME g_ool.ool42
                #No.FUN-B10050  --End
                NEXT FIELD ool42
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool43
          MESSAGE ''
          IF NOT cl_null(g_ool.ool43) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool43
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool43
          MESSAGE ''
          IF NOT cl_null(g_ool.ool43) THEN
#            CALL i090_ool11(g_ool.ool43)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool43,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool43,'0') RETURNING g_ool.ool43
                DISPLAY BY NAME g_ool.ool43
                #No.FUN-B10050  --End
                NEXT FIELD ool43
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool44
          MESSAGE ''
          IF NOT cl_null(g_ool.ool44) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool44
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool44
          MESSAGE ''
          IF NOT cl_null(g_ool.ool44) THEN
#            CALL i090_ool11(g_ool.ool44)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool44,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool44,'0') RETURNING g_ool.ool44
                DISPLAY BY NAME g_ool.ool44
                #No.FUN-B10050  --End
                NEXT FIELD ool44
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool51
          MESSAGE ''
          IF NOT cl_null(g_ool.ool51) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool51
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool51
          MESSAGE ''
          IF NOT cl_null(g_ool.ool51) THEN
#            CALL i090_ool11(g_ool.ool51)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool51,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool51,'0') RETURNING g_ool.ool51
                DISPLAY BY NAME g_ool.ool51
                #No.FUN-B10050  --End
                NEXT FIELD ool51
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool52
          MESSAGE ''
          IF NOT cl_null(g_ool.ool52) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool52
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool52
          MESSAGE ''
          IF NOT cl_null(g_ool.ool52) THEN
#            CALL i090_ool11(g_ool.ool52)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool52,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool52,'0') RETURNING g_ool.ool52
                DISPLAY BY NAME g_ool.ool52
                #No.FUN-B10050  --End
                NEXT FIELD ool52
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool53
          MESSAGE ''
          IF NOT cl_null(g_ool.ool53) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool53
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool53
          MESSAGE ''
          IF NOT cl_null(g_ool.ool53) THEN
#            CALL i090_ool11(g_ool.ool53)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool53,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool53,'0') RETURNING g_ool.ool53
                DISPLAY BY NAME g_ool.ool53
                #No.FUN-B10050  --End
                NEXT FIELD ool53
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool54
          MESSAGE ''
          IF NOT cl_null(g_ool.ool54) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool54
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool54
          MESSAGE ''
          IF NOT cl_null(g_ool.ool54) THEN
#            CALL i090_ool11(g_ool.ool54)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool54,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool54,'0') RETURNING g_ool.ool54
                DISPLAY BY NAME g_ool.ool54
                #No.FUN-B10050  --End
                NEXT FIELD ool54
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool45
          MESSAGE ''
          IF NOT cl_null(g_ool.ool45) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool45
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool45
          MESSAGE ''
          IF NOT cl_null(g_ool.ool45) THEN
#            CALL i090_ool11(g_ool.ool45)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool45,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool45,'0') RETURNING g_ool.ool45
                DISPLAY BY NAME g_ool.ool45
                #No.FUN-B10050  --End
                NEXT FIELD ool45
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool46
          MESSAGE ''
          IF NOT cl_null(g_ool.ool46) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool46
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool46
          MESSAGE ''
          IF NOT cl_null(g_ool.ool46) THEN
#            CALL i090_ool11(g_ool.ool46)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool46,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool46,'0') RETURNING g_ool.ool46
                DISPLAY BY NAME g_ool.ool46
                #No.FUN-B10050  --End
                NEXT FIELD ool46
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
        BEFORE FIELD ool47
          MESSAGE ''
          IF NOT cl_null(g_ool.ool47) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool47
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool47
          MESSAGE ''
          IF NOT cl_null(g_ool.ool47) THEN
#            CALL i090_ool11(g_ool.ool47)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool47,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool47,'0') RETURNING g_ool.ool47
                DISPLAY BY NAME g_ool.ool47
                #No.FUN-B10050  --End
                NEXT FIELD ool47
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
       #-----MOD-690136---------
        BEFORE FIELD ool15
          MESSAGE ''
          IF NOT cl_null(g_ool.ool15) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool15
                                                       AND aag00=g_aza.aza81  #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool15
          MESSAGE ''
          IF NOT cl_null(g_ool.ool15) THEN
#            CALL i090_ool11(g_ool.ool15)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool15,'0')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool15,'0') RETURNING g_ool.ool15
                DISPLAY BY NAME g_ool.ool15
                #No.FUN-B10050  --End
                NEXT FIELD ool15
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
       #-----END MOD-690136-----
 
 
       #No.FUN-670047 --begin
       BEFORE FIELD ool111
         MESSAGE ''
         IF NOT cl_null(g_ool.ool111) THEN
            SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool111
                                                      AND aag00=g_aza.aza82 #No.FUN-730073 
            MESSAGE g_aag02 CLIPPED
         END IF
 
        AFTER FIELD ool111
          MESSAGE ''
          IF NOT cl_null(g_ool.ool111) THEN
#            CALL i090_ool11(g_ool.ool111)
             CALL i090_ool11(g_ool.ool111,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool111,'1') RETURNING g_ool.ool111
                DISPLAY BY NAME g_ool.ool111
                #No.FUN-B10050  --End
                NEXT FIELD ool111
             ELSE
                MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
       BEFORE FIELD ool121
         MESSAGE ''
         IF NOT cl_null(g_ool.ool121) THEN
            SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool121
                                                      AND aag00=g_aza.aza82 #No.FUN-730073 
            MESSAGE g_aag02 CLIPPED
         END IF
 
        AFTER FIELD ool121
          MESSAGE ''
          IF NOT cl_null(g_ool.ool121) THEN
#            CALL i090_ool11(g_ool.ool121)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool121,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0)
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool121,'1') RETURNING g_ool.ool121
                DISPLAY BY NAME g_ool.ool121
                #No.FUN-B10050  --End
                NEXT FIELD ool121
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool131
          MESSAGE ''
          IF NOT cl_null(g_ool.ool131) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool131
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool131
          MESSAGE ''
          IF NOT cl_null(g_ool.ool131) THEN
#            CALL i090_ool11(g_ool.ool131)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool131,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool131,'1') RETURNING g_ool.ool131
                DISPLAY BY NAME g_ool.ool131
                #No.FUN-B10050  --End
                NEXT FIELD ool131
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool141
          MESSAGE ''
          IF NOT cl_null(g_ool.ool141) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool141
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool141
          MESSAGE ''
          IF NOT cl_null(g_ool.ool141) THEN
#            CALL i090_ool11(g_ool.ool141)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool141,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool141,'1') RETURNING g_ool.ool141
                DISPLAY BY NAME g_ool.ool141
                #No.FUN-B10050  --End
                NEXT FIELD ool141
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool211
          MESSAGE ''
          IF NOT cl_null(g_ool.ool211) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool211
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool211
          MESSAGE ''
          IF NOT cl_null(g_ool.ool211) THEN
#            CALL i090_ool11(g_ool.ool211)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool211,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool211,'1') RETURNING g_ool.ool211
                DISPLAY BY NAME g_ool.ool211
                #No.FUN-B10050  --End
                NEXT FIELD ool211
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool221
          MESSAGE ''
          IF NOT cl_null(g_ool.ool221) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool221
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool221
          MESSAGE ''
          IF NOT cl_null(g_ool.ool221) THEN
#            CALL i090_ool11(g_ool.ool221)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool221,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool221,'1') RETURNING g_ool.ool221
                DISPLAY BY NAME g_ool.ool221
                #No.FUN-B10050  --End
                NEXT FIELD ool221
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool231
          MESSAGE ''
          IF NOT cl_null(g_ool.ool231) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool231
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool231
          MESSAGE ''
          IF NOT cl_null(g_ool.ool231) THEN
#            CALL i090_ool11(g_ool.ool231)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool231,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool231,'1') RETURNING g_ool.ool231
                DISPLAY BY NAME g_ool.ool231
                #No.FUN-B10050  --End
                NEXT FIELD ool231
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool241
          MESSAGE ''
          IF NOT cl_null(g_ool.ool241) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool241
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool241
          MESSAGE ''
          IF NOT cl_null(g_ool.ool241) THEN
#            CALL i090_ool11(g_ool.ool241)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool241,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool241,'1') RETURNING g_ool.ool241
                DISPLAY BY NAME g_ool.ool241
                #No.FUN-B10050  --End
                NEXT FIELD ool241
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool251
          MESSAGE ''
          IF NOT cl_null(g_ool.ool251) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool251
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool251
          MESSAGE ''
          IF NOT cl_null(g_ool.ool251) THEN
#            CALL i090_ool11(g_ool.ool251)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool251,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool251,'1') RETURNING g_ool.ool251
                DISPLAY BY NAME g_ool.ool251
                #No.FUN-B10050  --End
                NEXT FIELD ool251
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool261
          MESSAGE ''
          IF NOT cl_null(g_ool.ool261) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool261
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool261
          MESSAGE ''
          IF NOT cl_null(g_ool.ool261) THEN
#            CALL i090_ool11(g_ool.ool261)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool261,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool261,'1') RETURNING g_ool.ool261
                DISPLAY BY NAME g_ool.ool261
                #No.FUN-B10050  --End
                NEXT FIELD ool261
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool271
          MESSAGE ''
          IF NOT cl_null(g_ool.ool271) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool271
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool271
          MESSAGE ''
          IF NOT cl_null(g_ool.ool271) THEN
#            CALL i090_ool11(g_ool.ool271)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool271,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool271,'1') RETURNING g_ool.ool271
                DISPLAY BY NAME g_ool.ool271
                #No.FUN-B10050  --End
                NEXT FIELD ool271
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool281
          MESSAGE ''
          IF NOT cl_null(g_ool.ool281) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool281
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool281
          MESSAGE ''
          IF NOT cl_null(g_ool.ool281) THEN
#            CALL i090_ool11(g_ool.ool281)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool281,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool281,'1') RETURNING g_ool.ool281
                DISPLAY BY NAME g_ool.ool281
                #No.FUN-B10050  --End
                NEXT FIELD ool281
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool411
          MESSAGE ''
          IF NOT cl_null(g_ool.ool411) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool411
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool411
          MESSAGE ''
          IF NOT cl_null(g_ool.ool411) THEN
#            CALL i090_ool11(g_ool.ool411)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool411,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool411,'1') RETURNING g_ool.ool411
                DISPLAY BY NAME g_ool.ool411
                #No.FUN-B10050  --End
                NEXT FIELD ool411
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool421
          MESSAGE ''
          IF NOT cl_null(g_ool.ool421) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool421
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool421
          MESSAGE ''
          IF NOT cl_null(g_ool.ool421) THEN
#            CALL i090_ool11(g_ool.ool421)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool421,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool421,'1') RETURNING g_ool.ool421
                DISPLAY BY NAME g_ool.ool421
                #No.FUN-B10050  --End
                NEXT FIELD ool421
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool431
          MESSAGE ''
          IF NOT cl_null(g_ool.ool431) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool431
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool431
          MESSAGE ''
          IF NOT cl_null(g_ool.ool431) THEN
#            CALL i090_ool11(g_ool.ool431)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool431,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool431,'1') RETURNING g_ool.ool431
                DISPLAY BY NAME g_ool.ool431
                #No.FUN-B10050  --End

                NEXT FIELD ool431
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool441
          MESSAGE ''
          IF NOT cl_null(g_ool.ool441) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool441
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool441
          MESSAGE ''
          IF NOT cl_null(g_ool.ool441) THEN
#            CALL i090_ool11(g_ool.ool441)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool441,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool441,'1') RETURNING g_ool.ool441
                DISPLAY BY NAME g_ool.ool441
                #No.FUN-B10050  --End
                NEXT FIELD ool441
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool511
          MESSAGE ''
          IF NOT cl_null(g_ool.ool511) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool511
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool511
          MESSAGE ''
          IF NOT cl_null(g_ool.ool511) THEN
#            CALL i090_ool11(g_ool.ool511)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool511,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool511,'1') RETURNING g_ool.ool511
                DISPLAY BY NAME g_ool.ool511
                #No.FUN-B10050  --End
                NEXT FIELD ool511
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool521
          MESSAGE ''
          IF NOT cl_null(g_ool.ool521) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool521
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool521
          MESSAGE ''
          IF NOT cl_null(g_ool.ool521) THEN
#            CALL i090_ool11(g_ool.ool521)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool521,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool521,'1') RETURNING g_ool.ool521
                DISPLAY BY NAME g_ool.ool521
                #No.FUN-B10050  --End
                NEXT FIELD ool521
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool531
          MESSAGE ''
          IF NOT cl_null(g_ool.ool531) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool531
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool531
          MESSAGE ''
          IF NOT cl_null(g_ool.ool531) THEN
#            CALL i090_ool11(g_ool.ool531)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool531,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool531,'1') RETURNING g_ool.ool531
                DISPLAY BY NAME g_ool.ool531
                #No.FUN-B10050  --End
                NEXT FIELD ool531
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool541
          MESSAGE ''
          IF NOT cl_null(g_ool.ool541) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool541
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool541
          MESSAGE ''
          IF NOT cl_null(g_ool.ool541) THEN
#            CALL i090_ool11(g_ool.ool541)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool541,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool541,'1') RETURNING g_ool.ool541
                DISPLAY BY NAME g_ool.ool541
                #No.FUN-B10050  --End
                NEXT FIELD ool541
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool451
          MESSAGE ''
          IF NOT cl_null(g_ool.ool451) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool451
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool451
          MESSAGE ''
          IF NOT cl_null(g_ool.ool451) THEN
#            CALL i090_ool11(g_ool.ool451)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool451,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool451,'1') RETURNING g_ool.ool451
                DISPLAY BY NAME g_ool.ool451
                #No.FUN-B10050  --End
                NEXT FIELD ool451
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
        BEFORE FIELD ool461
          MESSAGE ''
          IF NOT cl_null(g_ool.ool461) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool461
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool461
          MESSAGE ''
          IF NOT cl_null(g_ool.ool461) THEN
#            CALL i090_ool11(g_ool.ool461)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool461,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool461,'1') RETURNING g_ool.ool461
                DISPLAY BY NAME g_ool.ool461
                #No.FUN-B10050  --End
                NEXT FIELD ool461
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
        BEFORE FIELD ool471
          MESSAGE ''
          IF NOT cl_null(g_ool.ool471) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool471
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool471
          MESSAGE ''
          IF NOT cl_null(g_ool.ool471) THEN
#            CALL i090_ool11(g_ool.ool471)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool471,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool471,'1') RETURNING g_ool.ool471
                DISPLAY BY NAME g_ool.ool471
                #No.FUN-B10050  --End
                NEXT FIELD ool471
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
       #-----MOD-690136---------
        BEFORE FIELD ool151
          MESSAGE ''
          IF NOT cl_null(g_ool.ool151) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool151
                                                       AND aag00=g_aza.aza82 #No.FUN-730073 
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool151
          MESSAGE ''
          IF NOT cl_null(g_ool.ool151) THEN
#            CALL i090_ool11(g_ool.ool151)      #No.TQC-740061
             CALL i090_ool11(g_ool.ool151,'1')      #No.TQC-740061
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool151,'1') RETURNING g_ool.ool151
                DISPLAY BY NAME g_ool.ool151
                #No.FUN-B10050  --End
                NEXT FIELD ool151
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
       #-----END MOD-690136-----
 
        #No.FUN-670047 --end
        #FUN-960141 add begin 
        BEFORE FIELD ool31
          MESSAGE ''
          IF NOT cl_null(g_ool.ool31) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool31
                                                       AND aag00=g_aza.aza81
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool31
          MESSAGE ''
          IF NOT cl_null(g_ool.ool31) THEN
             CALL i090_ool11(g_ool.ool31,'0')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool31,'0') RETURNING g_ool.ool31
                DISPLAY BY NAME g_ool.ool31
                #No.FUN-B10050  --End
                NEXT FIELD ool31
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
        BEFORE FIELD ool32
          MESSAGE ''
          IF NOT cl_null(g_ool.ool32) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool32
                                                       AND aag00=g_aza.aza81
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool32
          MESSAGE ''
          IF NOT cl_null(g_ool.ool32) THEN
             CALL i090_ool11(g_ool.ool32,'0')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool32,'0') RETURNING g_ool.ool32
                DISPLAY BY NAME g_ool.ool32
                #No.FUN-B10050  --End
                NEXT FIELD ool32
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
        BEFORE FIELD ool33
          MESSAGE ''
          IF NOT cl_null(g_ool.ool33) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool33
                                                       AND aag00=g_aza.aza81
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool33
          MESSAGE ''
          IF NOT cl_null(g_ool.ool33) THEN
             CALL i090_ool11(g_ool.ool33,'0')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool33,'0') RETURNING g_ool.ool33
                DISPLAY BY NAME g_ool.ool33
                #No.FUN-B10050  --End
                NEXT FIELD ool33
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
        BEFORE FIELD ool34
          MESSAGE ''
          IF NOT cl_null(g_ool.ool34) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool34
                                                       AND aag00=g_aza.aza81
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool34
          MESSAGE ''
          IF NOT cl_null(g_ool.ool34) THEN
             CALL i090_ool11(g_ool.ool34,'0')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool34,'0') RETURNING g_ool.ool34
                DISPLAY BY NAME g_ool.ool34
                #No.FUN-B10050  --End
                NEXT FIELD ool34
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
#No.FUN-AB0034 --begin 
        BEFORE FIELD ool36
          MESSAGE ''
          IF NOT cl_null(g_ool.ool36) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool36
                                                       AND aag00=g_aza.aza81
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool36
          MESSAGE ''
          IF NOT cl_null(g_ool.ool36) THEN
             CALL i090_ool11(g_ool.ool36,'0')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool36,'0') RETURNING g_ool.ool36
                DISPLAY BY NAME g_ool.ool36
                #No.FUN-B10050  --End
                NEXT FIELD ool36
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
#No.FUN-AB0034 --end
         #FUN-C90078--add--str
          BEFORE FIELD ool40
          MESSAGE ''
          IF NOT cl_null(g_ool.ool40) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool40
                                                       AND aag00=g_aza.aza81
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool40
          MESSAGE ''
          IF NOT cl_null(g_ool.ool40) THEN
             CALL i090_ool11(g_ool.ool40,'0')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0)
                CALL i090_qry(g_ool.ool40,'0') RETURNING g_ool.ool40
                DISPLAY BY NAME g_ool.ool40
                NEXT FIELD ool40
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
          #FUN-C90078--add--end
        BEFORE FIELD ool35
          MESSAGE ''
          IF NOT cl_null(g_ool.ool35) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool35
                                                       AND aag00=g_aza.aza81
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool35
          MESSAGE ''
          IF NOT cl_null(g_ool.ool35) THEN
             CALL i090_ool11(g_ool.ool35,'0')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool35,'0') RETURNING g_ool.ool35
                DISPLAY BY NAME g_ool.ool35
                #No.FUN-B10050  --End
                NEXT FIELD ool35
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF

###-FUN-B40032- ADD - BEGIN -------------------------------------------------
        BEFORE FIELD ool55
           MESSAGE ''
           IF NOT cl_null(g_ool.ool55) THEN
              SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool55
                                                        AND aag00=g_aza.aza81
              MESSAGE g_aag02 CLIPPED
           END IF
        AFTER FIELD ool55
           MESSAGE ''
           IF NOT cl_null(g_ool.ool55) THEN
              CALL i090_ool11(g_ool.ool55,'0')
              IF NOT cl_null(g_errno)THEN
                 CALL cl_err('',g_errno,0)
                 CALL i090_qry(g_ool.ool55,'0') RETURNING g_ool.ool55
                 DISPLAY BY NAME g_ool.ool55
                 NEXT FIELD ool55
              ELSE
                  MESSAGE g_aag02 CLIPPED
              END IF
           END IF
###-FUN-B40032- ADD -  END  -------------------------------------------------

        #FUN-D70029--add--str--
        BEFORE FIELD ool56
           MESSAGE ''
           IF NOT cl_null(g_ool.ool56) THEN
              SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool56
                                                        AND aag00=g_aza.aza81
              MESSAGE g_aag02 CLIPPED
           END IF
        AFTER FIELD ool56
           MESSAGE ''
           IF NOT cl_null(g_ool.ool56) THEN
              CALL i090_ool11(g_ool.ool56,'0')
              IF NOT cl_null(g_errno)THEN
                 CALL cl_err('',g_errno,0)
                 CALL i090_qry(g_ool.ool56,'0') RETURNING g_ool.ool56
                 DISPLAY BY NAME g_ool.ool56
                 NEXT FIELD ool56
              ELSE
                  MESSAGE g_aag02 CLIPPED
              END IF
           END IF
        #FUN-D70029--add--end
 
        BEFORE FIELD ool311
          MESSAGE ''
          IF NOT cl_null(g_ool.ool311) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool311
                                                       AND aag00=g_aza.aza82
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool311
          MESSAGE ''
          IF NOT cl_null(g_ool.ool311) THEN
             CALL i090_ool11(g_ool.ool311,'1')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool311,'1') RETURNING g_ool.ool311
                DISPLAY BY NAME g_ool.ool311
                #No.FUN-B10050  --End
                NEXT FIELD ool311
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
        BEFORE FIELD ool321
          MESSAGE ''
          IF NOT cl_null(g_ool.ool321) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool321
                                                       AND aag00=g_aza.aza82
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool321
          MESSAGE ''
          IF NOT cl_null(g_ool.ool321) THEN
             CALL i090_ool11(g_ool.ool321,'1')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool321,'1') RETURNING g_ool.ool321
                DISPLAY BY NAME g_ool.ool321
                #No.FUN-B10050  --End
                NEXT FIELD ool321
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
        BEFORE FIELD ool331
          MESSAGE ''
          IF NOT cl_null(g_ool.ool331) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool331
                                                       AND aag00=g_aza.aza82
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool331
          MESSAGE ''
          IF NOT cl_null(g_ool.ool331) THEN
             CALL i090_ool11(g_ool.ool331,'1')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool331,'1') RETURNING g_ool.ool331
                DISPLAY BY NAME g_ool.ool331
                #No.FUN-B10050  --End
                NEXT FIELD ool331
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
 
        BEFORE FIELD ool341
          MESSAGE ''
          IF NOT cl_null(g_ool.ool341) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool341
                                                       AND aag00=g_aza.aza82
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool341
          MESSAGE ''
          IF NOT cl_null(g_ool.ool341) THEN
             CALL i090_ool11(g_ool.ool341,'1')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool341,'1') RETURNING g_ool.ool341
                DISPLAY BY NAME g_ool.ool341
                #No.FUN-B10050  --End
                NEXT FIELD ool341
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
#No.FUN-AB0034 --begin 
        BEFORE FIELD ool361
          MESSAGE ''
          IF NOT cl_null(g_ool.ool361) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool361
                                                       AND aag00=g_aza.aza81
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool361
          MESSAGE ''
          IF NOT cl_null(g_ool.ool361) THEN
             CALL i090_ool11(g_ool.ool361,'1')      #No.FUN-B10050
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool361,'1') RETURNING g_ool.ool361
                DISPLAY BY NAME g_ool.ool361
                #No.FUN-B10050  --End
                NEXT FIELD ool361
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
#No.FUN-AB0034 --end
        #FUN-C90078--ADD--str
        BEFORE FIELD ool401
          MESSAGE ''
          IF NOT cl_null(g_ool.ool401) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool401
                                                       AND aag00=g_aza.aza82
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool401
          MESSAGE ''
          IF NOT cl_null(g_ool.ool401) THEN
             CALL i090_ool11(g_ool.ool401,'1')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0)
                CALL i090_qry(g_ool.ool401,'1') RETURNING g_ool.ool401
                DISPLAY BY NAME g_ool.ool401
                NEXT FIELD ool401
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
          #FUN-C90078--add--end 
        BEFORE FIELD ool351
          MESSAGE ''
          IF NOT cl_null(g_ool.ool351) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool351
                                                       AND aag00=g_aza.aza82
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool351
          MESSAGE ''
          IF NOT cl_null(g_ool.ool351) THEN
             CALL i090_ool11(g_ool.ool351,'1')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0) 
                #No.FUN-B10050  --Begin
                CALL i090_qry(g_ool.ool351,'1') RETURNING g_ool.ool351
                DISPLAY BY NAME g_ool.ool351
                #No.FUN-B10050  --End
                NEXT FIELD ool351
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF

###-FUN-B40032- ADD - BEGIN -----------------------------------------------
        BEFORE FIELD ool551
          MESSAGE ''
          IF NOT cl_null(g_ool.ool551) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool551
                                                       AND aag00=g_aza.aza82
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool551
          MESSAGE ''
          IF NOT cl_null(g_ool.ool551) THEN
             CALL i090_ool11(g_ool.ool551,'1')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0)
                CALL i090_qry(g_ool.ool551,'1') RETURNING g_ool.ool551
                DISPLAY BY NAME g_ool.ool551
                NEXT FIELD ool551
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
###-FUN-B40032- ADD - BEGIN -----------------------------------------------

        #FUN-960141 add end
 
        #FUN-D70029--add--str--
        BEFORE FIELD ool561
          MESSAGE ''
          IF NOT cl_null(g_ool.ool561) THEN
             SELECT aag02 INTO g_aag02 FROM aag_file WHERE aag01=g_ool.ool561
                                                       AND aag00=g_aza.aza82
             MESSAGE g_aag02 CLIPPED
          END IF
        AFTER FIELD ool561
          MESSAGE ''
          IF NOT cl_null(g_ool.ool561) THEN
             CALL i090_ool11(g_ool.ool561,'1')
             IF NOT cl_null(g_errno)THEN
                CALL cl_err('',g_errno,0)
                CALL i090_qry(g_ool.ool561,'1') RETURNING g_ool.ool561
                DISPLAY BY NAME g_ool.ool561
                NEXT FIELD ool561
             ELSE
                 MESSAGE g_aag02 CLIPPED
             END IF
          END IF
          #FUN-D70029--add--end
        #FUN-850038     ---start---
        AFTER FIELD oolud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD oolud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850038     ----end----
 
       AFTER INPUT  #97/05/22 modify
          IF INT_FLAG THEN EXIT INPUT END IF
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(ool01) THEN
      #         LET g_ool.* = g_ool_t.*
      #         DISPLAY BY NAME g_ool.*
      #         NEXT FIELD ool01
      #      END IF
      #MOD-650015 --end
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ool11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool11
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool11
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool11 )
                 DISPLAY g_ool.ool11 TO ool11
              WHEN INFIELD(ool12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool12
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool12
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool12 )
                 DISPLAY g_ool.ool12 TO ool12
              WHEN INFIELD(ool13)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool13
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool13
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool13 )
                 DISPLAY g_ool.ool13 TO ool13
              WHEN INFIELD(ool14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool14
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool14
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool14 )
                 DISPLAY g_ool.ool14 TO ool14
              WHEN INFIELD(ool21)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool21
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool21
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool21 )
                 DISPLAY g_ool.ool21 TO ool21
              WHEN INFIELD(ool22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool22
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool22
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool22 )
                 DISPLAY g_ool.ool22 TO ool22
              WHEN INFIELD(ool23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool23
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool23
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool23 )
                 DISPLAY g_ool.ool23 TO ool23
              WHEN INFIELD(ool24)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool24
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool24
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool24 )
                 DISPLAY g_ool.ool24 TO ool24
              WHEN INFIELD(ool25)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool25
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool25
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool25 )
                 DISPLAY g_ool.ool25 TO ool25
              WHEN INFIELD(ool26)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool26
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool26
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool26 )
                 DISPLAY g_ool.ool26 TO ool26
              WHEN INFIELD(ool27)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool27
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool27
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool27 )
                 DISPLAY g_ool.ool27 TO ool27
              WHEN INFIELD(ool28)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool28
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool28
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool28 )
                 DISPLAY g_ool.ool28 TO ool28
              WHEN INFIELD(ool41)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool41
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool41
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool41 )
                 DISPLAY g_ool.ool41 TO ool41
              WHEN INFIELD(ool42)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_ool.ool42
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool42
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool42 )
                 DISPLAY g_ool.ool42 TO ool42
              WHEN INFIELD(ool43)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool43
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool43
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool43 )
                 DISPLAY g_ool.ool43 TO ool43
              WHEN INFIELD(ool44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool44
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool44
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool44 )
                 DISPLAY g_ool.ool44 TO ool44
              WHEN INFIELD(ool51)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.default1 = g_ool.ool51
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool51
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool51 )
                 DISPLAY g_ool.ool51 TO ool51
              WHEN INFIELD(ool52)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool52
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool52
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool52 )
                 DISPLAY g_ool.ool52 TO ool52
              WHEN INFIELD(ool53)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool53
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool53
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool53 )
                 DISPLAY g_ool.ool53 TO ool53
              WHEN INFIELD(ool54)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool54
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool54
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool54 )
                 DISPLAY g_ool.ool54 TO ool54
              WHEN INFIELD(ool45)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool45
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool45
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool45 )
                 DISPLAY g_ool.ool45 TO ool45
              WHEN INFIELD(ool46)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool46
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool46
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool46 )
                 DISPLAY g_ool.ool46 TO ool46
              WHEN INFIELD(ool47)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool47
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool47
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool47 )
                 DISPLAY g_ool.ool47 TO ool47
              #-----MOD-690136---------
              WHEN INFIELD(ool15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool15
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool15
                 DISPLAY g_ool.ool15 TO ool15
              #-----END MOD-690136-----
              #No.FUN-670047 --begin
              WHEN INFIELD(ool111)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool111
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool111
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool11 )
                 DISPLAY g_ool.ool111 TO ool111
              WHEN INFIELD(ool121)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool121
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool121
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool12 )
                 DISPLAY g_ool.ool121 TO ool121
              WHEN INFIELD(ool131)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool131
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool131
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool13 )
                 DISPLAY g_ool.ool131 TO ool131
              WHEN INFIELD(ool141)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool141
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool141
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool14 )
                 DISPLAY g_ool.ool141 TO ool141
              WHEN INFIELD(ool211)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool211
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool211
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool21 )
                 DISPLAY g_ool.ool211 TO ool211
              WHEN INFIELD(ool221)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool221
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool221
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool22 )
                 DISPLAY g_ool.ool221 TO ool221
              WHEN INFIELD(ool231)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool231
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool231
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool23 )
                 DISPLAY g_ool.ool231 TO ool231
              WHEN INFIELD(ool241)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool241
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool241
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool24 )
                 DISPLAY g_ool.ool241 TO ool241
              WHEN INFIELD(ool251)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool251
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool251
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool25 )
                 DISPLAY g_ool.ool251 TO ool251
              WHEN INFIELD(ool261)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool261
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool261
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool26 )
                 DISPLAY g_ool.ool261 TO ool261
              WHEN INFIELD(ool271)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool271
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool271
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool27 )
                 DISPLAY g_ool.ool271 TO ool271
              WHEN INFIELD(ool281)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool281
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool281
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool28 )
                 DISPLAY g_ool.ool281 TO ool281
              WHEN INFIELD(ool411)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool411
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool411
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool41 )
                 DISPLAY g_ool.ool411 TO ool411
              WHEN INFIELD(ool421)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool421
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool421
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool42 )
                 DISPLAY g_ool.ool421 TO ool421
              WHEN INFIELD(ool431)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool431
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool431
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool43 )
                 DISPLAY g_ool.ool431 TO ool431
              WHEN INFIELD(ool441)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool441
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool441
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool44 )
                 DISPLAY g_ool.ool441 TO ool441
              WHEN INFIELD(ool511)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool511
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool511
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool51 )
                 DISPLAY g_ool.ool511 TO ool511
              WHEN INFIELD(ool521)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool521
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool521
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool52 )
                 DISPLAY g_ool.ool521 TO ool521
              WHEN INFIELD(ool531)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool531
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool531
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool53 )
                 DISPLAY g_ool.ool531 TO ool531
              WHEN INFIELD(ool541)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool541
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool541
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool54 )
                 DISPLAY g_ool.ool541 TO ool541
              WHEN INFIELD(ool451)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool451
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool451
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool45 )
                 DISPLAY g_ool.ool451 TO ool451
              WHEN INFIELD(ool461)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool461
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool461
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool46 )
                 DISPLAY g_ool.ool461 TO ool461
              WHEN INFIELD(ool471)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool471
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool471
#                 CALL FGL_DIALOG_SETBUFFER( g_ool.ool47 )
                 DISPLAY g_ool.ool471 TO ool471
              #-----MOD-690136---------
              WHEN INFIELD(ool151)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82     #No.FUN-730073 
                 LET g_qryparam.default1 = g_ool.ool151
                 LET g_qryparam.where = " aag07 IN ('2','3')  AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool151
                 DISPLAY g_ool.ool151 TO ool151
              #-----END MOD-690136-----
              #No.FUN-670047 --end
              #FUN-960141 add begin
              WHEN INFIELD(ool31)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool31
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool31
                 DISPLAY g_ool.ool31 TO ool31
              WHEN INFIELD(ool32)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool32
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool32
                 DISPLAY g_ool.ool32 TO ool32
              WHEN INFIELD(ool33)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool33
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool33
                 DISPLAY g_ool.ool33 TO ool33
              WHEN INFIELD(ool34)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool34
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool34
                 DISPLAY g_ool.ool34 TO ool34
#No.FUN-AB0034 --begin
              WHEN INFIELD(ool36)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool36
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool36
                 DISPLAY g_ool.ool36 TO ool36
#No.FUN-AB0034 --end
              #FUN-C90078--add--str
              WHEN INFIELD(ool40)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool40
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool40
                 DISPLAY g_ool.ool36 TO ool40
              #FUN-C90078--add--end
              WHEN INFIELD(ool35)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool35
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool35
                 DISPLAY g_ool.ool35 TO ool35
###-FUN-B40032- ADD - BEGIN --------------------------------------------------
              WHEN INFIELD(ool55)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool55
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool55
                 DISPLAY g_ool.ool55 TO ool55
###-FUN-B40032- ADD -  END  --------------------------------------------------
              #FUN-D70029--add--str--
              WHEN INFIELD(ool56)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool56
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool56
                 DISPLAY g_ool.ool56 TO ool56
              #FUN-D70029--add--end
              WHEN INFIELD(ool311)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.default1 = g_ool.ool311
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool311
                 DISPLAY g_ool.ool311 TO ool311
              WHEN INFIELD(ool321)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.default1 = g_ool.ool321
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool321
                 DISPLAY g_ool.ool321 TO ool321
              WHEN INFIELD(ool331)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.default1 = g_ool.ool331
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool331
                 DISPLAY g_ool.ool331 TO ool331
              WHEN INFIELD(ool341)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.default1 = g_ool.ool341
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool341
                 DISPLAY g_ool.ool341 TO ool341
#No.FUN-AB0034 --begin
              WHEN INFIELD(ool361)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza81
                 LET g_qryparam.default1 = g_ool.ool361
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool361
                 DISPLAY g_ool.ool361 TO ool361
#No.FUN-AB0034 --end
              #FUN-C90078--add--str
              WHEN INFIELD(ool401)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.default1 = g_ool.ool401
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool401
                 DISPLAY g_ool.ool401 TO ool401
              #FUN-C90078--add--end
              WHEN INFIELD(ool351)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.default1 = g_ool.ool351
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool351
                 DISPLAY g_ool.ool351 TO ool351
###-FUN-B40032- ADD - BEGIN -------------------------------------------------
              WHEN INFIELD(ool551)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.default1 = g_ool.ool551
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool551
                 DISPLAY g_ool.ool551 TO ool551
###-FUN-B40032- ADD -  END  -------------------------------------------------
              #FUN-D70029--add--str--
              WHEN INFIELD(ool561)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_aza.aza82
                 LET g_qryparam.default1 = g_ool.ool561
                 LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' "
                 CALL cl_create_qry() RETURNING g_ool.ool561
                 DISPLAY g_ool.ool561 TO ool561
              #FUN-D70029--add--end
              #FUN-960141 add end
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION
 
FUNCTION i090_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ool.* TO NULL              #No.FUN-6B0042
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i090_curs()                        # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i090_count
    FETCH i090_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i090_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)
        INITIALIZE g_ool.* TO NULL
    ELSE
        CALL i090_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i090_fetch(p_flool)
    DEFINE
        p_flool         LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1),
        l_abso          LIKE type_file.num10            #No.FUN-680123 INTEGER
 
    CASE p_flool
        WHEN 'N' FETCH NEXT     i090_cs INTO g_ool.ool01
        WHEN 'P' FETCH PREVIOUS i090_cs INTO g_ool.ool01
        WHEN 'F' FETCH FIRST    i090_cs INTO g_ool.ool01
        WHEN 'L' FETCH LAST     i090_cs INTO g_ool.ool01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i090_cs INTO g_ool.ool01
            LET mi_no_ask = FALSE 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)
        INITIALIZE g_ool.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flool
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT *
      INTO g_ool.* FROM ool_file
       WHERE ool01 = g_ool.ool01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)   #No.FUN-660116
        CALL cl_err3("sel","ool_file",g_ool.ool01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
    ELSE
        CALL i090_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i090_show()
    DISPLAY BY NAME g_ool.ool01,g_ool.ool02,g_ool.ool11,g_ool.ool12,
                    g_ool.ool13,g_ool.ool14,g_ool.ool41,g_ool.ool42,
                    g_ool.ool43,g_ool.ool44,g_ool.ool51,g_ool.ool52,
                    g_ool.ool53,g_ool.ool54,
                 #  g_ool.ool31,g_ool.ool33,g_ool.ool35,  #FUN-960141 add              #FUN-B40032 MARK
                    g_ool.ool31,g_ool.ool33,g_ool.ool35,g_ool.ool55,g_ool.ool56, #FUN-960141 add   #FUN-B40032 ADD #FUN-D70029 add ool56
                    g_ool.ool21,g_ool.ool22,
                    g_ool.ool23,g_ool.ool24,g_ool.ool25,g_ool.ool26,
                    g_ool.ool27,g_ool.ool28,g_ool.ool45,g_ool.ool46,
                    #No.FUN-670047 --begin
                    #g_ool.ool47,g_ool.ool111,g_ool.ool121,   #MOD-690136
                    g_ool.ool47,g_ool.ool15,
                    g_ool.ool32,g_ool.ool34,     #FUN-960141 
                    g_ool.ool36,                 #No.FUN-AB0034
                    g_ool.ool40,                 #FUN-C90078
                    g_ool.ool111,g_ool.ool121,   #MOD-690136
                    g_ool.ool131,g_ool.ool141,g_ool.ool411,g_ool.ool421,
                    g_ool.ool431,g_ool.ool441,g_ool.ool511,g_ool.ool521,
                    g_ool.ool531,g_ool.ool541,
                 #  g_ool.ool311,g_ool.ool331,g_ool.ool351, #FUN-960141                #FUN-B40032 MARK
                    g_ool.ool311,g_ool.ool331,g_ool.ool351,g_ool.ool551,g_ool.ool561, #FUN-960141   #FUN-B40032 ADD #FUN-D70029 add ool561
                    g_ool.ool211,g_ool.ool221,
                    g_ool.ool231,g_ool.ool241,g_ool.ool251,g_ool.ool261,
                    g_ool.ool271,g_ool.ool281,g_ool.ool451,g_ool.ool461,
                    #g_ool.ool471   #MOD-690136
                    g_ool.ool471,g_ool.ool151,  #MOD-690136
                    #No.FUN-670047 --end
                    g_ool.ool321,g_ool.ool341, #FUN-960141  
                    g_ool.ool361,              #No.FUN-AB0034
                    g_ool.ool401,              #FUN-C90078
                    #FUN-850038     ---start---
                    g_ool.oolud01,g_ool.oolud02,g_ool.oolud03,g_ool.oolud04,
                    g_ool.oolud05,g_ool.oolud06,g_ool.oolud07,g_ool.oolud08,
                    g_ool.oolud09,g_ool.oolud10,g_ool.oolud11,g_ool.oolud12,
                    g_ool.oolud13,g_ool.oolud14,g_ool.oolud15 
                    #FUN-850038     ----end----
    MESSAGE ""
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i090_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ool.ool01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ool.* FROM ool_file WHERE ool01=g_ool.ool01
    IF SQLCA.SQLCODE THEN
#       CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)   #No.FUN-660116
        CALL cl_err3("sel","ool_file",g_ool.ool01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ool01_t = g_ool.ool01
    BEGIN WORK
 
    OPEN i090_cl USING g_ool.ool01
    IF STATUS THEN
       CALL cl_err("OPEN i090_cl:", STATUS, 1)
       CLOSE i090_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i090_cl INTO g_ool.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i090_show()                          # 顯示最新資料
    WHILE TRUE
        LET g_ool01_t = g_ool.ool01
        LET g_ool_t.* = g_ool.*               #No.FUN-670047
        CALL i090_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ool.*=g_ool_t.*
            CALL i090_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ool_file SET ool01 = g_ool.ool01,    # 更新DB
                            ool02 = g_ool.ool02,
                            ool11 = g_ool.ool11,
                            ool12 = g_ool.ool12,
                            ool13 = g_ool.ool13,
                            ool14 = g_ool.ool14,
                            ool21 = g_ool.ool21,
                            ool22 = g_ool.ool22,
                            ool23 = g_ool.ool23,
                            ool24 = g_ool.ool24,
                            ool25 = g_ool.ool25,
                            ool26 = g_ool.ool26,
                            ool27 = g_ool.ool27,
                            ool28 = g_ool.ool28,
                            ool41 = g_ool.ool41,
                            ool42 = g_ool.ool42,
                            ool43 = g_ool.ool43,
                            ool44 = g_ool.ool44,
                            ool51 = g_ool.ool51,
                            ool52 = g_ool.ool52,
                            ool53 = g_ool.ool53,
                            ool54 = g_ool.ool54,
                            ool45 = g_ool.ool45,
                            ool46 = g_ool.ool46,
                            ool47 = g_ool.ool47,
                            ool15 = g_ool.ool15,   #MOD-690136
                            #No.FUN-670047 --begin
                            ool111 = g_ool.ool111,
                            ool121 = g_ool.ool121,
                            ool131 = g_ool.ool131,
                            ool141 = g_ool.ool141,
                            ool211 = g_ool.ool211,
                            ool221 = g_ool.ool221,
                            ool231 = g_ool.ool231,
                            ool241 = g_ool.ool241,
                            ool251 = g_ool.ool251,
                            ool261 = g_ool.ool261,
                            ool271 = g_ool.ool271,
                            ool281 = g_ool.ool281,
                            ool411 = g_ool.ool411,
                            ool421 = g_ool.ool421,
                            ool431 = g_ool.ool431,
                            ool441 = g_ool.ool441,
                            ool511 = g_ool.ool511,
                            ool521 = g_ool.ool521,
                            ool531 = g_ool.ool531,
                            ool541 = g_ool.ool541,
                            ool451 = g_ool.ool451,
                            ool461 = g_ool.ool461,
                            ool471 = g_ool.ool471,
                            ool151 = g_ool.ool151,  #MOD-690136
                            #No.FUN-670047 --end
                            #FUN-960141 add begin
                            ool31 = g_ool.ool31,
                            ool32 = g_ool.ool32,
                            ool33 = g_ool.ool33,
                            ool34 = g_ool.ool34,  
                            ool36 = g_ool.ool36,     #No.FUN-AB0034
                            ool40 = g_ool.ool40,     #FUN-C90078
                            ool35 = g_ool.ool35,
                            ool55 = g_ool.ool55,     #FUN-B40032 ADD
                            ool311= g_ool.ool311,
                            ool321= g_ool.ool321,
                            ool331= g_ool.ool331,
                            ool341= g_ool.ool341,
                            ool361= g_ool.ool361,    #No.FUN-AB0034
                            ool401=g_ool.ool401,     #FUN-C90078
                            ool351= g_ool.ool351,
                            ool551= g_ool.ool551,    #FUN-B40032 ADD
                            #FUN-960141 add end
                            ool56 =g_ool.ool56,   #FUN-D70029
                            ool561=g_ool.ool561, #FUN-D70029
                            #FUN-850038 --start--
                            oolud01 = g_ool.oolud01,
                            oolud02 = g_ool.oolud02,
                            oolud03 = g_ool.oolud03,
                            oolud04 = g_ool.oolud04,
                            oolud05 = g_ool.oolud05,
                            oolud06 = g_ool.oolud06,
                            oolud07 = g_ool.oolud07,
                            oolud08 = g_ool.oolud08,
                            oolud09 = g_ool.oolud09,
                            oolud10 = g_ool.oolud10,
                            oolud11 = g_ool.oolud11,
                            oolud12 = g_ool.oolud12,
                            oolud13 = g_ool.oolud13,
                            oolud14 = g_ool.oolud14,
                            oolud15 = g_ool.oolud15
                            #FUN-850038 --end-- 
            WHERE ool01 = g_ool01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)   #No.FUN-660116
            CALL cl_err3("upd","ool_file",g_ool01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660116
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i090_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i090_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_ool.ool01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i090_cl USING g_ool.ool01
 
    IF STATUS THEN
       CALL cl_err("OPEN i090_cl:", STATUS, 1)
       CLOSE i090_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i090_cl INTO g_ool.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i090_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ool01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ool.ool01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM ool_file WHERE ool01 = g_ool.ool01
       CLEAR FORM
       OPEN i090_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i090_cs
          CLOSE i090_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i090_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i090_cs
          CLOSE i090_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i090_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i090_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i090_fetch('/')
       END IF
 
    END IF
    CLOSE i090_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i090_copy()
    DEFINE
        l_newno         LIKE ool_file.ool01,
        l_oldno         LIKE ool_file.ool01,
        l_n             LIKE type_file.num5             #No.FUN-680123 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ool.ool01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i090_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM ool01
 
        AFTER FIELD ool01
            SELECT count(*) INTO l_n FROM ool_file
                WHERE ool01 = l_newno
            IF l_n > 0 THEN                  # Duplicated
                CALL cl_err(l_newno,-239,0)
                LET g_ool.ool01 = g_ool01_t
                DISPLAY BY NAME g_ool.ool01
                NEXT FIELD ool01
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_ool.ool01
        RETURN
    END IF
 
    DROP TABLE x
 
    SELECT *  FROM ool_file WHERE ool01=g_ool.ool01 INTO TEMP x
 
    UPDATE  x SET ool01=l_newno 
 
    INSERT INTO ool_file SELECT * FROM x
 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_ool.ool01,SQLCA.sqlcode,0)   #No.FUN-660116
        CALL cl_err3("ins","ool_file",l_newno,"",SQLCA.sqlcode,"","",1)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_ool.ool01
        LET g_ool.ool01 = l_newno
        SELECT ool_file.* INTO g_ool.* FROM ool_file
               WHERE ool01 = l_newno
        CALL i090_u()
        #SELECT ool_file.* INTO g_ool.* FROM ool_file  #FUN-C80046
        #       WHERE ool01 = l_oldno                  #FUN-C80046
    END IF
    #LET g_ool.ool01 = l_oldno  #FUN-C80046
    CALL i090_show()
 
END FUNCTION
FUNCTION i090_out()
    DEFINE
        l_i         LIKE type_file.num5,         #No.FUN-680123  SMALLINT,
        l_ool       RECORD LIKE ool_file.*,
        l_name      LIKE type_file.chr1000,      #No.FUN-680123  VARCHAR(40),                # External(Disk) file name
        sr RECORD
            ool01   LIKE ool_file.ool01,
            ool02   LIKE ool_file.ool02,
            ool11   LIKE ool_file.ool11,
            ool12   LIKE ool_file.ool12,
            ool13   LIKE ool_file.ool13,
            ool14   LIKE ool_file.ool14,
            ool41   LIKE ool_file.ool41,
            ool42   LIKE ool_file.ool42,
            ool43   LIKE ool_file.ool43,
            ool44   LIKE ool_file.ool44,
            ool51   LIKE ool_file.ool51,
            ool52   LIKE ool_file.ool52,
            ool53   LIKE ool_file.ool53,
            ool54   LIKE ool_file.ool54,
            ool21   LIKE ool_file.ool21,
            ool22   LIKE ool_file.ool22,
            ool23   LIKE ool_file.ool23,
            ool24   LIKE ool_file.ool24,
            ool25   LIKE ool_file.ool25,
            ool26   LIKE ool_file.ool26,
            ool27   LIKE ool_file.ool27,
            ool28   LIKE ool_file.ool28,
            ool45   LIKE ool_file.ool45,
            ool46   LIKE ool_file.ool46,
            ool47   LIKE ool_file.ool47,   
            ool15   LIKE ool_file.ool15,   #MOD-690136
###-FUN-B50170- ADD - BEGIN --------------------------
            ool31   LIKE ool_file.ool31,
            ool32   LIKE ool_file.ool32,
            ool33   LIKE ool_file.ool33,
            ool34   LIKE ool_file.ool34,
            ool35   LIKE ool_file.ool35,
            ool36   LIKE ool_file.ool36,
            ool40   LIKE ool_file.ool40,   #FUN-C90078
            ool55   LIKE ool_file.ool55,
            ool56   LIKE ool_file.ool56,   #FUN-D70029
###-FUN-B50170- ADD -  END  --------------------------
            #No.FUN-670047 --begin
            ool111  LIKE ool_file.ool111,
            ool121  LIKE ool_file.ool121,
            ool131  LIKE ool_file.ool131,
            ool141  LIKE ool_file.ool141,
            ool411  LIKE ool_file.ool411,
            ool421  LIKE ool_file.ool421,
            ool431  LIKE ool_file.ool431,
            ool441  LIKE ool_file.ool441,
            ool511  LIKE ool_file.ool511,
            ool521  LIKE ool_file.ool521,
            ool531  LIKE ool_file.ool531,
            ool541  LIKE ool_file.ool541,
            ool211  LIKE ool_file.ool211,
            ool221  LIKE ool_file.ool221,
            ool231  LIKE ool_file.ool231,
            ool241  LIKE ool_file.ool241,
            ool251  LIKE ool_file.ool251,
            ool261  LIKE ool_file.ool261,
            ool271  LIKE ool_file.ool271,
            ool281  LIKE ool_file.ool281,
            ool451  LIKE ool_file.ool451,
            ool461  LIKE ool_file.ool461,
            ool471  LIKE ool_file.ool471, 
            ool151  LIKE ool_file.ool151,  #MOD-690136   #FUN-B50170 MOD -- ADD ','
###-FUN-B50170- ADD - BEGIN --------------------------
            ool311  LIKE ool_file.ool311,
            ool321  LIKE ool_file.ool321,
            ool331  LIKE ool_file.ool331,
            ool341  LIKE ool_file.ool341,
            ool351  LIKE ool_file.ool351,
            ool361  LIKE ool_file.ool361,
            ool401  LIKE ool_file.ool401,  #FUN-C90078
            ool551  LIKE ool_file.ool551
           ,ool561  LIKE ool_file.ool561   #FUN-D70029
###-FUN-B50170- ADD -  END  --------------------------
            #No.FUN-670047 --end
           END RECORD,
        m_ool       RECORD
                    ool11           LIKE aag_file.aag02,
                    ool12           LIKE aag_file.aag02,
                    ool13           LIKE aag_file.aag02,
                    ool14           LIKE aag_file.aag02,
                    ool41           LIKE aag_file.aag02,
                    ool42           LIKE aag_file.aag02,
                    ool43           LIKE aag_file.aag02,
                    ool44           LIKE aag_file.aag02,
                    ool51           LIKE aag_file.aag02,
                    ool52           LIKE aag_file.aag02,
                    ool53           LIKE aag_file.aag02,
                    ool54           LIKE aag_file.aag02,
                    ool21           LIKE aag_file.aag02,   #MOD-910238 mod
                    ool22           LIKE aag_file.aag02,   #MOD-910238 mod
                    ool23           LIKE aag_file.aag02,   #MOD-910238 mod
                    ool24           LIKE aag_file.aag02,   #MOD-910238 mod
                    ool25           LIKE aag_file.aag02,   #MOD-910238 mod
                    ool26           LIKE aag_file.aag02,   #MOD-910238 mod
                    ool27           LIKE aag_file.aag02,   #MOD-910238 mod
                    ool28           LIKE aag_file.aag02,   #MOD-910238 mod
                    ool45           LIKE aag_file.aag02,
                    ool46           LIKE aag_file.aag02,
                    ool47           LIKE aag_file.aag02,
                    ool15           LIKE aag_file.aag02,   #MOD-690136
###-FUN-B50170- ADD - BEGIN --------------------------
                    ool31           LIKE aag_file.aag02,
                    ool32           LIKE aag_file.aag02,
                    ool33           LIKE aag_file.aag02,
                    ool34           LIKE aag_file.aag02,
                    ool35           LIKE aag_file.aag02,
                    ool36           LIKE aag_file.aag02,
                    ool40           LIKE aag_file.aag02,  #FUN-C90078
                    ool55           LIKE aag_file.aag02,
                    ool56           LIKE aag_file.aag02,  #FUN-D70029
###-FUN-B50170- ADD -  END  --------------------------
                    #No.FUN-670047 --begin
                    ool111          LIKE aag_file.aag02,
                    ool121          LIKE aag_file.aag02,
                    ool131          LIKE aag_file.aag02,
                    ool141          LIKE aag_file.aag02,
                    ool411          LIKE aag_file.aag02,
                    ool421          LIKE aag_file.aag02,
                    ool431          LIKE aag_file.aag02,
                    ool441          LIKE aag_file.aag02,
                    ool511          LIKE aag_file.aag02,
                    ool521          LIKE aag_file.aag02,
                    ool531          LIKE aag_file.aag02,
                    ool541          LIKE aag_file.aag02,
                    ool211          LIKE aag_file.aag02,   #MOD-910238 mod
                    ool221          LIKE aag_file.aag02,   #MOD-910238 mod
                    ool231          LIKE aag_file.aag02,   #MOD-910238 mod
                    ool241          LIKE aag_file.aag02,   #MOD-910238 mod
                    ool251          LIKE aag_file.aag02,   #MOD-910238 mod
                    ool261          LIKE aag_file.aag02,   #MOD-910238 mod
                    ool271          LIKE aag_file.aag02,   #MOD-910238 mod
                    ool281          LIKE aag_file.aag02,   #MOD-910238 mod
                    ool451          LIKE aag_file.aag02,
                    ool461          LIKE aag_file.aag02,
                    ool471          LIKE aag_file.aag02,
                    ool151          LIKE aag_file.aag02,   #MOD-690136 #FUN-B50170 MOD -- ADD ','
###-FUN-B50170- ADD - BEGIN --------------------------
                    ool311          LIKE aag_file.aag02,
                    ool321          LIKE aag_file.aag02,
                    ool331          LIKE aag_file.aag02,
                    ool341          LIKE aag_file.aag02,
                    ool351          LIKE aag_file.aag02,
                    ool361          LIKE aag_file.aag02,
                    ool401          LIKE aag_file.aag02,  #FUN-C90078
                    ool551          LIKE aag_file.aag02
                   ,ool561          LIKE aag_file.aag02   #FUN-D70029
###-FUN-B50170- ADD -  END  --------------------------
                    #No.FUN-670047 --end
                    END RECORD,
        l_za05      LIKE type_file.chr1000          #No.FUN-680123 VARCHAR(50)                 #
 
    IF g_wc IS NULL THEN
    #   CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT ool01,ool02,ool11,ool12,ool13,ool14,",
              "       ool41,ool42,ool43,ool44,ool51,ool52,ool53,ool54,",
              "       ool21,ool22,ool23,ool24,ool25,ool26,ool27,ool28,",
              #"       ool45,ool46,ool47,",   #MOD-690136
              "       ool45,ool46,ool47,ool15,",   #MOD-690136
              "       ool31,ool32,ool33,ool34,ool35,ool36,ool40,ool55,ool56,",  #FUN-B50170 ADD #FUN-C90078 add--ool40 #FUN-D70029 add ool56
              #No.FUN-670047 --begin
              "       ool111,ool121,ool131,ool141,",
              "       ool411,ool421,ool431,ool441,ool511,ool521,ool531,ool541,",
              "       ool211,ool221,ool231,ool241,ool251,ool261,ool271,ool281,",
              #"       ool451,ool461,ool471 ",   #MOD-690136
              "       ool451,ool461,ool471,ool151 ",   #MOD-690136
              "      ,ool311,ool321,ool331,ool341,ool351,ool361,ool401,ool551,ool561",  #FUN-B50170 ADD FUN-C90078 add-ool401 #FUN-D70029 add ool561
              #No.FUN-670047 --end
			  " FROM ool_file",
			  " WHERE ",g_wc CLIPPED
    PREPARE i090_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i090_curo                         # SCROLL CURSOR
         CURSOR FOR i090_p1
 
#   CALL cl_outnam('axri090') RETURNING l_name #No.FUN-840052
#   START REPORT i090_rep TO l_name            #No.FUN-840052
    CALL cl_del_data(l_table)                  #No.FUN-840052
 
    FOREACH i090_curo INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_aag02=NULL
        CALL i090_aag02(sr.ool11,g_aza.aza81) LET m_ool.ool11=g_aag02
        CALL i090_aag02(sr.ool12,g_aza.aza81) LET m_ool.ool12=g_aag02
        CALL i090_aag02(sr.ool13,g_aza.aza81) LET m_ool.ool13=g_aag02
        CALL i090_aag02(sr.ool14,g_aza.aza81) LET m_ool.ool14=g_aag02
        CALL i090_aag02(sr.ool21,g_aza.aza81) LET m_ool.ool21=g_aag02
        CALL i090_aag02(sr.ool22,g_aza.aza81) LET m_ool.ool22=g_aag02
        CALL i090_aag02(sr.ool23,g_aza.aza81) LET m_ool.ool23=g_aag02
        CALL i090_aag02(sr.ool24,g_aza.aza81) LET m_ool.ool24=g_aag02
        CALL i090_aag02(sr.ool25,g_aza.aza81) LET m_ool.ool25=g_aag02
        CALL i090_aag02(sr.ool26,g_aza.aza81) LET m_ool.ool26=g_aag02
        CALL i090_aag02(sr.ool27,g_aza.aza81) LET m_ool.ool27=g_aag02
        CALL i090_aag02(sr.ool28,g_aza.aza81) LET m_ool.ool28=g_aag02
        CALL i090_aag02(sr.ool41,g_aza.aza81) LET m_ool.ool41=g_aag02
        CALL i090_aag02(sr.ool42,g_aza.aza81) LET m_ool.ool42=g_aag02
        CALL i090_aag02(sr.ool43,g_aza.aza81) LET m_ool.ool43=g_aag02
        CALL i090_aag02(sr.ool44,g_aza.aza81) LET m_ool.ool44=g_aag02
        CALL i090_aag02(sr.ool51,g_aza.aza81) LET m_ool.ool51=g_aag02
        CALL i090_aag02(sr.ool52,g_aza.aza81) LET m_ool.ool52=g_aag02
        CALL i090_aag02(sr.ool53,g_aza.aza81) LET m_ool.ool53=g_aag02
        CALL i090_aag02(sr.ool54,g_aza.aza81) LET m_ool.ool54=g_aag02
        CALL i090_aag02(sr.ool45,g_aza.aza81) LET m_ool.ool45=g_aag02
        CALL i090_aag02(sr.ool46,g_aza.aza81) LET m_ool.ool46=g_aag02
        CALL i090_aag02(sr.ool47,g_aza.aza81) LET m_ool.ool47=g_aag02
        CALL i090_aag02(sr.ool15,g_aza.aza81) LET m_ool.ool15=g_aag02   #MOD-690136
###-FUN-B50170- ADD - BEGIN -------------------------------------------------------
        CALL i090_aag02(sr.ool31,g_aza.aza81) LET m_ool.ool31=g_aag02
        CALL i090_aag02(sr.ool32,g_aza.aza81) LET m_ool.ool32=g_aag02
        CALL i090_aag02(sr.ool33,g_aza.aza81) LET m_ool.ool33=g_aag02
        CALL i090_aag02(sr.ool34,g_aza.aza81) LET m_ool.ool34=g_aag02
        CALL i090_aag02(sr.ool35,g_aza.aza81) LET m_ool.ool35=g_aag02
        CALL i090_aag02(sr.ool36,g_aza.aza81) LET m_ool.ool36=g_aag02
        CALL i090_aag02(sr.ool40,g_aza.aza81) LET m_ool.ool40=g_aag02  #FUN-C90078
        CALL i090_aag02(sr.ool55,g_aza.aza81) LET m_ool.ool55=g_aag02
        CALL i090_aag02(sr.ool56,g_aza.aza81) LET m_ool.ool56=g_aag02  #FUN-D70029
###-FUN-B50170- ADD -  END  -------------------------------------------------------
        #No.FUN-670047 --begin
        CALL i090_aag02(sr.ool111,g_aza.aza82) LET m_ool.ool111=g_aag02
        CALL i090_aag02(sr.ool121,g_aza.aza82) LET m_ool.ool121=g_aag02
        CALL i090_aag02(sr.ool131,g_aza.aza82) LET m_ool.ool131=g_aag02
        CALL i090_aag02(sr.ool141,g_aza.aza82) LET m_ool.ool141=g_aag02
        CALL i090_aag02(sr.ool211,g_aza.aza82) LET m_ool.ool211=g_aag02
        CALL i090_aag02(sr.ool221,g_aza.aza82) LET m_ool.ool221=g_aag02
        CALL i090_aag02(sr.ool231,g_aza.aza82) LET m_ool.ool231=g_aag02
        CALL i090_aag02(sr.ool241,g_aza.aza82) LET m_ool.ool241=g_aag02
        CALL i090_aag02(sr.ool251,g_aza.aza82) LET m_ool.ool251=g_aag02
        CALL i090_aag02(sr.ool261,g_aza.aza82) LET m_ool.ool261=g_aag02
        CALL i090_aag02(sr.ool271,g_aza.aza82) LET m_ool.ool271=g_aag02
        CALL i090_aag02(sr.ool281,g_aza.aza82) LET m_ool.ool281=g_aag02
        CALL i090_aag02(sr.ool411,g_aza.aza82) LET m_ool.ool411=g_aag02
        CALL i090_aag02(sr.ool421,g_aza.aza82) LET m_ool.ool421=g_aag02
        CALL i090_aag02(sr.ool431,g_aza.aza82) LET m_ool.ool431=g_aag02
        CALL i090_aag02(sr.ool441,g_aza.aza82) LET m_ool.ool441=g_aag02
        CALL i090_aag02(sr.ool511,g_aza.aza82) LET m_ool.ool511=g_aag02
        CALL i090_aag02(sr.ool521,g_aza.aza82) LET m_ool.ool521=g_aag02
        CALL i090_aag02(sr.ool531,g_aza.aza82) LET m_ool.ool531=g_aag02
        CALL i090_aag02(sr.ool541,g_aza.aza82) LET m_ool.ool541=g_aag02
        CALL i090_aag02(sr.ool451,g_aza.aza82) LET m_ool.ool451=g_aag02
        CALL i090_aag02(sr.ool461,g_aza.aza82) LET m_ool.ool461=g_aag02
        CALL i090_aag02(sr.ool471,g_aza.aza82) LET m_ool.ool471=g_aag02
        CALL i090_aag02(sr.ool151,g_aza.aza82) LET m_ool.ool151=g_aag02   #MOD-690136
###-FUN-B50170- ADD - BEGIN -------------------------------------------------------
        CALL i090_aag02(sr.ool311,g_aza.aza82) LET m_ool.ool311=g_aag02
        CALL i090_aag02(sr.ool321,g_aza.aza82) LET m_ool.ool321=g_aag02
        CALL i090_aag02(sr.ool331,g_aza.aza82) LET m_ool.ool331=g_aag02
        CALL i090_aag02(sr.ool341,g_aza.aza82) LET m_ool.ool341=g_aag02
        CALL i090_aag02(sr.ool351,g_aza.aza82) LET m_ool.ool351=g_aag02
        CALL i090_aag02(sr.ool361,g_aza.aza82) LET m_ool.ool361=g_aag02
        CALL i090_aag02(sr.ool401,g_aza.aza82) LET m_ool.ool401=g_aag02 #FUN-C90078
        CALL i090_aag02(sr.ool551,g_aza.aza82) LET m_ool.ool551=g_aag02
        CALL i090_aag02(sr.ool561,g_aza.aza82) LET m_ool.ool561=g_aag02 #FUN-D70029
###-FUN-B50170- ADD -  END  -------------------------------------------------------
        #No.FUN-670047 --end
#No.FUN-840052---Begin
 #      OUTPUT TO REPORT i090_rep(sr.*,m_ool.*)
        EXECUTE insert_prep USING sr.*,m_ool.*
    END FOREACH
 
#   FINISH REPORT i090_rep
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'ool01,ool02,ool11,ool12,ool13,ool14,ool41,ool42,ool43,ool44,ool51,
        ool52,ool53,ool54,ool21,ool22,ool23,ool24,ool25,ool26,ool27,ool28,
        ool45,ool46,ool47,ool15, 
        ool31,ool32,ool33,ool34,ool35,ool36,ool40,ool55,ool56,  
        ool111,ool121,ool131,ool141,ool411,ool421,ool431,ool441,ool511,
        ool521,ool531,ool541,ool211,ool221,ool23,ool24,ool25,ool26,ool27,ool28,
        ool451,ool461,ool471,ool151,ool311,ool321,ool331,ool341,ool351,ool361,ool401,ool551,ool561')   #FUN-B50170 ADD #FUN-C90078 add-ool401  #FUN-D70029 add ool561
    #   ool451,ool461,ool471,ool151')                 #FUN-B50170 MARK
    #FUN-D70029由於下面的註釋語句放在連個單引號之間，被當成欄位名編譯，導致無法正常轉譯成欄位中文名稱，故將註釋移到下面
    #FUN-B50170 ADD #FUN-C90078 add-ool40 #FUN-D70029 add ool56
            RETURNING g_wc                                                                                                            
    END IF                                                                                                                          
     LET g_str = g_wc,";", g_aza.aza63                                                                
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('axri090','axri090',l_sql,g_str)
 
    CLOSE i090_curo
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-840052---End
END FUNCTION
 
#No.FUN-840052---Begin
#REPORT i090_rep(sr,m_ool)
#    DEFINE
#        l_trailer_sw LIKE type_file.chr1,             #No.FUN-680123 VARCHAR(1),
#        sr RECORD
#            ool01   LIKE ool_file.ool01,
#            ool02   LIKE ool_file.ool02,
#            ool11   LIKE ool_file.ool11,
#            ool12   LIKE ool_file.ool12,
#            ool13   LIKE ool_file.ool13,
#            ool14   LIKE ool_file.ool14,
#            ool41   LIKE ool_file.ool41,
#            ool42   LIKE ool_file.ool42,
#            ool43   LIKE ool_file.ool43,
#            ool44   LIKE ool_file.ool44,
#            ool51   LIKE ool_file.ool51,
#            ool52   LIKE ool_file.ool52,
#            ool53   LIKE ool_file.ool53,
#            ool54   LIKE ool_file.ool54,
#            ool21   LIKE ool_file.ool21,
#            ool22   LIKE ool_file.ool22,
#            ool23   LIKE ool_file.ool23,
#            ool24   LIKE ool_file.ool24,
#            ool25   LIKE ool_file.ool25,
#            ool26   LIKE ool_file.ool26,
#            ool27   LIKE ool_file.ool27,
#            ool28   LIKE ool_file.ool28,
#            ool45   LIKE ool_file.ool45,
#            ool46   LIKE ool_file.ool46,
#            ool47   LIKE ool_file.ool47,
#            ool15   LIKE ool_file.ool15,   #MOD-690136
#            #No.FUN-670047 --begin
#            ool111  LIKE ool_file.ool111,
#            ool121  LIKE ool_file.ool121,
#            ool131  LIKE ool_file.ool131,
#            ool141  LIKE ool_file.ool141,
#            ool411  LIKE ool_file.ool411,
#            ool421  LIKE ool_file.ool421,
#            ool431  LIKE ool_file.ool431,
#            ool441  LIKE ool_file.ool441,
#            ool511  LIKE ool_file.ool511,
#            ool521  LIKE ool_file.ool521,
#            ool531  LIKE ool_file.ool531,
#            ool541  LIKE ool_file.ool541,
#            ool211  LIKE ool_file.ool211,
#            ool221  LIKE ool_file.ool221,
#            ool231  LIKE ool_file.ool231,
#            ool241  LIKE ool_file.ool241,
#            ool251  LIKE ool_file.ool251,
#            ool261  LIKE ool_file.ool261,
#            ool271  LIKE ool_file.ool271,
#            ool281  LIKE ool_file.ool281,
#            ool451  LIKE ool_file.ool451,
#            ool461  LIKE ool_file.ool461,
#            ool471  LIKE ool_file.ool471,
#            ool151  LIKE ool_file.ool151   #MOD-690136
#            #No.FUN-670047 --end
#           END RECORD,
#        m_ool       RECORD
#                    ool11           LIKE aag_file.aag02,
#                    ool12           LIKE aag_file.aag02,
#                    ool13           LIKE aag_file.aag02,
#                    ool14           LIKE aag_file.aag02,
#                    ool21           LIKE aag_file.aag02,
#                    ool22           LIKE aag_file.aag02,
#                    ool23           LIKE aag_file.aag02,
#                    ool24           LIKE aag_file.aag02,
#                    ool25           LIKE aag_file.aag02,
#                    ool26           LIKE aag_file.aag02,
#                    ool27           LIKE aag_file.aag02,
#                    ool28           LIKE aag_file.aag02,
#                    ool41           LIKE aag_file.aag02,
#                    ool42           LIKE aag_file.aag02,
#                    ool43           LIKE aag_file.aag02,
#                    ool44           LIKE aag_file.aag02,
#                    ool51           LIKE aag_file.aag02,
#                    ool52           LIKE aag_file.aag02,
#                    ool53           LIKE aag_file.aag02,
#                    ool54           LIKE aag_file.aag02,
#                    ool45           LIKE aag_file.aag02,
#                    ool46           LIKE aag_file.aag02,
#                    ool47           LIKE aag_file.aag02,
#                    ool15           LIKE aag_file.aag02,   #MOD-690136
#                    #No.FUN-670047 --begin
#                    ool111          LIKE aag_file.aag02,
#                    ool121          LIKE aag_file.aag02,
#                    ool131          LIKE aag_file.aag02,
#                    ool141          LIKE aag_file.aag02,
#                    ool211          LIKE aag_file.aag02,
#                    ool221          LIKE aag_file.aag02,
#                    ool231          LIKE aag_file.aag02,
#                    ool241          LIKE aag_file.aag02,
#                    ool251          LIKE aag_file.aag02,
#                    ool261          LIKE aag_file.aag02,
#                    ool271          LIKE aag_file.aag02,
#                    ool281          LIKE aag_file.aag02,
#                    ool411          LIKE aag_file.aag02,
#                    ool421          LIKE aag_file.aag02,
#                    ool431          LIKE aag_file.aag02,
#                    ool441          LIKE aag_file.aag02,
#                    ool511          LIKE aag_file.aag02,
#                    ool521          LIKE aag_file.aag02,
#                    ool531          LIKE aag_file.aag02,
#                    ool541          LIKE aag_file.aag02,
#                    ool451          LIKE aag_file.aag02,
#                    ool461          LIKE aag_file.aag02,
#                    ool471          LIKE aag_file.aag02,
#                    ool151          LIKE aag_file.aag02   #MOD-690136
#                    #No.FUN-670047 --end
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.ool01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED, pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[32],g_x[33],g_x[38]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.ool01
#           IF (PAGENO > 1 OR LINENO > 9)
#              THEN SKIP TO TOP OF PAGE
#           END IF
#           PRINT COLUMN g_c[32],g_x[11],COLUMN g_c[33],sr.ool01
#           PRINT COLUMN g_c[32],g_x[12],COLUMN g_c[33],sr.ool02
#
#        ON EVERY ROW
#           PRINT COLUMN g_c[32], g_x[13] CLIPPED,
#                 COLUMN g_c[33],sr.ool11,COLUMN g_c[38],m_ool.ool11
#           PRINT COLUMN g_c[32],g_x[14] CLIPPED,
#                 COLUMN g_c[33],sr.ool12,COLUMN g_c[38],m_ool.ool12
#           PRINT COLUMN g_c[32], g_x[15] CLIPPED,
#                 COLUMN g_c[33],sr.ool13,COLUMN g_c[38],m_ool.ool13
#           PRINT COLUMN g_c[32],g_x[16] CLIPPED,
#                 COLUMN g_c[33],sr.ool14,COLUMN g_c[38],m_ool.ool14
#           PRINT ''
#           PRINT COLUMN g_c[32],g_x[17] CLIPPED,
#                 COLUMN g_c[33],sr.ool21,COLUMN g_c[38],m_ool.ool21
#           PRINT COLUMN g_c[32],g_x[18] CLIPPED,
#                 COLUMN g_c[33],sr.ool22,COLUMN g_c[38],m_ool.ool22
#           PRINT COLUMN g_c[32],g_x[19] CLIPPED,
#                 COLUMN g_c[33],sr.ool23,COLUMN g_c[38],m_ool.ool23
#           PRINT COLUMN g_c[32],g_x[20] CLIPPED,
#                 COLUMN g_c[33],sr.ool24,COLUMN g_c[38],m_ool.ool24
#           PRINT COLUMN g_c[32],g_x[21] CLIPPED,
#                 COLUMN g_c[33],sr.ool25,COLUMN g_c[38],m_ool.ool25
#           PRINT COLUMN g_c[32],g_x[22] CLIPPED,
#                 COLUMN g_c[33],sr.ool26,COLUMN g_c[38],m_ool.ool26
#           PRINT COLUMN g_c[32],g_x[23] CLIPPED,
#                 COLUMN g_c[33],sr.ool27,COLUMN g_c[38],m_ool.ool27
#           PRINT COLUMN g_c[32],g_x[24] CLIPPED,
#                 COLUMN g_c[33],sr.ool28,COLUMN g_c[38],m_ool.ool28
#           PRINT ''
#           PRINT COLUMN g_c[32],g_x[25] CLIPPED,
#                 COLUMN g_c[33],sr.ool41,COLUMN g_c[38],m_ool.ool41
#           PRINT COLUMN g_c[32],g_x[26] CLIPPED,
#                 COLUMN g_c[33],sr.ool42,COLUMN g_c[38],m_ool.ool42
#           PRINT COLUMN g_c[32],g_x[27] CLIPPED,
#                 COLUMN g_c[33],sr.ool43,COLUMN g_c[38],m_ool.ool43
#           PRINT COLUMN g_c[32],g_x[28] CLIPPED,
#                 COLUMN g_c[33],sr.ool44,COLUMN g_c[38],m_ool.ool44
#           PRINT ''
#           PRINT COLUMN g_c[32],g_x[29] CLIPPED,
#                 COLUMN g_c[33],sr.ool51,COLUMN g_c[38],m_ool.ool51
#           PRINT COLUMN g_c[32],g_x[30] CLIPPED,
#                 COLUMN g_c[33],sr.ool52,COLUMN g_c[38],m_ool.ool52
#           PRINT COLUMN g_c[32],g_x[31] CLIPPED,
#                 COLUMN g_c[33],sr.ool53,COLUMN g_c[38],m_ool.ool53
#           PRINT COLUMN g_c[32],g_x[34] CLIPPED,
#                 COLUMN g_c[33],sr.ool54,COLUMN g_c[38],m_ool.ool54
#           PRINT COLUMN g_c[32],g_x[35] CLIPPED,
#                 COLUMN g_c[33],sr.ool45,COLUMN g_c[38],m_ool.ool45
#           PRINT COLUMN g_c[32],g_x[36] CLIPPED,
#                 COLUMN g_c[33],sr.ool46,COLUMN g_c[38],m_ool.ool46
#           PRINT COLUMN g_c[32],g_x[37] CLIPPED,
#                 COLUMN g_c[33],sr.ool47,COLUMN g_c[38],m_ool.ool47
#           PRINT COLUMN g_c[32],g_x[62] CLIPPED,   #MOD-690136
#                 COLUMN g_c[33],sr.ool15,COLUMN g_c[38],m_ool.ool15   #MOD-690136
#           PRINT ''
#           #No.FUN-670047 --begin
#           IF g_aza.aza63 = 'Y' THEN
#              SKIP TO TOP OF PAGE
#              PRINT COLUMN g_c[32], g_x[39] CLIPPED,
#                    COLUMN g_c[33],sr.ool111,COLUMN g_c[38],m_ool.ool111
#              PRINT COLUMN g_c[32],g_x[40] CLIPPED,
#                    COLUMN g_c[33],sr.ool121,COLUMN g_c[38],m_ool.ool121
#              PRINT COLUMN g_c[32], g_x[41] CLIPPED,
#                    COLUMN g_c[33],sr.ool131,COLUMN g_c[38],m_ool.ool131
#              PRINT COLUMN g_c[32],g_x[42] CLIPPED,
#                    COLUMN g_c[33],sr.ool141,COLUMN g_c[38],m_ool.ool141
#              PRINT ''
#              PRINT COLUMN g_c[32],g_x[43] CLIPPED,
#                    COLUMN g_c[33],sr.ool211,COLUMN g_c[38],m_ool.ool211
#              PRINT COLUMN g_c[32],g_x[44] CLIPPED,
#                    COLUMN g_c[33],sr.ool221,COLUMN g_c[38],m_ool.ool221
#              PRINT COLUMN g_c[32],g_x[45] CLIPPED,
#                    COLUMN g_c[33],sr.ool231,COLUMN g_c[38],m_ool.ool231
#              PRINT COLUMN g_c[32],g_x[46] CLIPPED,
#                    COLUMN g_c[33],sr.ool241,COLUMN g_c[38],m_ool.ool241
#              PRINT COLUMN g_c[32],g_x[47] CLIPPED,
#                    COLUMN g_c[33],sr.ool251,COLUMN g_c[38],m_ool.ool251
#              PRINT COLUMN g_c[32],g_x[48] CLIPPED,
#                    COLUMN g_c[33],sr.ool261,COLUMN g_c[38],m_ool.ool261
#              PRINT COLUMN g_c[32],g_x[49] CLIPPED,
#                    COLUMN g_c[33],sr.ool271,COLUMN g_c[38],m_ool.ool271
#              PRINT COLUMN g_c[32],g_x[50] CLIPPED,
#                    COLUMN g_c[33],sr.ool281,COLUMN g_c[38],m_ool.ool281
#              PRINT ''
#              PRINT COLUMN g_c[32],g_x[51] CLIPPED,
#                    COLUMN g_c[33],sr.ool411,COLUMN g_c[38],m_ool.ool411
#              PRINT COLUMN g_c[32],g_x[52] CLIPPED,
#                    COLUMN g_c[33],sr.ool421,COLUMN g_c[38],m_ool.ool421
#              PRINT COLUMN g_c[32],g_x[53] CLIPPED,
#                    COLUMN g_c[33],sr.ool431,COLUMN g_c[38],m_ool.ool431
#              PRINT COLUMN g_c[32],g_x[54] CLIPPED,
#                    COLUMN g_c[33],sr.ool441,COLUMN g_c[38],m_ool.ool441
#              PRINT ''
#              PRINT COLUMN g_c[32],g_x[55] CLIPPED,
#                    COLUMN g_c[33],sr.ool511,COLUMN g_c[38],m_ool.ool511
#              PRINT COLUMN g_c[32],g_x[56] CLIPPED,
#                    COLUMN g_c[33],sr.ool521,COLUMN g_c[38],m_ool.ool521
#              PRINT COLUMN g_c[32],g_x[57] CLIPPED,
#                    COLUMN g_c[33],sr.ool531,COLUMN g_c[38],m_ool.ool531
#              PRINT COLUMN g_c[32],g_x[58] CLIPPED,
#                    COLUMN g_c[33],sr.ool541,COLUMN g_c[38],m_ool.ool541
#              PRINT COLUMN g_c[32],g_x[59] CLIPPED,
#                    COLUMN g_c[33],sr.ool451,COLUMN g_c[38],m_ool.ool451
#              PRINT COLUMN g_c[32],g_x[60] CLIPPED,
#                    COLUMN g_c[33],sr.ool461,COLUMN g_c[38],m_ool.ool461
#              PRINT COLUMN g_c[32],g_x[61] CLIPPED,
#                    COLUMN g_c[33],sr.ool471,COLUMN g_c[38],m_ool.ool471
#              PRINT COLUMN g_c[32],g_x[63] CLIPPED,   #MOD-690136
#                    COLUMN g_c[33],sr.ool151,COLUMN g_c[38],m_ool.ool151   #MOD-690136
#           END IF
#           #No.FUN-670047 --end
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-840052---End
 
FUNCTION i090_ool11(p_code,p_flag)      #No.TQC-740061
  DEFINE p_code     LIKE aag_file.aag01
  DEFINE p_flag     LIKE type_file.chr1      #No.TQC-740061
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag07    LIKE aag_file.aag07
  DEFINE l_aag09    LIKE aag_file.aag09
  DEFINE l_aag03    LIKE aag_file.aag03
  DEFINE l_aag00    LIKE aag_file.aag00      #No.TQC-740061
 
   #No.TQC-740061 --begin
   IF p_flag = '0' THEN
      LET l_aag00 = g_aza.aza81
   ELSE
      LET l_aag00 = g_aza.aza82
   END IF
   #No.TQC-740061 --end
   #--FUN-5C0032 START--
   #SELECT aag03,aag07,aag09,aagacti
   #  INTO l_aag03,l_aag07,l_aag09,l_aagacti
   SELECT aag02,aag03,aag07,aag09,aagacti
     INTO g_aag02,l_aag03,l_aag07,l_aag09,l_aagacti
   #--FUN-5C0032 END----
     FROM aag_file
    WHERE aag01=p_code
#     AND aag00=g_aza.aza81 #No.FUN-730073       #No.TQC-740061
      AND aag00=l_aag00      #No.TQC-740061
   CASE WHEN STATUS=100         LET g_errno='agl-001'  #No.7926
        WHEN l_aagacti='N'      LET g_errno='9028'
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
         WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
         WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
END FUNCTION
 
FUNCTION i090_aag02(actno,p_bookno)
DEFINE actno	LIKE aag_file.aag01,           #No.FUN-680123 VARCHAR(24)
       p_bookno LIKE aza_file.aza81  
        IF cl_null(actno) THEN
           LET g_aag02=NULL
        END IF
        SELECT aag02 INTO g_aag02 FROM aag_file
         WHERE aag01=actno
           AND aag00=p_bookno   #No.FUN-730073
END FUNCTION
 
FUNCTION i090_set_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ool01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i090_set_no_entry(p_cmd)
DEFINE   p_cmd  LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey='N'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ool01",FALSE)
  END IF
END FUNCTION
 
#No.FUN-B10050  --Begin
FUNCTION i090_qry(p_aag01,p_flag)
   DEFINE p_aag01         LIKE aag_file.aag01
   DEFINE p_flag          LIKE type_file.chr1
   DEFINE l_aag00         LIKE aag_file.aag00

   IF p_flag = '0' THEN
      LET l_aag00 = g_aza.aza81
   ELSE
      LET l_aag00 = g_aza.aza82
   END IF
   CALL cl_init_qry_var()
   LET g_qryparam.form ="q_aag"
   LET g_qryparam.construct = 'N'
   LET g_qryparam.default1 = p_aag01
   LET g_qryparam.arg1 = l_aag00
   LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aagacti='Y' AND aag01 LIKE '",p_aag01 CLIPPED,"%'"
   CALL cl_create_qry() RETURNING p_aag01
   RETURN p_aag01
END FUNCTION
#No.FUN-B10050  --End  

#No.MOD-D20126  --Begin
FUNCTION i090_ool43()
DEFINE l_ool43     LIKE gae_file.gae04
DEFINE l_ool44     LIKE gae_file.gae04
DEFINE l_ool431    LIKE gae_file.gae04
DEFINE l_ool441    LIKE gae_file.gae04
DEFINE l_index43   LIKE type_file.num5
DEFINE l_index44   LIKE type_file.num5
DEFINE l_index431  LIKE type_file.num5
DEFINE l_index441  LIKE type_file.num5
DEFINE l_str43     STRING
DEFINE l_str44     STRING
DEFINE l_str431    STRING
DEFINE l_str441    STRING

   SELECT gae04 INTO l_ool43 FROM gae_file
    WHERE gae01 = 'axri090'
      AND gae12 = 'std'
      AND gae02 = 'ool43'
      AND gae03 = g_lang 
   SELECT gae04 INTO l_ool431 FROM gae_file
    WHERE gae01 = 'axri090'
      AND gae12 = 'std'
      AND gae02 = 'ool431'
      AND gae03 = g_lang 
   SELECT gae04 INTO l_ool44 FROM gae_file
    WHERE gae01 = 'axri090'
      AND gae12 = 'std'
      AND gae02 = 'ool44'
      AND gae03 = g_lang
   SELECT gae04 INTO l_ool441 FROM gae_file
    WHERE gae01 = 'axri090'
      AND gae12 = 'std'
      AND gae02 = 'ool441'
      AND gae03 = g_lang
   SELECT oaz107 INTO g_oaz.oaz107 FROM oaz_file
   LET l_str43 = l_ool43
   LET l_str431 = l_ool431
   LET l_str44 = l_ool44
   LET l_str441 = l_ool441
   LET l_index43 = l_str43.getIndexOf("/",1)
   LET l_index431 = l_str431.getIndexOf("/",1)
   LET l_index44 = l_str44.getIndexOf("/",1)
   LET l_index441 = l_str441.getIndexOf("/",1)
   IF g_oaz.oaz107 = 'Y' THEN
   	  CALL cl_set_comp_att_text("ool43",l_str43.subString(1,l_index43-1))
   	  CALL cl_set_comp_att_text("ool431",l_str43.subString(1,l_index43-1))
   	  CALL cl_set_comp_att_text("ool44",l_str44.subString(1,l_index44-1))
   	  CALL cl_set_comp_att_text("ool441",l_str44.subString(1,l_index441-1))
   	  
   ELSE
      CALL cl_set_comp_att_text("ool43",l_str43.subString(l_index43+1,l_str43.getLength()))
      CALL cl_set_comp_att_text("ool431",l_str431.subString(l_index431+1,l_str431.getLength()))
   	  CALL cl_set_comp_att_text("ool44",l_str44.subString(l_index44+1,l_str44.getLength()))
   	  CALL cl_set_comp_att_text("ool441",l_str441.subString(l_index441+1,l_str441.getLength()))
   END IF
END FUNCTION	
#No.MOD-D20126  --End
