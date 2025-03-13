# Prog. Version..: '5.30.06-13.03.26(00005)'     #
#
# Pattern name...: apcp102.4gl
# Descriptions...: POS交易資料復原下傳作業 
# Date & Author..: 11/12/07 By pauline #FUN-BC0015 
# Modify.........: No.FUN-C20119 12/02/29 By pauline 當g_success為null時,使用另外一個錯誤訊息
# Modify.........: No.FUN-C50090 12/05/29 By yangxf 新增sapcp102作業POS数据恢复
# Modify.........: No.FUN-D30046 13/03/18 By dongsz 日期傳參修改為g_date
# Modify.........: No.FUN-D30092 13/03/25 By dongsz 添加卡券POS還原邏輯
 
DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_pdb               LIKE ryg_file.ryg00
DEFINE g_plant             STRING
DEFINE g_pos               STRING
DEFINE p_row,p_col         LIKE type_file.num5
DEFINE g_date              LIKE type_file.dat
DEFINE g_sale              LIKE type_file.chr1
DEFINE g_order             LIKE type_file.chr1
DEFINE g_deposit           LIKE type_file.chr1
DEFINE g_card              LIKE type_file.chr1    #FUN-D30092 add
DEFINE g_coupon            LIKE type_file.chr1    #FUN-D30092 add
DEFINE g_change_lang       LIKE type_file.chr1000
#DEFINE g_plantstr         STRING                 #FUN-C50090 mark
DEFINE g_count             LIKE type_file.num5
DEFINE g_trans_no          LIKE ryy_file.ryy01
DEFINE g_sql               STRING                  #FUN-C50090 add 

MAIN
    OPTIONS
    INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("APC")) THEN
       EXIT PROGRAM
    END IF
    IF g_aza.aza88<>'Y' THEN
       CALL cl_err('','apc-120',1)
       EXIT PROGRAM
    END IF

    IF cl_null(g_bgjob) THEN
       LET g_bgjob = 'N'
    END IF 

    CALL  cl_used(g_prog,g_time,1) RETURNING g_time
    LET p_row = 5 LET p_col = 10
    WHILE TRUE
       IF g_bgjob='N' THEN
          CALL p102_p1()
          CLOSE WINDOW p102_w
       END IF
    END WHILE
    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p102_p1()
DEFINE l_tok          base.StringTokenizer
DEFINE l_plant        LIKE azw_file.azw01
DEFINE l_n            LIKE type_file.num5

   OPEN WINDOW p102_w AT p_row,p_col WITH FORM "apc/42f/apcp102"
      ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   SELECT DISTINCT ryg00 INTO g_pdb FROM ryg_file

   DISPLAY g_pdb TO pdb

   CALL cl_show_fld_cont()

   WHILE TRUE
      INPUT g_plant, g_pos, g_date, g_sale, g_order, g_deposit,g_card,g_coupon   #FUN-D30092 add g_card,g_coupon
           FROM plant, pos, date, sale, order, deposit, card, coupon             #FUN-D30092 add card, coupon
 
      BEFORE INPUT 
         LET g_date = TODAY
         LET g_sale = 'Y'
         LET g_order = 'Y'
         LET g_deposit = 'Y'
         LET g_card = 'Y'      #FUN-D30092 add
         LET g_coupon = 'Y'    #FUN-D30092 add
         DISPLAY g_date, g_sale, g_order, g_deposit, g_card, g_coupon    #FUN-D30092 add g_card,g_coupon
              TO date, sale, order, deposit, card, coupon                #FUN-D30092 add card, coupon

      AFTER FIELD plant
         IF NOT cl_null(g_plant) THEN
            LET l_tok = base.stringtokenizer.create(g_plant,"|")
            WHILE l_tok.hasmoretokens()
               LET l_plant = l_tok.nextToken()
                  SELECT COUNT(*) INTO l_n FROM ryg_file
                      WHERE ryg01 = l_plant AND rygacti='Y'
               IF l_n=0 OR cl_null(l_n) THEN
                  CALL cl_err(l_plant,'apc-119',0)  #该营运中心没有设置传输
                  DISPLAY g_plant TO plant
                  NEXT FIELD plant
               END IF
            END WHILE
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(plant)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ryg01"
               CALL cl_create_qry() RETURNING g_plant  #qryparam.multiret
               DISPLAY g_plant TO plant
               NEXT FIELD plant
            OTHERWISE EXIT CASE
         END CASE
           
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
        #IF cl_null(g_sale) AND cl_null(g_order) AND cl_null(g_deposit) THEN      #FUN-D30092 mark
         IF cl_null(g_sale) AND cl_null(g_order) AND cl_null(g_deposit) AND cl_null(g_card) AND cl_null(g_coupon) THEN   #FUN-D30092 add
            CALL cl_err('','apc-144',0)
            NEXT FIELD sale
         END IF
        #IF g_sale = 'N' AND g_order = 'N' AND g_deposit = 'N' THEN     #FUN-D30092 mark
         IF g_sale = 'N' AND g_order = 'N' AND g_deposit = 'N' AND g_card = 'N' AND g_coupon = 'N' THEN   #FUN-D30092 add
            CALL cl_err('','apc-144',0)
            NEXT FIELD sale 
         END IF  

      ON ACTION locale
         LET g_change_lang = TRUE
         EXIT INPUT

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

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

      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION qbe_save
         CALL cl_qbe_save()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p102_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      CALL p102_prepare()
   END WHILE
