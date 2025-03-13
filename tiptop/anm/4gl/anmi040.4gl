# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmi040.4gl
# Descriptions...: 票據系統-部門預設科目維護作業
# Date & Author..: 96/11/04 By Lynn
# Modify.........: By Lin 97-02-24 增加應收保證票及存入保證票
# Modify.........: By Wiky add nms68,nms70,nms71
# Modify.........: No.MOD-490074 04/09/03 By Yuna 右邊放棄的action應該不要
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.MOD-510042 05/01/14 By Kitty 列印改為用 COLUMN方式
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/16 By flowld 兩套帳修改及alter table -- ANM模塊,前端基礎數據,融資
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0011 06/10/04 By jamie 1.FUNCTION i040_q() 一開始應清空g_nms.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0082 06/11/07 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740028 07/04/10 By hongmei 會計科目加帳套
# Modify.........: No.TQC-750041 07/05/11 By Lynn 打印內容:FROM:位置在報表名之上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770038 07/07/13 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-7B0094 07/11/15 By chenl   第二科目取值有錯。
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-950023 09/05/06 By xiaofeizhu 點復制，報錯信息anm-088有誤，改為aap-088
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:FUN-B40004 11/04/14 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: NO.MOD-BC0228 11/12/23 By Polly 相關使用 l_aag05 判斷改為 l_aag05 = 'Y' AND nmz11 = 'Y' 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nms   RECORD LIKE nms_file.*,
    g_nms_t RECORD LIKE nms_file.*,
    g_nms_o RECORD LIKE nms_file.*,
    g_nms01_t LIKE nms_file.nms01,
    g_dbs_gl            LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,   #No.FUN-980025 VARCHAR(10)
    g_wc,g_sql          STRING                  #TQC-630166
 
DEFINE g_forupd_sql STRING                      #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
 
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_str           STRING                 #No.FUN-770038
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0082
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_plant_new = g_nmz.nmz02p
    LET g_plant_gl  = g_nmz.nmz02p   #No.FUN-980025
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
    INITIALIZE g_nms.* TO NULL
    INITIALIZE g_nms_t.* TO NULL
    INITIALIZE g_nms_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM nms_file WHERE nms01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i040_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW i040_w AT p_row,p_col
         WITH FORM "anm/42f/anmi040"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    #No.FUN-680034 --Begin
    CALL cl_set_comp_visible("page02",g_aza.aza63='Y')
    #No.FUN-680034 --End
 
    IF g_nmz.nmz11 = 'N' THEN CALL cl_err('','anm-073',0) END IF
    WHILE TRUE
      LET g_action_choice = ""
      CALL i040_menu()
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
    END WHILE
    CLOSE WINDOW i040_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION i040_cs()
    CLEAR FORM
   INITIALIZE g_nms.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        nms01,nms12,nms13,nms14,nms15,nms16,nms17,nms18,
        nms21,nms22,nms23,nms24,nms25,nms26,nms27,
       #No.+099 010505 by plum
       #nms50,nms51,
        nms50,nms51,nms28, 
       #No.+099..end
        nms55,nms56,nms57,nms58,nms59,
        nms60,nms61,nms62,nms63,nms64,nms65,nms66,nms67,nms69,
        nms68,nms70,nms71,
# NO.FUN-680034 --start--
       nms121,nms131,nms141,nms151,nms161,nms171,nms181,
       nms211,nms221,nms231,nms241,nms251,nms261,nms271,
       nms501,nms511,nms281,
       nms551,nms561,nms571,nms581,nms591,
       nms601,nms611,nms621,nms631,nms641,nms651,nms661,nms671,nms691,
       nms681,nms701,nms711,
# NO.FUN-680034 ---end---
        nmsuser,nmsgrup,nmsmodu,nmsdate,nmsacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
 
        ON ACTION controlp
           CASE WHEN INFIELD(nms01)
#                 CALL q_gem(10,10,g_nms.nms01) RETURNING g_nms.nms01
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state= "c"
                  LET g_qryparam.default1 = g_nms.nms01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nms01
                  NEXT FIELD nms01
              WHEN INFIELD(nms12)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms12,'23')
#                      RETURNING g_nms.nms12
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms12,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms12,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms12
                  DISPLAY BY NAME g_nms.nms12 NEXT FIELD nms12
              WHEN INFIELD(nms13)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms13,'23')
#                      RETURNING g_nms.nms13
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms13,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025 
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms13,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms13
                  DISPLAY BY NAME g_nms.nms13 NEXT FIELD nms13
              WHEN INFIELD(nms14)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms14,'23')
#                      RETURNING g_nms.nms14
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms14,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms14,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms14
                  DISPLAY BY NAME g_nms.nms14 NEXT FIELD nms14
              WHEN INFIELD(nms15)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms15,'23')
#                      RETURNING g_nms.nms15
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms15,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms15,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms15
                  DISPLAY BY NAME g_nms.nms15 NEXT FIELD nms15
              WHEN INFIELD(nms16)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms16,'23')
#                      RETURNING g_nms.nms16
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms16,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms16,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms16
                  DISPLAY BY NAME g_nms.nms16 NEXT FIELD nms16
              WHEN INFIELD(nms17)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms17,'23')
#                      RETURNING g_nms.nms17
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms17,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms17,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms17
                  DISPLAY BY NAME g_nms.nms17 NEXT FIELD nms17
              WHEN INFIELD(nms18)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms18,'23')
#                      RETURNING g_nms.nms18
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms18,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms18,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms18
                  DISPLAY BY NAME g_nms.nms18 NEXT FIELD nms18
              WHEN INFIELD(nms21)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms21,'23')
#                      RETURNING g_nms.nms21
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms21,'23',g_aza.aza81)       #No.FUN-740028
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms21,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms21
                  DISPLAY BY NAME g_nms.nms21 NEXT FIELD nms21
              WHEN INFIELD(nms22)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms22,'23')
#                      RETURNING g_nms.nms22
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms22,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms22,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms22
                  DISPLAY BY NAME g_nms.nms22 NEXT FIELD nms22
              WHEN INFIELD(nms23)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms23,'23')
#                      RETURNING g_nms.nms23
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms23,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms23,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms23
                  DISPLAY BY NAME g_nms.nms23 NEXT FIELD nms23
              WHEN INFIELD(nms24)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms24,'23')
#                      RETURNING g_nms.nms24
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms24,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms24,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms24
                  DISPLAY BY NAME g_nms.nms24 NEXT FIELD nms24
              WHEN INFIELD(nms25)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms25,'23')
#                      RETURNING g_nms.nms25
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms25,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms25,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms25
                  DISPLAY BY NAME g_nms.nms25 NEXT FIELD nms25
              WHEN INFIELD(nms26)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms26,'23')
#                      RETURNING g_nms.nms26
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms26,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms26,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms26
                  DISPLAY BY NAME g_nms.nms26 NEXT FIELD nms26
              WHEN INFIELD(nms27)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms27,'23')
#                      RETURNING g_nms.nms27
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms27,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms27,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms27
                  DISPLAY BY NAME g_nms.nms27 NEXT FIELD nms27
              WHEN INFIELD(nms28)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms28,'23')
#                      RETURNING g_nms.nms28
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms28,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms28,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms28
                  DISPLAY BY NAME g_nms.nms28 NEXT FIELD nms28
              WHEN INFIELD(nms50)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms50,'23')
#                      RETURNING g_nms.nms50
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms50,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms50,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms50
                  DISPLAY BY NAME g_nms.nms50 NEXT FIELD nms50
              WHEN INFIELD(nms51)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms51,'23')
#                      RETURNING g_nms.nms51
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms51,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms51,'23',g_aza.aza81)     #No.FUN-980025  
                       RETURNING g_nms.nms51
                  DISPLAY BY NAME g_nms.nms51 NEXT FIELD nms51
              WHEN INFIELD(nms55)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms55,'23')
#                      RETURNING g_nms.nms55
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms55,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms55,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms55
                  DISPLAY BY NAME g_nms.nms55 NEXT FIELD nms55
              WHEN INFIELD(nms56)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms56,'23')
#                      RETURNING g_nms.nms56
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms56,'23',g_aza.aza81)       #No.FUN-740028
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms56,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms56
                  DISPLAY BY NAME g_nms.nms56 NEXT FIELD nms56
              WHEN INFIELD(nms57)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms57,'23')
#                      RETURNING g_nms.nms57
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms57,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms57,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms57
                  DISPLAY BY NAME g_nms.nms57 NEXT FIELD nms57
              WHEN INFIELD(nms58)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms58,'23')
#                      RETURNING g_nms.nms58
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms58,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms58,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms58
                  DISPLAY BY NAME g_nms.nms58 NEXT FIELD nms58
              WHEN INFIELD(nms59)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms59,'23')
#                      RETURNING g_nms.nms59
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms59,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms59,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms59
                  DISPLAY BY NAME g_nms.nms59 NEXT FIELD nms59
              WHEN INFIELD(nms25)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms25,'23')
#                      RETURNING g_nms.nms25
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms25,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms25,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms25
                  DISPLAY BY NAME g_nms.nms25 NEXT FIELD nms25
              WHEN INFIELD(nms26)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms26,'23')
#                      RETURNING g_nms.nms26
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms26,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms26,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms26
                  DISPLAY BY NAME g_nms.nms26 NEXT FIELD nms26
              WHEN INFIELD(nms27)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms27,'23')
#                      RETURNING g_nms.nms27
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms27,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms27,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms27
                  DISPLAY BY NAME g_nms.nms27 NEXT FIELD nms27
              WHEN INFIELD(nms60)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms60,'23')
#                      RETURNING g_nms.nms60
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms60,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms60,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms60
                  DISPLAY BY NAME g_nms.nms60 NEXT FIELD nms60
              WHEN INFIELD(nms61)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms61,'23')
#                      RETURNING g_nms.nms61
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms61,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms61,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms61
                  DISPLAY BY NAME g_nms.nms61 NEXT FIELD nms61
              WHEN INFIELD(nms62)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms62,'23')
#                      RETURNING g_nms.nms62
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms62,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms62,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms62
                  DISPLAY BY NAME g_nms.nms62 NEXT FIELD nms62
              WHEN INFIELD(nms63)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms63,'23')
#                      RETURNING g_nms.nms63
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms63,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms63,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms63
                  DISPLAY BY NAME g_nms.nms63 NEXT FIELD nms63
              WHEN INFIELD(nms64)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms64,'23')
#                      RETURNING g_nms.nms64
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms64,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms64,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms64
                  DISPLAY BY NAME g_nms.nms64 NEXT FIELD nms64
              WHEN INFIELD(nms65)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms65,'23')
#                      RETURNING g_nms.nms65
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms65,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms65,'23',g_aza.aza81)     #No.FUN-980025  
                       RETURNING g_nms.nms65
                  DISPLAY BY NAME g_nms.nms65 NEXT FIELD nms65
              WHEN INFIELD(nms66)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms66,'23')
#                      RETURNING g_nms.nms66
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms66,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms66,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms66
                  DISPLAY BY NAME g_nms.nms66 NEXT FIELD nms66
              WHEN INFIELD(nms67)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms67,'23')
#                      RETURNING g_nms.nms67
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms67,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms67,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms67
                  DISPLAY BY NAME g_nms.nms67 NEXT FIELD nms67
              WHEN INFIELD(nms69)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms69,'23')
#                      RETURNING g_nms.nms69
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms69,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms69,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms69
                  DISPLAY BY NAME g_nms.nms69 NEXT FIELD nms69
              WHEN INFIELD(nms68)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms68,'23')
#                      RETURNING g_nms.nms68
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms68,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms68,'23',g_aza.aza81)     #No.FUN-980025
                       RETURNING g_nms.nms68
                  DISPLAY BY NAME g_nms.nms68 NEXT FIELD nms68
              WHEN INFIELD(nms70)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms70,'23')
