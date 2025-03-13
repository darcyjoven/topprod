# Prog. Version..: '5.30.09-13.09.06(00000)'     #
#
# Pattern name...: aglq900.4gl
# Descriptions...: 财务指标分析查询结果
# Date & Author..: FUN-D50004 13/05/06 By zhangweib
# Modify.........: No.FUN-D60097 13/07/08 By wangrr Bug修改,將replace中多余的')'去除
# Modify.........: No.TQC-D80014 13/08/08 By zhangweib 模擬駕駛倉FUNC架構錯誤

DATABASE ds

GLOBALS "../../config/top.global"   #FUN-D50004

DEFINE
     tm  RECORD
          yy00   LIKE type_file.num5,    #年度            
          yy01   LIKE type_file.num5, 
          yy02   LIKE type_file.num5,
          yy03   LIKE type_file.num5,
          yy04   LIKE type_file.num5,
          yy05   LIKE type_file.num5,
          yy06   LIKE type_file.num5,
          yy07   LIKE type_file.num5,
          yy08   LIKE type_file.num5,
          yy09   LIKE type_file.num5,
          yy10   LIKE type_file.num5,
          yy11   LIKE type_file.num5,
          yy12   LIKE type_file.num5,

          b_mm00   LIKE type_file.num5,  #起始期别       
          b_mm01   LIKE type_file.num5,
          b_mm02   LIKE type_file.num5,
          b_mm03   LIKE type_file.num5,
          b_mm04   LIKE type_file.num5,
          b_mm05   LIKE type_file.num5,
          b_mm06   LIKE type_file.num5,
          b_mm07   LIKE type_file.num5,
          b_mm08   LIKE type_file.num5,
          b_mm09   LIKE type_file.num5,
          b_mm10  LIKE type_file.num5,
          b_mm11  LIKE type_file.num5,
          b_mm12  LIKE type_file.num5,

          e_mm00   LIKE type_file.num5,  #截至期别  
          e_mm01   LIKE type_file.num5,
          e_mm02   LIKE type_file.num5,
          e_mm03   LIKE type_file.num5,
          e_mm04   LIKE type_file.num5,
          e_mm05   LIKE type_file.num5,
          e_mm06   LIKE type_file.num5,
          e_mm07   LIKE type_file.num5,
          e_mm08   LIKE type_file.num5,
          e_mm09   LIKE type_file.num5,
          e_mm10   LIKE type_file.num5,
          e_mm11   LIKE type_file.num5,
          e_mm12   LIKE type_file.num5
        END RECORD,

            g_abq00    LIKE abq_file.abq00,    #帐套
            g_abq01      LIKE abq_file.abq01,    #财务分析编号
            g_type       LIKE type_file.chr1,             #对比来源方式
            g_b_y      LIKE type_file.num5,             #对比起始年度
            g_e_y      LIKE type_file.num5,             #对比截至年度
            g_b_m      LIKE type_file.num5,             #对比起始期别
            g_e_m      LIKE type_file.num5,             #对比截至期别
            g_b_q      LIKE type_file.num5,             #对比起始季度
            g_e_q      LIKE type_file.num5,              #对比截至季度


      g_abq,g_hx DYNAMIC ARRAY OF RECORD
            abq04   LIKE abq_file.abq04,       #序号
            abq06   LIKE abq_file.abq06,       #指标名称
            abq08   LIKE abq_file.abq08,       #指标说明
            abq15   LIKE abq_file.abq15,
            abq16   LIKE abq_file.abq16,
            abq17   LIKE abq_file.abq17,
            abq18   LIKE abq_file.abq18,
            abq19   LIKE abq_file.abq19,
            tot01   LIKE type_file.chr30,                           #期别金额第一期
            tot02   LIKE type_file.chr30,                           #期别金额第二期
            tot03   LIKE type_file.chr30,                           #期别金额第三期
            tot04   LIKE type_file.chr30,                           #期别金额第四期
            tot05   LIKE type_file.chr30,                           #期别金额第五期
            tot06   LIKE type_file.chr30,                           #期别金额第六期
            tot07   LIKE type_file.chr30,                           #期别金额第七期
            tot08   LIKE type_file.chr30,                           #期别金额第八期
            tot09   LIKE type_file.chr30,                           #期别金额第九期
            tot10   LIKE type_file.chr30,                           #期别金额第十期
            tot11   LIKE type_file.chr30,                           #期别金额第十一期
            tot12   LIKE type_file.chr30                            #期别金额第十二期 
        END RECORD, 
      g_wc,g_str,g_sql STRING,     #WHERE CONDITION
      g_rec_b LIKE type_file.num5           #單身筆數


DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_msg           LIKE ze_file.ze03

DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   l_table             STRING
DEFINE g_i                 LIKE type_file.num5
DEFINE g_draw_x,g_draw_y,g_draw_dx,g_draw_dy,
       g_draw_width,g_draw_multiple LIKE type_file.num10 
DEFINE g_draw_base,g_draw_maxy      LIKE type_file.num10 
DEFINE g_draw_start_y               LIKE type_file.num10 
DEFINE hx_cnt                          LIKE type_file.num5
DEFINE hx_cnt1                         LIKE type_file.num5
DEFINE hx_cnt_t                        LIKE type_file.num5
DEFINE hx_cnt1_t                       LIKE type_file.num5
DEFINE l_ac                         LIKE type_file.num5    
DEFINE g_chr1                      LIKE type_file.chr1 
DEFINE g_max                        LIKE type_file.num20_6
DEFINE g_min                        LIKE type_file.num20_6
DEFINE g_n                          LIKE type_file.num10
DEFINE g_l_i                        LIKE type_file.num10
DEFINE g_yp                         LIKE type_file.num10   #圆盘计数
DEFINE PI                           FLOAT
DEFINE g_yb_m1     LIKE type_file.chr10
DEFINE g_pi        LIKE type_file.num5

