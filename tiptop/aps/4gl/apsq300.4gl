# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsq300.4gl
# Descriptions...: ATP插單達交試算查詢
# Date & Author..: 97/07/17 By Duke FUN-870081 以aps運算回傳條件為主，計算預測料件之預計達交狀況
# Modify.........: TQC-8A0050 08/10/16 BY DUKE 修正挑選版本時多儲存版本問題
# Modify.........: FUN-8A0149 08/11/03 BY DUKE 不用判斷apsp400的是否使用預測料號,一律判斷ima133
# Modify.........: No.TQC-940109 09/05/07 BY destiny order by的字段錯誤，程序沒有用到vld12
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/24 By JIACHENCHAO 更改關於字段ima26的相關語句
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1	LIKE ima_file.ima01,	# 料號  
    g_argv2	LIKE mps_file.mps041,   
    g_msr	RECORD LIKE msr_file.*,
    h_mps   RECORD      #NO.FUN-870081
            apsrev      LIKE vld_file.vld01,   #APS 版本
            saverev     LIKE vld_file.vld02,   #APS 儲存版本
            partno      LIKE ima_file.ima01,   #產品編號
            qty         LIKE mps_file.mps041,  #接單數量
            atpdate     LIKE type_file.chr10   #可達交日期
            END RECORD,
    g_wc,g_wc2          string,  
    g_sql               string,  
    g_mxno              LIKE type_file.num5,    
    #NO.FUN-870081
    g_mps           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
			seq     	LIKE type_file.num5,    
	 	        tbday  	        LIKE type_file.dat,   
			invqty 	        LIKE type_file.num10,   
			preqty 	        LIKE type_file.num10,   
			atpqty    	LIKE type_file.num10   
                    END RECORD,
    g_buf           LIKE type_file.chr1000,
    g_rec_b         LIKE type_file.num5,   
    l_ac            LIKE type_file.num5,   
    l_sl            LIKE type_file.num5,   
    g_ima25         LIKE ima_file.ima25,
    g_ima02         LIKE ima_file.ima02,
    g_ima16         LIKE ima_file.ima16,
    g_ima133        LIKE ima_file.ima133,   #預測料號
#    g_ima262        LIKE ima_file.ima262,   #可用庫存 #FUN-A20044
    g_avl_stk        LIKE type_file.num15_3,   #可用庫存 #FUN-A20044
#    g_ima262S       LIKE ima_file.ima262,   #FUN-8A0149 #FUN-A20044
    g_avl_stk_mpsmrp LIKE type_file.num15_3, #FUN-A20044
    g_unavl_stk      LIKE type_file.num15_3, #FUN-A20044
    g_avl_stkS       LIKE type_file.num15_3,   #FUN-8A0149 #FUN-A20044
    g_ima139        LIKE ima_file.ima139,
    g_vld02         LIKE vld_file.vld02,
    g_vld16         LIKE vld_file.vld16,
    g_rqa02         LIKE rqa_file.rqa02,
    l_saverev       LIKE vld_file.vld02
 
DEFINE   g_cnt           LIKE type_file.num10        
DEFINE   g_i             LIKE type_file.num5     
DEFINE   g_msg           LIKE type_file.chr1000  
DEFINE   g_row_count     LIKE type_file.num10     
DEFINE   g_curs_index    LIKE type_file.num10     
DEFINE   g_jump          LIKE type_file.num10     
DEFINE   g_no_ask       LIKE type_file.num5     
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1= ARG_VAL(1)
    LET g_argv2= ARG_VAL(2)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
    INITIALIZE h_mps.* TO NULL
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW q300_w WITH FORM "aps/42f/apsq300" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_rqa02 = g_mpz.mpz05
    IF NOT cl_null(g_argv1) THEN CALL q300_q() END IF
    CALL q300()
    CLOSE WINDOW q300_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q300()
    CALL q300_menu()
END FUNCTION
 