#                      RETURNING g_nms.nms70
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms70,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms70,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms70
                  DISPLAY BY NAME g_nms.nms70 NEXT FIELD nms70
              WHEN INFIELD(nms71)
#                 CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms71,'23')
#                      RETURNING g_nms.nms71
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms71,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms71,'23',g_aza.aza81)     #No.FUN-980025 
                       RETURNING g_nms.nms71
                  DISPLAY BY NAME g_nms.nms71 NEXT FIELD nms71
# NO.FUN-680034 --start--
              WHEN INFIELD(nms121)
                  CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms121,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
                       RETURNING g_nms.nms121
                  DISPLAY BY NAME g_nms.nms121 NEXT FIELD nms121
              WHEN INFIELD(nms131)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms131,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms131,'23',g_aza.aza82)     #No.FUN-980025
                       RETURNING g_nms.nms131
                  DISPLAY BY NAME g_nms.nms131 NEXT FIELD nms131
              WHEN INFIELD(nms141)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms141,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms141,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms141
                  DISPLAY BY NAME g_nms.nms141 NEXT FIELD nms141
              WHEN INFIELD(nms151)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms151,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms151,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms151
                  DISPLAY BY NAME g_nms.nms151 NEXT FIELD nms151
              WHEN INFIELD(nms161)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms161,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms161,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms161
                  DISPLAY BY NAME g_nms.nms161 NEXT FIELD nms161
              WHEN INFIELD(nms171)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms171,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms171,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms171
                  DISPLAY BY NAME g_nms.nms171 NEXT FIELD nms171
              WHEN INFIELD(nms181)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms181,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms181,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms181
                  DISPLAY BY NAME g_nms.nms181 NEXT FIELD nms181
              WHEN INFIELD(nms211)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms211,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms211,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms211
                  DISPLAY BY NAME g_nms.nms211 NEXT FIELD nms211
              WHEN INFIELD(nms221)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms221,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms221,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms221
                  DISPLAY BY NAME g_nms.nms221 NEXT FIELD nms221
              WHEN INFIELD(nms231)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms231,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms231,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms231
                  DISPLAY BY NAME g_nms.nms231 NEXT FIELD nms231
              WHEN INFIELD(nms241)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms241,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms241,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms241
                  DISPLAY BY NAME g_nms.nms241 NEXT FIELD nms241
              WHEN INFIELD(nms251)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms251,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms251,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms251
                  DISPLAY BY NAME g_nms.nms251 NEXT FIELD nms251
              WHEN INFIELD(nms261)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms261,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms261,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms261
                  DISPLAY BY NAME g_nms.nms261 NEXT FIELD nms261
              WHEN INFIELD(nms271)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms271,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms271,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms271
                  DISPLAY BY NAME g_nms.nms271 NEXT FIELD nms271
              WHEN INFIELD(nms501)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms501,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms501,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms501
                  DISPLAY BY NAME g_nms.nms501 NEXT FIELD nms501
              WHEN INFIELD(nms511)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms511,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms511,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms511
                  DISPLAY BY NAME g_nms.nms511 NEXT FIELD nms511
              WHEN INFIELD(nms281)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms281,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms281,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms281
                  DISPLAY BY NAME g_nms.nms281 NEXT FIELD nms281
              WHEN INFIELD(nms551)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms551,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms551,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms551
                  DISPLAY BY NAME g_nms.nms551 NEXT FIELD nms551
              WHEN INFIELD(nms561)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms561,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms561,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms561
                  DISPLAY BY NAME g_nms.nms561 NEXT FIELD nms561
              WHEN INFIELD(nms571)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms571,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms571,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms571
                  DISPLAY BY NAME g_nms.nms571 NEXT FIELD nms571
              WHEN INFIELD(nms581)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms581,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms581,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms581
                  DISPLAY BY NAME g_nms.nms581 NEXT FIELD nms581
              WHEN INFIELD(nms591)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms591,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms591,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms591
                  DISPLAY BY NAME g_nms.nms591 NEXT FIELD nms591
              WHEN INFIELD(nms601)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms601,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms601,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms601
                  DISPLAY BY NAME g_nms.nms601 NEXT FIELD nms601
              WHEN INFIELD(nms611)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms611,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms611,'23',g_aza.aza82)     #No.FUN-980025
                       RETURNING g_nms.nms611
                  DISPLAY BY NAME g_nms.nms611 NEXT FIELD nms611
              WHEN INFIELD(nms621)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms621,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms621,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms621
                  DISPLAY BY NAME g_nms.nms621 NEXT FIELD nms621
              WHEN INFIELD(nms631)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms631,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms631,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms631
                  DISPLAY BY NAME g_nms.nms631 NEXT FIELD nms631
              WHEN INFIELD(nms641)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms641,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms641,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms641
                  DISPLAY BY NAME g_nms.nms641 NEXT FIELD nms641
              WHEN INFIELD(nms651)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms651,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms651,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms651
                  DISPLAY BY NAME g_nms.nms651 NEXT FIELD nms651
              WHEN INFIELD(nms661)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms661,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms661,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms661
                  DISPLAY BY NAME g_nms.nms661 NEXT FIELD nms661
              WHEN INFIELD(nms671)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms671,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms671,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms671
                  DISPLAY BY NAME g_nms.nms671 NEXT FIELD nms671
              WHEN INFIELD(nms691)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms691,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms691,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms691
                  DISPLAY BY NAME g_nms.nms691 NEXT FIELD nms691
              WHEN INFIELD(nms681)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms681,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms681,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms681
                  DISPLAY BY NAME g_nms.nms681 NEXT FIELD nms681
              WHEN INFIELD(nms701)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms701,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms701,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms701
                  DISPLAY BY NAME g_nms.nms701 NEXT FIELD nms701
              WHEN INFIELD(nms711)
#                 CALL q_m_aag(TRUE,TRUE,g_dbs_gl,g_nms.nms711,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nms.nms711,'23',g_aza.aza82)     #No.FUN-980025 
                       RETURNING g_nms.nms711
 
# NO.FUN-680034 ---end---
              OTHERWISE EXIT CASE
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
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND nmsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND nmsgrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND nmsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmsuser', 'nmsgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT nms01 FROM nms_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED
         IF g_nmz.nmz11 = 'N'
            THEN LET g_sql= g_sql CLIPPED," AND nms01 = ' '"
            ELSE LET g_sql= g_sql CLIPPED," AND nms01 != ' '"
         END IF
        LET g_sql= g_sql CLIPPED," ORDER BY nms01"
    PREPARE i040_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i040_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i040_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM nms_file WHERE ",g_wc CLIPPED
         IF g_nmz.nmz11 = 'N'
            THEN LET g_sql= g_sql CLIPPED," AND nms01 = ' '"
            ELSE LET g_sql= g_sql CLIPPED," AND nms01 != ' '"
         END IF
    PREPARE i040_recount FROM g_sql
    DECLARE i040_count
         CURSOR FOR i040_recount
END FUNCTION
 
FUNCTION i040_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i040_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i040_q()
            END IF
        ON ACTION next
            CALL i040_fetch('N')
        ON ACTION previous
            CALL i040_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i040_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL i040_x()
               CALL cl_set_field_pic("","","","","",g_nms.nmsacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i040_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i040_copy()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL i040_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_nms.nmsacti)
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        # ON ACTION cancel #No.MOD-490047
       #    LET g_action_choice = "exit"
       #    EXIT MENU
        ON ACTION jump
            CALL i040_fetch('/')
        ON ACTION first
            CALL i040_fetch('F')
        ON ACTION last
            CALL i040_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
      #No.FUN-6A0011-------add--------str----
      ON ACTION related_document       #相關文件
         LET g_action_choice="related_document"
         IF cl_chk_act_auth() THEN
             IF g_nms.nms01 IS NOT NULL THEN
                LET g_doc.column1 = "nms01"
                LET g_doc.value1 = g_nms.nms01
                CALL cl_doc()
             END IF
         END IF
      #No.FUN-6A0011-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i040_cs
END FUNCTION
 
FUNCTION i040_a()
    IF s_anmshut(0) THEN RETURN END IF
    MESSAGE ""
    # 是否依部門區分預設會計科目" 設為 'N'
    IF g_nmz.nmz11 = 'N' THEN
         SELECT count(*) INTO g_cnt FROM nms_file
             WHERE (nms01 = ' ' OR nms01 IS NULL)
         IF g_cnt > 0 THEN
             CALL cl_err(g_nms.nms01,'anm-160',1)
             LET g_nms.nms01 = g_nms01_t
             DISPLAY BY NAME g_nms.nms01
             RETURN
         END IF
    END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_nms.* LIKE nms_file.*
    LET g_nms01_t = NULL
    LET g_nms_o.* = g_nms.*
    LET g_nms_t.* = g_nms.*
#%  LET g_nms.xxxx = 0				# DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_nms.nmsacti ='Y'                   #有效的資料
        LET g_nms.nmsuser = g_user
        LET g_nms.nmsoriu = g_user #FUN-980030
        LET g_nms.nmsorig = g_grup #FUN-980030
        LET g_nms.nmsgrup = g_grup               #使用者所屬群
        LET g_nms.nmsdate = g_today
        CALL i040_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_nms.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_nmz.nmz11 = 'N' THEN
           LET g_nms.nms01 = ' '
        ELSE
           IF cl_null(g_nms.nms01) THEN             # KEY 不可空白
               CONTINUE WHILE
           END IF
        END IF
        INSERT INTO nms_file VALUES(g_nms.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nms_file",g_nms.nms01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        ELSE
            LET g_nms_t.* = g_nms.*                # 保存上筆資料
            SELECT nms01 INTO g_nms.nms01 FROM nms_file
                WHERE nms01 = g_nms.nms01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i040_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-680107 VARCHAR(1)
        l_dir           LIKE type_file.chr1,    #判斷是否 #No.FUN-680107 VARCHAR(1)
        l_actname	LIKE type_file.chr50, 	#No.FUN-680107 VARCHAR(30)
        l_n             LIKE type_file.num5     #No.FUN-680107 SMALLINT
    DEFINE  l_aag05     LIKE aag_file.aag05     #No.FUN-B40004 
 
    INPUT BY NAME g_nms.nmsoriu,g_nms.nmsorig,
        g_nms.nms01,g_nms.nms12,g_nms.nms13, g_nms.nms14,g_nms.nms15,
        g_nms.nms16,g_nms.nms17,g_nms.nms18, g_nms.nms21,g_nms.nms22,
        g_nms.nms23,g_nms.nms24,g_nms.nms25,g_nms.nms26,g_nms.nms27,
       #No.+099 010505 by plum
       #g_nms.nms50,g_nms.nms51,g_nms.nms55,
        g_nms.nms50,g_nms.nms51,g_nms.nms28,g_nms.nms55,
       #No.+099 ..end
        g_nms.nms56,g_nms.nms57,g_nms.nms58,g_nms.nms59,
        g_nms.nms60,g_nms.nms61,g_nms.nms62,g_nms.nms63,g_nms.nms64,g_nms.nms65,
        g_nms.nms66,g_nms.nms67,g_nms.nms69,g_nms.nms68,g_nms.nms70,g_nms.nms71,
# NO.FUN-680034 --start--
        g_nms.nms121,g_nms.nms131, g_nms.nms141,g_nms.nms151,
        g_nms.nms161,g_nms.nms171,g_nms.nms181, g_nms.nms211,g_nms.nms221,
        g_nms.nms231,g_nms.nms241,g_nms.nms251,g_nms.nms261,g_nms.nms271,
        g_nms.nms501,g_nms.nms511,g_nms.nms281,g_nms.nms551,
        g_nms.nms561,g_nms.nms571,g_nms.nms581,g_nms.nms591,
        g_nms.nms601,g_nms.nms611,g_nms.nms621,g_nms.nms631,g_nms.nms641,g_nms.nms651,
        g_nms.nms661,g_nms.nms671,g_nms.nms691,g_nms.nms681,g_nms.nms701,g_nms.nms711,
# NO.FUN-680034 ---end---
        g_nms.nmsuser,g_nms.nmsgrup,g_nms.nmsmodu,g_nms.nmsdate,g_nms.nmsacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i040_set_entry(p_cmd)
            CALL i040_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD nms01            #部門編號
            IF NOT cl_null(g_nms.nms01) THEN
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_nms.nms01 != g_nms01_t) THEN
                   SELECT count(*) INTO l_n FROM nms_file
                    WHERE nms01 = g_nms.nms01
                   IF l_n > 0 THEN                  # Duplicated
                      CALL cl_err(g_nms.nms01,-239,1)
                      LET g_nms.nms01 = g_nms01_t
                      DISPLAY BY NAME g_nms.nms01
                      NEXT FIELD nms01
                   END IF
               END IF
               IF cl_null(g_nms_o.nms01) THEN
                  CALL i040_nms01('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_nms.nms01,g_errno,0)
                     LET g_nms.nms01 = g_nms_o.nms01
                     DISPLAY BY NAME g_nms.nms01
                     CALL i040_nms01('a')
                     NEXT FIELD nms01
                  END IF
                END IF
            END IF
            LET g_nms_o.nms01 = g_nms.nms01

        AFTER FIELD nms12
           IF NOT cl_null(g_nms.nms12) THEN
   	      IF NOT i040_actchk(g_nms.nms12,g_aza.aza81) THEN 
#FUN-B20073 --begin--
             CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms12,'23',g_aza.aza81)   
                    RETURNING g_nms.nms12
             DISPLAY BY NAME g_nms.nms12 