END FUNCTION

FUNCTION p102_prepare()
DEFINE l_posstr           STRING
DEFINE l_plantstr         STRING
DEFINE l_date             LIKE type_file.dat 
DEFINE l_mach             STRING
DEFINE l_fdate            LIKE type_file.dat
DEFINE l_flag             LIKE type_file.chr1
DEFINE l_sql              STRING

   LET l_date = g_today
   LET l_posstr = ''
   LET l_fdate = DATE(g_date) USING "yyyymmdd"
   LET l_mach = g_pos
   IF g_sale = 'Y' THEN     #POS 銷售資料
      IF cl_null(l_posstr) THEN
         LET l_posstr = '901'
      ELSE
         LET l_posstr = l_posstr,'|901'
      END IF
   END IF

   IF g_order = 'Y' THEN    #POS 訂單資料
      IF cl_null(l_posstr) THEN
#        LET l_posstr = '|902'         #FUN-C50090 mark
         LET l_posstr = '902'          #FUN-C50090 add
      ELSE
         LET l_posstr = l_posstr,'|902'
      END IF
   END IF

   IF g_deposit = 'Y' THEN   #POS 訂金退回資料
      IF cl_null(l_posstr) THEN
#        LET l_posstr = '|903'         #FUN-C50090 mark
         LET l_posstr = '903'          #FUN-C50090 add
      ELSE
         LET l_posstr = l_posstr,'|903'
      END IF
   END IF

  #FUN-D30092--add--str---
   IF g_card = 'Y' THEN     #POS 卡異動資料
      IF cl_null(l_posstr) THEN
         LET l_posstr = '904'
      ELSE
         LET l_posstr = l_posstr,'|904'
      END IF
   END IF

   IF g_coupon = 'Y' THEN   #POS 券異動資料
      IF cl_null(l_posstr) THEN
         LET l_posstr = '905'
      ELSE
         LET l_posstr = l_posstr,'|905'
      END IF
   END IF
  #FUN-D30092--add--end---
   IF NOT cl_null(l_posstr) THEN
      IF cl_sure(0,0) THEN                   #FUN-C50090 add
#        LET g_trans_no = p100_trans_no()       #FUN-C50090 mark
         LET g_trans_no = p102_trans_no()       #FUN-C50090 add 
#        CALL p100(l_posstr,g_plant,g_pdb,l_date,'2',l_mach,l_fdate)                  #FUN-C50090 mark
        #CALL p102(l_posstr,g_plant,l_date,l_mach,g_trans_no)                         #FUN-C50090 add  #FUN-D30046 mark
         CALL p102(l_posstr,g_plant,g_date,l_mach,g_trans_no)           #FUN-D30046 add

         LET g_count = 0
         SELECT COUNT(*) INTO g_count FROM ryy_file 
           WHERE ryy01 = g_trans_no
         IF cl_null(g_success) THEN  #FUN-C20119 add
            CALL cl_err('','apc-152',0)
         ELSE  #FUN-C20119 add
            IF g_success = 'Y' THEN
               IF g_count = 0 THEN
                  CALL cl_err('','apc-151',1) 
               ELSE
                  CALL cl_end2(1) RETURNING l_flag
               END IF
            ELSE
               CALL cl_err('','apc-150',1)
            END IF
         END IF  #FUN-C20119 add
         IF NOT l_flag THEN
            CLOSE WINDOW p102_w
            CALL  cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
       END IF 
    END IF
END FUNCTION 

#FUN-C50090 add begin ---
FUNCTION p102_trans_no()
   DEFINE l_time  LIKE type_file.chr30
   DEFINE l_ryy01 LIKE ryy_file.ryy01

   LET l_time =CURRENT YEAR TO FRACTION(4)
   LET l_time = l_time[1,4],l_time[6,7],l_time[9,10],l_time[12,13],l_time[15,16],l_time[18,19],l_time[21,23]
   LET l_ryy01 = "D",l_time CLIPPED
   RETURN l_ryy01
END FUNCTION
#FUN-C50090 add END ---

#FUN-C50090 mark begin ---
#FUNCTION p102_plant()
#DEFINE l_tok          base.StringTokenizer
#DEFINE l_plant        LIKE azw_file.azw01
#   LET g_plantstr = ' '
#   IF NOT cl_null(g_plant) THEN
#      LET l_tok = base.StringTokenizer.create(g_plant,'|')
#      WHILE l_tok.hasMoreTokens()
#          LET l_plant = l_tok.nextToken()
#          IF cl_null(g_plantstr) THEN
#             LET g_plantstr = "'",l_plant,"'"
#          ELSE
#             LET g_plantstr = g_plantstr,",'",l_plant,"'"
#          END IF
#      END WHILE
#   END IF
#   IF NOT cl_null(g_plantstr) THEN
#      LET g_plantstr = "(",g_plantstr,")"
#   END IF
#END FUNCTION
#FUN-C50090 mark end ----
#FUN-BC0015