MAIN

   DEFINE    l_sl      LIKE type_file.num5
   DEFINE p_row,p_col   LIKE type_file.num5

   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
  
   LET g_sql="abq03.abq_file.abq03,",
             "abq04.abq_file.abq04,",#若需使用CR報表的TEMP Table需在setup後宣告開啟的字串
             "abq06.abq_file.abq06,",#格式為 "colname_in_temp.table.col_name"
             "abq08.abq_file.abq08,",#每個宣告間以逗號隔開
             "abq15.abq_file.abq15,",
             "abq16.abq_file.abq16,",
             "abq17.abq_file.abq17,",
             "abq18.abq_file.abq18,",
             "abq19.abq_file.abq19,",
             "tot01.type_file.chr30,",
             "tot02.type_file.chr30,",
             "tot03.type_file.chr30,",
             "tot04.type_file.chr30,",
             "tot05.type_file.chr30,",
             "tot06.type_file.chr30,",
             "tot07.type_file.chr30,",
             "tot08.type_file.chr30,",
             "tot09.type_file.chr30,",
             "tot10.type_file.chr30,",
             "tot11.type_file.chr30,",
             "tot12.type_file.chr30 "
             
   LET l_table = cl_prt_temptable('aglq900',g_sql) CLIPPED  #建立temp table,回傳狀態值
   IF  l_table = -1 THEN EXIT PROGRAM END IF          
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET p_row = 1 LET p_col = 1
    OPEN WINDOW aglq900_w AT p_row,p_col
         WITH FORM "agl/42f/aglq900"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
    DROP TABLE x_tmp
    CREATE TABLE x_tmp(
      x_q DEC(20,6)
      ) 
    DROP TABLE ffa_tmp
    SELECT abo01 FROM abo_file WHERE 1 = 0 INTO TEMP ffa_tmp  
    SELECT asin(0.5)*6 INTO PI FROM DUAL
 
    CALL q900_menu()
    CLOSE WINDOW aglq900_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q900_cs()
   DEFINE   lc_qbe_sn string
   DEFINE   l_year LIKE type_file.num5
   DEFINE   l_i LIKE type_file.num5
   DEFINE   l_abq00 LIKE abq_file.abq00
   DEFINE   l_abq01 LIKE abq_file.abq01
   DEFINE   l_mm00   LIKE type_file.num5
   
   CALL cl_set_comp_required("b_m,e_m,b_q,e_q",FALSE) 
   CALL cl_set_comp_visible("tot01,tot02,tot03,tot04,tot05,tot06,tot07,tot08,tot09,tot10,tot11,tot12",TRUE  )
   
   CLEAR FORM #清除畫面
   CALL g_abq.clear()
   CALL g_hx.clear()
   CALL drawselect("cv1") 
   CALL drawClear()
   CALL drawselect("cv2") 
   CALL drawClear()
   CALL drawselect("cv3") 
   CALL drawClear()
   CALL drawselect("cv4") 
   CALL drawClear()
   CALL drawselect("cv5") 
   CALL drawClear()
   
   INITIALIZE tm.* TO NULL 
        
   CALL cl_opmsg('q')
   INITIALIZE g_abq00 TO NULL  #清空第一个单头变量
   INITIALIZE g_abq01 TO NULL
   INITIALIZE g_type TO NULL 
   INITIALIZE g_b_y TO NULL 
   INITIALIZE g_e_y TO NULL 
   INITIALIZE g_b_m TO NULL 
   INITIALIZE g_e_m TO NULL 
   INITIALIZE g_b_q TO NULL 
   INITIALIZE g_e_q TO NULL 
   
   INITIALIZE tm.* TO NULL        # Default condition 
   
   CALL cl_set_head_visible("","YES")
   
 WHILE TRUE

  INPUT  g_abq00,g_abq01,g_type,g_b_y,g_b_m,g_b_q,g_e_y,g_e_m,g_e_q FROM abq00,abq01,type,b_y,b_m,b_q,e_y,e_m,e_q

      BEFORE INPUT
      CALL cl_qbe_init() 
      LET g_type = '1'
      LET g_b_y = YEAR(g_today)
      LET g_e_y = g_b_y
      LET g_b_m = 1
      LET g_e_m = 12
      LET g_b_q = 1 
      LET g_e_q = 4
      SELECT aza81 INTO g_aza.aza81 FROM aza_file
      SELECT tc_fbb01 INTO g_abq01 FROM abq_file WHERE abq00 = g_aza.aza81 AND rownum = 1
      LET g_abq00 = g_aza.aza81 
      DISPLAY  g_type,g_b_y,g_e_y,g_b_m,g_e_m,g_b_q,g_e_q TO  type,b_y,e_y,b_m,e_m,b_q,e_q
      CALL cl_set_comp_required("b_m,e_m",TRUE)
      CALL cl_set_comp_required("b_q,e_q",TRUE)
      CALL cl_set_comp_entry("b_m,e_m",TRUE) 
      CALL cl_set_comp_entry("b_q,e_q",TRUE)  

       AFTER FIELD abq00 
          IF NOT cl_null(g_abq00) THEN
             SELECT aaa01 INTO l_abq00 FROM aaa_file WHERE aaa01 = g_abq00 AND aaaacti = 'Y'
             IF cl_null(l_abq00) THEN
               CALL cl_err('帐套不存在','!',1)
               NEXT FIELD abq00
            END IF
           END IF

        AFTER FIELD abq01 
          IF NOT cl_null(g_abq01) THEN
            SELECT abq01 INTO l_abq01 FROM abq_file WHERE abq01 = g_abq01
            IF cl_null(l_abq01) THEN
               CALL cl_err('无此财务分析编号','!',1)
               NEXT FIELD abq01
            END IF
          END IF
 
        AFTER FIELD type  
            IF NOT cl_null(g_type) THEN 
               IF g_type = '1' then
                   LET g_b_q = NULL
                   LET g_e_q = NULL
                   DISPLAY  g_b_q,g_e_q TO b_q,e_q
                   CALL cl_set_comp_required("b_m,e_m",TRUE)
                   CALL cl_set_comp_entry("b_m,e_m",TRUE)
                   CALL cl_set_comp_required("b_q,e_q",FALSE)
                   CALL cl_set_comp_entry("b_q,e_q",FALSE)  
               END IF
               IF g_type = '2' then
                   LET g_b_m = NULL
                   LET g_e_m = NULL
                   DISPLAY  g_b_m,g_e_m  TO b_m,e_m
                   CALL cl_set_comp_required("b_m,e_m",FALSE)
                   CALL cl_set_comp_entry("b_m,e_m",FALSE)
                   CALL cl_set_comp_required("b_q,e_q",TRUE)
                   CALL cl_set_comp_entry("b_q,e_q",TRUE) 
               END IF
            END IF

        AFTER FIELD e_y
          IF NOT cl_null(g_e_y) THEN
             IF g_e_y < g_b_y THEN
                CALL cl_err('截止年度不能小于起始年度','!',1)
                NEXT FIELD e_y
             END IF             	
          END IF

        AFTER FIELD b_m
          IF NOT  cl_null(g_b_m)  THEN
             IF g_b_m < 1 OR g_b_m > 12 THEN
                CALL cl_err('期别必须在1~12之间','!',1)
             NEXT FIELD b_m
            END IF
          END IF

        AFTER FIELD e_m
          IF NOT  cl_null(g_e_m)  THEN
             IF g_e_m < 1 OR g_e_m > 12 THEN
                CALL cl_err('期别必须在1~12之间','!',1)
                NEXT FIELD e_m
             END IF 
          END IF

        AFTER FIELD b_q
          IF NOT  cl_null(g_b_q) THEN
             IF g_b_q < 1 OR g_b_q > 4 THEN
                CALL cl_err('季度必须在1~4之间','!',1)
             NEXT FIELD b_q
            END IF
          END IF

        AFTER FIELD e_q
          IF NOT  cl_null(g_e_q) THEN
             IF g_e_q < 1 OR g_e_q > 4 THEN
                CALL cl_err('季度必须在1~4之间','!',1)
             NEXT FIELD e_q
            END IF
         END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(abq00)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               CALL cl_create_qry() RETURNING  g_abq00
               DISPLAY g_abq00 TO abq00
               NEXT FIELD abq00

            WHEN INFIELD(abq01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_abq01"
               CALL cl_create_qry() RETURNING g_abq01
               DISPLAY g_abq01 TO abq01
               NEXT FIELD abq01

         END CASE

      ON ACTION controlg
         CALL cl_cmdask() 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      ON action EXIT 
         LET INT_FLAG = 1 
         EXIT INPUT    

   END INPUT

   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      RETURN 
   END IF

   INPUT tm.yy00,tm.yy01,tm.yy02,tm.yy03,tm.yy04,tm.yy05,tm.yy06,tm.yy07,tm.yy08,tm.yy09,tm.yy10,tm.yy11,tm.yy12
        ,tm.b_mm00,tm.b_mm01,tm.b_mm02,tm.b_mm03,tm.b_mm04,tm.b_mm05,tm.b_mm06,tm.b_mm07,tm.b_mm08,tm.b_mm09,tm.b_mm10,tm.b_mm11,tm.b_mm12
        ,tm.e_mm00,tm.e_mm01,tm.e_mm02,tm.e_mm03,tm.e_mm04,tm.e_mm05,tm.e_mm06,tm.e_mm07,tm.e_mm08,tm.e_mm09,tm.e_mm10,tm.e_mm11,tm.e_mm12
         FROM
         yy00,yy01,yy02,yy03,yy04,yy05,yy06,yy07,yy08,yy09,yy10,yy11,yy12
         ,b_mm00,b_mm01,b_mm02,b_mm03,b_mm04,b_mm05,b_mm06,b_mm07,b_mm08,b_mm09,b_mm10,b_mm11,b_mm12
        ,e_mm00,e_mm01,e_mm02,e_mm03,e_mm04,e_mm05,e_mm06,e_mm07,e_mm08,e_mm09,e_mm10,e_mm11,e_mm12

   BEFORE INPUT
       CALL cl_qbe_display_condition(lc_qbe_sn)
       LET l_year = g_e_y-g_b_y
       IF l_year = 0 THEN
          LET l_i = 0
          IF g_type ='1' THEN
            LET l_mm00 = ''
            LET l_mm00 = g_b_m - 1 
            IF l_mm00 = 0 THEN 
               LET tm.yy00 = g_b_y -1
               LET tm.b_mm00 = 12
               LET tm.e_mm00 = 12
            END IF 
            IF l_mm00 <> 0 THEN 
               LET tm.yy00 = g_b_y
               LET tm.b_mm00 = l_mm00
               LET tm.e_mm00 = l_mm00
            END IF        
              WHILE (g_b_m + l_i <= g_e_m AND l_i < 12)  
               IF l_i = 0 THEN
                   LET tm.yy01 = g_b_y
                   LET tm.b_mm01 = g_b_m
                   LET tm.e_mm01 = g_b_m
               END IF
               IF l_i = 1 THEN
                   LET tm.yy02 = g_b_y
                   LET tm.b_mm02 = g_b_m + l_i
                   LET tm.e_mm02 = g_b_m + l_i
               END IF
               IF l_i = 2 THEN
                   LET tm.yy03 = g_b_y
                   LET tm.b_mm03 = g_b_m + l_i
                   LET tm.e_mm03 = g_b_m + l_i
               END IF
               IF l_i = 3 THEN
                   LET tm.yy04 = g_b_y
                   LET tm.b_mm04 = g_b_m + l_i
                   LET tm.e_mm04 = g_b_m + l_i
               END IF
               IF l_i = 4 THEN
                   LET tm.yy05 = g_b_y
                   LET tm.b_mm05 = g_b_m + l_i
                   LET tm.e_mm05 = g_b_m + l_i
               END IF
               IF l_i = 5 THEN
                   LET tm.yy06 = g_b_y
                   LET tm.b_mm06 = g_b_m + l_i
                   LET tm.e_mm06 = g_b_m + l_i
               END IF
               IF l_i = 6 THEN
                   LET tm.yy07 = g_b_y
                   LET tm.b_mm07 = g_b_m + l_i
                   LET tm.e_mm07 = g_b_m + l_i
               END IF
               IF l_i = 7 THEN
                   LET tm.yy08 = g_b_y
                   LET tm.b_mm08 = g_b_m + l_i
                   LET tm.e_mm08 = g_b_m + l_i
               END IF
               IF l_i = 8 THEN
                   LET tm.yy09 = g_b_y
                   LET tm.b_mm09 = g_b_m + l_i
                   LET tm.e_mm09 = g_b_m + l_i
               END IF
               IF l_i = 9 THEN
                   LET tm.yy10 = g_b_y
                   LET tm.b_mm10 = g_b_m + l_i
                   LET tm.e_mm10 = g_b_m + l_i
               END IF
               IF l_i = 10 THEN
                   LET tm.yy11 = g_b_y
                   LET tm.b_mm11 = g_b_m + l_i
                   LET tm.e_mm11 = g_b_m + l_i
               END IF
               IF l_i = 11 THEN
                   LET tm.yy12 = g_b_y
                   LET tm.b_mm12 = g_b_m + l_i
                   LET tm.e_mm12 = g_b_m + l_i
               END IF
                  LET l_i = l_i + 1
            END WHILE
          END IF
          IF g_type = '2' THEN
           LET l_mm00 = ''
           LET l_mm00 = g_b_q - 1 
           IF l_mm00 = 0 THEN 
              LET tm.yy00 = g_b_y -1
              LET tm.b_mm00 = 9
              LET tm.e_mm00 = 12
           END IF 
           IF l_mm00 <> 0 THEN 
              LET tm.yy00 = g_b_y
              LET tm.b_mm00 = (l_mm00-1)*3+1
              LET tm.e_mm00 = l_mm00*3
           END IF        
            WHILE (g_b_q + l_i <= g_e_q AND l_i < 5 )
                 IF l_i = 0 THEN
                     LET tm.yy01 = g_b_y
                   LET tm.b_mm01 = (g_b_q+l_i-1)*3+1
                   LET tm.e_mm01 =(g_b_q+l_i)*3
               END IF
               IF l_i = 1 THEN
                     LET tm.yy02 = g_b_y
                   LET tm.b_mm02 = (g_b_q+l_i-1)*3+1
                   LET tm.e_mm02 =(g_b_q+l_i)*3
               END IF
                 IF l_i = 2 THEN
                     LET tm.yy03 = g_b_y
                   LET tm.b_mm03 = (g_b_q+l_i-1)*3+1
                   LET tm.e_mm03 =(g_b_q+l_i)*3
               END IF
               IF l_i = 3 THEN
                     LET tm.yy04 = g_b_y
                   LET tm.b_mm04 = (g_b_q+l_i-1)*3+1
                   LET tm.e_mm04 =(g_b_q+l_i)*3
               END IF
               LET l_i = l_i + 1
            END WHILE
          END IF
        END IF
        IF l_year > 0 THEN
             LET l_i = 0
             IF g_type = '1' THEN 
               LET tm.yy00 = g_b_y-1
               LET tm.b_mm00 = g_b_m
               LET tm.e_mm00 = g_e_m 
                WHILE (g_b_y + l_i  <= g_e_y AND l_i < 13)

                      IF l_i = 0 THEN
                         LET tm.yy01 = g_b_y + l_i
                         LET tm.b_mm01 = g_b_m
                         LET tm.e_mm01 = g_e_m
                     END IF
                     IF l_i = 1 THEN
                         LET tm.yy02 = g_b_y + l_i
                         LET tm.b_mm02 = g_b_m
                         LET tm.e_mm02 = g_e_m
                     END IF
                     IF l_i = 2 THEN
                         LET tm.yy03 = g_b_y + l_i
                         LET tm.b_mm03 = g_b_m
                         LET tm.e_mm03 = g_e_m
                     END IF
                     IF l_i = 3 THEN
                         LET tm.yy04 = g_b_y + l_i
                         LET tm.b_mm04 = g_b_m
                         LET tm.e_mm04 = g_e_m
                     END IF
                     IF l_i = 4 THEN
                         LET tm.yy05 = g_b_y + l_i
                         LET tm.b_mm05 = g_b_m
                         LET tm.e_mm05 = g_e_m
                     END IF
                     IF l_i = 5 THEN
                         LET tm.yy06 = g_b_y + l_i
                         LET tm.b_mm06 = g_b_m
                         LET tm.e_mm06 = g_e_m
                     END IF
                     IF l_i = 6 THEN
                         LET tm.yy07 = g_b_y + l_i
                         LET tm.b_mm07 = g_b_m
                         LET tm.e_mm07 = g_e_m
                     END IF
                     IF l_i = 7 THEN
                         LET tm.yy08 = g_b_y + l_i
                         LET tm.b_mm08 = g_b_m
                         LET tm.e_mm08 = g_e_m
                     END IF
                     IF l_i = 8 THEN
                         LET tm.yy09 = g_b_y + l_i
                         LET tm.b_mm09 = g_b_m
                         LET tm.e_mm09 = g_e_m
                     END IF
                     IF l_i = 9 THEN
                         LET tm.yy10 = g_b_y + l_i
                         LET tm.b_mm10 = g_b_m
                         LET tm.e_mm10 = g_e_m
                     END IF
                     IF l_i = 10 THEN
                         LET tm.yy11 = g_b_y + l_i
                         LET tm.b_mm11 = g_b_m
                         LET tm.e_mm11 = g_e_m
                     END IF
                     IF l_i = 11 THEN
                         LET tm.yy12 = g_b_y + l_i
                         LET tm.b_mm12 = g_b_m
                         LET tm.e_mm12 = g_e_m
                     END IF
                   LET l_i = l_i + 1
                END WHILE
             END IF
             IF g_type = '2' THEN
                LET tm.yy00 = g_b_y -1 
                LET tm.b_mm00 = (g_b_q-1)*3+1
                LET tm.e_mm00 = g_e_q*3
                WHILE (g_b_y + l_i  <= g_e_y AND l_year < 13)
                     IF l_i = 0 THEN
                         LET tm.yy01 = g_b_y + l_i
                         LET tm.b_mm01 = (g_b_q-1)*3+1
                         LET tm.e_mm01 = g_e_q*3
                     END IF
                     IF l_i = 1 THEN
                         LET tm.yy02 = g_b_y + l_i
                         LET tm.b_mm02 = (g_b_q-1)*3+1
                         LET tm.e_mm02 = g_e_q*3
                     END IF
                     IF l_i = 2 THEN
                         LET tm.yy03 = g_b_y + l_i
                         LET tm.b_mm03 = (g_b_q-1)*3+1
                         LET tm.e_mm03 = g_e_q*3
                     END IF
                     IF l_i = 3 THEN
                         LET tm.yy04 = g_b_y + l_i
                         LET tm.b_mm04 = (g_b_q-1)*3+1
                         LET tm.e_mm04 = g_e_q*3
                     END IF
                     IF l_i = 4 THEN
                         LET tm.yy05 = g_b_y + l_i
                         LET tm.b_mm05 = (g_b_q-1)*3+1
                         LET tm.e_mm05 = g_e_q*3
                     END IF
                     IF l_i = 5 THEN
                         LET tm.yy06 = g_b_y + l_i
                         LET tm.b_mm06 = (g_b_q-1)*3+1
                         LET tm.e_mm06 = g_e_q*3
                     END IF
                     IF l_i = 6 THEN
                         LET tm.yy07 = g_b_y + l_i
                         LET tm.b_mm07 = (g_b_q-1)*3+1
                         LET tm.e_mm07 = g_e_q*3
                     END IF
                     IF l_i = 7 THEN
                         LET tm.yy08 = g_b_y + l_i
                         LET tm.b_mm08 = (g_b_q-1)*3+1
                         LET tm.e_mm08 = g_e_q*3
                     END IF
                     IF l_i = 8 THEN
                         LET tm.yy09 = g_b_y + l_i
                         LET tm.b_mm09 = (g_b_q-1)*3+1
                         LET tm.e_mm09 = g_e_q*3
                     END IF
                     IF l_i = 9 THEN
                         LET tm.yy10 = g_b_y + l_i
                         LET tm.b_mm10 = (g_b_q-1)*3+1
                         LET tm.e_mm10 = g_e_q*3
                     END IF
                     IF l_i = 10 THEN
                         LET tm.yy11 = g_b_y + l_i
                         LET tm.b_mm11 = (g_b_q-1)*3+1
                         LET tm.e_mm11 = g_e_q*3
                     END IF
                     IF l_i = 11 THEN
                         LET tm.yy12 = g_b_y + l_i
                         LET tm.b_mm12 = (g_b_q-1)*3+1
                         LET tm.e_mm12 = g_e_q*3
                     END IF
                     LET l_i = l_i + 1
                END WHILE
             END IF
        END IF

      BEFORE FIELD yy00
      
         DISPLAY  tm.yy00,tm.yy01,tm.yy02,tm.yy03,tm.yy04,tm.yy05,tm.yy06,tm.yy07,tm.yy08,tm.yy09,tm.yy10,tm.yy11,tm.yy12
           ,tm.b_mm00,tm.b_mm01,tm.b_mm02,tm.b_mm03,tm.b_mm04,tm.b_mm05,tm.b_mm06,tm.b_mm07,tm.b_mm08,tm.b_mm09,tm.b_mm10,tm.b_mm11,tm.b_mm12
           ,tm.e_mm00,tm.e_mm01,tm.e_mm02,tm.e_mm03,tm.e_mm04,tm.e_mm05,tm.e_mm06,tm.e_mm07,tm.e_mm08,tm.e_mm09,tm.e_mm10,tm.e_mm11,tm.e_mm12
           TO
           yy00,yy01,yy02,yy03,yy04,yy05,yy06,yy07,yy08,yy09,yy10,yy11,yy12
            ,b_mm00,b_mm01,b_mm02,b_mm03,b_mm04,b_mm05,b_mm06,b_mm07,b_mm08,b_mm09,b_mm10,b_mm11,b_mm12
           ,e_mm00,e_mm01,e_mm02,e_mm03,e_mm04,e_mm05,e_mm06,e_mm07,e_mm08,e_mm09,e_mm10,e_mm11,e_mm12
      
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      
      ON ACTION CONTROLG 
         CALL cl_cmdask()    # Command execution
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about
         CALL cl_about()
      
      ON ACTION help
         CALL cl_show_help()
      
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      
      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT  
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      RETURN 
   END IF
   EXIT WHILE
 END WHILE 
 CALL g_hx.clear() 
 CALL g_abq.clear() 
 CALL q900_show()
END FUNCTION

FUNCTION q900_menu()

   WHILE TRUE
      CALL q900_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q900_cs() 
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL q900_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #No.TQC-D80014 ---Add--- Start
         WHEN "cve"
            IF cl_chk_act_auth() THEN
               CALL q900_b_pic()
            END IF
        #No.TQC-D80014 ---Add--- End
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_abq),'','')
            END IF 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_abq TO s_abq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count ) 
         CALL cl_show_fld_cont()


      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
         IF l_ac > 0 THEN
            CALL q900_b_fill2()
         END IF
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

     #ON ACTION output
     #   LET g_action_choice="output"
     #   EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
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

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION cva
         CALL q900_b_fill3('1')
         
      ON ACTION cvb
         CALL q900_b_fill3('2')
       
      ON ACTION cvc
         CALL q900_b_fill3('3')
        
      ON ACTION cvd
         CALL q900_b_fill3('4')   
         
     #No.TQC-D80014 ---Mark--- Start
     #ON ACTION cve
     #   CALL q900_b_pic()         
     ##ON ACTION pict 
     ##  CALL q900_b_pic() 
     #No.TQC-D80014 ---Mark--- End
     #No.TQC-D80014 ---Add--- Start
      ON ACTION cve
         LET g_action_choice="cve"
         EXIT DISPLAY
     #No.TQC-D80014 ---Add--- End
      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION CONTROLS 
         CALL cl_set_head_visible("","AUTO")

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	

  
FUNCTION q900_show()

    DISPLAY BY NAME g_abq00,g_abq01
    CALL q900_b_fill() #單身  
    #CALL q900_b_pic()
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q900_b_fill()              #BODY FILL UP
   DEFINE l_sql   LIKE type_file.chr1000
   DEFINE l_abq   RECORD LIKE abq_file.*
   DEFINE l_yy       LIKE type_file.num5
   DEFINE l_b_mm     LIKE type_file.num5
   DEFINE l_e_mm     LIKE type_file.num5
   DEFINE l_amount   LIKE type_file.num20_6
   DEFINE l_flag     LIKE type_file.num5
   DEFINE l_flag_01  LIKE type_file.chr1
   DEFINE l_flag_02  LIKE type_file.chr1
   DEFINE l_flag_03  LIKE type_file.chr1
   DEFINE l_flag_04  LIKE type_file.chr1
   DEFINE l_flag_05  LIKE type_file.chr1
   DEFINE l_flag_06  LIKE type_file.chr1
   DEFINE l_flag_07  LIKE type_file.chr1
   DEFINE l_flag_08  LIKE type_file.chr1
   DEFINE l_flag_09  LIKE type_file.chr1
   DEFINE l_flag_10  LIKE type_file.chr1
   DEFINE l_flag_11  LIKE type_file.chr1
   DEFINE l_flag_12  LIKE type_file.chr1

   #获取单身哪些期别需要抓取及显示
   #PS:可借由是否显示进行字段隐藏处理
   LET l_flag_01 = 'Y'
   LET l_flag_02 = 'Y'
   LET l_flag_03 = 'Y'
   LET l_flag_04 = 'Y'
   LET l_flag_05 = 'Y'
   LET l_flag_06 = 'Y'
   LET l_flag_07 = 'Y'
   LET l_flag_08 = 'Y'
   LET l_flag_09 = 'Y'
   LET l_flag_10 = 'Y'
   LET l_flag_11 = 'Y'
   LET l_flag_12 = 'Y'

   IF cl_null(tm.yy01) AND cl_null(tm.b_mm01) AND cl_null(tm.e_mm01) THEN
      LET l_flag_01 = 'N'
   END IF

   IF cl_null(tm.yy02) AND cl_null(tm.b_mm02) AND cl_null(tm.e_mm02) THEN
      LET l_flag_02 = 'N'
   END IF

   IF cl_null(tm.yy03) AND cl_null(tm.b_mm03) AND cl_null(tm.e_mm03) THEN
      LET l_flag_03 = 'N'
   END IF

   IF cl_null(tm.yy04) AND cl_null(tm.b_mm04) AND cl_null(tm.e_mm04) THEN
      LET l_flag_04 = 'N'
   END IF

   IF cl_null(tm.yy05) AND cl_null(tm.b_mm05) AND cl_null(tm.e_mm05) THEN
      LET l_flag_05 = 'N'
   END IF

   IF cl_null(tm.yy06) AND cl_null(tm.b_mm06) AND cl_null(tm.e_mm06) THEN
      LET l_flag_06 = 'N'
   END IF

   IF cl_null(tm.yy07) AND cl_null(tm.b_mm07) AND cl_null(tm.e_mm07) THEN
      LET l_flag_07 = 'N'
   END IF

   IF cl_null(tm.yy08) AND cl_null(tm.b_mm08) AND cl_null(tm.e_mm08) THEN
      LET l_flag_08 = 'N'
   END IF

   IF cl_null(tm.yy09) AND cl_null(tm.b_mm09) AND cl_null(tm.e_mm09) THEN
      LET l_flag_09 = 'N'
   END IF

   IF cl_null(tm.yy10) AND cl_null(tm.b_mm10) AND cl_null(tm.e_mm10) THEN
      LET l_flag_10 = 'N'
   END IF

   IF cl_null(tm.yy11) AND cl_null(tm.b_mm11) AND cl_null(tm.e_mm11) THEN
      LET l_flag_11 = 'N'
   END IF

   IF cl_null(tm.yy12) AND cl_null(tm.b_mm12) AND cl_null(tm.e_mm12) THEN
      LET l_flag_12 = 'N'
   END IF

   IF l_flag_01 = 'N'   THEN  CALL cl_set_comp_visible("tot01",FALSE ) CALL cl_set_comp_visible("tot00",FALSE )   END IF

   IF l_flag_02 = 'N'   THEN  CALL cl_set_comp_visible("tot02" ,FALSE )   END IF

   IF l_flag_03 = 'N'   THEN  CALL cl_set_comp_visible("tot03" ,FALSE )   END IF

   IF l_flag_04 = 'N'   THEN  CALL cl_set_comp_visible("tot04" ,FALSE )   END IF

   IF l_flag_05 = 'N'   THEN  CALL cl_set_comp_visible("tot05" ,FALSE )   END IF

   IF l_flag_06 = 'N'   THEN  CALL cl_set_comp_visible("tot06" ,FALSE )   END IF

   IF l_flag_07 = 'N'   THEN  CALL cl_set_comp_visible("tot07" ,FALSE )   END IF

   IF l_flag_08 = 'N'   THEN  CALL cl_set_comp_visible("tot08" ,FALSE )   END IF

   IF l_flag_09 = 'N'   THEN  CALL cl_set_comp_visible("tot09" ,FALSE )   END IF

   IF l_flag_10 = 'N'   THEN  CALL cl_set_comp_visible("tot10" ,FALSE )   END IF

   IF l_flag_11 = 'N'   THEN  CALL cl_set_comp_visible("tot11" ,FALSE )   END IF

   IF l_flag_12 = 'N'   THEN  CALL cl_set_comp_visible("tot12" ,FALSE )   END IF

      LET l_sql = "SELECT *",
               " FROM  abq_file ",
               " WHERE abq00 ='", g_abq00,"' AND  abq01 ='", g_abq01,"'",
               "   AND abq05 <> '3' ",
               " ORDER BY abq03 "

    PREPARE q900_pb FROM l_sql
    DECLARE q900_bcs                       #BODY CURSOR
        CURSOR FOR q900_pb

    FOR g_cnt = 1 TO g_abq.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_abq[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0
    LET g_cnt = 1
    LET g_chr1 = 'N'
    FOREACH q900_bcs INTO l_abq.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_chr1 = 'Y' 
        LET g_abq[g_cnt].abq04 = l_abq.abq04
        LET g_abq[g_cnt].abq06 = l_abq.abq06
        LET g_abq[g_cnt].abq08 = l_abq.abq08
        LET g_abq[g_cnt].abq15 = l_abq.abq15 
        LET g_abq[g_cnt].abq16 = l_abq.abq16 
        LET g_abq[g_cnt].abq17 = l_abq.abq17 
        LET g_abq[g_cnt].abq18 = l_abq.abq18 
        LET g_abq[g_cnt].abq19 = l_abq.abq19  
        
        #若数据来源<>'1,则本行仅显示指标名称/指标说明
        IF l_abq.abq05 = '1' THEN
           #对单身的12期做循环
           FOR l_flag = 1 TO 12
              #第一期
              IF l_flag = 1 THEN
                 IF l_flag_01 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy01,tm.b_mm01,tm.e_mm01,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot01 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot01进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot01,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot01
              END IF
              #第二期
              IF l_flag = 2 THEN
                 IF l_flag_02 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy02,tm.b_mm02,tm.e_mm02,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot02 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot02进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot02,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot02
              END IF
              #第三期
              IF l_flag = 3 THEN
                 IF l_flag_03 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy03,tm.b_mm03,tm.e_mm03,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot03 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot03进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot03,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot03
              END IF
              #第四期
              IF l_flag = 4 THEN
                 IF l_flag_04 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy04,tm.b_mm04,tm.e_mm04,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot04 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot04进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot04,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot04
              END IF
              #第五期
              IF l_flag = 5 THEN
                 IF l_flag_05 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy05,tm.b_mm05,tm.e_mm05,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot05 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot05进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot05,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot05
              END IF
              #第六期
              IF l_flag = 6 THEN
                 IF l_flag_06 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy06,tm.b_mm06,tm.e_mm06,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot06 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot06进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot06,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot06
              END IF
              #第七期
              IF l_flag = 7 THEN
                 IF l_flag_07 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy07,tm.b_mm07,tm.e_mm07,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot07 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot07进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot07,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot07
              END IF
              #第八期
              IF l_flag = 8 THEN
                 IF l_flag_08 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy08,tm.b_mm08,tm.e_mm08,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot08 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot08进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot08,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot08
              END IF
              #第九期
              IF l_flag = 9 THEN
                 IF l_flag_09 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy09,tm.b_mm09,tm.e_mm09,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot09 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot09进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot09,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot09
              END IF
              #第十期
              IF l_flag = 10 THEN
                 IF l_flag_10 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy10,tm.b_mm10,tm.e_mm10,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot10 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot10进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot10,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot10
              END IF
              #第十一期
              IF l_flag = 11 THEN
                 IF l_flag_11 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy11,tm.b_mm11,tm.e_mm11,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot11 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot05进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot11,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot11
              END IF
              #第十二期
              IF l_flag = 12 THEN
                 IF l_flag_12 = 'N' THEN
                    CONTINUE FOR
                 END IF
                                     #公式              #年度    #起始期别 #截至期别
                 CALL q900_analy_form(l_abq.abq07,tm.yy12,tm.b_mm12,tm.e_mm12,l_flag)
                    RETURNING l_amount
                 LET g_abq[g_cnt].tot12 = l_amount
                 #再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot12进行显示格式调整
                                    #栏位金额              数据格式          保留位数
                 CALL q900_dis_form(g_abq[g_cnt].tot12,l_abq.abq09,l_abq.abq10)
                    RETURNING g_abq[g_cnt].tot12
              END IF
           END FOR
        END IF

        LET g_cnt = g_cnt + 1

        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF

    END FOREACH
    LET g_rec_b=g_cnt-1
    CALL g_abq.deleteElement(g_cnt)               #單身筆數-1 
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q900_out()
DEFINE
    l_i             LIKE type_file.num5,   
    sr              RECORD
        abq03    LIKE abq_file.abq03,
        abq04    LIKE abq_file.abq04,
        abq06    LIKE abq_file.abq06,
        abq08    LIKE abq_file.abq08,
        abq15    LIKE abq_file.abq15,
        abq16    LIKE abq_file.abq16,
        abq17    LIKE abq_file.abq17,
        abq18    LIKE abq_file.abq18,
        abq19    LIKE abq_file.abq19,
        tot01   LIKE type_file.chr30,
        tot02   LIKE type_file.chr30,
        tot03   LIKE type_file.chr30,
        tot04   LIKE type_file.chr30,
        tot05   LIKE type_file.chr30,
        tot06   LIKE type_file.chr30,
        tot07   LIKE type_file.chr30,
        tot08   LIKE type_file.chr30,
        tot09   LIKE type_file.chr30,
        tot10   LIKE type_file.chr30,
        tot11   LIKE type_file.chr30,
        tot12   LIKE type_file.chr30
    END RECORD
   DEFINE l_flag01  LIKE type_file.chr1
   DEFINE l_flag02  LIKE type_file.chr1
   DEFINE l_flag03  LIKE type_file.chr1
   DEFINE l_flag04  LIKE type_file.chr1
   DEFINE l_flag05  LIKE type_file.chr1
   DEFINE l_flag06  LIKE type_file.chr1
   DEFINE l_flag07  LIKE type_file.chr1
   DEFINE l_flag08  LIKE type_file.chr1
   DEFINE l_flag09  LIKE type_file.chr1
   DEFINE l_flag10  LIKE type_file.chr1
   DEFINE l_flag11  LIKE type_file.chr1
   DEFINE l_flag12  LIKE type_file.chr1
   DEFINE l_za05    LIKE za_file.za05     
   
   LET g_wc = ''
   #cr报表期别动态显示/隐藏
   LET l_flag01 = 'Y'
   LET l_flag02 = 'Y'
   LET l_flag03 = 'Y'
   LET l_flag04 = 'Y'
   LET l_flag05 = 'Y'
   LET l_flag06 = 'Y'
   LET l_flag07 = 'Y'
   LET l_flag08 = 'Y'
   LET l_flag09 = 'Y'
   LET l_flag10 = 'Y'
   LET l_flag11 = 'Y'
   LET l_flag12 = 'Y'

   IF cl_null(tm.yy01) AND cl_null(tm.b_mm01) AND cl_null(tm.e_mm01) THEN
      LET l_flag01 = 'N'
   END IF

   IF cl_null(tm.yy02) AND cl_null(tm.b_mm02) AND cl_null(tm.e_mm02) THEN
      LET l_flag02 = 'N'
   END IF

   IF cl_null(tm.yy03) AND cl_null(tm.b_mm03) AND cl_null(tm.e_mm03) THEN
      LET l_flag03 = 'N'
   END IF

   IF cl_null(tm.yy04) AND cl_null(tm.b_mm04) AND cl_null(tm.e_mm04) THEN
      LET l_flag04 = 'N'
   END IF

   IF cl_null(tm.yy05) AND cl_null(tm.b_mm05) AND cl_null(tm.e_mm05) THEN
      LET l_flag05 = 'N'
   END IF

   IF cl_null(tm.yy06) AND cl_null(tm.b_mm06) AND cl_null(tm.e_mm06) THEN
      LET l_flag06 = 'N'
   END IF

   IF cl_null(tm.yy07) AND cl_null(tm.b_mm07) AND cl_null(tm.e_mm07) THEN
      LET l_flag07 = 'N'
   END IF

   IF cl_null(tm.yy08) AND cl_null(tm.b_mm08) AND cl_null(tm.e_mm08) THEN
      LET l_flag08 = 'N'
   END IF

   IF cl_null(tm.yy09) AND cl_null(tm.b_mm09) AND cl_null(tm.e_mm09) THEN
      LET l_flag09 = 'N'
   END IF

   IF cl_null(tm.yy10) AND cl_null(tm.b_mm10) AND cl_null(tm.e_mm10) THEN
      LET l_flag10 = 'N'
   END IF

   IF cl_null(tm.yy11) AND cl_null(tm.b_mm11) AND cl_null(tm.e_mm11) THEN
      LET l_flag11 = 'N'
   END IF

   IF cl_null(tm.yy12) AND cl_null(tm.b_mm12) AND cl_null(tm.e_mm12) THEN
      LET l_flag12 = 'N'
   END IF
   
    IF cl_null(g_abq01) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
     
    IF cl_null(g_wc) THEN
       LET g_wc =l_flag01,";",l_flag02,";",l_flag03,";",l_flag04,";",l_flag05,";",l_flag06,";",l_flag07,";",l_flag08,";",l_flag09,";",l_flag10,";",l_flag11,";",l_flag12    
    END IF
  
    CALL cl_wait()
      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
      SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
         
    CALL cl_del_data(l_table)
      LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    
    FOR l_i = 1 TO g_rec_b
    
       SELECT abq03 INTO sr.abq03 
         FROM (SELECT abq03,rownum a FROM abq_file WHERE abq00 = g_abq00 AND abq01 = g_abq01)
           WHERE a = l_i
       IF SQLCA.sqlcode THEN
            CALL cl_err('sel:',SQLCA.sqlcode,1)
            RETURN 
       END IF
       LET sr.abq04 = g_abq[l_i].abq04
       LET sr.abq06 = g_abq[l_i].abq06
       LET sr.abq08 = g_abq[l_i].abq08
       LET sr.abq15 = g_abq[l_i].abq15
       LET sr.abq16 = g_abq[l_i].abq16
       LET sr.abq17 = g_abq[l_i].abq17
       LET sr.abq18 = g_abq[l_i].abq18
       LET sr.abq19 = g_abq[l_i].abq19 
       LET sr.tot01 = g_abq[l_i].tot01
       LET sr.tot02 = g_abq[l_i].tot02
       LET sr.tot03 = g_abq[l_i].tot03
       LET sr.tot04 = g_abq[l_i].tot04
       LET sr.tot05 = g_abq[l_i].tot05
       LET sr.tot06 = g_abq[l_i].tot06
       LET sr.tot07 = g_abq[l_i].tot07
       LET sr.tot08 = g_abq[l_i].tot08
       LET sr.tot09 = g_abq[l_i].tot09
       LET sr.tot10 = g_abq[l_i].tot10
       LET sr.tot11 = g_abq[l_i].tot11
       LET sr.tot12 = g_abq[l_i].tot12 
       EXECUTE insert_prep USING sr.*
       IF SQLCA.sqlcode THEN
            CALL cl_err('execute:',SQLCA.sqlcode,1)
            RETURN 
       END IF
    END FOR 
   
    LET g_str = g_wc CLIPPED
    LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('aglq900','aglq900',g_sql,g_str)
    
    ERROR ""
 END FUNCTION

FUNCTION q900_analy_form(p_abq07,p_yy,p_b_mm,p_e_mm,p_flag)
   DEFINE l_str      STRING
   DEFINE l_str1     STRING
   DEFINE l_formula  DYNAMIC ARRAY OF LIKE abo_file.abo01
   DEFINE l_amt      DYNAMIC ARRAY OF LIKE type_file.num20_6
   DEFINE p_abq07   LIKE abq_file.abq07
   DEFINE p_yy            LIKE type_file.num5
   DEFINE p_b_mm          LIKE type_file.num5
   DEFINE p_e_mm          LIKE type_file.num5
   DEFINE l_a          LIKE type_file.chr1
   DEFINE l_count      LIKE type_file.num5
   DEFINE l_length     LIKE type_file.num5
   DEFINE l_i          LIKE type_file.num5
   DEFINE j            LIKE type_file.num5
   DEFINE l_aah04      LIKE aah_file.aah04
   DEFINE l_amount     LIKE type_file.num20_6
   DEFINE l_bdate      LIKE type_file.dat
   DEFINE l_edate      LIKE type_file.dat
   DEFINE p_flag       LIKE type_file.num5
   DEFINE l_abo01   LIKE abo_file.abo01 
   DEFINE l_max        LIKE type_file.num10
   DEFINE l_sql        STRING
   DEFINE l_num        LIKE type_file.num10

   LET l_amount = 0
   LET l_str = p_abq07
   LET l_count = 1
   LET l_length =l_str.getLength()
   LET l_a = ''
   LET l_str1 = ''
   LET l_i = 1
   WHILE (l_count <= l_length)
     LET l_a = l_str.getCharAt(l_count)
       IF l_a MATCHES "[a-zA-Z]" THEN
           WHILE l_a MATCHES "[a-zA-Z]"
               IF cl_null(l_str1) THEN
                  LET l_str1 = l_a
               ELSE
                  LET l_str1=l_str1,l_a
               END IF
             LET l_count = l_count + 1
             LET l_a = l_str.getCharAt(l_count)
           END WHILE
         LET l_formula[l_i] = l_str1
         LET l_i = l_i + 1
         LET l_count = l_count - 1
       ELSE
         LET l_str1 = ''
         LET l_a = ''
       END IF
     LET l_count = l_count + 1
   END WHILE
  
   #然后分别对各个变量代码根据其取数逻辑,至aah_file进行取数
   DELETE FROM ffa_tmp
   FOR j = 1 to l_formula.getLength()
      #若财务指标是'DATE'或'date'则
      #LET l_amt[j] = 期间天数
     IF NOT cl_null(l_formula[j]) THEN 
       IF l_formula[j] <> 'DATE' AND  l_formula[j] <> 'date' THEN
         #启用函数,获取此变量代码的aah_file对应金额
         #             变量代码     年度 起始期别 截至期别
         CALL q900_aah(l_formula[j],p_yy,p_b_mm,p_e_mm,p_flag)
            RETURNING l_aah04
         LET l_amt[j] = l_aah04
       ELSE
        CALL s_ymtodate(p_yy,p_b_mm,p_yy,p_e_mm)
           RETURNING l_bdate,l_edate
        LET l_amt[j] = l_edate - l_bdate + 1
       END IF    
      #把l_str中的变量'l_formula[1]'替换为'l_amt[1]'
     # CALL cl_replace_str(l_str,l_formula[j],l_amt[j]) RETURNING l_str
       INSERT INTO ffa_tmp VALUES(l_formula[j])
     END IF 
   END FOR
   
   LET l_sql = "SELECT DISTINCT abo01,length(abo01) a FROM ffa_tmp ORDER BY a desc "
   PREPARE des_pre FROM l_sql
   DECLARE des_cs CURSOR FOR des_pre
   FOREACH des_cs INTO l_abo01,l_num
      FOR j = 1 TO l_formula.getLength()
          IF l_formula[j] = l_abo01 THEN 
            CALL cl_replace_str(l_str,l_formula[j],l_amt[j]) RETURNING l_str
            EXIT FOR 
          END IF 
      END FOR 
   END FOREACH                
   
   #至此,l_str应该为只含加减乘除,及金额,数字的字符串.
   #可借用oracle进行数据查询
   LET g_sql = "SELECT ",l_str CLIPPED," FROM DUAL"
   PREPARE g_sql_pre FROM g_sql
   EXECUTE g_sql_pre INTO l_amount
   RETURN l_amount
END FUNCTION

#再根据'数据格式'和'保留位数'的设置对g_abq[g_cnt].tot02进行显示格式调整
                       #栏位金额   数据格式  保留位数
FUNCTION q900_dis_form(p_tot02,p_abq09,p_abq10)
   DEFINE p_abq09 LIKE abq_file.abq09
   DEFINE p_abq10 LIKE abq_file.abq10
   DEFINE p_tot02    LIKE type_file.chr20

   #先根据数据格式对金额进行处理
   IF p_abq09 = '1' THEN LET p_tot02 = p_tot02 * 100 END IF
   IF p_abq09 = '2' THEN LET p_tot02 = p_tot02 END IF
   IF p_abq09 = '3' THEN LET p_tot02 = p_tot02 * 1000 END IF

   #再根据保留位数进行四舍五入处理
   LET  p_tot02 = cl_digcut(p_tot02,p_abq10)

   #去除多余的小数位数
   CALL q900_fetch_bit(p_tot02,p_abq10)
      RETURNING p_tot02

   #再根据数据格式对金额显示进行处理
  # IF p_abq09 = '1' THEN LET p_tot02 = p_tot02 CLIPPED,'%'  END IF
  # IF p_abq09 = '3' THEN LET p_tot02 = p_tot02 CLIPPED,'‰'  END IF

    RETURN p_tot02


END FUNCTION

#                变量代码  年度 起始期别 截至期别
FUNCTION q900_aah(p_abo01,p_yy,p_b_mm,p_e_mm,p_flag)
   DEFINE l_abo   RECORD LIKE abo_file.*
   DEFINE p_abo01 LIKE abo_file.abo01
   DEFINE p_yy          LIKE type_file.num5
   DEFINE p_b_mm          LIKE type_file.num5
   DEFINE p_e_mm          LIKE type_file.num5
   DEFINE amt0         LIKE aah_file.aah04
   DEFINE l_a          LIKE aah_file.aah04
   DEFINE l_b          LIKE aah_file.aah04
   DEFINE p_flag       LIKE type_file.num5

   LET l_a=0 
   LET l_b=0

   SELECT * INTO l_abo.*
     FROM abo_file
    WHERE abo00 = g_abq00
      AND abo01 = p_abo01

   #以下逻辑参考aglq811/aglq812金额抓取
   #abo06金额来源为
   #1.科目之期初(借减贷)
  IF l_abo.abo06 = '1' THEN
   SELECT SUM(aah04-aah05) INTO amt0
     FROM aah_file,aag_file
      WHERE aah00 = g_abq00
        AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 < p_b_mm
   END IF
    
    #2.科目之当期异动
   IF l_abo.abo06 = '2' THEN
    SELECT SUM(aah04-aah05) INTO amt0
     FROM aah_file,aag_file
      WHERE aah00 = g_abq00
        AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 BETWEEN p_b_mm AND p_e_mm
     
     #损益类科目的借方发生额
     SELECT SUM(abb07) INTO l_a from aba_file,abb_file,aag_file
       WHERE aba00= g_abq00
         AND aba00=aag00
         AND aba00=abb00
         AND aba01=abb01
         AND abb03=aag01
         AND aag01 BETWEEN l_abo.abo04 AND l_abo.abo05
         AND aag07 IN ('2','3')
         AND aag04='2'
         AND abb06='1'  #借方
         AND aba03 = p_yy
         AND aba04 BETWEEN p_b_mm AND p_e_mm
         AND aba06='CE'
         
     #损益类科目的贷方发生额
     SELECT SUM(abb07) INTO l_b from aba_file,abb_file,aag_file
      WHERE aba00= g_abq00
        AND aba00=aag00
        AND aba00=abb00
        AND aba01=abb01
        AND abb03=aag01
        AND aag01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aag07 IN ('2','3')
        AND aag04='2'
        AND abb06='2'  #贷方
        AND aba03 = p_yy
        AND aba04 BETWEEN p_b_mm AND p_e_mm
        AND aba06='CE'
   END IF
   
    
   #3.科目之期末(借减贷)
   IF l_abo.abo06 = '3' THEN
     SELECT SUM(aah04-aah05) INTO amt0
      FROM aah_file,aag_file
       WHERE aah00 = g_abq00
        AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 <= p_e_mm
    END IF
    
    #4.科目之当期异动(借)
   IF l_abo.abo06 = '4' THEN
    SELECT SUM(aah04) INTO amt0
     FROM aah_file,aag_file
      WHERE aah00 = g_abq00
        AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 BETWEEN p_b_mm AND p_e_mm
        
        #损益类科目的借方发生额
     SELECT SUM(abb07) INTO l_a from aba_file,abb_file,aag_file
       WHERE aba00= g_abq00
         AND aba00=aag00
         AND aba00=abb00
         AND aba01=abb01
         AND abb03=aag01
         AND aag01 BETWEEN l_abo.abo04 AND l_abo.abo05
         AND aag07 IN ('2','3')
         AND aag04='2'
         AND abb06='1'  #借方
         AND aba03 = p_yy
         AND aba04 BETWEEN p_b_mm AND p_e_mm
         AND aba06='CE'

     #损益类科目的贷方发生额
     SELECT SUM(abb07) INTO l_b from aba_file,abb_file,aag_file
      WHERE aba00= g_abq00
        AND aba00=aag00
        AND aba00=abb00
        AND aba01=abb01
        AND abb03=aag01
        AND aag01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aag07 IN ('2','3')
        AND aag04='2'
        AND abb06='2'  #贷方
        AND aba03 = p_yy
        AND aba04 BETWEEN p_b_mm AND p_e_mm
        AND aba06='CE'
   END IF     
   
    #5.科目之当期异动(贷)
   IF l_abo.abo06 = '5' THEN
    SELECT SUM(aah05) INTO amt0
     FROM aah_file,aag_file
      WHERE aah00 =g_abq00
      AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 BETWEEN p_b_mm AND p_e_mm
        
    #损益类科目的借方发生额
     SELECT SUM(abb07) INTO l_a from aba_file,abb_file,aag_file
       WHERE aba00= g_abq00
         AND aba00=aag00
         AND aba00=abb00
         AND aba01=abb01
         AND abb03=aag01
         AND aag01 BETWEEN l_abo.abo04 AND l_abo.abo05
         AND aag07 IN ('2','3')
         AND aag04='2'
         AND abb06='1'  #借方
         AND aba03 = p_yy
         AND aba04 BETWEEN p_b_mm AND p_e_mm
         AND aba06='CE'
         
     #损益类科目的贷方发生额
     SELECT SUM(abb07) INTO l_b from aba_file,abb_file,aag_file
      WHERE aba00= g_abq00
        AND aba00=aag00
        AND aba00=abb00
        AND aba01=abb01
        AND abb03=aag01
        AND aag01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aag07 IN ('2','3')
        AND aag04='2'
        AND abb06='2'  #贷方
        AND aba03 = p_yy
        AND aba04 BETWEEN p_b_mm AND p_e_mm
        AND aba06='CE'
   END IF   
   
    #6.科目之期初(借)
   IF  l_abo.abo06 = '6' THEN
    SELECT SUM(aah04) INTO amt0
     FROM aah_file,aag_file
      WHERE aah00 = g_abq00
        AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 < p_b_mm
  END IF
   
    #7.科目之期初(贷)
   IF l_abo.abo06 = '7' THEN
    SELECT SUM(aah05) INTO amt0
     FROM aah_file,aag_file
      WHERE aah00 = g_abq00
      AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 < p_b_mm
   END IF
    
    #8.科目之期末(借)
   IF l_abo.abo06 = '8' THEN
    SELECT SUM(aah04) INTO amt0
     FROM aah_file,aag_file
      WHERE aah00 = g_abq00
        AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 <= p_e_mm
   END IF
    
    #9.科目之期末(贷)
   IF l_abo.abo06 = '9' THEN
    SELECT SUM(aah05) INTO amt0
     FROM aah_file,aag_file
      WHERE aah00 = g_abq00
        AND aah00 = aag00
        AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aah01 = aag01
        AND aag07 IN ('2','3')
        AND aah02 = p_yy
        AND aah03 <= p_e_mm
  END IF

    #10.科目之年初余额
   IF l_abo.abo06 = '10' THEN
      SELECT SUM(aah04-aah05) INTO amt0
        FROM aah_file,aag_file
       WHERE aah00 = g_abq00
         AND aah00 = aag00
         AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
         AND aah01 = aag01
         AND aag07 IN ('2','3')
         AND aah02 = p_yy 
         AND aah03 = 0
      
   END IF
 
    #11.科目之上期余额
   IF l_abo.abo06 = '11' THEN 
      IF p_flag = 1 THEN 
        LET p_yy = tm.yy00
        LET p_b_mm = tm.b_mm00
        LET p_e_mm = tm.e_mm00
      END IF  
      IF p_flag = 2 THEN 
        LET p_yy = tm.yy01
        LET p_b_mm = tm.b_mm01
        LET p_e_mm = tm.e_mm01
      END IF 
      IF p_flag = 3 THEN 
        LET p_yy = tm.yy02
        LET p_b_mm = tm.b_mm02
        LET p_e_mm = tm.e_mm02
      END IF 
      IF p_flag = 4 THEN 
        LET p_yy = tm.yy03
        LET p_b_mm = tm.b_mm03
        LET p_e_mm = tm.e_mm03
      END IF 
      IF p_flag = 5 THEN 
        LET p_yy = tm.yy04
        LET p_b_mm = tm.b_mm04
        LET p_e_mm = tm.e_mm04
      END IF 
      IF p_flag = 6 THEN 
        LET p_yy = tm.yy05
        LET p_b_mm = tm.b_mm05
        LET p_e_mm = tm.e_mm05
      END IF 
      IF p_flag = 7 THEN 
        LET p_yy = tm.yy06
        LET p_b_mm = tm.b_mm06
        LET p_e_mm = tm.e_mm06
      END IF 
      IF p_flag = 8 THEN 
        LET p_yy = tm.yy07
        LET p_b_mm = tm.b_mm07
        LET p_e_mm = tm.e_mm07
      END IF 
      IF p_flag = 9 THEN 
        LET p_yy = tm.yy08
        LET p_b_mm = tm.b_mm08
        LET p_e_mm = tm.e_mm08
      END IF 
      IF p_flag = 10 THEN 
        LET p_yy = tm.yy09
        LET p_b_mm = tm.b_mm09
        LET p_e_mm = tm.e_mm09
      END IF 
      IF p_flag = 11 THEN 
        LET p_yy = tm.yy10
        LET p_b_mm = tm.b_mm10
        LET p_e_mm = tm.e_mm10
      END IF      
      IF p_flag = 12 THEN 
        LET p_yy = tm.yy11
        LET p_b_mm = tm.b_mm11
        LET p_e_mm = tm.e_mm11
      END IF           
      SELECT SUM(aah04-aah05) INTO amt0
        FROM aah_file,aag_file
       WHERE aah00 = g_abq00
         AND aah00 = aag00
         AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
         AND aah01 = aag01
         AND aag07 IN ('2','3')
         AND aah02 = p_yy
         AND aah03 <= p_e_mm
     
   END IF
  
   #12.科目之上期异动
   IF l_abo.abo06 = '12' THEN 
      IF p_flag = 1 THEN 
        LET p_yy = tm.yy00
        LET p_b_mm = tm.b_mm00
        LET p_e_mm = tm.e_mm00
      END IF  
      IF p_flag = 2 THEN 
        LET p_yy = tm.yy01
        LET p_b_mm = tm.b_mm01
        LET p_e_mm = tm.e_mm01
      END IF 
      IF p_flag = 3 THEN 
        LET p_yy = tm.yy02
        LET p_b_mm = tm.b_mm02
        LET p_e_mm = tm.e_mm02
      END IF 
      IF p_flag = 4 THEN 
        LET p_yy = tm.yy03
        LET p_b_mm = tm.b_mm03
        LET p_e_mm = tm.e_mm03
      END IF 
      IF p_flag = 5 THEN 
        LET p_yy = tm.yy04
        LET p_b_mm = tm.b_mm04
        LET p_e_mm = tm.e_mm04
      END IF 
      IF p_flag = 6 THEN 
        LET p_yy = tm.yy05
        LET p_b_mm = tm.b_mm05
        LET p_e_mm = tm.e_mm05
      END IF 
      IF p_flag = 7 THEN 
        LET p_yy = tm.yy06
        LET p_b_mm = tm.b_mm06
        LET p_e_mm = tm.e_mm06
      END IF 
      IF p_flag = 8 THEN 
        LET p_yy = tm.yy07
        LET p_b_mm = tm.b_mm07
        LET p_e_mm = tm.e_mm07
      END IF 
      IF p_flag = 9 THEN 
        LET p_yy = tm.yy08
        LET p_b_mm = tm.b_mm08
        LET p_e_mm = tm.e_mm08
      END IF 
      IF p_flag = 10 THEN 
        LET p_yy = tm.yy09
        LET p_b_mm = tm.b_mm09
        LET p_e_mm = tm.e_mm09
      END IF 
      IF p_flag = 11 THEN 
        LET p_yy = tm.yy10
        LET p_b_mm = tm.b_mm10
        LET p_e_mm = tm.e_mm10
      END IF      
      IF p_flag = 12 THEN 
        LET p_yy = tm.yy11
        LET p_b_mm = tm.b_mm11
        LET p_e_mm = tm.e_mm11
      END IF           
      SELECT SUM(aah04-aah05) INTO amt0
        FROM aah_file,aag_file
       WHERE aah00 = g_abq00
         AND aah00 = aag00
         AND aah01 BETWEEN l_abo.abo04 AND l_abo.abo05
         AND aah01 = aag01
         AND aag07 IN ('2','3')
         AND aah02 = p_yy
         AND aah03 BETWEEN p_b_mm AND p_e_mm
         
           #损益类科目的借方发生额
      SELECT SUM(abb07) INTO l_a from aba_file,abb_file,aag_file
       WHERE aba00= g_abq00
         AND aba00=aag00
         AND aba00=abb00
         AND aba01=abb01
         AND abb03=aag01
         AND aag01 BETWEEN l_abo.abo04 AND l_abo.abo05
         AND aag07 IN ('2','3')
         AND aag04='2'
         AND abb06='1'  #借方
         AND aba03 = p_yy
         AND aba04 BETWEEN p_b_mm AND p_e_mm
         AND aba06='CE'
         
     #损益类科目的贷方发生额
     SELECT SUM(abb07) INTO l_b from aba_file,abb_file,aag_file
      WHERE aba00= g_abq00
        AND aba00=aag00
        AND aba00=abb00
        AND aba01=abb01
        AND abb03=aag01
        AND aag01 BETWEEN l_abo.abo04 AND l_abo.abo05
        AND aag07 IN ('2','3')
        AND aag04='2'
        AND abb06='2'  #贷方
        AND aba03 = p_yy
        AND aba04 BETWEEN p_b_mm AND p_e_mm
        AND aba06='CE'    
   END IF        
    
   #13.经营活动产生的现金流量  
   IF l_abo.abo06 = '13' THEN 
     
      #损益类科目的借方发生额
      SELECT SUM(NVL(nme08,0)) INTO l_a from nme_file
       WHERE YEAR(nme16) = p_yy
         AND MONTH(nme16) BETWEEN p_b_mm AND p_e_mm
         AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 = '10' AND nmlacti = 'Y' ) 
       
     #损益类科目的贷方发生额 
     SELECT SUM(NVL(nme08,0)) INTO l_a from nme_file
       WHERE YEAR(nme16) = p_yy
         AND MONTH(nme16) BETWEEN p_b_mm AND p_e_mm
         AND nme14 IN (SELECT nml01 FROM nml_file WHERE nml03 = '11' AND nmlacti = 'Y' ) 
   END IF
          
    
    IF cl_null(amt0) THEN
       LET amt0=0
    END IF

    IF cl_null(l_a) THEN
       LET l_a=0
    END IF

    IF cl_null(l_b) THEN
       LET l_b=0
    END IF

    IF l_abo.abo06 = 2 OR l_abo.abo06 = 4 OR l_abo.abo06 = 5 OR l_abo.abo06 = 12 OR l_abo.abo06 = 13 THEN 
      #amt需要减去a加上b的值
       LET amt0 = amt0 - l_a + l_b
    END IF 

    #如果是贷余,以上抓取借-贷的金额要乘-1
    IF l_abo.abo03 = '2' AND (l_abo.abo06 ='1' OR l_abo.abo06 ='2' OR l_abo.abo06 ='3' OR l_abo.abo06 = '10' OR l_abo.abo06 = '11' OR l_abo.abo06 = '12') THEN
       LET amt0 = amt0 * (-1)
    END IF
    
    RETURN amt0