#FUN-B20073 --end--   	      
   	        NEXT FIELD nms12 
   	      END IF   #No.FUN-740028
              #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms12
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms12,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms12,g_errno,0)
                  DISPLAY BY NAME g_nms.nms12
                  NEXT FIELD nms12
               END IF
               #No.FUN-B40004  --End
           END IF
          
        AFTER FIELD nms13
           IF NOT cl_null(g_nms.nms13) THEN
	      IF NOT i040_actchk(g_nms.nms13,g_aza.aza81) THEN 
#FUN-B20073 --begin--
            CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms13,'23',g_aza.aza81)  
                    RETURNING g_nms.nms13
            DISPLAY BY NAME g_nms.nms13 
#FUN-B20073 --end--	        
	         NEXT FIELD nms13 
	       END IF   #No.FUN-740028
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms13
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms13,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms13,g_errno,0)
                  DISPLAY BY NAME g_nms.nms13
                  NEXT FIELD nms13
               END IF
               #No.FUN-B40004  --End
           END IF
        
        AFTER FIELD nms14
           IF NOT cl_null(g_nms.nms14) THEN
	      IF NOT i040_actchk(g_nms.nms14,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms14,'23',g_aza.aza81) 
                    RETURNING g_nms.nms14
           DISPLAY BY NAME g_nms.nms14 
#FUN-B20073 --end--	        
	         NEXT FIELD nms14 
	      END IF   #No.FUN-740028
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms14
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms14,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms14,g_errno,0)
                  DISPLAY BY NAME g_nms.nms14
                  NEXT FIELD nms14
               END IF
               #No.FUN-B40004  --End
           END IF
        
        AFTER FIELD nms15
           IF NOT cl_null(g_nms.nms15) THEN
	      IF NOT i040_actchk(g_nms.nms15,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms15,'23',g_aza.aza81)   
                    RETURNING g_nms.nms15
           DISPLAY BY NAME g_nms.nms15 
#FUN-B20073 --end--	      
	         NEXT FIELD nms15 
	      END IF   #No.FUN-740028
	             #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms15
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms15,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms15,g_errno,0)
                  DISPLAY BY NAME g_nms.nms15
                  NEXT FIELD nms15
               END IF
               #No.FUN-B40004  --End
           END IF
        
        AFTER FIELD nms16
           IF NOT cl_null(g_nms.nms16) THEN
	      IF NOT i040_actchk(g_nms.nms16,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms16,'23',g_aza.aza81) 
                    RETURNING g_nms.nms16
           DISPLAY BY NAME g_nms.nms16 
#FUN-B20073 --end--	      
	        NEXT FIELD nms16 
	      END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms16
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms16,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms16,g_errno,0)
                  DISPLAY BY NAME g_nms.nms16
                  NEXT FIELD nms16
               END IF
               #No.FUN-B40004  --End
           END IF
        
        AFTER FIELD nms17
           IF NOT cl_null(g_nms.nms17) THEN
	      IF NOT i040_actchk(g_nms.nms17,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms17,'23',g_aza.aza81)   
                    RETURNING g_nms.nms17
           DISPLAY BY NAME g_nms.nms17 
#FUN-B20073 --end--	      
	         NEXT FIELD nms17 
	      END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms17
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms17,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms17,g_errno,0)
                  DISPLAY BY NAME g_nms.nms17
                  NEXT FIELD nms17
               END IF
               #No.FUN-B40004  --End
           END IF
        
        AFTER FIELD nms18
           IF NOT cl_null(g_nms.nms18) THEN
	      IF NOT i040_actchk(g_nms.nms18,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms18,'23',g_aza.aza81) 
                    RETURNING g_nms.nms18
           DISPLAY BY NAME g_nms.nms18 
#FUN-B20073 --end--	      
	         NEXT FIELD nms18 
	      END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms18
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms18,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms18,g_errno,0)
                  DISPLAY BY NAME g_nms.nms18
                  NEXT FIELD nms18
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms21
           IF NOT cl_null(g_nms.nms21) THEN
	      IF NOT i040_actchk(g_nms.nms21,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms21,'23',g_aza.aza81)   
                    RETURNING g_nms.nms21
           DISPLAY BY NAME g_nms.nms21 
#FUN-B20073 --end--	      
	         NEXT FIELD nms21 
	      END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms21
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms21,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms21,g_errno,0)
                  DISPLAY BY NAME g_nms.nms21
                  NEXT FIELD nms21
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms22
           IF NOT cl_null(g_nms.nms22) THEN
	      IF NOT i040_actchk(g_nms.nms22,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms22,'23',g_aza.aza81)   
                    RETURNING g_nms.nms22
           DISPLAY BY NAME g_nms.nms22 
#FUN-B20073 --end--	      
	         NEXT FIELD nms22 
	      END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms22
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms22,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms22,g_errno,0)
                  DISPLAY BY NAME g_nms.nms22
                  NEXT FIELD nms22
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms23
           IF NOT cl_null(g_nms.nms23) THEN
	      IF NOT i040_actchk(g_nms.nms23,g_aza.aza81) THEN 
#FUN-B20073 --begin--
           CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms23,'23',g_aza.aza81)  
                    RETURNING g_nms.nms23
           DISPLAY BY NAME g_nms.nms23 
#FUN-B20073 --end--	      
	         NEXT FIELD nms23 
	      END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms23
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms23,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms23,g_errno,0)
                  DISPLAY BY NAME g_nms.nms23
                  NEXT FIELD nms23
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms24
           IF NOT cl_null(g_nms.nms24) THEN
	      IF NOT i040_actchk(g_nms.nms24,g_aza.aza81) THEN 
#FUN-B20073 --begin--
          CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms24,'23',g_aza.aza81)    
                    RETURNING g_nms.nms24
          DISPLAY BY NAME g_nms.nms24 
#FUN-B20073 --end--	      
	        NEXT FIELD nms24 
	      END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms24
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms24,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms24,g_errno,0)
                  DISPLAY BY NAME g_nms.nms24
                  NEXT FIELD nms24
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms25
           IF NOT cl_null(g_nms.nms25) THEN
	      IF NOT i040_actchk(g_nms.nms25,g_aza.aza81) THEN 
#FUN-B20073 --begin--
         CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms25,'23',g_aza.aza81)  
                 RETURNING g_nms.nms25
         DISPLAY BY NAME g_nms.nms25
#FUN-B20073 --end--	      
	      NEXT FIELD nms25 END IF   #No.FUN-740028
	           #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms25
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms25,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms25,g_errno,0)
                  DISPLAY BY NAME g_nms.nms25
                  NEXT FIELD nms25
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms26
           IF NOT cl_null(g_nms.nms26) THEN
	      IF NOT i040_actchk(g_nms.nms26,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms26,'23',g_aza.aza81)  
                    RETURNING g_nms.nms26
               DISPLAY BY NAME g_nms.nms26 
#FUN-B20073 --end--	      
	      NEXT FIELD nms26 END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms26
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms26,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms26,g_errno,0)
                  DISPLAY BY NAME g_nms.nms26
                  NEXT FIELD nms26
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms27
           IF NOT cl_null(g_nms.nms27) THEN
	      IF NOT i040_actchk(g_nms.nms27,g_aza.aza81) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms27,'23',g_aza.aza81) 
                    RETURNING g_nms.nms27
               DISPLAY BY NAME g_nms.nms27 
#FUN-B20073 --end--	      
	      NEXT FIELD nms27 END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms27
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms27,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms27,g_errno,0)
                  DISPLAY BY NAME g_nms.nms27
                  NEXT FIELD nms27
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms28
           IF NOT cl_null(g_nms.nms28) THEN
	      IF NOT i040_actchk(g_nms.nms28,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms28,'23',g_aza.aza81) 
                    RETURNING g_nms.nms28
               DISPLAY BY NAME g_nms.nms28 
#FUN-B20073 --end--	      
	      NEXT FIELD nms28 END IF   #No.FUN-740028
	           #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms28
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms28,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms28,g_errno,0)
                  DISPLAY BY NAME g_nms.nms28
                  NEXT FIELD nms28
               END IF
               #No.FUN-B40004  --End
           END IF
        
        AFTER FIELD nms50
           IF NOT cl_null(g_nms.nms50) THEN
	      IF NOT i040_actchk(g_nms.nms50,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms50,'23',g_aza.aza81) 
                    RETURNING g_nms.nms50
               DISPLAY BY NAME g_nms.nms50 
#FUN-B20073 --end--	      
	      NEXT FIELD nms50 END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms50
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms50,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms50,g_errno,0)
                  DISPLAY BY NAME g_nms.nms50
                  NEXT FIELD nms50
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms51
           IF NOT cl_null(g_nms.nms51) THEN
	      IF NOT i040_actchk(g_nms.nms51,g_aza.aza81) THEN 
#FUN-B20073 --begin--
       CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms51,'23',g_aza.aza81) 
                    RETURNING g_nms.nms51
               DISPLAY BY NAME g_nms.nms51 
#FUN-B20073 --end--	      
	      NEXT FIELD nms51 END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms51
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms51,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms51,g_errno,0)
                  DISPLAY BY NAME g_nms.nms51
                  NEXT FIELD nms51
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms55
           IF NOT cl_null(g_nms.nms55) THEN
	      IF NOT i040_actchk(g_nms.nms55,g_aza.aza81) THEN
#FUN-B20073 --begin--
     CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms55,'23',g_aza.aza81) 
                    RETURNING g_nms.nms55
               DISPLAY BY NAME g_nms.nms55 
#FUN-B20073 --end--	      
	       NEXT FIELD nms55 END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms55
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms55,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms55,g_errno,0)
                  DISPLAY BY NAME g_nms.nms55
                  NEXT FIELD nms55
               END IF
               #No.FUN-B40004  --End  
           END IF
        AFTER FIELD nms56
           IF NOT cl_null(g_nms.nms56) THEN
	      IF NOT i040_actchk(g_nms.nms56,g_aza.aza81) THEN 
#FUN-B20073 --begin--
    CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms56,'23',g_aza.aza81) 
                    RETURNING g_nms.nms56
               DISPLAY BY NAME g_nms.nms56 
#FUN-B20073 --end--	      
	      NEXT FIELD nms56 END IF   #No.FUN-740028
	             #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms56
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms56,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms56,g_errno,0)
                  DISPLAY BY NAME g_nms.nms56
                  NEXT FIELD nms56
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms57
           IF NOT cl_null(g_nms.nms57) THEN
   	      IF NOT i040_actchk(g_nms.nms57,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms57,'23',g_aza.aza81)   
                    RETURNING g_nms.nms57
               DISPLAY BY NAME g_nms.nms57 