FUNCTION q300_cs()
DEFINE l_apsrev  like vld_file.vld01
DEFINE l_vld12   like vld_file.vld12
 
    CALL cl_set_head_visible("","YES")   
    IF NOT cl_null(g_argv1) THEN   
       LET h_mps.partno=g_argv1
       LET h_mps.qty   =g_argv2
    ELSE
 
       INPUT h_mps.apsrev,h_mps.partno,h_mps.qty WITHOUT DEFAULTS
       FROM FORMONLY.apsrev,FORMONLY.partno,FORMONLY.qty
 
       #TQC-8A0050 MARK
       AFTER FIELD apsrev
       #  # SELECT vld02 INTO g_vld02 FROM vld_file,vlz_file
       #  #  WHERE vld01 = h_mps.apsrev  and vld01=vlz01 and vld02=vlz02 order by vld12
       #  SELECT max(vld12) INTO l_vld12 FROM vld_file,vlz_file
       #   WHERE vld01 = h_mps.apsrev  and vld01=vlz01 and vld02=vlz02
       #
         SELECT vld02 INTO g_vld02 FROM vld_file
          WHERE vld01 = h_mps.apsrev  AND vld02=h_mps.saverev
        
         IF STATUS
            THEN
            #CALL cl_err('','aps-300',1)    #FUN-8A0149 MARK
            CALL cl_err('','aps-302',1)     #FUN-8A0149 ADD
            NEXT FIELD apsrev
       #  ELSE 
       #     DISPLAY g_vld02 TO FORMONLY.saverev
       #     LET l_saverev = g_vld02
         END IF
 
 
       AFTER FIELD partno
#         SELECT ima02,ima16,ima139,ima133,ima262  #FUN-A20044
         SELECT ima02,ima16,ima139,ima133  #FUN-A20044
#                INTO g_ima02,g_ima16,g_ima139,g_ima133,g_ima262 FROM ima_file #FUN-A20044
                INTO g_ima02,g_ima16,g_ima139,g_ima133 FROM ima_file #FUN-A20044
          WHERE ima01 = h_mps.partno
          CALL s_getstock(h_mps.partno,g_plant)RETURNING g_avl_stk_mpsmrp,g_unavl_stk,g_avl_stk #FUN-A20044
         #IF STATUS    #FUN-8A0149  MARK
         IF cl_null(g_ima02) THEN  #FUN-8A0149 ADD
            CALL cl_err('','mfg0002',0)
            NEXT FIELD partno
         ELSE
#            IF cl_null(g_ima262) THEN  #FUN-8A0149 ADD #FUN-A20044
            IF cl_null(g_avl_stk) THEN  #FUN-8A0149 ADD #FUN-A20044
#               LET g_ima262 = 0 #FUN-A20044
               LET g_avl_stk = 0 #FUN-A20044
            END IF 
            DISPLAY g_ima02 TO FORMONLY.ima02
         END IF
 
       AFTER FIELD qty
         IF cl_null(h_mps.qty) OR h_mps.qty<=0
            THEN
            NEXT FIELD qty
         END IF
 
     AFTER INPUT
         IF INT_FLAG THEN   EXIT INPUT END IF   #bugno:5418
         IF cl_null(h_mps.partno) OR h_mps.qty<=0
            THEN
            NEXT FIELD partno
         END IF
 
         IF cl_null(h_mps.qty) OR h_mps.qty<=0
            THEN
            NEXT FIELD qty
         END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(apsrev)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_vld01"  #TQC-8A0050
                CALL cl_create_qry() RETURNING h_mps.apsrev,h_mps.saverev
                DISPLAY BY NAME h_mps.apsrev,h_mps.saverev      
                LET  l_saverev = h_mps.saverev  
                NEXT FIELD apsrev
            WHEN INFIELD(partno)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ima"  #TQC-8A0050
               CALL cl_create_qry() RETURNING h_mps.partno
               DISPLAY BY NAME h_mps.partno        
               NEXT FIELD partno
          END CASE
 
        ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      END INPUT
 
 
      IF INT_FLAG THEN 
          RETURN 
      END IF
    END IF
 
 
   LET g_sql="SELECT DISTINCT vld01 FROM vld_file ",
              " WHERE vld01 = '",h_mps.apsrev,"' ",
             #" ORDER BY vld12 "                      #No.TQC-940109         
              " ORDER BY vld01 "                      #No.TQC-940109         
 
    PREPARE q300_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q300_cs SCROLL CURSOR WITH HOLD FOR q300_prepare
    #----->modi:2840
    DROP TABLE x
    SELECT mps01,mps_v FROM mps_file GROUP BY mps01,mps_v INTO TEMP x 
    LET g_sql= "SELECT COUNT(*) FROM x WHERE ",g_wc CLIPPED 
    #----->(end)
    PREPARE q300_precount FROM g_sql
    DECLARE q300_count CURSOR FOR q300_precount