END FUNCTION

#去除多余的小数位数
FUNCTION q900_fetch_bit(p_tot02,p_abq10)
   DEFINE p_tot02    LIKE type_file.chr20
   DEFINE p_abq10 LIKE abq_file.abq10
   DEFINE l_num_6    DEC(20,6)
   DEFINE l_num_5    DEC(20,5)
   DEFINE l_num_4    DEC(20,4)
   DEFINE l_num_3    DEC(20,3)
   DEFINE l_num_2    DEC(20,2)
   DEFINE l_num_1    DEC(20,1)
   DEFINE l_num_0    DEC(20,1)
   DEFINE l_tot02    LIKE type_file.chr20

   CASE p_abq10
      WHEN '6' LET l_num_6 = p_tot02
               LET l_tot02 = l_num_6
      WHEN '5' LET l_num_5 = p_tot02
               LET l_tot02 = l_num_5
      WHEN '4' LET l_num_4 = p_tot02
               LET l_tot02 = l_num_4
      WHEN '3' LET l_num_3 = p_tot02
               LET l_tot02 = l_num_3
      WHEN '2' LET l_num_2 = p_tot02
               LET l_tot02 = l_num_2
      WHEN '1' LET l_num_1 = p_tot02
               LET l_tot02 = l_num_1
      WHEN '0' LET l_num_0 = p_tot02
               LET l_tot02 = l_num_0
      OTHERWISE
               LET l_tot02 = p_tot02
   END CASE
   RETURN l_tot02