#FUN-B20073 --end--   	      
   	      NEXT FIELD nms57 END IF   #No.FUN-740028
   	          #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms57
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms57,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms57,g_errno,0)
                  DISPLAY BY NAME g_nms.nms57
                  NEXT FIELD nms57
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms58
           IF NOT cl_null(g_nms.nms58) THEN
	      IF NOT i040_actchk(g_nms.nms58,g_aza.aza81) THEN
#FUN-B20073 --begin--
    CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms58,'23',g_aza.aza81)   
                    RETURNING g_nms.nms58
               DISPLAY BY NAME g_nms.nms58 
#FUN-B20073 --end--	      
	       NEXT FIELD nms58 END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms58
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms58,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms58,g_errno,0)
                  DISPLAY BY NAME g_nms.nms58
                  NEXT FIELD nms58
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms59
           IF NOT cl_null(g_nms.nms59) THEN
    	      IF NOT i040_actchk(g_nms.nms59,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms59,'23',g_aza.aza81) 
                    RETURNING g_nms.nms59
               DISPLAY BY NAME g_nms.nms59
#FUN-B20073 --end--    	      
    	      NEXT FIELD nms59 END IF   #No.FUN-740028
    	        #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms59
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms59,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms59,g_errno,0)
                  DISPLAY BY NAME g_nms.nms59
                  NEXT FIELD nms59
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms60
           IF NOT cl_null(g_nms.nms60) THEN
	      IF NOT i040_actchk(g_nms.nms60,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms60,'23',g_aza.aza81)  
                    RETURNING g_nms.nms60
               DISPLAY BY NAME g_nms.nms60 
#FUN-B20073 --end--	      
	      NEXT FIELD nms60 END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms60
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms60,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms60,g_errno,0)
                  DISPLAY BY NAME g_nms.nms60
                  NEXT FIELD nms60
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms61
           IF NOT cl_null(g_nms.nms61) THEN
	     IF NOT i040_actchk(g_nms.nms61,g_aza.aza81) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms61,'23',g_aza.aza81) 
                    RETURNING g_nms.nms61
               DISPLAY BY NAME g_nms.nms61 
#FUN-B20073 --end--	     
	     NEXT FIELD nms61 END IF   #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms61
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms61,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms61,g_errno,0)
                  DISPLAY BY NAME g_nms.nms61
                  NEXT FIELD nms61
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms62
           IF NOT cl_null(g_nms.nms62) THEN
	      IF NOT i040_actchk(g_nms.nms62,g_aza.aza81) THEN
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms62,'23',g_aza.aza81) 
                    RETURNING g_nms.nms62
               DISPLAY BY NAME g_nms.nms62 
#FUN-B20073 --end--	      
	       NEXT FIELD nms62 END IF  #No.FUN-740028
	             #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms62
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms62,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms62,g_errno,0)
                  DISPLAY BY NAME g_nms.nms62
                  NEXT FIELD nms62
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms63
           IF NOT cl_null(g_nms.nms63) THEN
	      IF NOT i040_actchk(g_nms.nms63,g_aza.aza81) THEN 
#FUN-B20073 --begin--
   CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms63,'23',g_aza.aza81)  
                    RETURNING g_nms.nms63
               DISPLAY BY NAME g_nms.nms63 
#FUN-B20073 --end--	      
	      NEXT FIELD nms63 END IF  #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms63
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms63,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms63,g_errno,0)
                  DISPLAY BY NAME g_nms.nms63
                  NEXT FIELD nms63
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms64
           IF NOT cl_null(g_nms.nms64) THEN
	      IF NOT i040_actchk(g_nms.nms64,g_aza.aza81) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms64,'23',g_aza.aza81)   
                    RETURNING g_nms.nms64
               DISPLAY BY NAME g_nms.nms64 
#FUN-B20073 --end-	      
	      NEXT FIELD nms64 END IF  #No.FUN-740028
	           #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms64
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms64,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms64,g_errno,0)
                  DISPLAY BY NAME g_nms.nms64
                  NEXT FIELD nms64
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms65
           IF NOT cl_null(g_nms.nms65) THEN
	      IF NOT i040_actchk(g_nms.nms65,g_aza.aza81) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms65,'23',g_aza.aza81) 
                    RETURNING g_nms.nms65
               DISPLAY BY NAME g_nms.nms65 
#FUN-B20073 --end--	     
	      NEXT FIELD nms65 END IF  #No.FUN-740028
	             #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms65
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms65,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms65,g_errno,0)
                  DISPLAY BY NAME g_nms.nms65
                  NEXT FIELD nms65
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms66
           IF NOT cl_null(g_nms.nms66) THEN
	      IF NOT i040_actchk(g_nms.nms66,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms66,'23',g_aza.aza81) 
                    RETURNING g_nms.nms66
               DISPLAY BY NAME g_nms.nms66 
#FUN-B20073 --end--	      
	      NEXT FIELD nms66 END IF  #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms66
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms66,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms66,g_errno,0)
                  DISPLAY BY NAME g_nms.nms66
                  NEXT FIELD nms66
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms67
           IF NOT cl_null(g_nms.nms67) THEN
	      IF NOT i040_actchk(g_nms.nms67,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms67,'23',g_aza.aza81)  
                    RETURNING g_nms.nms67
               DISPLAY BY NAME g_nms.nms67 
#FUN-B20073 --end--	      
	      NEXT FIELD nms67 END IF  #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms67
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms67,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms67,g_errno,0)
                  DISPLAY BY NAME g_nms.nms67
                  NEXT FIELD nms67
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms69
           IF NOT cl_null(g_nms.nms69) THEN
	      IF NOT i040_actchk(g_nms.nms69,g_aza.aza81) THEN 
#FUN-B20073 --begin--
   CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms69,'23',g_aza.aza81)  
                    RETURNING g_nms.nms69
               DISPLAY BY NAME g_nms.nms69 
#FUN-B20073 --end--	      
	      NEXT FIELD nms69 END IF  #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms69
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms69,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms69,g_errno,0)
                  DISPLAY BY NAME g_nms.nms69
                  NEXT FIELD nms69
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms68
           IF NOT cl_null(g_nms.nms68) THEN
	      IF NOT i040_actchk(g_nms.nms68,g_aza.aza81) THEN
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms68,'23',g_aza.aza81) 
                    RETURNING g_nms.nms68
               DISPLAY BY NAME g_nms.nms68 
#FUN-B20073 --end--	      
	       NEXT FIELD nms68 END IF  #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms68
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms68,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms68,g_errno,0)
                  DISPLAY BY NAME g_nms.nms68
                  NEXT FIELD nms68
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms70
           IF NOT cl_null(g_nms.nms70) THEN
	      IF NOT i040_actchk(g_nms.nms70,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms70,'23',g_aza.aza81)   
                    RETURNING g_nms.nms70
               DISPLAY BY NAME g_nms.nms70 
#FUN-B20073 --end--	      
	      NEXT FIELD nms70 END IF  #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms70
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms70,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms70,g_errno,0)
                  DISPLAY BY NAME g_nms.nms70
                  NEXT FIELD nms70
               END IF
               #No.FUN-B40004  --End
           END IF
        AFTER FIELD nms71
           IF NOT cl_null(g_nms.nms71) THEN
	      IF NOT i040_actchk(g_nms.nms71,g_aza.aza81) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms71,'23',g_aza.aza81)   
                    RETURNING g_nms.nms71
               DISPLAY BY NAME g_nms.nms71 
#FUN-B20073 --end--	      
	      NEXT FIELD nms71 END IF  #No.FUN-740028
	            #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms71
                  AND aag00 = g_aza.aza81
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms71,g_nms.nms01,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms71,g_errno,0)
                  DISPLAY BY NAME g_nms.nms71
                  NEXT FIELD nms71
               END IF
               #No.FUN-B40004  --End
           END IF
            
# NO.FUN-680034 --start--
       AFTER FIELD nms121
          IF NOT cl_null(g_nms.nms121) THEN
             IF NOT i040_actchk(g_nms.nms121,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms121,'23',g_aza.aza82)    
                   RETURNING g_nms.nms121
              DISPLAY BY NAME g_nms.nms121 
#FUN-B20073 --end--             
             NEXT FIELD nms121 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms121
                  AND aag00 = g_aza.aza82
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms121,g_nms.nms01,g_aza.aza82)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms121,g_errno,0)
                  DISPLAY BY NAME g_nms.nms121
                  NEXT FIELD nms121
               END IF
               #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms131
          IF NOT cl_null(g_nms.nms131) THEN
             IF NOT i040_actchk(g_nms.nms131,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms131,'23',g_aza.aza82)   
                   RETURNING g_nms.nms131
              DISPLAY BY NAME g_nms.nms131 
#FUN-B20073 --end--             
             NEXT FIELD nms131 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms131
                  AND aag00 = g_aza.aza82
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms131,g_nms.nms01,g_aza.aza82)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms131,g_errno,0)
                  DISPLAY BY NAME g_nms.nms131
                  NEXT FIELD nms131
               END IF
               #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms141
          IF NOT cl_null(g_nms.nms141) THEN
             IF NOT i040_actchk(g_nms.nms141,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms141,'23',g_aza.aza82)  
                  RETURNING g_nms.nms141
             DISPLAY BY NAME g_nms.nms141
#FUN-B20073 --end--             
             NEXT FIELD nms141 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms141
                  AND aag00 = g_aza.aza82
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms141,g_nms.nms01,g_aza.aza82)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms141,g_errno,0)
                  DISPLAY BY NAME g_nms.nms141
                  NEXT FIELD nms141
               END IF
               #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms151
          IF NOT cl_null(g_nms.nms151) THEN
             IF NOT i040_actchk(g_nms.nms151,g_aza.aza82) THEN 
#FUN-B20073 --begin--
CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms151,'23',g_aza.aza82)    
                  RETURNING g_nms.nms151
             DISPLAY BY NAME g_nms.nms151 
#FUN-B20073 --end--
             NEXT FIELD nms151 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_nms.nms151
                  AND aag00 = g_aza.aza82
              #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
               IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_nms.nms151,g_nms.nms01,g_aza.aza82)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nms.nms151,g_errno,0)
                  DISPLAY BY NAME g_nms.nms151
                  NEXT FIELD nms151
               END IF
               #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms161
          IF NOT cl_null(g_nms.nms161) THEN
             IF NOT i040_actchk(g_nms.nms161,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms161,'23',g_aza.aza82)    
                  RETURNING g_nms.nms161
             DISPLAY BY NAME g_nms.nms161 
#FUN-B20073 --end--             
             NEXT FIELD nms161 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms161
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms161,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms161,g_errno,0)
                DISPLAY BY NAME g_nms.nms161
                NEXT FIELD nms161
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms171
          IF NOT cl_null(g_nms.nms171) THEN
             IF NOT i040_actchk(g_nms.nms171,g_aza.aza82) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms171,'23',g_aza.aza82)     
                  RETURNING g_nms.nms171
             DISPLAY BY NAME g_nms.nms171
#FUN-B20073 --end--             
             NEXT FIELD nms171 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms171
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms171,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms171,g_errno,0)
                DISPLAY BY NAME g_nms.nms171
                NEXT FIELD nms171
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms181
          IF NOT cl_null(g_nms.nms181) THEN
             IF NOT i040_actchk(g_nms.nms181,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms181,'23',g_aza.aza82)    
                  RETURNING g_nms.nms181
             DISPLAY BY NAME g_nms.nms181 
#FUN-B20073 --end--             
             NEXT FIELD nms181 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms181
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms181,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms181,g_errno,0)
                DISPLAY BY NAME g_nms.nms181
                NEXT FIELD nms181
             END IF
             #No.FUN-B40004  --End 
          END IF
                   
       AFTER FIELD nms211
          IF NOT cl_null(g_nms.nms211) THEN
             IF NOT i040_actchk(g_nms.nms211,g_aza.aza82) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms211,'23',g_aza.aza82)    
                  RETURNING g_nms.nms211
             DISPLAY BY NAME g_nms.nms211 