END FUNCTION
 
FUNCTION q300_menu()
 
   WHILE TRUE
      CALL q300_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q300_q() 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #@WHEN "計算達交日"
         WHEN "comp_due_date"
            IF NOT cl_null(h_mps.apsrev)  AND NOT cl_null(h_mps.partno) AND 
               NOT cl_null(h_mps.qty) THEN
               CALL q300_d()
            END IF
      END CASE
   END WHILE
      CLOSE q300_cs
END FUNCTION
 
FUNCTION q300_q()
 
    CLEAR FORM #MOD-490279
    CALL g_mps.clear() 
    INITIALIZE h_mps.* TO NULL 
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q300_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_mps.clear()
   MESSAGE " SEARCHING ! " 
 
END FUNCTION
 
 
FUNCTION q300_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
    DEFINE l_vld        RECORD LIKE vld_file.*
 
    CLEAR FORM
    CALL g_mps.clear()
    DISPLAY g_cnt TO FORMONLY.cnt
    DISPLAY BY NAME h_mps.apsrev,h_mps.partno,h_mps.qty
 
    DISPLAY l_saverev TO  FORMONLY.saverev
 
    SELECT ima02,ima16,ima139,ima25 
      INTO l_ima.ima02,g_ima16,g_ima139,g_ima25
      FROM ima_file WHERE ima01=h_mps.partno
    DISPLAY l_ima.ima02 TO FORMONLY.ima02
 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
#FUN-870081 計算達交日
FUNCTION q300_d()
   DEFINE l_plant,l_dbs	  LIKE type_file.chr21    
   DEFINE l_i             LIKE type_file.num5
   DEFINE wekday          LIKE type_file.num5
   DEFINE wekdate         LIKE type_file.dat
   DEFINE buk_type        LIKE type_file.chr1
   DEFINE x               LIKE type_file.chr8
   DEFINE l_desc          LIKE type_file.chr50
   DEFINE l_seq           LIKE type_file.num5
   DEFINE l_svoa05     LIKE voa_file.voa05
 
   LET g_mps[1].seq = 1
   LET g_mps[31].seq   =0
   LET g_mps[31].invqty=0
   LET g_mps[31].preqty =0
   LET g_mps[31].atpqty  =0
 
   SELECT  vld06,vld16 INTO  buk_type,g_vld16  FROM vld_file
     WHERE vld01 = h_mps.apsrev
       AND vld02 = l_saverev
 
   #FUN-8A0149 不依apsp400決定料件,一律用實際料號 ima01
   #依預測料件可用庫存為空或預測料件為空值則以實際料件為取出預測餘量之條件
   #IF g_vld16!='Y' THEN  LET  g_ima133 = h_mps.partno  END IF
 
   LET wekday = weekday(g_today)
   LET wekdate = g_today
 
   FOR l_i =1  to 31
      LET g_mps[l_i].seq = l_i 
      CASE 
         WHEN  buk_type='2'  
               LET wekdate = g_today + l_i - 1
         WHEN  buk_type='3' 
               LET  wekday = weekday(wekdate)
               IF   wekday=0 THEN LET wekday = 7 END IF
               LET  wekdate = wekdate - wekday  + 1
         WHEN  buk_type='4'
               LET  x = wekdate USING 'yyyymmdd'
               CASE WHEN x[7,8]<='10' LET x[7,8]='01'
                    WHEN x[7,8]<='20' LET x[7,8]='11'
                    OTHERWISE         LET x[7,8]='21'
                    END CASE
               LET wekdate = MDY(x[5,6],x[7,8],x[1,4])
         WHEN  buk_type='5'
               LET x = wekdate USING 'yyyymmdd'
               LET X[7,8]='01'
               LET wekdate=MDY(x[5,6],x[7,8],x[1,4])
      END CASE   
      LET g_mps[l_i].tbday = wekdate 
      LET g_mps[l_i].invqty = 0
      LET g_mps[l_i].preqty = 0
      LET g_mps[l_i].atpqty = 0
      IF buk_type='3' THEN LET wekdate = cl_cal(wekdate,0,7)  END IF
      IF buk_type='4' THEN 
         LET wekdate = cl_cal(wekdate,0,10) 
         LET x=wekdate USING 'yyyymmdd'
         IF x[7,8]='31' THEN LET wekdate = wekdate + 1 END IF
      END IF
      IF buk_type='5' THEN LET wekdate = cl_cal(wekdate,1,0) END IF
   END FOR
 
   #FUN-870081  取出目前預測可用庫存量若無預測料號則改取實際料號
   IF NOT cl_null(g_ima133) THEN
      SELECT sum(voa05) INTO l_svoa05 FROM voa_file
        WHERE voa01=h_mps.apsrev
          and voa02=l_saverev
          and voa04=g_ima133
          and voa11='F'
   ELSE
     SELECT sum(voa05) INTO l_svoa05 FROM voa_file
       WHERE voa01=h_mps.apsrev
        and voa02=l_saverev
        and voa04=h_mps.partno
        and voa11='F'
   END IF
 
   #FUN-8A0149 MARK --STR
   #IF  STATUS  THEN
   #   LET l_svoa05 = 0
   #END IF
   #FUN-8A0149 MARK --END
   #FUN-8A0149  ADD --STR
   IF cl_null(l_svoa05) THEN
      LET l_svoa05 = 0
   END IF
   #FUN-8A0149 ADD  --END
 
 