END FUNCTION
 
FUNCTION q900_b_fill2()
DEFINE id,l_h          LIKE type_file.num10  
DEFINE l_str           STRING
DEFINE l_length        LIKE type_file.num20_6
DEFINE l_p1            LIKE type_file.num10
DEFINE l_p2               LIKE type_file.num20_6
DEFINE l_p3               LIKE type_file.num20_6
DEFINE l_p4               LIKE type_file.num20_6
DEFINE l_p5               LIKE type_file.num20_6
DEFINE l_p6               LIKE type_file.num20_6
DEFINE l_p7               LIKE type_file.num20_6
DEFINE l_p8               LIKE type_file.num20_6
DEFINE l_p9               LIKE type_file.num20_6
DEFINE l_p10              LIKE type_file.num20_6
DEFINE l_p11              LIKE type_file.num20_6
DEFINE l_p12              LIKE type_file.num20_6
DEFINE l_p15              LIKE type_file.num20_6
DEFINE l_p16              LIKE type_file.num20_6 
DEFINE l_p17              LIKE type_file.num20_6
DEFINE l_p18              LIKE type_file.num20_6 
DEFINE l_p19              LIKE type_file.num20_6 
DEFINE l_q1               LIKE type_file.num20_6
DEFINE l_q2               LIKE type_file.num20_6
DEFINE l_q3               LIKE type_file.num20_6
DEFINE l_q4               LIKE type_file.num20_6
DEFINE l_q5               LIKE type_file.num20_6
DEFINE l_q6               LIKE type_file.num20_6
DEFINE l_q7               LIKE type_file.num20_6
DEFINE l_q8               LIKE type_file.num20_6
DEFINE l_q9               LIKE type_file.num20_6
DEFINE l_q10              LIKE type_file.num20_6
DEFINE l_q11              LIKE type_file.num20_6
DEFINE l_q12              LIKE type_file.num20_6 
DEFINE l_q15              LIKE type_file.num20_6
DEFINE l_q16              LIKE type_file.num20_6 
DEFINE l_q17              LIKE type_file.num20_6
DEFINE l_q18              LIKE type_file.num20_6 
DEFINE l_q19              LIKE type_file.num20_6 
DEFINE l_str1             LIKE type_file.chr20
DEFINE l_abq13         LIKE abq_file.abq13
DEFINE l_abq15         LIKE abq_file.abq15
DEFINE l_abq16         LIKE abq_file.abq16
DEFINE l_abq17         LIKE abq_file.abq17
DEFINE l_abq18         LIKE abq_file.abq18
DEFINE l_abq19         LIKE abq_file.abq19
 
   CALL drawselect("cv1") 
   CALL drawClear()
   
   IF g_chr1 = 'N' THEN
      RETURN
   END IF
   
   LET l_q1 = g_abq[l_ac].tot01
   LET l_q2 = g_abq[l_ac].tot02
   LET l_q3 = g_abq[l_ac].tot03
   LET l_q4 = g_abq[l_ac].tot04
   LET l_q5 = g_abq[l_ac].tot05
   LET l_q6 = g_abq[l_ac].tot06
   LET l_q7 = g_abq[l_ac].tot07
   LET l_q8 = g_abq[l_ac].tot08
   LET l_q9 = g_abq[l_ac].tot09
   LET l_q10 = g_abq[l_ac].tot10
   LET l_q11 = g_abq[l_ac].tot11
   LET l_q12 = g_abq[l_ac].tot12
   LET l_q15 = g_abq[l_ac].abq15
   LET l_q16 = g_abq[l_ac].abq16
   LET l_q17 = g_abq[l_ac].abq17
   LET l_q18 = g_abq[l_ac].abq18
   LET l_q19 = g_abq[l_ac].abq19
   LET g_max = ''
   LET g_min = ''  
   DELETE FROM x_tmp   
   INSERT INTO x_tmp VALUES (l_q1)
   INSERT INTO x_tmp VALUES (l_q2)
   INSERT INTO x_tmp VALUES (l_q3)
   INSERT INTO x_tmp VALUES (l_q4)
   INSERT INTO x_tmp VALUES (l_q5)
   INSERT INTO x_tmp VALUES (l_q6)
   INSERT INTO x_tmp VALUES (l_q7)
   INSERT INTO x_tmp VALUES (l_q8)
   INSERT INTO x_tmp VALUES (l_q9)
   INSERT INTO x_tmp VALUES (l_q10)
   INSERT INTO x_tmp VALUES (l_q11)
   INSERT INTO x_tmp VALUES (l_q12)
   INSERT INTO x_tmp VALUES (l_q15)
   INSERT INTO x_tmp VALUES (l_q16)
   INSERT INTO x_tmp VALUES (l_q17)
   INSERT INTO x_tmp VALUES (l_q18)
   INSERT INTO x_tmp VALUES (l_q19) 
   SELECT MAX(x_q) INTO g_max FROM x_tmp WHERE x_q is NOT NULL 
   SELECT MIN(x_q) INTO g_min FROM x_tmp WHERE x_q is NOT NULL 
   LET l_length = (g_max - g_min)/10
   LET l_p1 = (l_q1 - g_min)/l_length*70+200
   LET l_p2 = (l_q2 - g_min)/l_length*70+200
   LET l_p3 = (l_q3 - g_min)/l_length*70+200
   LET l_p4 = (l_q4 - g_min)/l_length*70+200
   LET l_p5 = (l_q5 - g_min)/l_length*70+200
   LET l_p6 = (l_q6 - g_min)/l_length*70+200
   LET l_p7 = (l_q7 - g_min)/l_length*70+200
   LET l_p8 = (l_q8 - g_min)/l_length*70+200
   LET l_p9 = (l_q9 - g_min)/l_length*70+200
   LET l_p10= (l_q10 - g_min)/l_length*70+200
   LET l_p11= (l_q11 - g_min)/l_length*70+200
   LET l_p12= (l_q12 - g_min)/l_length*70+200
   LET l_p15= (l_q15 - g_min)/l_length*70+200
   LET l_p16= (l_q16 - g_min)/l_length*70+200
   LET l_p17= (l_q17 - g_min)/l_length*70+200
   LET l_p18= (l_q18 - g_min)/l_length*70+200
   LET l_p19= (l_q19 - g_min)/l_length*70+200 
   
   LET g_draw_x=0   #起始x軸位置
   LET g_draw_y=60  #起始y軸位置
   LET g_draw_dx=0  #起始dx軸位置
   LET g_draw_dy=10 #起始dy軸位置   
   
   LET g_draw_width=10
   LET g_draw_multiple=1 #時間的放大倍數(在長條圖上的刻度比例) 
      
   CALL DrawFillColor("black") 
   IF g_min >= 0 THEN
     #                     y坐标，x坐标，宽度， 长度
      LET id=DrawRectangle(200,100,1,1000)  #(橫軸)
     #                     y坐标，x坐标，长度， 宽度 
      LET id=DrawRectangle(200,100,1000,1)  #(縱軸)
                             #增加的y长度，增加的x长度    
   END IF    
   IF g_min < 0 THEN
     #                     y坐标，x坐标，宽度， 长度
      LET id=DrawRectangle(200+(0-(g_min))/l_length*80,100,1,1000)  #(橫軸)
     #                     y坐标，x坐标，长度， 宽度 
      LET id=DrawRectangle(200,100,1000,1)  #(縱軸)
                             #增加的y长度，增加的x长度 
   END IF     
   CALL drawLineWidth(1)  
   IF NOT cl_null(g_min) THEN     
   	   SELECT abq13 INTO l_abq13
         FROM abq_file
        WHERE abq00 = g_abq00
          AND abq01 = g_abq01
          AND abq04 = g_abq[l_ac].abq04
   	  IF l_abq13 = 'Y' AND NOT cl_null(l_p15) THEN
         LET id = drawline(l_p15,100,0,1000-100)
      END IF 
      LET id = drawText(100,100+50*1,"优秀值")
      LET id = drawText(100,100+50*2,"良好值")
      LET id = drawText(100,100+50*3,"平均值")
      LET id = drawText(100,100+50*4,"较低值")
      LET id = drawText(100,100+50*5,"较差值")
      IF NOT cl_null(l_p1) THEN
         LET id = drawText(100,100+50*6,"第一期")
      END IF
      IF NOT cl_null(l_p2) THEN	   
         LET id = drawText(100,100+50*7,"第二期")
      END IF
      IF NOT cl_null(l_p3) THEN	   
         LET id = drawText(100,100+50*8,"第三期")
      END IF
      IF NOT cl_null(l_p4) THEN	
         LET id = drawText(100,100+50*9,"第四期")
      END IF
      IF NOT cl_null(l_p5) THEN	
         LET id = drawText(100,100+50*10,"第五期")
      END IF
      IF NOT cl_null(l_p6) THEN	
         LET id = drawText(100,100+50*11,"第六期")
      END IF
      IF NOT cl_null(l_p7) THEN	
         LET id = drawText(100,100+50*12,"第七期")
      END IF
      IF NOT cl_null(l_p8) THEN	
         LET id = drawText(100,100+50*13,"第八期")
      END IF
      IF NOT cl_null(l_p9) THEN	
         LET id = drawText(100,100+50*14,"第九期")
      END IF
      IF NOT cl_null(l_p10) THEN	
         LET id = drawText(100,100+50*15,"第十期")
      END IF
      IF NOT cl_null(l_p11) THEN	
         LET id = drawText(100,100+50*16,"第十一期")
      END IF
      IF NOT cl_null(l_p12) THEN	
         LET id = drawText(100,100+50*17,"第十二期")
      END IF 
      CALL q900_drawsety(l_length,0)   
      CALL q900_drawsety(l_length,1) 
      CALL q900_drawsety(l_length,2) 
      CALL q900_drawsety(l_length,3)   
      CALL q900_drawsety(l_length,4) 
      CALL q900_drawsety(l_length,5) 
      CALL q900_drawsety(l_length,6)   
      CALL q900_drawsety(l_length,7) 
      CALL q900_drawsety(l_length,8) 
      CALL q900_drawsety(l_length,9)   
      CALL q900_drawsety(l_length,10) 
    #  CALL q900_drawsety(l_length,11) 
      IF NOT cl_null(l_p15) AND NOT cl_null(l_p16) THEN 
        CALL q900_drawcolor(l_p15,l_p16)    
         LET id = drawLine(l_p15,100+50*1,l_p16-l_p15,50)
      END IF
      IF NOT cl_null(l_p16) AND NOT cl_null(l_p17) THEN    
        CALL q900_drawcolor(l_p16,l_p17)
         LET id = drawLine(l_p16,100+50*2,l_p17-l_p16,50)
      END IF 
      IF NOT cl_null(l_p17) AND NOT cl_null(l_p18) THEN  
         CALL q900_drawcolor(l_p17,l_p18)  
         LET id = drawLine(l_p17,100+50*3,l_p18-l_p17,50)
      END IF 
      IF NOT cl_null(l_p18) AND NOT cl_null(l_p19) THEN    
        CALL q900_drawcolor(l_p18,l_p19)
         LET id = drawLine(l_p18,100+50*4,l_p19-l_p18,50)
      END IF 
      IF NOT cl_null(l_p19) AND NOT cl_null(l_p1) THEN   
        CALL q900_drawcolor(l_p19,l_p1) 
         LET id = drawLine(l_p19,100+50*5,l_p1-l_p19,50)
      END IF  
      IF NOT cl_null(l_p1) AND NOT cl_null(l_p2) THEN 
         CALL q900_drawcolor(l_p1,l_p2)  
         LET id = drawLine(l_p1,100+50*6,l_p2-l_p1,50)
      END IF
      IF NOT cl_null(l_p2) AND NOT cl_null(l_p3) THEN     
         CALL q900_drawcolor(l_p2,l_p3)
         LET id = drawLine(l_p2,100+50*7,l_p3-l_p2,50)
      END IF 
      IF NOT cl_null(l_p3) AND NOT cl_null(l_p4) THEN     
         CALL q900_drawcolor(l_p3,l_p4)
         LET id = drawLine(l_p3,100+50*8,l_p4-l_p3,50)
      END IF 
      IF NOT cl_null(l_p4) AND NOT cl_null(l_p5) THEN    
         CALL q900_drawcolor(l_p4,l_p5)
         LET id = drawLine(l_p4,100+50*9,l_p5-l_p4,50)
      END IF    
      IF NOT cl_null(l_p5) AND NOT cl_null(l_p6) THEN  
         CALL q900_drawcolor(l_p5,l_p6)
         LET id = drawLine(l_p5,100+50*10,l_p6-l_p5,50)
      END IF 
      IF NOT cl_null(l_p6) AND NOT cl_null(l_p7) THEN     
         CALL q900_drawcolor(l_p6,l_p7)
         LET id = drawLine(l_p6,100+50*11,l_p7-l_p6,50)
      END IF 
      IF NOT cl_null(l_p7) AND NOT cl_null(l_p8) THEN     
         CALL q900_drawcolor(l_p7,l_p8)
         LET id = drawLine(l_p7,100+50*12,l_p8-l_p7,50)
      END IF 
      IF NOT cl_null(l_p8) AND NOT cl_null(l_p9) THEN      
         CALL q900_drawcolor(l_p8,l_p9)
         LET id = drawLine(l_p8,100+50*13,l_p9-l_p8,50)
      END IF 
      IF NOT cl_null(l_p9) AND NOT cl_null(l_p10) THEN     
         CALL q900_drawcolor(l_p9,l_p10)
         LET id = drawLine(l_p9,100+50*14,l_p10-l_p9,50)
      END IF    
      IF NOT cl_null(l_p10) AND NOT cl_null(l_p11) THEN  
         CALL q900_drawcolor(l_p10,l_p11)
         LET id = drawLine(l_p10,100+50*15,l_p11-l_p10,50)
      END IF 
      IF NOT cl_null(l_p11) AND NOT cl_null(l_p12) THEN     
         CALL q900_drawcolor(l_p11,l_p12)
         LET id = drawLine(l_p11,100+50*16,l_p12-l_p11,50)
      END IF    
       
      #标明那个点     
      CALL q900_p(l_p15,1)
      CALL q900_p(l_p16,2)
      CALL q900_p(l_p17,3) 
      CALL q900_p(l_p18,4)
      CALL q900_p(l_p19,5)
      CALL q900_p(l_p1,6)
      CALL q900_p(l_p2,7)
      CALL q900_p(l_p3,8) 
      CALL q900_p(l_p4,9) 
      CALL q900_p(l_p5,10)
      CALL q900_p(l_p6,11)
      CALL q900_p(l_p7,12) 
      CALL q900_p(l_p8,13)
      CALL q900_p(l_p9,14)  
      CALL q900_p(l_p10,15)   
      CALL q900_p(l_p11,16)
      CALL q900_p(l_p12,17) 
   END IF                           
   CALL drawInit()
                                                             