#FUN-B20073 --end--             
             NEXT FIELD nms211 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms211
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms211,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms211,g_errno,0)
                DISPLAY BY NAME g_nms.nms211
                NEXT FIELD nms211
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms221
          IF NOT cl_null(g_nms.nms221) THEN
             IF NOT i040_actchk(g_nms.nms221,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms221,'23',g_aza.aza82)   
                  RETURNING g_nms.nms221
             DISPLAY BY NAME g_nms.nms221 
#FUN-B20073 --end--             
             NEXT FIELD nms221 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms221
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms221,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms221,g_errno,0)
                DISPLAY BY NAME g_nms.nms221
                NEXT FIELD nms221
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms231
          IF NOT cl_null(g_nms.nms231) THEN
             IF NOT i040_actchk(g_nms.nms231,g_aza.aza82) THEN
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms231,'23',g_aza.aza82)    
                  RETURNING g_nms.nms231
             DISPLAY BY NAME g_nms.nms231
#FUN-B20073 --end--             
              NEXT FIELD nms231 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms231
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms231,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms231,g_errno,0)
                DISPLAY BY NAME g_nms.nms231
                NEXT FIELD nms231
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms241
          IF NOT cl_null(g_nms.nms241) THEN
             IF NOT i040_actchk(g_nms.nms241,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms241,'23',g_aza.aza82)    
                  RETURNING g_nms.nms241
             DISPLAY BY NAME g_nms.nms241 
#FUN-B20073 --end--             
             NEXT FIELD nms241 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms241
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms241,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms241,g_errno,0)
                DISPLAY BY NAME g_nms.nms241
                NEXT FIELD nms241
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms251
          IF NOT cl_null(g_nms.nms251) THEN
             IF NOT i040_actchk(g_nms.nms251,g_aza.aza82) THEN
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms251,'23',g_aza.aza82)   
                  RETURNING g_nms.nms251
             DISPLAY BY NAME g_nms.nms251 
#FUN-B20073 --end--             
              NEXT FIELD nms251 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms251
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms251,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms251,g_errno,0)
                DISPLAY BY NAME g_nms.nms251
                NEXT FIELD nms251
             END IF
             #No.FUN-B40004  --End
          END IF
                  
       AFTER FIELD nms261
          IF NOT cl_null(g_nms.nms261) THEN
             IF NOT i040_actchk(g_nms.nms261,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms261,'23',g_aza.aza82)    
                  RETURNING g_nms.nms261
             DISPLAY BY NAME g_nms.nms261 
#FUN-B20073 --end--             
             NEXT FIELD nms261 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms261
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms261,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms261,g_errno,0)
                DISPLAY BY NAME g_nms.nms261
                NEXT FIELD nms261
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms271
          IF NOT cl_null(g_nms.nms271) THEN
             IF NOT i040_actchk(g_nms.nms271,g_aza.aza82) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms271,'23',g_aza.aza82)    
                  RETURNING g_nms.nms271
             DISPLAY BY NAME g_nms.nms271 
#FUN-B20073 --end--             
             NEXT FIELD nms271 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms271
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms271,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms271,g_errno,0)
                DISPLAY BY NAME g_nms.nms271
                NEXT FIELD nms271
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms501
          IF NOT cl_null(g_nms.nms501) THEN
             IF NOT i040_actchk(g_nms.nms501,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms501,'23',g_aza.aza82)    
                  RETURNING g_nms.nms501
             DISPLAY BY NAME g_nms.nms501 
#FUN-B20073 --end--             
             NEXT FIELD nms501 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms501
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms501,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms501,g_errno,0)
                DISPLAY BY NAME g_nms.nms501
                NEXT FIELD nms501
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms511
          IF NOT cl_null(g_nms.nms511) THEN
             IF NOT i040_actchk(g_nms.nms511,g_aza.aza82) THEN
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms511,'23',g_aza.aza82)     
                  RETURNING g_nms.nms511
             DISPLAY BY NAME g_nms.nms511 
#FUN-B20073 --end--             
              NEXT FIELD nms511 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms511
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms511,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms511,g_errno,0)
                DISPLAY BY NAME g_nms.nms511
                NEXT FIELD nms511
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms281
          IF NOT cl_null(g_nms.nms281) THEN
             IF NOT i040_actchk(g_nms.nms281,g_aza.aza82) THEN
#FUN-B20073 --begin--
   CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms281,'23',g_aza.aza82)     
                  RETURNING g_nms.nms281
             DISPLAY BY NAME g_nms.nms281
#FUN-B20073 --end--             
              NEXT FIELD nms281 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms281
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms281,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms281,g_errno,0)
                DISPLAY BY NAME g_nms.nms281
                NEXT FIELD nms281
             END IF
             #No.FUN-B40004  --End
          END IF
          
       AFTER FIELD nms551
          IF NOT cl_null(g_nms.nms551) THEN
             IF NOT i040_actchk(g_nms.nms551,g_aza.aza82) THEN
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms551,'23',g_aza.aza82)    
                  RETURNING g_nms.nms551
             DISPLAY BY NAME g_nms.nms551 
#FUN-B20073 --end--             
              NEXT FIELD nms551 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms551
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms551,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms551,g_errno,0)
                DISPLAY BY NAME g_nms.nms551
                NEXT FIELD nms551
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms561
          IF NOT cl_null(g_nms.nms561) THEN
             IF NOT i040_actchk(g_nms.nms561,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms561,'23',g_aza.aza82)      
                  RETURNING g_nms.nms561
             DISPLAY BY NAME g_nms.nms561 
#FUN-B20073 --end--             
             NEXT FIELD nms561 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
            #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms561
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms561,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms561,g_errno,0)
                DISPLAY BY NAME g_nms.nms561
                NEXT FIELD nms561
             END IF
             #No.FUN-B40004  --End
         END IF
       AFTER FIELD nms571
          IF NOT cl_null(g_nms.nms571) THEN
             IF NOT i040_actchk(g_nms.nms571,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms571,'23',g_aza.aza82)    
                  RETURNING g_nms.nms571
             DISPLAY BY NAME g_nms.nms571 
#FUN-B20073 --end--             
             NEXT FIELD nms571 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms571
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms571,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms571,g_errno,0)
                DISPLAY BY NAME g_nms.nms571
                NEXT FIELD nms571
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms581
          IF NOT cl_null(g_nms.nms581) THEN
             IF NOT i040_actchk(g_nms.nms581,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms581,'23',g_aza.aza82)     
                  RETURNING g_nms.nms581
             DISPLAY BY NAME g_nms.nms581 
#FUN-B20073 --end--             
             NEXT FIELD nms581 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms581
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms581,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms581,g_errno,0)
                DISPLAY BY NAME g_nms.nms581
                NEXT FIELD nms581
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms591
          IF NOT cl_null(g_nms.nms591) THEN
             IF NOT i040_actchk(g_nms.nms591,g_aza.aza82) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms591,'23',g_aza.aza82)   
                  RETURNING g_nms.nms591
             DISPLAY BY NAME g_nms.nms591 
#FUN-B20073 --end--             
             NEXT FIELD nms591 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms591
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms591,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms591,g_errno,0)
                DISPLAY BY NAME g_nms.nms591
                NEXT FIELD nms591
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms601
          IF NOT cl_null(g_nms.nms601) THEN
             IF NOT i040_actchk(g_nms.nms601,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms601,'23',g_aza.aza82)    
                  RETURNING g_nms.nms601
             DISPLAY BY NAME g_nms.nms601 
#FUN-B20073 --end--             
             NEXT FIELD nms601 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms601
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms601,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms601,g_errno,0)
                DISPLAY BY NAME g_nms.nms601
                NEXT FIELD nms601
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms611
          IF NOT cl_null(g_nms.nms611) THEN
             IF NOT i040_actchk(g_nms.nms611,g_aza.aza82) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms611,'23',g_aza.aza82)  
                  RETURNING g_nms.nms611
             DISPLAY BY NAME g_nms.nms611 
#FUN-B20073 --end--             
             NEXT FIELD nms611 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms611
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms611,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms611,g_errno,0)
                DISPLAY BY NAME g_nms.nms611
                NEXT FIELD nms611
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms621
          IF NOT cl_null(g_nms.nms621) THEN
             IF NOT i040_actchk(g_nms.nms621,g_aza.aza82) THEN
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms621,'23',g_aza.aza82)      
                  RETURNING g_nms.nms621
             DISPLAY BY NAME g_nms.nms621
#FUN-B20073 --end--             
              NEXT FIELD nms621 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms621
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms621,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms621,g_errno,0)
                DISPLAY BY NAME g_nms.nms621
                NEXT FIELD nms621
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms631
          IF NOT cl_null(g_nms.nms631) THEN
             IF NOT i040_actchk(g_nms.nms631,g_aza.aza82) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms631,'23',g_aza.aza82)    
                  RETURNING g_nms.nms631
             DISPLAY BY NAME g_nms.nms631
#FUN-B20073 --end--             
             NEXT FIELD nms631 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms631
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms631,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms631,g_errno,0)
                DISPLAY BY NAME g_nms.nms631
                NEXT FIELD nms631
             END IF
             #No.FUN-B40004  --End
          END IF
        
       AFTER FIELD nms641
          IF NOT cl_null(g_nms.nms641) THEN
             IF NOT i040_actchk(g_nms.nms641,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms641,'23',g_aza.aza82)     # 
                  RETURNING g_nms.nms641
             DISPLAY BY NAME g_nms.nms641 
#FUN-B20073 --end--             
             NEXT FIELD nms641 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms641
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms641,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms641,g_errno,0)
                DISPLAY BY NAME g_nms.nms641
                NEXT FIELD nms641
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms651
          IF NOT cl_null(g_nms.nms651) THEN
             IF NOT i040_actchk(g_nms.nms651,g_aza.aza82) THEN 
#FUN-B20073 --begin--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms651,'23',g_aza.aza82)     
                  RETURNING g_nms.nms651
             DISPLAY BY NAME g_nms.nms651 
#FUN-B20073 --end--             
             NEXT FIELD nms651 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms651
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms651,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms651,g_errno,0)
                DISPLAY BY NAME g_nms.nms651
                NEXT FIELD nms651
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms661
          IF NOT cl_null(g_nms.nms661) THEN
             IF NOT i040_actchk(g_nms.nms661,g_aza.aza82) THEN 
#FUN-B20073 --beign--
  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms661,'23',g_aza.aza82)     
                  RETURNING g_nms.nms661
             DISPLAY BY NAME g_nms.nms661 
#FUN-B20073 --end--             
             NEXT FIELD nms661 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms661
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms661,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms661,g_errno,0)
                DISPLAY BY NAME g_nms.nms661
                NEXT FIELD nms661
             END IF
             #No.FUN-B40004  --End          
          END IF

       AFTER FIELD nms671
          IF NOT cl_null(g_nms.nms671) THEN
             IF NOT i040_actchk(g_nms.nms671,g_aza.aza82) THEN 
#FUN-B20073 --begin--  
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms671,'23',g_aza.aza82)   
                  RETURNING g_nms.nms671
             DISPLAY BY NAME g_nms.nms671
#FUN-20073 --end--             
             NEXT FIELD nms671 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms671
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms671,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms671,g_errno,0)
                DISPLAY BY NAME g_nms.nms671
                NEXT FIELD nms671
             END IF
             #No.FUN-B40004  --End
          END IF
          
       AFTER FIELD nms691
          IF NOT cl_null(g_nms.nms691) THEN
             IF NOT i040_actchk(g_nms.nms691,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms691,'23',g_aza.aza82)     
                  RETURNING g_nms.nms691
             DISPLAY BY NAME g_nms.nms691 
#FUN-B20073 --end--             
             NEXT FIELD nms691 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms691
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms691,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms691,g_errno,0)
                DISPLAY BY NAME g_nms.nms691
                NEXT FIELD nms691
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms681
          IF NOT cl_null(g_nms.nms681) THEN
             IF NOT i040_actchk(g_nms.nms681,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms681,'23',g_aza.aza82)    
                  RETURNING g_nms.nms681
             DISPLAY BY NAME g_nms.nms681 