#   IF  g_ima262 >=l_svoa05 THEN LET g_mps[1].invqty = g_ima262 - l_svoa05 #FUN-A20044
   IF  g_avl_stk >=l_svoa05 THEN LET g_mps[1].invqty = g_avl_stk - l_svoa05 #FUN-A20044
   ELSE  LET  g_mps[1].invqty = 0
   END IF      
 
   FOR l_i = 1 to 30   
      #FUN-870081  取出沖銷預測餘量
      IF NOT cl_null(g_ima133) THEN
         SELECT sum(voa05) into g_mps[l_i].preqty FROM voa_file
           WHERE voa01 = h_mps.apsrev
             AND voa02 = l_saverev
             AND voa04 = g_ima133
             AND voa11='F'
             AND voa23 >= g_mps[l_i].tbday
             AND voa23 < g_mps[l_i+1].tbday
      ELSE
        SELECT sum(voa05) into g_mps[l_i].preqty FROM voa_file
          WHERE voa01 = h_mps.apsrev
            AND voa02 = l_saverev
            AND voa04 = h_mps.partno
            AND voa11='F'
            AND voa23 >= g_mps[l_i].tbday
            AND voa23 < g_mps[l_i+1].tbday
      END IF
 
      IF  cl_null(g_mps[l_i].preqty) THEN
           LET g_mps[l_i].preqty = 0 
      END IF
      DISPLAY BY NAME  g_mps[l_i].preqty
        
   END FOR
  
   
 
   #FUN-870081 計算每期預計庫存量 
   LET l_desc = '預估期間內無法達交,請重新評估'
   IF g_mps[1].invqty+g_mps[1].preqty >= h_mps.qty THEN
      LET g_mps[1].atpqty=h_mps.qty
      LET h_mps.qty = 0 
      DISPLAY g_mps[1].tbday TO FORMONLY.atpdate
      LET l_desc = '預計於 ',g_mps[1].tbday,' 可達交'
   END IF
 
   FOR l_i = 2 to 31
     LET g_mps[l_i].invqty = g_mps[l_i-1].invqty + g_mps[l_i-1].preqty -g_mps[l_i-1].atpqty 
     IF g_mps[l_i].invqty+g_mps[l_i].preqty>=h_mps.qty  and  h_mps.qty<>0 THEN
        LET g_mps[l_i].atpqty = h_mps.qty
        LET h_mps.qty = 0
        DISPLAY g_mps[l_i].tbday TO FORMONLY.atpdate
        LET l_desc = '預計於 ',g_mps[l_i].tbday,' 可達交'
     END IF
   END FOR
   DISPLAY l_desc TO FORMONLY.desc   
   DISPLAY 1 TO  FORMONLY.cnt
   LET l_seq = 0
   FOR l_i = 1 to 31 
       LET l_seq = l_seq + 1
   END FOR
   DISPLAY l_seq TO  FORMONLY.cn2 
 
 
END FUNCTION
 
FUNCTION q300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mps  TO s_mps.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
#      ON ACTION first 
#         CALL q300_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
#      ON ACTION previous
#         CALL q300_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
#      ON ACTION jump 
#         CALL q300_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
#      ON ACTION next
#         CALL q300_fetch('N') 
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
#      ON ACTION last 
#         CALL q300_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION  計算達交日
      ON ACTION comp_due_date
         LET g_action_choice="comp_due_date"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