END FUNCTION   
 
FUNCTION q900_b_fill3(p_chr)
DEFINE id,l_h          LIKE type_file.num10  
DEFINE l_str           STRING 
DEFINE l_length        LIKE type_file.num20_6
DEFINE l_p1            LIKE type_file.num10
DEFINE l_p2               LIKE type_file.num20_6
DEFINE l_p3               LIKE type_file.num20_6
DEFINE l_p4               LIKE type_file.num20_6
DEFINE l_p5               LIKE type_file.num20_6
DEFINE l_p6               LIKE type_file.num20_6
DEFINE l_p7               LIKE type_file.num20_6
DEFINE l_p8               LIKE type_file.num20_6
DEFINE l_p9               LIKE type_file.num20_6
DEFINE l_p10              LIKE type_file.num20_6
DEFINE l_p11              LIKE type_file.num20_6
DEFINE l_p12              LIKE type_file.num20_6
DEFINE l_p15              LIKE type_file.num20_6
DEFINE l_p16              LIKE type_file.num20_6
DEFINE l_p17              LIKE type_file.num20_6
DEFINE l_p18              LIKE type_file.num20_6
DEFINE l_p19              LIKE type_file.num20_6 
DEFINE l_q1               LIKE type_file.num20_6
DEFINE l_q2               LIKE type_file.num20_6
DEFINE l_q3               LIKE type_file.num20_6
DEFINE l_q4               LIKE type_file.num20_6
DEFINE l_q5               LIKE type_file.num20_6
DEFINE l_q6               LIKE type_file.num20_6
DEFINE l_q7               LIKE type_file.num20_6
DEFINE l_q8               LIKE type_file.num20_6
DEFINE l_q9               LIKE type_file.num20_6
DEFINE l_q10              LIKE type_file.num20_6
DEFINE l_q11              LIKE type_file.num20_6
DEFINE l_q12              LIKE type_file.num20_6      
DEFINE l_q15              LIKE type_file.num20_6 
DEFINE l_q16              LIKE type_file.num20_6 
DEFINE l_q17              LIKE type_file.num20_6 
DEFINE l_q18              LIKE type_file.num20_6 
DEFINE l_q19              LIKE type_file.num20_6  
DEFINE l_str1             LIKE type_file.chr20
DEFINE l_i                LIKE type_file.num10
DEFINE l_count            LIKE type_file.num10
DEFINE l_n                LIKE type_file.num10         
DEFINE l_cnt              LIKE type_file.num10
DEFINE l_abq12         LIKE abq_file.abq12
DEFINE l_abq13         LIKE abq_file.abq13
DEFINE p_chr              LIKE type_file.chr1
DEFINE c,s     om.DomNode
DEFINE w ui.Window 
  
   IF p_chr = '1' THEN
   	  CALL drawselect("cv2")
   END IF 	
   IF p_chr = '2' THEN
   	  CALL drawselect("cv3")
   END IF
   IF p_chr = '3' THEN
   	  CALL drawselect("cv4")
   END IF
   IF p_chr = '4' THEN
   	  CALL drawselect("cv5")
   END IF    
   CALL drawClear() 
      IF g_chr1 = 'N' THEN
      RETURN
   END IF 
   
   #abq12 = '1'  
   DELETE FROM x_tmp     
   LET g_n = 0
   CALL g_hx.clear()
   FOR l_i = 1 TO g_rec_b
       LET l_abq12 = ''
       SELECT abq12 INTO l_abq12
         FROM abq_file
        WHERE abq00 = g_abq00
          AND abq01 = g_abq01
          AND abq04 = g_abq[l_i].abq04
       IF l_abq12 <> p_chr THEN
          CONTINUE FOR
       END IF   
       LET g_n = g_n + 1 
       LET g_hx[g_n].* = g_abq[l_i].*  
       LET l_q1  = NULL
       LET l_q2  = NULL
       LET l_q3  = NULL                   
       LET l_q4  = NULL
       LET l_q5  = NULL
       LET l_q6  = NULL
       LET l_q7  = NULL                   
       LET l_q8  = NULL
       LET l_q9  = NULL
       LET l_q10 = NULL
       LET l_q11 = NULL                   
       LET l_q12 = NULL
       LET l_q15 = NULL
       LET l_q16 = NULL                   
       LET l_q17 = NULL
       LET l_q18 = NULL
       LET l_q19 = NULL   
       SELECT to_number(g_abq[l_i].tot01) INTO l_q1  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot02) INTO l_q2  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot03) INTO l_q3  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot04) INTO l_q4  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot05) INTO l_q5  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot06) INTO l_q6  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot07) INTO l_q7  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot08) INTO l_q8  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot09) INTO l_q9  FROM DUAL 
       SELECT to_number(g_abq[l_i].tot10) INTO l_q10 FROM DUAL 
       SELECT to_number(g_abq[l_i].tot11) INTO l_q11 FROM DUAL 
       SELECT to_number(g_abq[l_i].tot12) INTO l_q12 FROM DUAL 
       SELECT to_number(g_abq[l_i].abq15) INTO l_q15 FROM DUAL 
       SELECT to_number(g_abq[l_i].abq16) INTO l_q16 FROM DUAL 
       SELECT to_number(g_abq[l_i].abq17) INTO l_q17 FROM DUAL 
       SELECT to_number(g_abq[l_i].abq18) INTO l_q18 FROM DUAL 
       SELECT to_number(g_abq[l_i].abq19) INTO l_q19 FROM DUAL  

       INSERT INTO x_tmp VALUES (l_q1)
       INSERT INTO x_tmp VALUES (l_q2)
       INSERT INTO x_tmp VALUES (l_q3)
       INSERT INTO x_tmp VALUES (l_q4)
       INSERT INTO x_tmp VALUES (l_q5)
       INSERT INTO x_tmp VALUES (l_q6)
       INSERT INTO x_tmp VALUES (l_q7)
       INSERT INTO x_tmp VALUES (l_q8)
       INSERT INTO x_tmp VALUES (l_q9)
       INSERT INTO x_tmp VALUES (l_q10)
       INSERT INTO x_tmp VALUES (l_q11)
       INSERT INTO x_tmp VALUES (l_q12) 
       INSERT INTO x_tmp VALUES (l_q15)
       INSERT INTO x_tmp VALUES (l_q16)
       INSERT INTO x_tmp VALUES (l_q17)
       INSERT INTO x_tmp VALUES (l_q18)
       INSERT INTO x_tmp VALUES (l_q19)    
       
   END FOR 
   LET l_count = 0
   
   SELECT COUNT(*) INTO l_count
     FROM abq_file
    WHERE abq00 = g_abq00
      AND abq01 = g_abq01
      AND abq12 = p_chr
   IF l_count = 0 OR cl_null(l_count) THEN
      RETURN
   END IF       
    
   LET g_max = ''
   LET g_min = ''  
   SELECT MAX(x_q) INTO g_max FROM x_tmp WHERE x_q is NOT NULL 
   SELECT MIN(x_q) INTO g_min FROM x_tmp WHERE x_q is NOT NULL 
   LET l_length = (g_max - g_min)/10

   LET l_cnt = 1
   FOR l_i = 1 TO g_hx.getLength() 
      LET l_abq13 = 'N' 
      SELECT abq13 INTO l_abq13
         FROM abq_file
        WHERE abq00 = g_abq00
          AND abq01 = g_abq01
          AND abq04 = g_hx[l_i].abq04
      LET l_p1 = (g_hx[l_i].tot01 - g_min)/l_length*80+150
      LET l_p2 = (g_hx[l_i].tot02 - g_min)/l_length*80+150
      LET l_p3 = (g_hx[l_i].tot03 - g_min)/l_length*80+150
      LET l_p4 = (g_hx[l_i].tot04 - g_min)/l_length*80+150
      LET l_p5 = (g_hx[l_i].tot05 - g_min)/l_length*80+150
      LET l_p6 = (g_hx[l_i].tot06 - g_min)/l_length*80+150
      LET l_p7 = (g_hx[l_i].tot07 - g_min)/l_length*80+150
      LET l_p8 = (g_hx[l_i].tot08 - g_min)/l_length*80+150
      LET l_p9 = (g_hx[l_i].tot09 - g_min)/l_length*80+150
      LET l_p10= (g_hx[l_i].tot10 - g_min)/l_length*80+150
      LET l_p11= (g_hx[l_i].tot11 - g_min)/l_length*80+150
      LET l_p12= (g_hx[l_i].tot12 - g_min)/l_length*80+150  
      LET l_p15 = (g_hx[l_i].abq15 - g_min)/l_length*80+150
      LET l_p16 = (g_hx[l_i].abq16 - g_min)/l_length*80+150
      LET l_p17= (g_hx[l_i].abq17 - g_min)/l_length*80+150
      LET l_p18= (g_hx[l_i].abq18 - g_min)/l_length*80+150
      LET l_p19= (g_hx[l_i].abq19 - g_min)/l_length*80+150  
       
      IF g_min >= 0 THEN
        #                     y坐标，x坐标，宽度， 长度
         LET id=DrawRectangle(150,80,1,1000)  #(橫軸)
        #                     y坐标，x坐标，长度， 宽度 
         LET id=DrawRectangle(150,80,1000,1)  #(縱軸)
                                #增加的y长度，增加的x长度    
      END IF    
      IF g_min < 0 THEN
        #                     y坐标，x坐标，宽度， 长度
         LET id=DrawRectangle(150+(0-(g_min))/l_length*80,80,1,1000)  #(橫軸)
        #                     y坐标，x坐标，长度， 宽度 
         LET id=DrawRectangle(150,80,1000,1)  #(縱軸)
                                #增加的y长度，增加的x长度 
      END IF     
      CALL drawLineWidth(1)        
      IF NOT cl_null(g_min) THEN
        IF l_cnt = 1 THEN
           #设置x，y轴的刻度
           CALL DrawFillColor("black")     
            LET id = drawText(100,100+50*1,"优秀值")
            LET id = drawText(100,100+50*2,"良好值")
            LET id = drawText(100,100+50*3,"平均值")
            LET id = drawText(100,100+50*4,"较低值")
            LET id = drawText(100,100+50*5,"较差值")
            LET id = drawText(100,100+50*6,"第一期")
            LET id = drawText(100,100+50*7,"第二期")
            LET id = drawText(100,100+50*8,"第三期")
            LET id = drawText(100,100+50*9,"第四期")
            LET id = drawText(100,100+50*10,"第五期")
            LET id = drawText(100,100+50*11,"第六期")
            LET id = drawText(100,100+50*12,"第七期")
            LET id = drawText(100,100+50*13,"第八期")
            LET id = drawText(100,100+50*14,"第九期")
            LET id = drawText(100,100+50*15,"第十期")
            LET id = drawText(100,100+50*16,"第十一期")
            LET id = drawText(100,100+50*17,"第十二期")
            CALL q900_drawsety1(l_length,0)   
            CALL q900_drawsety1(l_length,1) 
            CALL q900_drawsety1(l_length,2) 
            CALL q900_drawsety1(l_length,3)   
            CALL q900_drawsety1(l_length,4) 
            CALL q900_drawsety1(l_length,5) 
            CALL q900_drawsety1(l_length,6)   
            CALL q900_drawsety1(l_length,7) 
            CALL q900_drawsety1(l_length,8) 
            CALL q900_drawsety1(l_length,9)
            CALL q900_drawsety1(l_length,10)    
         END IF    
         LET l_cnt = l_cnt + 1        
          
         #设置颜色
         IF l_i = 1 THEN
            CALL DrawFillColor("#003366")  
         END IF  
         IF l_i = 2 THEN
            CALL DrawFillColor("red")  
         END IF 
         IF l_i = 3 THEN
            CALL DrawFillColor("blue")  
         END IF 
         IF l_i = 4 THEN
            CALL DrawFillColor("green")  
         END IF 
         IF l_i = 5 THEN
            CALL DrawFillColor("#FF1493")  
         END IF  
         IF l_i = 6 THEN
            CALL DrawFillColor("#ADD8E6")  
         END IF 
         IF l_i = 7 THEN
            CALL DrawFillColor("#F0E68C")  
         END IF 
         IF l_i = 8 THEN
            CALL DrawFillColor("#00008B")  
         END IF
         IF l_i = 9 THEN
            CALL DrawFillColor("#9ACD32")  
         END IF  
         IF l_i = 10 THEN
            CALL DrawFillColor("#black")  
         END IF 
         IF l_i > 10 THEN
            CALL DrawFillColor("black")  
         END IF  
         IF l_i >=1 THEN
            IF NOT cl_null(l_p19) THEN
               LET id = drawText(l_p15,120,g_hx[l_i].abq06)          
            ELSE
               LET id = drawText(l_p1,120+50*5,g_hx[l_i].abq06)
            END IF
         END IF

         IF l_abq13 = 'Y' AND NOT cl_null(l_p15) THEN
            LET id = drawline(l_p15,80,0,1000-80)
         END IF 	 
         #设置颜色的标识 
         IF NOT cl_null(g_hx[l_i].abq06) THEN 
            IF l_i = 1 THEN
               LET g_l_i = 0 
            END IF
            LET id = DrawRectangle(30,140*(l_i-1)+30+g_l_i,30,30)
            LET g_l_i = g_l_i+length(g_hx[l_i].abq06)
            LET id = drawText(30,140*(l_i-1)+90+g_l_i,g_hx[l_i].abq06) 
         END IF 
         
         #画线       
         IF NOT cl_null(l_p15) AND NOT cl_null(l_p16) THEN    
           LET id = drawLine(l_p15,100+50*1,l_p16-l_p15,50)
        END IF
        IF NOT cl_null(l_p16) AND NOT cl_null(l_p17) THEN    
           LET id = drawLine(l_p16,100+50*2,l_p17-l_p16,50) 
        END IF 
        IF NOT cl_null(l_p17) AND NOT cl_null(l_p18) THEN    
           LET id = drawLine(l_p17,100+50*3,l_p18-l_p17,50) 
        END IF 
        IF NOT cl_null(l_p18) AND NOT cl_null(l_p19) THEN    
           LET id = drawLine(l_p18,100+50*4,l_p19-l_p18,50) 
        END IF 
        IF NOT cl_null(l_p19) AND NOT cl_null(l_p1) THEN    
           LET id = drawLine(l_p19,100+50*5,l_p1-l_p19,50) 
        END IF     
         IF NOT cl_null(l_p1) AND NOT cl_null(l_p2) THEN    
           LET id = drawLine(l_p1,100+50*6,l_p2-l_p1,50) 
        END IF
        IF NOT cl_null(l_p2) AND NOT cl_null(l_p3) THEN    
            LET id = drawLine(l_p2,100+50*7,l_p3-l_p2,50) 
         END IF 
         IF NOT cl_null(l_p3) AND NOT cl_null(l_p4) THEN   
            LET id = drawLine(l_p3,100+50*8,l_p4-l_p3,50) 
         END IF 
         IF NOT cl_null(l_p4) AND NOT cl_null(l_p5) THEN   
            LET id = drawLine(l_p4,100+50*9,l_p5-l_p4,50) 
         END IF    
         IF NOT cl_null(l_p5) AND NOT cl_null(l_p6) THEN  
            LET id = drawLine(l_p5,100+50*10,l_p6-l_p5,50)
         END IF 
         IF NOT cl_null(l_p6) AND NOT cl_null(l_p7) THEN  
            LET id = drawLine(l_p6,100+50*11,l_p7-l_p6,50)
         END IF 
         IF NOT cl_null(l_p7) AND NOT cl_null(l_p8) THEN  
            LET id = drawLine(l_p7,100+50*12,l_p8-l_p7,50)
         END IF 
         IF NOT cl_null(l_p8) AND NOT cl_null(l_p9) THEN   
            LET id = drawLine(l_p8,100+50*13,l_p9-l_p8,50)
         END IF 
         IF NOT cl_null(l_p9) AND NOT cl_null(l_p10) THEN   
            LET id = drawLine(l_p9,100+50*14,l_p10-l_p9,50)
         END IF    
         IF NOT cl_null(l_p10) AND NOT cl_null(l_p11) THEN   
            LET id = drawLine(l_p10,100+50*15,l_p11-l_p10,50)
         END IF 
         IF NOT cl_null(l_p11) AND NOT cl_null(l_p12) THEN    
            LET id = drawLine(l_p11,100+50*16,l_p12-l_p11,50)
         END IF 
         
         #标明那个点     
         CALL q900_p(l_p15,1)
         CALL q900_p(l_p16,2)
         CALL q900_p(l_p17,3) 
         CALL q900_p(l_p18,4)
         CALL q900_p(l_p19,5)
         CALL q900_p(l_p1,6)
         CALL q900_p(l_p2,7)
         CALL q900_p(l_p3,8) 
         CALL q900_p(l_p4,9) 
         CALL q900_p(l_p5,10)
         CALL q900_p(l_p6,11)
         CALL q900_p(l_p7,12) 
         CALL q900_p(l_p8,13)
         CALL q900_p(l_p9,14)  
         CALL q900_p(l_p10,15)   
         CALL q900_p(l_p11,16)
         CALL q900_p(l_p12,17)
      END IF  
   END FOR                              
   CALL drawInit()                                                          