#FUN-B20073 --end--             
             NEXT FIELD nms681 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms681
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms681,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms681,g_errno,0)
                DISPLAY BY NAME g_nms.nms681
                NEXT FIELD nms681
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms701
          IF NOT cl_null(g_nms.nms701) THEN
             IF NOT i040_actchk(g_nms.nms701,g_aza.aza82) THEN 
#FUN-B20073 --begin--
CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms701,'23',g_aza.aza82)   
                  RETURNING g_nms.nms701
             DISPLAY BY NAME g_nms.nms701
#FUN-B20073 --end--             
             NEXT FIELD nms701 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms701
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms701,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms701,g_errno,0)
                DISPLAY BY NAME g_nms.nms701
                NEXT FIELD nms701
             END IF
             #No.FUN-B40004  --End
          END IF
       AFTER FIELD nms711
          IF NOT cl_null(g_nms.nms711) THEN
             IF NOT i040_actchk(g_nms.nms711,g_aza.aza82) THEN 
#FUN-B20073 --begin--
 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nms.nms711,'23',g_aza.aza82)     
                  RETURNING g_nms.nms711
             DISPLAY BY NAME g_nms.nms711 
#FUN-B20073 --end--             
             NEXT FIELD nms711 END IF  #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82
             #No.FUN-B40004  --Begin
             LET l_aag05=''
             SELECT aag05 INTO l_aag05 FROM aag_file
              WHERE aag01 = g_nms.nms711
                AND aag00 = g_aza.aza82
            #IF l_aag05 = 'Y' THEN                               #MOD-BC0228 mark
             IF l_aag05 = 'Y'  AND g_nmz.nmz11 = 'Y' THEN        #MOD-BC0228 add
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                IF g_aaz.aaz90 !='Y' THEN
                   LET g_errno = ' '
                   CALL s_chkdept(g_aaz.aaz72,g_nms.nms711,g_nms.nms01,g_aza.aza82)
                        RETURNING g_errno
                END IF
             END IF
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_nms.nms711,g_errno,0)
                DISPLAY BY NAME g_nms.nms711
                NEXT FIELD nms711
             END IF
             #No.FUN-B40004  --End
          END IF
 
# NO.FUN-680034 ---end---
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nms.nmsuser = s_get_data_owner("nms_file") #FUN-C10039
           LET g_nms.nmsgrup = s_get_data_group("nms_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_nmz.nmz11 = 'Y' THEN
               IF cl_null(g_nms.nms01) THEN
                   LET l_flag='Y'
                   DISPLAY BY NAME g_nms.nms01
               END IF
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD nms01
            END IF
 
        #MOD-650015 --start
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(nms01) THEN
        #        LET g_nms.* = g_nms_t.*
        #        DISPLAY BY NAME g_nms.*
        #        NEXT FIELD nms01
        #    END IF
        #MOD-650015 --start
     ON ACTION controlp
         CASE WHEN INFIELD(nms01)
#              CALL q_gem(10,10,g_nms.nms01) RETURNING g_nms.nms01
#              CALL FGL_DIALOG_SETBUFFER( g_nms.nms01 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_nms.nms01
               CALL cl_create_qry() RETURNING g_nms.nms01
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms01 )
               DISPLAY BY NAME g_nms.nms01 NEXT FIELD nms01
              WHEN INFIELD(nms12)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms12,'23')
#                   RETURNING g_nms.nms12
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms12 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms12,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms12,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms12
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms12 )
               DISPLAY BY NAME g_nms.nms12 NEXT FIELD nms12
              WHEN INFIELD(nms13)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms13,'23')
#                   RETURNING g_nms.nms13
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms13 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms13,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms13,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms13
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms13 )
               DISPLAY BY NAME g_nms.nms13 NEXT FIELD nms13
              WHEN INFIELD(nms14)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms14,'23')
#                   RETURNING g_nms.nms14
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms14 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms14,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms14,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms14
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms14 )
               DISPLAY BY NAME g_nms.nms14 NEXT FIELD nms14
              WHEN INFIELD(nms15)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms15,'23')
#                   RETURNING g_nms.nms15
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms15 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms15,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms15,'23',g_aza.aza81)     #No.FUN-980025
                    RETURNING g_nms.nms15
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms15 )
               DISPLAY BY NAME g_nms.nms15 NEXT FIELD nms15
              WHEN INFIELD(nms16)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms16,'23')
#                   RETURNING g_nms.nms16
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms16 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms16,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms16,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms16
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms16 )
               DISPLAY BY NAME g_nms.nms16 NEXT FIELD nms16
              WHEN INFIELD(nms17)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms17,'23')
#                   RETURNING g_nms.nms17
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms17 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms17,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms17,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms17
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms17 )
               DISPLAY BY NAME g_nms.nms17 NEXT FIELD nms17
              WHEN INFIELD(nms18)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms18,'23')
#                   RETURNING g_nms.nms18
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms18 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms18,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms18,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms18
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms18 )
               DISPLAY BY NAME g_nms.nms18 NEXT FIELD nms18
              WHEN INFIELD(nms21)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms21,'23')
#                   RETURNING g_nms.nms21
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms21 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms21,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms21,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms21
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms21 )
               DISPLAY BY NAME g_nms.nms21 NEXT FIELD nms21
              WHEN INFIELD(nms22)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms22,'23')
#                   RETURNING g_nms.nms22
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms22 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms22,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms22,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms22
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms22 )
               DISPLAY BY NAME g_nms.nms22 NEXT FIELD nms22
              WHEN INFIELD(nms23)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms23,'23')
#                   RETURNING g_nms.nms23
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms23 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms23,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms23,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms23
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms23 )
               DISPLAY BY NAME g_nms.nms23 NEXT FIELD nms23
              WHEN INFIELD(nms24)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms24,'23')
#                   RETURNING g_nms.nms24
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms24 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms24,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms24,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms24
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms24 )
               DISPLAY BY NAME g_nms.nms24 NEXT FIELD nms24
              WHEN INFIELD(nms25)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms25,'23')
#                   RETURNING g_nms.nms25
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms25 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms25,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms25,'23',g_aza.aza81)     #No.FUN-980025
                    RETURNING g_nms.nms25
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms25 )
               DISPLAY BY NAME g_nms.nms25 NEXT FIELD nms25
              WHEN INFIELD(nms26)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms26,'23')
#                   RETURNING g_nms.nms26
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms26 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms26,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms26,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms26
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms26 )
               DISPLAY BY NAME g_nms.nms26 NEXT FIELD nms26
              WHEN INFIELD(nms27)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms27,'23')
#                   RETURNING g_nms.nms27
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms27 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms27,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms27,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms27
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms27 )
               DISPLAY BY NAME g_nms.nms27 NEXT FIELD nms27
              WHEN INFIELD(nms28)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms28,'23')
#                   RETURNING g_nms.nms28
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms28 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms28,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025 
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms28,'23',g_aza.aza81)     #No.FUN-980025
                    RETURNING g_nms.nms28
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms28 )
               DISPLAY BY NAME g_nms.nms28 NEXT FIELD nms28
              WHEN INFIELD(nms50)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms50,'23')
#                   RETURNING g_nms.nms50
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms50 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms50,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms50,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms50
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms50 )
               DISPLAY BY NAME g_nms.nms50 NEXT FIELD nms50
              WHEN INFIELD(nms51)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms51,'23')
#                   RETURNING g_nms.nms51
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms51 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms51,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms51,'23',g_aza.aza81)     #No.FUN-980025
                    RETURNING g_nms.nms51
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms51 )
               DISPLAY BY NAME g_nms.nms51 NEXT FIELD nms51
              WHEN INFIELD(nms55)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms55,'23')
#                   RETURNING g_nms.nms55
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms55 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms55,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms55,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms55
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms55 )
               DISPLAY BY NAME g_nms.nms55 NEXT FIELD nms55
              WHEN INFIELD(nms56)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms56,'23')
#                   RETURNING g_nms.nms56
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms56 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms56,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms56,'23',g_aza.aza81)     #No.FUN-980025
                    RETURNING g_nms.nms56
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms56 )
               DISPLAY BY NAME g_nms.nms56 NEXT FIELD nms56
              WHEN INFIELD(nms57)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms57,'23')
#                   RETURNING g_nms.nms57
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms57 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms57,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms57,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms57
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms57 )
               DISPLAY BY NAME g_nms.nms57 NEXT FIELD nms57
              WHEN INFIELD(nms58)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms58,'23')
#                   RETURNING g_nms.nms58
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms58 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms58,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms58,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms58
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms58 )
               DISPLAY BY NAME g_nms.nms58 NEXT FIELD nms58
              WHEN INFIELD(nms59)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms59,'23')
#                   RETURNING g_nms.nms59
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms59 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms59,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms59,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms59
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms59 )
               DISPLAY BY NAME g_nms.nms59 NEXT FIELD nms59
              WHEN INFIELD(nms25)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms25,'23')
#                   RETURNING g_nms.nms25
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms25 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms25,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms25,'23',g_aza.aza81)     #No.FUN-980025
                    RETURNING g_nms.nms25
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms25 )
               DISPLAY BY NAME g_nms.nms25 NEXT FIELD nms25
              WHEN INFIELD(nms26)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms26,'23')
#                   RETURNING g_nms.nms26
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms26 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms26,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms26,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms26
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms26 )
               DISPLAY BY NAME g_nms.nms26 NEXT FIELD nms26
              WHEN INFIELD(nms27)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms27,'23')
#                   RETURNING g_nms.nms27
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms27 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms27,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms27,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms27
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms27 )
               DISPLAY BY NAME g_nms.nms27 NEXT FIELD nms27
              WHEN INFIELD(nms60)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms60,'23')
#                   RETURNING g_nms.nms60
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms60 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms60,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms60,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms60
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms60 )
               DISPLAY BY NAME g_nms.nms60 NEXT FIELD nms60
              WHEN INFIELD(nms61)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms61,'23')
#                   RETURNING g_nms.nms61
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms61 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms61,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms61,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms61
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms61 )
               DISPLAY BY NAME g_nms.nms61 NEXT FIELD nms61
              WHEN INFIELD(nms62)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms62,'23')
#                   RETURNING g_nms.nms62
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms62 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms62,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms62,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms62
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms62 )
               DISPLAY BY NAME g_nms.nms62 NEXT FIELD nms62
              WHEN INFIELD(nms63)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms63,'23')
#                   RETURNING g_nms.nms63
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms63 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms63,'23',g_aza.aza81)       #No.FUN-740028 #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms63,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms63
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms63 )
               DISPLAY BY NAME g_nms.nms63 NEXT FIELD nms63
              WHEN INFIELD(nms64)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms64,'23')
#                   RETURNING g_nms.nms64
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms64 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms64,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms64,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms64
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms64 )
               DISPLAY BY NAME g_nms.nms64 NEXT FIELD nms64
              WHEN INFIELD(nms65)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms65,'23')
#                   RETURNING g_nms.nms65
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms65 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms65,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms65,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms65
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms65 )
               DISPLAY BY NAME g_nms.nms65 NEXT FIELD nms65
              WHEN INFIELD(nms66)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms66,'23')
#                   RETURNING g_nms.nms66
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms66 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms66,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms66,'23',g_aza.aza81)     #No.FUN-980025
                    RETURNING g_nms.nms66
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms66 )
               DISPLAY BY NAME g_nms.nms66 NEXT FIELD nms66
              WHEN INFIELD(nms67)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms67,'23')
#                   RETURNING g_nms.nms67
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms67 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms67,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms67,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms67
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms67 )
               DISPLAY BY NAME g_nms.nms67 NEXT FIELD nms67
              WHEN INFIELD(nms69)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms69,'23')
#                   RETURNING g_nms.nms69
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms69 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms69,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms69,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms69
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms69 )
               DISPLAY BY NAME g_nms.nms69 NEXT FIELD nms69
              WHEN INFIELD(nms68)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms68,'23')
#                   RETURNING g_nms.nms68
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms68 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms68,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms68,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms68
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms68 )
               DISPLAY BY NAME g_nms.nms68 NEXT FIELD nms68
              WHEN INFIELD(nms70)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms70,'23')
#                   RETURNING g_nms.nms70
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms70 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms70,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms70,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms70
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms70 )
               DISPLAY BY NAME g_nms.nms70 NEXT FIELD nms70
              WHEN INFIELD(nms71)
#              CALL q_m_aag(10,10,g_dbs_gl,g_nms.nms71,'23')
#                   RETURNING g_nms.nms71
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms71 )
#              CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms71,'23',g_aza.aza81)       #No.FUN-740028  #No.FUN-980025
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms71,'23',g_aza.aza81)     #No.FUN-980025 
                    RETURNING g_nms.nms71
#               CALL FGL_DIALOG_SETBUFFER( g_nms.nms71 )
               DISPLAY BY NAME g_nms.nms71 NEXT FIELD nms71
# NO.FUN-680034 --start--
             WHEN INFIELD(nms121)
#             CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms121,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
              CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms121,'23',g_aza.aza82)     #No.FUN-980025
                   RETURNING g_nms.nms121
              DISPLAY BY NAME g_nms.nms121 NEXT FIELD nms121
 
             WHEN INFIELD(nms131)
#             CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms131,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
              CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms131,'23',g_aza.aza82)     #No.FUN-980025 
                   RETURNING g_nms.nms131
              DISPLAY BY NAME g_nms.nms131 NEXT FIELD nms131
            WHEN INFIELD(nms141)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms141,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms141,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms141
             DISPLAY BY NAME g_nms.nms141 NEXT FIELD nms141
 
            WHEN INFIELD(nms151)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms151,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms151,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms151
             DISPLAY BY NAME g_nms.nms151 NEXT FIELD nms151
 
            WHEN INFIELD(nms161)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms161,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms161,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms161
             DISPLAY BY NAME g_nms.nms161 NEXT FIELD nms161
 
            WHEN INFIELD(nms171)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms171,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms171,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms171
             DISPLAY BY NAME g_nms.nms171 NEXT FIELD nms171
 
            WHEN INFIELD(nms181)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms181,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms181,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms181
             DISPLAY BY NAME g_nms.nms181 NEXT FIELD nms181
 
            WHEN INFIELD(nms211)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms211,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms211,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms211
             DISPLAY BY NAME g_nms.nms211 NEXT FIELD nms211
 
            WHEN INFIELD(nms221)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms221,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms221,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms221
             DISPLAY BY NAME g_nms.nms221 NEXT FIELD nms221
 
            WHEN INFIELD(nms231)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms231,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms231,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms231
             DISPLAY BY NAME g_nms.nms231 NEXT FIELD nms231
 
            WHEN INFIELD(nms241)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms241,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms241,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms241
             DISPLAY BY NAME g_nms.nms241 NEXT FIELD nms241
 
            WHEN INFIELD(nms251)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms251,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms251,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms251
             DISPLAY BY NAME g_nms.nms251 NEXT FIELD nms251
            WHEN INFIELD(nms261)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms261,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms261,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms261
             DISPLAY BY NAME g_nms.nms261 NEXT FIELD nms261
 
            WHEN INFIELD(nms271)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms271,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms271,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms271
             DISPLAY BY NAME g_nms.nms271 NEXT FIELD nms271
 
            WHEN INFIELD(nms501)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms501,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms501,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms501
             DISPLAY BY NAME g_nms.nms501 NEXT FIELD nms501
 
            WHEN INFIELD(nms511)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms511,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms511,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms511
             DISPLAY BY NAME g_nms.nms511 NEXT FIELD nms511
 
            WHEN INFIELD(nms281)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms281,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms281,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms281
             DISPLAY BY NAME g_nms.nms281 NEXT FIELD nms281
 
            WHEN INFIELD(nms551)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms551,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms551,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms551
             DISPLAY BY NAME g_nms.nms551 NEXT FIELD nms551
 
            WHEN INFIELD(nms561)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms561,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms561,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms561
             DISPLAY BY NAME g_nms.nms561 NEXT FIELD nms561
 
            WHEN INFIELD(nms571)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms571,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms571,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms571
             DISPLAY BY NAME g_nms.nms571 NEXT FIELD nms571
 
            WHEN INFIELD(nms581)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms581,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms581,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms581
             DISPLAY BY NAME g_nms.nms581 NEXT FIELD nms581
 
            WHEN INFIELD(nms591)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms591,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms591,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms591
             DISPLAY BY NAME g_nms.nms591 NEXT FIELD nms591
 
            WHEN INFIELD(nms601)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms601,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms601,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms601
             DISPLAY BY NAME g_nms.nms601 NEXT FIELD nms601
 
            WHEN INFIELD(nms611)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms611,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms611,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms611
             DISPLAY BY NAME g_nms.nms611 NEXT FIELD nms611
 
            WHEN INFIELD(nms621)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms621,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms621,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms621
             DISPLAY BY NAME g_nms.nms621 NEXT FIELD nms621
            WHEN INFIELD(nms631)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms631,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms631,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms631
             DISPLAY BY NAME g_nms.nms631 NEXT FIELD nms631
 
            WHEN INFIELD(nms641)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms641,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms641,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms641
             DISPLAY BY NAME g_nms.nms641 NEXT FIELD nms641
 
            WHEN INFIELD(nms651)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms651,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms651,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms651
             DISPLAY BY NAME g_nms.nms651 NEXT FIELD nms651
 
            WHEN INFIELD(nms661)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms661,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms661,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms661
             DISPLAY BY NAME g_nms.nms661 NEXT FIELD nms661
 
            WHEN INFIELD(nms671)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms671,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms671,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms671
             DISPLAY BY NAME g_nms.nms671 NEXT FIELD nms671
 
            WHEN INFIELD(nms691)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms691,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms691,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms691
             DISPLAY BY NAME g_nms.nms691 NEXT FIELD nms691
 
            WHEN INFIELD(nms681)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms681,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms681,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms681
             DISPLAY BY NAME g_nms.nms681 NEXT FIELD nms681
 
            WHEN INFIELD(nms701)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms701,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms701,'23',g_aza.aza82)     #No.FUN-980025
                  RETURNING g_nms.nms701
             DISPLAY BY NAME g_nms.nms701 NEXT FIELD nms701
 
            WHEN INFIELD(nms711)
#            CALL q_m_aag(FALSE,TRUE,g_dbs_gl,g_nms.nms711,'23',g_aza.aza82)       #No.FUN-740028  #No.TQC-7B0094 alter aza81->aza82 #No.FUN-980025
             CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nms.nms711,'23',g_aza.aza82)     #No.FUN-980025 
                  RETURNING g_nms.nms711
             DISPLAY BY NAME g_nms.nms711 NEXT FIELD nms711
 
# NO.FUN-680034 ---end---
             OTHERWISE EXIT CASE
        END CASE
 
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
END FUNCTION
 
FUNCTION i040_nms01(p_cmd)  #部門編號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
           INTO l_gem02,l_gemacti
           FROM gem_file WHERE gem01 = g_nms.nms01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-071'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO gem02
    END IF
END FUNCTION
 