END FUNCTION  

FUNCTION q900_p(p1,p2)
DEFINE p1 LIKE type_file.num20_6
DEFINE p2 LIKE type_file.num10
DEFINE id LIKE type_file.num10
  IF NOT cl_null(p1) THEN 
     LET id=DrawRectangle(p1-7,100+50*p2-2,14,4) 
  END IF     
END FUNCTION   
FUNCTION q900_drawcolor(l_p1,l_p2)
DEFINE l_p1  LIKE type_file.num20_6
DEFINE l_p2  LIKE type_file.num20_6
  {IF l_p2 > l_p1 THEN
    CALL DrawFillColor("red")
  ELSE
    CALL DrawFillColor("green")   
  END IF  }
  CALL DrawFillColor("red")  
END FUNCTION   

FUNCTION q900_drawsety(l_length,l_p)
DEFINE l_length   LIKE type_file.num20_6
DEFINE l_p        LIKE type_file.num20_6 
DEFINE l_str1     LIKE type_file.chr20
DEFINE l_str      STRING
DEFINE id         LIKE type_file.num10
DEFINE l_sql      STRING

   LET l_str = "round('",g_min,"+",l_length*l_p,",4)"
   LET l_sql = "SELECT ",cl_tp_tochar(l_str,'fm9999999990.00')," FROM DUAL"
   PREPARE q900_sel_prep FROM l_sql
   EXECUTE q900_sel_prep INTO l_str1
   LET l_str = l_str1
   LET id=drawText(200+70*l_p,70,l_str) 
END FUNCTION   
 
FUNCTION q900_drawsety1(l_length,l_p)
DEFINE l_length   LIKE type_file.num20_6
DEFINE l_p        LIKE type_file.num20_6 
DEFINE l_str1     LIKE type_file.chr20
DEFINE l_str      STRING
DEFINE id         LIKE type_file.num10
DEFINE l_sql      STRING

   LET l_str = "round(",g_min,"+",l_length*l_p,",4)"
   LET l_sql = "SELECT ",cl_tp_tochar(l_str,'fm9999999990.00')," FROM DUAL"
   PREPARE q900_sel_prep1 FROM l_sql
   EXECUTE q900_sel_prep1 INTO l_str1
   LET l_str = l_str1
   LET id=drawText(150+80*l_p,50,l_str) 
END FUNCTION    

FUNCTION q900_b_pic()
DEFINE id          LIKE type_file.num10
DEFINE l_abq14  LIKE abq_file.abq14
DEFINE l_count     LIKE type_file.num10
DEFINE l_t         LIKE type_file.num5
DEFINE l_i         LIKE type_file.num5
DEFINE l_while     LIKE type_file.chr1
    SELECT COUNT(*) INTO l_count FROM abq_file
     WHERE abq00 = g_abq00
       AND abq01 = g_abq01
       AND abq14 = 'Y'
    IF cl_null(l_count) OR l_count = 0 THEN
    	 CALL cl_err('无需要显示的圆盘','!',0)
    	 RETURN
    END IF 	     
    	  
    LET g_action_choice = " " 	 
    INPUT g_yb_m1 WITHOUT DEFAULTS FROM yb_m1
    BEFORE INPUT  
       IF cl_null(g_yb_m1) THEN
       	  LET g_yb_m1 = 1
       	  LET g_pi = 0
          CALL q900_drawclear()
	        FOR l_i = 1 TO g_rec_b 
	            SELECT abq14 INTO l_abq14 FROM abq_file
	             WHERE abq00 = g_abq00
	               AND abq01 = g_abq01
	               AND abq04 = g_abq[l_i].abq04
	            IF l_abq14 = 'Y' AND l_count > 1 AND NOT cl_null(g_abq[l_i].abq15) THEN
	            	 LET g_pi = g_pi + 1
	            	 CALL q900_drawcir(l_i,g_yb_m1) 
	            END IF 	
	        END FOR     
       END IF 	  
       DISPLAY g_yb_m1 TO yb_m1 
          
      ON CHANGE yb_m1
         LET g_pi = 0
         CALL q900_drawclear()
	       FOR l_i = 1 TO g_rec_b 
	           SELECT abq14 INTO l_abq14 FROM abq_file
	            WHERE abq00 = g_abq00
	              AND abq01 = g_abq01
	              AND abq04 = g_abq[l_i].abq04
	           IF l_abq14 = 'Y' AND l_count > 1 AND NOT cl_null(g_abq[l_i].abq15) THEN
	           	 LET g_pi = g_pi + 1
	           	 CALL q900_drawcir(l_i,g_yb_m1) 
	           END IF 	
	       END FOR       
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
        
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
      
      ON ACTION CONTROLG 
         CALL cl_cmdask()     
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about
         CALL cl_about()
      
      ON ACTION help
         CALL cl_show_help()
      
      ON ACTION accept 
         EXIT INPUT 
         
      ON ACTION cancel
         LET g_action_choice="exit"
         LET INT_FLAG = 1
         EXIT INPUT 
     #No.TQC-D80014 ---Mark--- Start
     #ON ACTION queding
     #   LET g_action_choice = "queding"
     #   EXIT INPUT        
     #No.TQC-D80014 ---Mark--- End
      ON ACTION exit
         LET INT_FLAG = 1 
         EXIT INPUT  
         
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END INPUT
   #No.TQC-D80014 ---Add--- Start
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
   #No.TQC-D80014 ---Add--- End
      		  