FUNCTION i040_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i040_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i040_count
    FETCH i040_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i040_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0)
        INITIALIZE g_nms.* TO NULL
    ELSE
        CALL i040_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i040_fetch(p_flnms)
    DEFINE
        p_flnms         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
    CASE p_flnms
        WHEN 'N' FETCH NEXT     i040_cs INTO g_nms.nms01
        WHEN 'P' FETCH PREVIOUS i040_cs INTO g_nms.nms01
        WHEN 'F' FETCH FIRST    i040_cs INTO g_nms.nms01
        WHEN 'L' FETCH LAST     i040_cs INTO g_nms.nms01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump i040_cs INTO g_nms.nms01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0)
        INITIALIZE g_nms.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnms
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_nms.* FROM nms_file            # 重讀DB,因TEMP有不被更新特性
     WHERE nms01 = g_nms.nms01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0)   #No.FUN-660148
       CALL cl_err3("sel","nms_file",g_nms.nms01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_data_owner = g_nms.nmsuser     #No.FUN-4C0063
       LET g_data_group = g_nms.nmsgrup     #No.FUN-4C0063
       CALL i040_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i040_show()
    LET g_nms_t.* = g_nms.*
    DISPLAY BY NAME g_nms.nmsoriu,g_nms.nmsorig,
        g_nms.nms01,g_nms.nms12,g_nms.nms13, g_nms.nms14,g_nms.nms15,
        g_nms.nms16,g_nms.nms17,g_nms.nms18, g_nms.nms21,g_nms.nms22,
        g_nms.nms23,g_nms.nms24,g_nms.nms25,g_nms.nms26,g_nms.nms27,
       #No.+099 010505 by plum
       #g_nms.nms50,g_nms.nms51,g_nms.nms55,
        g_nms.nms50,g_nms.nms51,g_nms.nms28,g_nms.nms55,
        g_nms.nms56,g_nms.nms57,g_nms.nms58,g_nms.nms59,
        g_nms.nms60,g_nms.nms61,g_nms.nms62,g_nms.nms63,g_nms.nms64,g_nms.nms65,
        g_nms.nms66,g_nms.nms67,g_nms.nms69,g_nms.nms68,g_nms.nms70,g_nms.nms71,
# NO.FUN-680034 --start--
        g_nms.nms121,g_nms.nms131, g_nms.nms141,g_nms.nms151,
        g_nms.nms161,g_nms.nms171,g_nms.nms181, g_nms.nms211,g_nms.nms221,
        g_nms.nms231,g_nms.nms241,g_nms.nms251,g_nms.nms261,g_nms.nms271,
        g_nms.nms501,g_nms.nms511,g_nms.nms281,g_nms.nms551,
        g_nms.nms561,g_nms.nms571,g_nms.nms581,g_nms.nms591,
        g_nms.nms601,g_nms.nms611,g_nms.nms621,g_nms.nms631,g_nms.nms641,g_nms.nms651,
        g_nms.nms661,g_nms.nms671,g_nms.nms691,g_nms.nms681,g_nms.nms701,g_nms.nms711,
 
# NO.FUN-680034 ---end---
        g_nms.nmsuser,g_nms.nmsgrup,g_nms.nmsmodu,g_nms.nmsdate,g_nms.nmsacti
 
    CALL i040_nms01('d')
    CALL cl_set_field_pic("","","","","",g_nms.nmsacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i040_u()
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nms.nms01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_nms.nmsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_nms.nms01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
    OPEN i040_cl USING g_nms.nms01
    IF STATUS THEN
       CALL cl_err("OPEN i040_cl:", STATUS, 1)
       CLOSE i040_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i040_cl INTO g_nms.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_nms01_t = g_nms.nms01
    LET g_nms_o.*=g_nms.*
    LET g_nms.nmsmodu=g_user                     #修改者
    LET g_nms.nmsdate = g_today                  #修改日期
    CALL i040_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i040_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_nms.*=g_nms_t.*
            CALL i040_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE nms_file SET nms_file.* = g_nms.*    # 更新DB
            WHERE nms01 = g_nms01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nms_file",g_nms01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i040_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i040_x()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
        IF s_anmshut(0) THEN RETURN END IF
	IF g_nms.nms01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
	BEGIN WORK
        OPEN i040_cl USING g_nms.nms01
        IF STATUS THEN
           CALL cl_err("OPEN i040_cl:", STATUS, 1)
           CLOSE i040_cl
           ROLLBACK WORK
           RETURN
        END IF
	FETCH i040_cl INTO g_nms.*
	IF SQLCA.sqlcode THEN
           CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0) RETURN
        END IF
	CALL i040_show()
	IF cl_exp(15,21,g_nms.nmsacti) THEN
        LET g_chr=g_nms.nmsacti
        IF g_nms.nmsacti='Y'
           THEN LET g_nms.nmsacti='N'
           ELSE LET g_nms.nmsacti='Y'
        END IF
        UPDATE nms_file
            SET nmsacti=g_nms.nmsacti,
               nmsmodu=g_user, nmsdate=g_today
            WHERE nms01 = g_nms.nms01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nms_file",g_nms.nms01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            LET g_nms.nmsacti=g_chr
        END IF
        DISPLAY BY NAME g_nms.nmsacti
    END IF
    CLOSE i040_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i040_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nms.nms01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
    OPEN i040_cl USING g_nms.nms01
    IF STATUS THEN
       CALL cl_err("OPEN i040_cl:", STATUS, 1)
       CLOSE i040_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i040_cl INTO g_nms.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0) RETURN END IF
    CALL i040_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nms01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nms.nms01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM nms_file WHERE nms01 = g_nms.nms01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_nms.nms01,SQLCA.sqlcode,0)   #No.FUN-660148
           CALL cl_err3("del","nms_file",g_nms.nms01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
        ELSE
           CLEAR FORM
           INITIALIZE g_nms.* TO NULL
           OPEN i040_count
           #FUN-B50063-add-start--
           IF STATUS THEN
              CLOSE i040_cs
              CLOSE i040_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end-- 
           FETCH i040_count INTO g_row_count
           #FUN-B50063-add-start--
           IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
              CLOSE i040_cs
              CLOSE i040_count
              COMMIT WORK
              RETURN
           END IF
           #FUN-B50063-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN i040_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL i040_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i040_fetch('/')
           END IF
        END IF
    END IF
    CLOSE i040_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i040_copy()
   DEFINE l_nms           RECORD LIKE nms_file.*,
          l_oldno,l_newno LIKE nms_file.nms01,
          l_gem02         LIKE gem_file.gem02,
          l_n             LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nmz.nmz11 = 'N' THEN
#        CALL cl_err('','anm-088',0)             #TQC-950023                                                                        
         CALL cl_err('','aap-088',0)             #TQC-950023
         RETURN
    END IF
    IF g_nms.nms01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #DISPLAY "" AT 1,1
 
    LET g_before_input_done = FALSE
    CALL i040_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM nms01
        AFTER FIELD nms01             #部門編號
            IF NOT cl_null(l_newno) THEN
               SELECT gem02 INTO l_gem02 FROM gem_file
                WHERE gem01 = l_newno
               IF STATUS THEN
#                 CALL cl_err(l_newno,STATUS,0)   #No.FUN-660148
                  CALL cl_err3("sel","gem_file",l_newno,"",STATUS,"","",1)  #No.FUN-660148
                  NEXT FIELD nms01
               END IF
               DISPLAY l_gem02 TO gem02
            END IF
 
        AFTER INPUT  #判斷
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT INPUT
            END IF
            SELECT count(*) INTO l_n FROM nms_file
                WHERE nms01 = l_newno
           IF l_n > 0 THEN                  # Duplicated
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD nms01
           END IF
 
     ON ACTION controlp
         CASE WHEN INFIELD(nms01)
#              CALL q_gem(10,10,l_newno) RETURNING l_newno
#              CALL FGL_DIALOG_SETBUFFER( l_newno )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = l_newno
               CALL cl_create_qry() RETURNING l_newno
#               CALL FGL_DIALOG_SETBUFFER( l_newno )
               DISPLAY l_newno TO nms01
               NEXT FIELD nms01
         END CASE
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
        DISPLAY BY NAME g_nms.nms01
        RETURN
    END IF
    LET l_nms.* = g_nms.*
    LET l_nms.nms01  =l_newno   #資料鍵值
    LET l_nms.nmsuser=g_user    #資料所有者
    LET l_nms.nmsgrup=g_grup    #資料所有者所屬群
    LET l_nms.nmsmodu=NULL      #資料修改日期
    LET l_nms.nmsdate=g_today   #資料建立日期
    LET l_nms.nmsacti='Y'       #有效資料
    LET l_nms.nmsoriu = g_user      #No.FUN-980030 10/01/04
    LET l_nms.nmsorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO nms_file VALUES (l_nms.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660148
        CALL cl_err3("ins","nms_file",L_NMS.NMS01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_nms.nms01
        SELECT nms_file.* INTO g_nms.* FROM nms_file
                       WHERE nms01 = l_newno
        CALL i040_u()
        #SELECT nms_file.* INTO g_nms.* FROM nms_file #FUN-C80046
        #               WHERE nms01 = l_oldno         #FUN-C80046
    END IF
    CALL i040_show()
END FUNCTION
 
FUNCTION i040_out()
    DEFINE
        l_i             LIKE type_file.num5,   #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
        l_nms           RECORD LIKE nms_file.*,
        l_gem02         LIKE gem_file.gem02,
        l_apr02         LIKE apr_file.apr02,
        l_za05          LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(40)
        l_chr           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    CALL cl_wait()
    #No.FUN-770038  --Begin
    #CALL cl_outnam('anmi040') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmi040'
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT nms_file.*,gem_file.gem02",   # 組合出 SQL 指令
              "  FROM nms_file  LEFT OUTER join gem_file ON(nms01 = gem01 AND gemacti = 'Y')",
              " WHERE  ",
               g_wc CLIPPED
    IF g_nmz.nmz11 = 'N' THEN
        LET g_sql= g_sql CLIPPED," AND nms01 = ' '"
    END IF
 
    #PREPARE i040_p1 FROM g_sql                # RUNTIME 編譯
    #DECLARE i040_co CURSOR FOR i040_p1
 
    #START REPORT i040_rep TO l_name
 
    #FOREACH i040_co INTO l_nms.*,l_gem02
    #    IF SQLCA.sqlcode THEN
    #        CALL cl_err('Foreach:',SQLCA.sqlcode,1)
    #        EXIT FOREACH
    #        END IF
    #    OUTPUT TO REPORT i040_rep(l_nms.*,l_gem02)
    #END FOREACH
 
    #FINISH REPORT i040_rep
 
    #CLOSE i040_co
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'nms01')
            RETURNING g_str
    END IF
 
    CALL cl_prt_cs1('anmi040','anmi040',g_sql,g_str)
    #No.FUN-770038  --End
END FUNCTION
 
#No.FUN-770038  --Begin
#REPORT i040_rep(sr,l_gem02)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#        sr              RECORD LIKE nms_file.*,
#        l_gem02         LIKE gem_file.gem02,
#        l_actname	LIKE type_file.chr50,  #No.FUN-680107 VARCHAR(30)
#        l_chr           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.nms01
#
#    FORMAT
#        PAGE HEADER
#            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED     # No.TQC-750041
#            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#            PRINT ' '
#            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN (g_len-FGL_WIDTH(g_user)-18),'FROM:',g_user CLIPPED, COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'      # No.TQC-750041
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.nms01
#            IF sr.nmsacti = 'N' THEN PRINT '*'; END IF
#            PRINT COLUMN 3,g_x[11] CLIPPED,COLUMN 12,sr.nms01,' ',l_gem02
#            PRINT ' '
#
#         #No.MOD-510042
#        ON EVERY ROW
#            PRINT COLUMN 2,g_x[12] CLIPPED,COLUMN 27,sr.nms12,
#                  COLUMN 52,g_x[55] CLIPPED, COLUMN 72,sr.nms55    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[13] CLIPPED,COLUMN 27,sr.nms13,
#                  COLUMN 52,g_x[56] CLIPPED, COLUMN 72,sr.nms56    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[14] CLIPPED,COLUMN 27,sr.nms14,
#                  COLUMN 52,g_x[57] CLIPPED, COLUMN 72,sr.nms57    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[15] CLIPPED,COLUMN 27,sr.nms15,
#                  COLUMN 52,g_x[58] CLIPPED, COLUMN 72,sr.nms58    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[16] CLIPPED,COLUMN 27,sr.nms16,
#                  COLUMN 52,g_x[59] CLIPPED, COLUMN 72,sr.nms59    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[17] CLIPPED,COLUMN 27,sr.nms17,
#                  COLUMN 52,g_x[60] CLIPPED, COLUMN 72,sr.nms60    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[18] CLIPPED,COLUMN 27,sr.nms18,
#                  COLUMN 52,g_x[61] CLIPPED, COLUMN 72,sr.nms61    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[21] CLIPPED,COLUMN 27,sr.nms21,
#                  COLUMN 52,g_x[62] CLIPPED, COLUMN 72,sr.nms62    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[22] CLIPPED,COLUMN 27,sr.nms22,
#                  COLUMN 52,g_x[63] CLIPPED, COLUMN 72,sr.nms63    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[23] CLIPPED,COLUMN 27,sr.nms23,
#                  COLUMN 52,g_x[64] CLIPPED, COLUMN 72,sr.nms64    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[25] CLIPPED,COLUMN 27,sr.nms25,
#                  COLUMN 52,g_x[65] CLIPPED, COLUMN 72,sr.nms65    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[26] CLIPPED,COLUMN 27,sr.nms26,
#                  COLUMN 52,g_x[66] CLIPPED, COLUMN 72,sr.nms66    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[27] CLIPPED,COLUMN 27,sr.nms27,
#                  COLUMN 52,g_x[67] CLIPPED, COLUMN 72,sr.nms67    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[50] CLIPPED,COLUMN 27,sr.nms50,
#                  COLUMN 52,g_x[69] CLIPPED, COLUMN 72,sr.nms69    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[51] CLIPPED,COLUMN 27,sr.nms51,
#                  COLUMN 52,g_x[68] CLIPPED, COLUMN 72,sr.nms68    #No.TQC-6A0110
#
#            PRINT COLUMN 2,g_x[70] CLIPPED,COLUMN 27,sr.nms70,
#                  COLUMN 52,g_x[71] CLIPPED, COLUMN 72,sr.nms71    #No.TQC-6A0110
#            PRINT COLUMN 2,g_x[72] CLIPPED,COLUMN 27,sr.nms28
#
#        AFTER GROUP OF sr.nms01
#            SKIP 1 LINE
#
#        ON LAST ROW
#            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#               CALL cl_wcchp(g_wc,'nms01')
#                    RETURNING g_sql
#               PRINT g_dash[1,g_len]
#
#            #TQC-630166
#            {
#               IF g_sql[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#               IF g_sql[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#               IF g_sql[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#            }
#               CALL cl_prt_pos_wc(g_sql)
#            #END TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-770038  --End  
 
FUNCTION i040_actchk(p_code,p_bookno)        #No.FUN-740028
  DEFINE p_code     LIKE aag_file.aag01
  DEFINE l_aagacti  LIKE aag_file.aagacti
  DEFINE l_aag02    LIKE aag_file.aag02
  DEFINE l_aag07    LIKE aag_file.aag07
  DEFINE l_aag09    LIKE aag_file.aag09
  DEFINE l_aag03    LIKE aag_file.aag03
  DEFINE p_bookno   LIKE aag_file.aag00       #No.FUN-740028
 
     LET g_errno = ' '
     IF g_nmz.nmz02 = 'N' OR p_code IS NULL THEN RETURN 1 END IF
        SELECT aag02,aag03,aag07,aag09,aagacti
          INTO l_aag02,l_aag03,l_aag07,l_aag09,l_aagacti
          FROM aag_file
         WHERE aag01=p_code
           AND aag00=p_bookno      #No.FUN-740028
        CASE WHEN STATUS=100         LET g_errno = 'agl-001'  #No.7926
             WHEN l_aagacti='N'      LET g_errno='9028'
              WHEN l_aag07  = '1'      LET g_errno = 'agl-015'
              WHEN l_aag03  = '4'      LET g_errno = 'agl-177'
              WHEN l_aag09  = 'N'      LET g_errno = 'agl-214'
             OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
        END CASE
	IF cl_null(g_errno) THEN RETURN 1 END IF
	CALL cl_err(p_code,g_errno,0)
	RETURN 0
END FUNCTION
 
FUNCTION i040_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nms01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i040_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF (p_cmd='a' AND g_nmz.nmz11 = 'N') OR
      (p_cmd='u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done)) THEN
      CALL cl_set_comp_entry("nms01",FALSE)
   END IF
END FUNCTION
 
#Patch....NO.TQC-610036 <001,002> #