END FUNCTION 
	
FUNCTION q900_drawcir(p_i,p_mm)
DEFINE id          LIKE type_file.num10
DEFINE l_x         float
DEFINE l_y         float
DEFINE p_i         LIKE type_file.num10
DEFINE p_mm        LIKE type_file.chr10
DEFINE l_mm        LIKE type_file.chr30 
DEFINE l_len       LIKE type_file.num20_6 
DEFINE l_str       LIKE type_file.chr30
DEFINE l_b_mm      LIKE type_file.num10
DEFINE l_num       LIKE type_file.chr30
DEFINE l_t15       LIKE abq_file.abq15
DEFINE l_t16       LIKE abq_file.abq16
DEFINE l_t17       LIKE abq_file.abq17
DEFINE l_t18       LIKE abq_file.abq18
DEFINE l_t19       LIKE abq_file.abq19
DEFINE l_sql       STRING
DEFINE l_str1      STRING
   CASE p_mm 
   	WHEN '1'   LET l_mm = g_abq[p_i].tot01 LET l_b_mm = tm.b_mm01
   	WHEN '2'   LET l_mm = g_abq[p_i].tot02 LET l_b_mm = tm.b_mm02
   	WHEN '3'   LET l_mm = g_abq[p_i].tot03 LET l_b_mm = tm.b_mm03
   	WHEN '4'   LET l_mm = g_abq[p_i].tot04 LET l_b_mm = tm.b_mm04
   	WHEN '5'   LET l_mm = g_abq[p_i].tot05 LET l_b_mm = tm.b_mm05
   	WHEN '6'   LET l_mm = g_abq[p_i].tot06 LET l_b_mm = tm.b_mm06
   	WHEN '7'   LET l_mm = g_abq[p_i].tot07 LET l_b_mm = tm.b_mm07
   	WHEN '8'   LET l_mm = g_abq[p_i].tot08 LET l_b_mm = tm.b_mm08
   	WHEN '9'   LET l_mm = g_abq[p_i].tot09 LET l_b_mm = tm.b_mm09
   	WHEN '10'  LET l_mm = g_abq[p_i].tot10 LET l_b_mm = tm.b_mm10
   	WHEN '11'  LET l_mm = g_abq[p_i].tot11 LET l_b_mm = tm.b_mm11
   	WHEN '12'  LET l_mm = g_abq[p_i].tot12 LET l_b_mm = tm.b_mm12
   END CASE 
   IF cl_null(l_mm) OR cl_null(l_b_mm) THEN
   	  LET g_pi = g_pi -1 
   	  RETURN
   END IF	  
 
   SELECT replace(l_mm,' ','') INTO l_mm FROM DUAL  
   IF g_pi <10 THEN
      LET l_sql = "SELECT 'cv1'||replace(",cl_tp_tochar(g_pi,'999'),",' ','') FROM DUAL"
   ELSE 
      LET l_sql = "SELECT 'cv'||replace(",cl_tp_tochar(g_pi+10,'999'),",' ','') FROM DUAL" 
   END IF	 
   PREPARE q900_sel_prep2 FROM l_sql
   EXECUTE  q900_sel_prep2 INTO l_str 
   CALL drawselect(l_str)
   CALL drawclear()
   CALL drawLineWidth(1) 
   CALL DrawFillColor("white")
   LET id=drawArc(900,50,900,0,180)
   CALL DrawFillColor("red")
   LET id=drawArc(900,50,900,150,30)
   CALL DrawFillColor("yellow")
   LET id=drawArc(900,50,900,120,30)
   CALL DrawFillColor("green")
   LET id=drawArc(900,50,900,90,30)
   CALL DrawFillColor("blue")
   LET id=drawArc(900,50,900,60,30)
   CALL DrawFillColor("purple")
   LET id=drawArc(900,50,900,30,30) 
   CALL DrawFillColor("gray")
   LET id=drawArc(900,50,900,0,30) 
   CALL DrawFillColor("white")
   LET id=drawArc(700,250,500,0,180)
   CALL DrawFillColor("blue")
   CALL drawLineWidth(20)
   IF g_abq[p_i].abq15 > g_abq[p_i].abq16 THEN
   	  LET l_t15 = g_abq[p_i].abq15 
   	  LET l_t16 = g_abq[p_i].abq16 
   	  LET l_t17 = g_abq[p_i].abq17 
   	  LET l_t18 = g_abq[p_i].abq18 
   	  LET l_t19 = g_abq[p_i].abq19
   ELSE            
   	  LET l_t15 = g_abq[p_i].abq19 
   	  LET l_t16 = g_abq[p_i].abq18 
   	  LET l_t17 = g_abq[p_i].abq17 
   	  LET l_t18 = g_abq[p_i].abq16 
   	  LET l_t19 = g_abq[p_i].abq15
   END IF 	  	   
   IF l_mm <= l_t19 THEN  
   	  IF l_mm >= 0 THEN 
   	  	 LET l_len = l_t19
   	  	 SELECT 350*cos(5/6*PI+1/6*PI*(l_t19 - l_mm)/l_len) INTO l_x FROM dual
         SELECT 350*sin(5/6*PI+1/6*PI*(l_t19 - l_mm)/l_len) INTO l_y FROM dual
      END IF 
      IF l_mm < 0 AND l_t19 >= 0 THEN 
      	 SELECT 350*cos(5/6*PI+1/6*PI*1/2) INTO l_x FROM dual
         SELECT 350*sin(5/6*PI+1/6*PI*1/2) INTO l_y FROM dual   
      END IF   
      IF l_mm < 0 AND l_t19 < 0 THEN 
      	 LET l_len = (0-l_t19)*10
      	 IF l_mm < 0 -l_len THEN
      	 	  SELECT 350*cos(0.00001-PI) INTO l_x FROM dual
            SELECT 350*sin(0.00001-PI) INTO l_y FROM dual
         ELSE     
   	  	    SELECT 350*cos(5/6*PI+1/6*PI*(l_t19 - l_mm)/l_len) INTO l_x FROM dual
            SELECT 350*sin(5/6*PI+1/6*PI*(l_t19 - l_mm)/l_len) INTO l_y FROM dual 
         END IF   
      END IF  	 
   END IF	
   IF l_mm > l_t19 AND l_mm <= l_t18 THEN 
   	  LET l_len = l_t18 - l_t19 
      SELECT 350*cos(4/6*PI+1/6*PI*(l_t18-l_mm)/l_len) INTO l_x FROM dual
      SELECT 350*sin(4/6*PI+1/6*PI*(l_t18-l_mm)/l_len) INTO l_y FROM dual   
   END IF 		 
   IF l_mm > l_t18 AND l_mm <= l_t17 THEN 
   	  LET l_len = l_t17 - l_t18 
      SELECT 350*cos(3/6*PI+1/6*PI*(l_t17-l_mm)/l_len) INTO l_x FROM dual
      SELECT 350*sin(3/6*PI+1/6*PI*(l_t17-l_mm)/l_len) INTO l_y FROM dual   
   END IF 		
   IF l_mm > l_t17 AND l_mm <= l_t16 THEN 
   	  LET l_len = l_t16 - l_t17 
      SELECT 350*cos(2/6*PI+1/6*PI*(l_t16-l_mm)/l_len) INTO l_x FROM dual
      SELECT 350*sin(2/6*PI+1/6*PI*(l_t16-l_mm)/l_len) INTO l_y FROM dual   
   END IF 				
   IF l_mm > l_t16 AND l_mm <= l_t15 THEN 
   	  LET l_len = l_t15 - l_t16 
      SELECT 350*cos(1/6*PI+1/6*PI*(l_t15-l_mm)/l_len) INTO l_x FROM dual
      SELECT 350*sin(1/6*PI+1/6*PI*(l_t15-l_mm)/l_len) INTO l_y FROM dual   
   END IF 		
   IF l_mm >= l_t15 THEN   
      IF l_mm < 0  THEN 
      	 LET l_len = (0-l_t15) 
   	  	 SELECT 350*cos(1/6*PI-1/6*PI*(l_mm-l_t15)/l_len) INTO l_x FROM dual
         SELECT 350*sin(1/6*PI-1/6*PI*(l_mm-l_t15)/l_len) INTO l_y FROM dual    
      END IF   
      IF l_mm >= 0 AND l_t15 < 0 THEN 
      	 SELECT 350*cos(1/6*PI-1/6*PI*1/2) INTO l_x FROM dual
         SELECT 350*sin(1/6*PI-1/6*PI*1/2) INTO l_y FROM dual 
      END IF     
      IF l_t15 > 0 THEN 
      	 LET l_len = l_t15*10
      	 IF l_mm > l_len THEN
      	    SELECT 350*cos(0.00001) INTO l_x FROM dual
            SELECT 350*sin(0.00001-PI) INTO l_y FROM dual
         ELSE     
   	  	    SELECT 350*cos(1/6*PI-1/6*PI*(l_mm-l_t15)/l_len) INTO l_x FROM dual
            SELECT 350*sin(1/6*PI-1/6*PI*(l_mm-l_t15)/l_len) INTO l_y FROM dual 
         END IF   
      END IF  	 
   END IF			 
   	
   LET id = drawline(450,500,l_y,l_x) 
   CALL DrawFillColor("black")
   LET id = drawText(100,500,g_abq[p_i].abq06)   
   IF NOT cl_null(l_t19) THEN
   	  SELECT 470*cos(5/6*PI) INTO l_x FROM dual
      SELECT 470*sin(5/6*PI) INTO l_y FROM dual 
      LET l_str1 = "round(",l_t19,",4)"
     #LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),"),' ','') FROM DUAL" #FUN-D60097 mark
      LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),",' ','') FROM DUAL"  #FUN-D60097
      PREPARE q900_sel_prep3 FROM l_sql
      EXECUTE q900_sel_prep3 INTO l_num
      LET id = drawText(450+l_y+10,450+l_x+10,l_num)
   END IF   
   IF NOT cl_null(l_t18) THEN
   	  SELECT 470*cos(4/6*PI) INTO l_x FROM dual
      SELECT 470*sin(4/6*PI) INTO l_y FROM dual 
      LET l_str1 = "round(",l_t18,",4)"
     #LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),"),' ','') FROM DUAL" #FUN-D60097 mark
      LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),",' ','') FROM DUAL"  #FUN-D60097
      PREPARE q900_sel_prep4 FROM l_sql
      EXECUTE q900_sel_prep4 INTO l_num
      LET id = drawText(450+l_y,450+l_x,l_num)
   END IF 
   IF NOT cl_null(l_t17) THEN
   	  SELECT 470*cos(3/6*PI) INTO l_x FROM dual
      SELECT 470*sin(3/6*PI) INTO l_y FROM dual 
      LET l_str1 = "round(",l_t17,",4)"
     #LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),"),' ','') FROM DUAL" #FUN-D60097 mark
      LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),",' ','') FROM DUAL"  #FUN-D60097
      PREPARE q900_sel_prep5 FROM l_sql
      EXECUTE q900_sel_prep5 INTO l_num
      LET id = drawText(450+l_y,450+l_x+40,l_num)
   END IF
   IF NOT cl_null(l_t16) THEN
   	  SELECT 470*cos(2/6*PI) INTO l_x FROM dual
      SELECT 470*sin(2/6*PI) INTO l_y FROM dual 
      LET l_str1 = "round(",l_t16,",4)"
     #LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),"),' ','') FROM DUAL" #FUN-D60097 mark
      LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),",' ','') FROM DUAL"  #FUN-D60097
      PREPARE q900_sel_prep6 FROM l_sql
      EXECUTE q900_sel_prep6 INTO l_num
      LET id = drawText(450+l_y,450+l_x+50,l_num)
   END IF 
   IF NOT cl_null(l_t15) THEN
   	  SELECT 470*cos(1/6*PI) INTO l_x FROM dual
      SELECT 470*sin(1/6*PI) INTO l_y FROM dual 
      LET l_str1 = "round(",l_t15,",4)"
     #LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),"),' ','') FROM DUAL" #FUN-D60097 mark
      LET l_sql = "SELECT replace(",cl_tp_tochar(l_str1,'fm990.0'),",' ','') FROM DUAL"  #FUN-D60097
      PREPARE q900_sel_prep7 FROM l_sql
      EXECUTE q900_sel_prep7 INTO l_num
      LET id = drawText(450+l_y+10,450+l_x+90,l_num)
   END IF  	 		
   #LET l_sql = "SELECT replace(",cl_tp_tochar(l_mm,'fm990.0'),"),' ','') FROM DUAL" #FUN-D60097 mark
    LET l_sql = "SELECT replace(",cl_tp_tochar(l_mm,'fm990.0'),",' ','') FROM DUAL"  #FUN-D60097
    PREPARE q900_sel_prep8 FROM l_sql
    EXECUTE q900_sel_prep8 INTO l_num
   LET id = drawText(200,500,l_mm) 	
END FUNCTION		
	
FUNCTION q900_drawclear()
DEFINE l_str       LIKE type_file.chr30	
DEFINE l_i         LIKE type_file.num10
DEFINE l_sql      STRING
   FOR l_i = 11 TO 22
       LET l_sql = "SELECT 'cv'||replace(",cl_tp_tochar(l_i,'999'),",' ','') FROM DUAL" 
       PREPARE q900_sel_prep9 FROM l_sql
       EXECUTE q900_sel_prep9 INTO l_str
       CALL drawselect(l_str)
       CALL drawclear()
       CALL drawinit()
   END FOR    
END FUNCTION 
			
