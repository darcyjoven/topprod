# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amsq502.4gl
# Descriptions...: MRP QR查詢
# Date & Author..: 96/05/06 By Roger
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560230 05/06/27 By Melody QPA->DEC(16,8) 
# Modify.........: No.MOD-580322 05/08/30 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-710073 07/12/03 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.TQC-960324 09/06/23 By chenmoyan g_wc沒有值
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.TQC-BA0069 11/10/14 By houlia 添加報錯信息ams-827
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:CHI-C80041 13/02/06 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_argv1	LIKE ima_file.ima01,	# 料號  No.MOD-490217
    g_argv2	LIKE mps_file.mps041,   #NO.FUN-680101 DEC(15,3)  # 數量
    g_msr	RECORD LIKE msr_file.*,
    h_mps   RECORD
            partno      LIKE ima_file.ima01,   #產品編號
            qty         LIKE mps_file.mps041,  #NO.FUN-680101 DEC(15,3)  #接單數量
            atpdate     LIKE type_file.dat     #NO.FUN-680101 DATE       #可達交日期
            END RECORD,
    g_wc,g_wc2          string,  #No.FUN-580092 HCN
    g_sql               string,  #No.FUN-580092 HCN
    g_mxno              LIKE type_file.num5,    #NO.FUN-680101
    g_mps           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
			seq    	LIKE type_file.num5,         #NO.FUN-680101 SMALLINT 
	 	        mpk_d  	LIKE mpk_file.mpk_d,         #NO.FUN-680101 VARCHAR(10)
			order_qty 	LIKE type_file.num10,   #NO.FUN-680101 INTEGER
			invqty 	        LIKE type_file.num10,   #NO.FUN-680101 INTEGER
			mps_qty  	LIKE type_file.num10,   #NO.FUN-680101 INTEGER
			atp    	        LIKE type_file.num10,   #NO.FUN-680101 INTEGER
			catp            LIKE type_file.num10    #NO.FUN-680101 INTEGER
                    END RECORD,
    g_buf           LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(78)
    g_rec_b         LIKE type_file.num5,   #NO.FUN-680101 SMALLINT   #單身筆數
    l_ac            LIKE type_file.num5,   #NO.FUN-680101 SMALLINT   #目前處理的ARRAY CNT
    l_sl            LIKE type_file.num5,   #NO.FUN-680101 SMALLINT   #目前處理的SCREEN LINE
    g_ima25         LIKE ima_file.ima25,
    g_ima02         LIKE ima_file.ima02,
    g_ima16         LIKE ima_file.ima16,
    g_ima139        LIKE ima_file.ima139,
    g_rqa02         LIKE rqa_file.rqa02,
    g_first_mps_level  LIKE type_file.num5,    #NO.FUN-680101 SMALLINT   # 最接近主件的下階MPS件所在的Level
    g_first_mps_partno LIKE ima_file.ima01     # 最接近主件的下階MPS件所在的item
 
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680101 INTEGER    
DEFINE   g_i             LIKE type_file.num5     #NO.FUN-680101 SMALLINT #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-680101 INTEGER 
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680101 INTEGER 
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-680101 INTEGER 
DEFINE   mi_no_ask       LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1= ARG_VAL(1)
    LET g_argv2= ARG_VAL(2)
    INITIALIZE h_mps.* TO NULL
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
 
    LET p_row = 3 LET p_col = 3 
    OPEN WINDOW q502_w AT p_row,p_col WITH FORM "ams/42f/amsq502" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_rqa02 = g_mpz.mpz05
    IF NOT cl_null(g_argv1) THEN CALL q502_q() END IF
    CALL q502()
    CLOSE WINDOW q502_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION q502()
    CALL q502_menu()
END FUNCTION
 
FUNCTION q502_cs()
 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    IF NOT cl_null(g_argv1) THEN   # 由 axmt410 call
       LET h_mps.partno=g_argv1
       LET h_mps.qty   =g_argv2
    ELSE
 
       INPUT h_mps.partno,h_mps.qty WITHOUT DEFAULTS 
        FROM FORMONLY.partno,FORMONLY.qty
 
        AFTER FIELD partno
          SELECT ima02,ima16,ima139 INTO g_ima02,g_ima16,g_ima139 FROM ima_file
           WHERE ima01 = h_mps.partno
          IF STATUS 
             THEN
             CALL cl_err('','mfg0002',0)
             NEXT FIELD partno
          ELSE
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
 
      #TQC-860019-add
      ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
      #TQC-860019-add
 
       END INPUT
       IF INT_FLAG THEN 
          RETURN 
       END IF
    END IF
 
   # 抓取該料件下階 BOM
    CALL q502_get_mps01()
 
    LET g_sql="SELECT UNIQUE bmb03,qty,'',level1 FROM bom_tmp",
              " WHERE 1=1 ",
              " ORDER BY 4,1,2"
 
    PREPARE q502_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q502_cs SCROLL CURSOR WITH HOLD FOR q502_prepare
    #----->modi:2840
    DROP TABLE x
    SELECT mps01,mps_v FROM mps_file GROUP BY mps01,mps_v INTO TEMP x 
  # LET g_sql= "SELECT COUNT(*) FROM x WHERE ",g_wc CLIPPED #No.TQC-960324
    LET g_sql= "SELECT COUNT(*) FROM x WHERE 1=1 "          #No.TQC-960324
    #----->(end)
 #  LET g_sql= "SELECT COUNT(DISTINCT mps01) FROM mps_file WHERE ",g_wc CLIPPED
    PREPARE q502_precount FROM g_sql
    DECLARE q502_count CURSOR FOR q502_precount
END FUNCTION
 
FUNCTION q502_menu()
 
   WHILE TRUE
      CALL q502_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q502_q() 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        #@WHEN "工廠切換"
        #WHEN "switch_plant"     #FUN-B10030 
        #   CALL q502_d()        #FUN-B10030 
      END CASE
   END WHILE
      CLOSE q502_cs
END FUNCTION
 
FUNCTION q502_q()
 
    CLEAR FORM #MOD-490279
    CALL g_mps.clear() #MOD-490279
    INITIALIZE h_mps.* TO NULL #MOD-490279
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q502_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN LET INT_FLAG = 0 CLEAR FORM RETURN END IF
   CALL g_mps.clear()
   MESSAGE " SEARCHING ! " 
   OPEN q502_count
   FETCH q502_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN q502_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err(h_mps.partno,SQLCA.sqlcode,0)
       INITIALIZE h_mps.* TO NULL
   ELSE
       CALL q502_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION q502_fetch(p_flmps)
    DEFINE
        p_flmps         LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
        l_abso          LIKE type_file.num10    #NO.FUN-680101 INTEGER
 
    CASE p_flmps
        WHEN 'N' FETCH NEXT     q502_cs INTO h_mps.*
        WHEN 'P' FETCH PREVIOUS q502_cs INTO h_mps.*
        WHEN 'F' FETCH FIRST    q502_cs INTO h_mps.*
        WHEN 'L' FETCH LAST     q502_cs INTO h_mps.*
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q502_cs INTO h_mps.*
            LET mi_no_ask = FALSE 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(h_mps.partno,SQLCA.sqlcode,0)
        INITIALIZE h_mps.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flmps
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    CALL q502_show()                      # 重新顯示
END FUNCTION
 
FUNCTION q502_show()
    DEFINE l_ima	RECORD LIKE ima_file.*
 
    CLEAR FORM
    CALL g_mps.clear()
    DISPLAY g_cnt TO FORMONLY.cnt
    DISPLAY BY NAME h_mps.partno,h_mps.qty
 
    SELECT ima02,ima16,ima139,ima25 
      INTO l_ima.ima02,g_ima16,g_ima139,g_ima25
      FROM ima_file WHERE ima01=h_mps.partno
    DISPLAY l_ima.ima02 TO FORMONLY.ima02
 
    CALL q502_b_fill(h_mps.partno)  
 
    IF g_ima139='Y' # MPS 件
       THEN 
    ELSE
 #No.MOD-580322--begin                                                                                                              
#      CASE g_lang                                                                                                                  
#        WHEN '0'                                                                                                                   
           MESSAGE cl_getmsg('ams-825',g_lang),g_ima25,cl_getmsg('ams-826',g_lang)                                                      
#        WHEN '2'                                                                                                                   
#        OTHERWISE                                                                                                                  
#      END CASE                                                                                                                     
 #No.MOD-580322--end  
    END IF
    CALL q502_atpdate()
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q502_out(p_cmd)
   DEFINE p_cmd	    LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1) 
          l_cmd	    LIKE type_file.chr1000, #NO.FUN-680101 VARCHAR(400)
          l_wc      LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(200)
 
{
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = 'mps01="',h_mps.mps01,'"' 		# "新增"則印單張
      ELSE LET l_wc = g_wc                     			# 其他則印多張
   END IF
   IF g_wc IS NULL THEN
#     CALL cl_err('',-400,0) END IF
       CALL cl_err('','9057',0) RETURN END IF
   LET l_cmd = "amsr510",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' '",
               l_wc CLIPPED
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
}
END FUNCTION
 
#FUN-B10030 ----------mark start----------------
#FUNCTION q502_d()
#  DEFINE l_plant,l_dbs	  LIKE type_file.chr21    #NO.FUN-680101 VARCHAR(21)
#
#           LET INT_FLAG = 0  ######add for prompt bug
#  PROMPT 'PLANT CODE:' FOR l_plant
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
##         CONTINUE PROMPT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  
#  END PROMPT
#  IF l_plant IS NULL THEN RETURN END IF
#  SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#  IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#  DATABASE l_dbs
##   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#  CALL cl_ins_del_sid(1,l_plant) #FUN-980030  #FUN-990069
#  IF STATUS THEN ERROR 'open database error!' RETURN END IF
#  LET g_plant = l_plant
#  LET g_dbs   = l_dbs
#END FUNCTION
#FUN-B10030 ---------------mark end--------------
 
FUNCTION q502_b_fill(p_partno)              #BODY FILL UP
DEFINE p_partno        LIKE ima_file.ima01
DEFINE l_invqty        LIKE type_file.num10,    #NO.FUN-680101 INTEGER 
       l_i             LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
       l_date          LIKE type_file.dat       #NO.FUN-680101 DATE
DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044 
 
    DECLARE q502_mpk_cur CURSOR FOR SELECT mpk_d FROM mpk_file
             WHERE mpk_v = ' ' OR mpk_v IS NULL
             ORDER BY 1
 
    CALL g_mps.clear()
 
    LET g_mps[1].seq = 1
    LET g_mps[31].seq   =0
    LET g_mps[31].order_qty=0
    LET g_mps[31].mps_qty =0
    LET g_mps[31].atp   =0
    LET g_mps[31].catp  =0
 
    LET g_rec_b = 0
    LET l_i = 1
#   FOREACH mps_curs INTO g_mps[l_i].*   #單身 ARRAY 填充
    FOREACH q502_mpk_cur INTO l_date   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_mps[l_i].mpk_d= l_date  
        LET g_mps[l_i].mps_qty =0
        LET g_mps[l_i].seq = l_i
 
        SELECT SUM(msb05*ima55_fac) INTO g_mps[l_i].mps_qty
          FROM msa_file,msb_file,ima_file,mpm_file
         WHERE msa03 = 'N'                # 未結案 MPS
           AND msa01 = msb01
           AND msb03 = p_partno
           AND ( mpm_v = ' ' OR mpm_v IS NULL )  
           AND mpm_d = g_mps[l_i].mpk_d
           AND msb04 = mpm_act
           AND ima01 = msb03
           AND msa05<>'X'  #CHI-C80041
 
        IF cl_null(g_mps[l_i].mps_qty) THEN LET g_mps[l_i].mps_qty =0 END IF
 
        #  由 MPS Log檔抓受訂量
        SELECT SUM(mpg05*mpg06*oeb05_fac) INTO g_mps[l_i].order_qty   # 受訂量
          FROM mpg_file,oeb_file,mpm_file
         WHERE ( mpm_v = ' ' OR mpm_v IS NULL) 
           AND mpm_d = g_mps[l_i].mpk_d
           AND mpg04 = mpm_act
           AND mpg01 = p_partno
           AND mpg02 = oeb01
           AND mpg03 = oeb03
 
        IF g_mps[l_i].order_qty IS NULL 
           THEN 
           LET g_mps[l_i].order_qty = 0 
        END IF
 
      # 計算ATP = MPS - 受訂
        LET g_mps[l_i].atp = g_mps[l_i].mps_qty - g_mps[l_i].order_qty
 
        IF l_i = 1  # 若為第 1 期則 ATP = MPS - 受訂 + 前期庫存量
           THEN 
           # 期初庫存量
#            SELECT ima262 INTO g_mps[1].invqty #FUN-A20044
#              FROM ima_file
 #            WHERE ima01 = p_partno#FUN-A20044
           CALL s_getstock(p_partno,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
              LET g_mps[1].invqty = l_avl_stk #FUN-A20044
           IF cl_null(g_mps[1].invqty) THEN LET g_mps[1].invqty=0 END IF
           LET g_mps[l_i].atp = g_mps[l_i].atp + g_mps[l_i].invqty
        END IF
 
        #當 ATP <0 時 LET ATP = 0
        IF g_mps[l_i].atp < 0 THEN LET g_mps[l_i].atp = 0 END IF
 
        LET g_mps[31].order_qty=g_mps[31].order_qty+g_mps[l_i].order_qty
        LET g_mps[31].mps_qty =g_mps[31].mps_qty +g_mps[l_i].mps_qty 
 
        # 計算CATP = 前期 CATP + 本期 ATP
        IF l_i > 1 
           THEN
           LET g_mps[l_i].catp = g_mps[l_i-1].catp + g_mps[l_i].atp
           LET g_mps[l_i].seq   = g_mps[l_i-1].seq + 1
        ELSE
           LET g_mps[1].catp = g_mps[1].atp
        END IF
 
        LET l_i = l_i + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
 
    IF l_i > 1 
       THEN
       LET g_mps[31].invqty=g_mps[1].invqty
       LET g_mps[31].catp = g_mps[l_i-1].catp
 
       LET g_mps[l_i].*=g_mps[31].*
       LET g_mps[l_i].mpk_d='合 計'
    END IF
    LET g_rec_b=(l_i-1)
    INITIALIZE g_mps[31] TO NULL    #genero 會多一筆
    DISPLAY g_rec_b TO FORMONLY.cn2
    CALL SET_COUNT(l_i-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION q502_bp(p_ud)
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
 
#      BEFORE ROW
#        LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q502_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q502_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q502_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q502_fetch('N') 
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q502_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
    #@ON ACTION 工廠切換
    # ON ACTION switch_plant                      #FUN-B10030
    #    LET g_action_choice="switch_plant"       #FUN-B10030
    #    EXIT DISPLAY                             #FUN-B10030
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
       #No.MOD-530852  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530852  --end          
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
## 計算可達交日
FUNCTION q502_atpdate()
DEFINE i         LIKE type_file.num5,     #NO.FUN-680101 SMALLINT 
       l_ima139  LIKE ima_file.ima139,
       l_atpdate_1 LIKE type_file.dat,    #NO.FUN-680101 DATE  # 當 CATP 無法滿足訂購量時可先部份交貨之達交日
       l_desc    LIKE type_file.chr1000,  #NO.FUN-680101 VARCHAR(40)
       l_qty     LIKE mps_file.mps041,    #NO.FUN-680101 DEC(15,3)
       l_qty2    LIKE mps_file.mps041     #NO.FUN-680101 DEC(15,3)
 
    LET l_atpdate_1 = ''
 
    # 當該料件為MPS件時
    IF g_ima139 = 'Y' 
       THEN
       LET l_qty = 0
       FOR i = 1 TO 30 
           IF g_mps[i].catp >= h_mps.qty   # 已可以滿足訂購量,Return
              THEN
              LET h_mps.atpdate = g_mps[i].mpk_d
              DISPLAY BY NAME h_mps.atpdate
              RETURN
           END IF
           # 未滿足訂購量的情況下,找出最大可部份達交數量及日期
           IF i>1 
              THEN   
              IF g_mps[i].catp>g_mps[i-1].catp
                 THEN
                 LET l_atpdate_1 = g_mps[i].mpk_d
                 LET l_qty = g_mps[i].catp
              END IF
           ELSE
              IF g_mps[1].catp>0 
                 THEN 
                 LET l_atpdate_1 = g_mps[1].mpk_d 
                 LET l_qty = g_mps[1].catp
              END IF
           END IF
       END FOR
 
       LET h_mps.atpdate = ''
       IF cl_null(l_atpdate_1) THEN 
          DISPLAY '無任何供給數量可供達交' TO FORMONLY.desc
          RETURN
       ELSE
          LET l_desc = '可於 ',l_atpdate_1,' 先行達交 ',l_qty USING "<<<<<<<<.#"
          DISPLAY l_desc TO FORMONLY.desc
       END IF
 
# 當現有 MPS 無法滿足訂購量時,應在依照產品製程所定義的資源項目,並考慮
# 每日的產能往後推算可達交日期
 
       LET l_qty2 = h_mps.qty - l_qty  # 不足數量 = 訂購量 - 部份達交量
       LET h_mps.atpdate=q502_cap(h_mps.partno,l_qty2,l_atpdate_1)
 
       DISPLAY BY NAME h_mps.atpdate
       RETURN
    ELSE          # 主件非 MPS 件時
       # 找最接近主件的下階MPS件所在的Level
       SELECT MIN(level1) INTO g_first_mps_level
         FROM bom_tmp
        WHERE bmb03 <> h_mps.partno
       IF STATUS THEN 
  #    CALL cl_err('sel bom_tmp',STATUS,1) #No.FUN-660108
       CALL cl_err3("sel","bom_tmp",h_mps.partno,"",STATUS,"","sel bom_tmp",1)        #No.FUN-660108
        RETURN END IF
 
       # 找該 level 的 component part 中最大 atp date + 生產至主件的 lead time
       LET h_mps.atpdate = q502_get_max_atpdate(g_first_mps_level)
 
       DISPLAY BY NAME h_mps.atpdate
       RETURN
    END IF 
 
 
END FUNCTION
 
# 抓取該料件下階 BOM 並存入 temp table bom_tmp 及 bom_tmp2 中
FUNCTION q502_get_mps01()
 
   DEFINE l_bmb06    LIKE bmb_file.bmb06
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
 
    CLOSE q502_cs
    DROP TABLE bom_tmp
    DROP TABLE bom_tmp2
    
    CREATE TEMP TABLE bom_tmp(
        level1  LIKE type_file.num5,  
        bmb01   LIKE bmb_file.bmb01,
        bmb03   LIKE bmb_file.bmb03,
        qty     LIKE mps_file.mps041)
    
## FOR 計算 LeadTime 用
    CREATE TEMP TABLE bom_tmp2(
       level1  LIKE type_file.num5,  
        bmb01   LIKE bmb_file.bmb01,
        bmb03   LIKE bmb_file.bmb03,
        qty     LIKE mps_file.mps041)     
        
 
    INSERT INTO bom_tmp VALUES(g_ima16,'@',h_mps.partno,h_mps.qty)
    IF STATUS THEN CALL cl_err('ins bom_tmp',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
 
    INSERT INTO bom_tmp2 VALUES(g_ima16,'@',h_mps.partno,h_mps.qty)
    IF STATUS THEN CALL cl_err('ins bom_tmp2',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
 
    #FUN-550110
    LET l_ima910=''
    SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=h_mps.partno
    IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
    #--
    # 抓取該料件下階 BOM 並存入 temp table bom_tmp 及 bom_tmp2 中
    CALL q502_bom(g_ima16,h_mps.partno,l_ima910,h_mps.qty,g_today)   #FUN-550110   
                                                                      
END FUNCTION                                                          
                                                                      
FUNCTION q502_bom(p_level,p_pn,p_key2,p_qty,p_date) #FUN-550110
   DEFINE p_level     LIKE type_file.num5,     #NO.FUN-680101 SMALLINT 
          p_pn        LIKE oeb_file.oeb04,     #料件編號
          p_key2      LIKE ima_file.ima910,    #FUN-550110
          p_qty       LIKE bmb_file.bmb06,     #NO.FUN-680101 DEC(18,6)
          p_date      LIKE type_file.dat,      #NO.FUN-680101 DATE     
          l_bmb01     LIKE bmb_file.bmb01,
          l_ac,i      LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
          arrno       LIKE type_file.num5,     #NO.FUN-680101 SMALLINT      #BUFFER SIZE (可存筆數)
          sr DYNAMIC ARRAY OF RECORD       #每階存放資料
              bmb03     LIKE bmb_file.bmb03,       #元件料號
              bmb06     LIKE bmb_file.bmb06,       #FUN-560230
              bmb18     LIKE bmb_file.bmb18,       #投料時距
              bmb10_fac LIKE bmb_file.bmb10_fac,   
              bma01     LIKE bma_file.bma01
          END RECORD,
          mpg         RECORD LIKE mpg_file.*,
          l_ima08     LIKE ima_file.ima08,
          l_ima59     LIKE ima_file.ima59,
          l_ima60     LIKE ima_file.ima60,
          l_ima601    LIKE ima_file.ima601,   #No.FUN-840194
          l_ima61     LIKE ima_file.ima61,
          l_ima50     LIKE ima_file.ima50,
          l_ima48     LIKE ima_file.ima48,
          l_ima49     LIKE ima_file.ima49,
          l_ima491    LIKE ima_file.ima491,
          l_leadtime  LIKE ima_file.ima50,
          l_ima133    LIKE ima_file.ima133,
          l_ima139    LIKE ima_file.ima139,
          l_needate   LIKE type_file.dat            #NO.FUN-680101 DATE 
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
    LET p_level = p_level + 1 
    LET arrno = 600
 
    DECLARE mps_bom_c1 CURSOR FOR
          SELECT bmb03,(bmb06/bmb07),bmb18,bmb10_fac,bma01
            FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03=bma_file.bma01 
           WHERE bmb01=p_pn  
             AND bmb29 =p_key2  #FUN-550110
             AND bmb04<=p_date AND (bmb05 IS NULL OR bmb05>p_date) 
 
    LET l_ac = 1
    FOREACH mps_bom_c1 INTO sr[l_ac].*
       IF SQLCA.sqlcode THEN 
          CALL cl_err('fore mps_bom_c1:',STATUS,1) EXIT FOREACH 
       END IF
       LET sr[l_ac].bmb06=sr[l_ac].bmb06*p_qty
       #FUN-8B0035--BEGIN--                                                                                                    
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END-- 
       LET l_ac = l_ac + 1                    # 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore p500_cur:',STATUS,1) END IF
 
    FOR i = 1 TO l_ac-1               # 讀BUFFER傳給REPORT
       message p_level,' ',sr[i].bmb03 clipped
        SELECT ima133,ima139 INTO l_ima133,l_ima139 FROM ima_file 
          WHERE ima01 = sr[i].bmb03
        IF l_ima139 ='Y' THEN 
 
           LET l_leadtime = q502_leadtime(sr[i].bmb03,sr[i].bmb06)
 
           LET l_needate =p_date  -l_ima50	# 減採購/製造前置日數
           INSERT INTO bom_tmp VALUES(p_level,p_pn,sr[i].bmb03,sr[i].bmb06)
          IF STATUS THEN
#          CALL cl_err('ins bom_tmp',STATUS,1)  #No.FUN-660108
           CALL cl_err3("ins","bom_tmp","","",STATUS,"","ins bom_tmp",1)        #No.FUN-660108
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM END IF
        END IF
 
        INSERT INTO bom_tmp2 VALUES(p_level,p_pn,sr[i].bmb03,sr[i].bmb06)
        IF STATUS THEN 
        CALL cl_err('ins bom_tmp',STATUS,1)  #No.FUN-660108
        CALL cl_err3("ins","bom_tmp","","",STATUS,"","ins bom_tmp",1)        #No.FUN-660108
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM END IF
 
        IF sr[i].bma01 IS NOT NULL THEN #若為主件
          #CALL q502_bom(p_level,sr[i].bmb03,' ',sr[i].bmb06,p_date)        #FUN-8B0035
           CALL q502_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06,p_date)#FUN-8B0035
        END IF
    END FOR
END FUNCTION
 
# 找該 level 的 component part 中最大 atp date + 生產至主件的 lead time
FUNCTION q502_get_max_atpdate(p_level)
DEFINE p_level   LIKE type_file.num5     #NO.FUN-680101 SMALLINT 
DEFINE l_bmb03   LIKE bmb_file.bmb03,
       l_qty     LIKE mps_file.mps041,   #NO.FUN-680101 DEC(15,3) 
       l_qty2    LIKE mps_file.mps041,   #NO.FUN-680101 DEC(15,3)
       l_atpdate LIKE type_file.dat,     #NO.FUN-680101 DATE
       l_date    LIKE type_file.dat,     #NO.FUN-680101 DATE
       l_leadtime LIKE ima_file.ima50,
       i         LIKE type_file.num5,    #NO.FUN-680101 SMALLINT
       l_desc    LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(80)
 
    SELECT COUNT(*) INTO g_i
      FROM bom_tmp
     WHERE level1 = p_level
    IF g_i = 0 
       THEN
    #  CALL cl_err('下階MPS件無任何MPS供需彙總資料!','!',0) #TQC-BA0069
       CALL cl_err('','ams-827',0)    #TQC-BA0069
       RETURN ''
    END IF
 
    DECLARE bom_tmp_cur CURSOR FOR SELECT UNIQUE bmb03,qty 
                                     FROM bom_tmp
                                    WHERE level1 = p_level
    IF STATUS THEN CALL cl_err('decl ',STATUS,1) END IF
 
    LET l_atpdate = '1901/01/01'
    LET g_first_mps_partno = ''
    FOREACH bom_tmp_cur INTO l_bmb03,l_qty
 
       CALL q502_b_fill(l_bmb03)
 
       LET l_qty2 = 0  # 未滿足數量
       FOR i = 1 TO 30 
           IF g_mps[i].catp >= l_qty  
              THEN
              IF l_atpdate < g_mps[i].mpk_d
                 THEN
                 LET l_atpdate = g_mps[i].mpk_d
                 LET g_first_mps_partno = l_bmb03
              END IF
              CONTINUE FOREACH
           END IF
       END FOR
 
# 當現有 MPS 無法滿足訂購量時,應在依照產品製程所定義的資源項目,並考慮
# 每日的產能往後推算可達交日期
 
       LET l_qty2 = l_qty - g_mps[i].catp  # 未滿足數量
       LET l_date=q502_cap(l_bmb03,l_qty2,g_mps[1].mpk_d)
       IF l_atpdate < l_date
          THEN
          LET l_atpdate = l_date
          LET g_first_mps_partno = l_bmb03
       END IF
       IF cl_null(g_first_mps_partno) THEN RETURN '' END IF
 
    END FOREACH
 
    # 生產至主件(非MPS part)的 lead time
    LET l_leadtime = q502_not_mps_leadtime(g_first_mps_partno,h_mps.partno)
 
    LET l_desc = '下階MPS件 "',g_first_mps_partno CLIPPED,'" 生產至主件所須的前置時間為 ',l_leadtime
    DISPLAY l_desc TO FORMONLY.desc
    LET l_atpdate = l_atpdate + l_leadtime
 
    RETURN l_atpdate
 
END FUNCTION
 
# 生產某一料件的 lead time
FUNCTION q502_leadtime(p_pn,p_qty)
DEFINE    p_pn        LIKE ima_file.ima01,
          p_qty       LIKE mps_file.mps041,   #NO.FUN-680101 DEC(15,3)
          l_ima08     LIKE ima_file.ima08,
          l_ima59     LIKE ima_file.ima59,
          l_ima60     LIKE ima_file.ima60,
          l_ima601    LIKE ima_file.ima601,   #No.FUN-840194
          l_ima61     LIKE ima_file.ima61,
          l_ima50     LIKE ima_file.ima50,
          l_ima48     LIKE ima_file.ima48,
          l_ima49     LIKE ima_file.ima49,
          l_ima491    LIKE ima_file.ima491,
          l_leadtime  LIKE ima_file.ima50,
          l_ima133    LIKE ima_file.ima133,
          l_ima139    LIKE ima_file.ima139
         #l_ima56     LIKE ima_file.ima56    #CHI-810015 mark #FUN-710073 add
 
    #SELECT ima08,ima59,ima60,ima61,ima50,ima48,ima49,ima491   #No.FUN-840194 #CHI-810015拿掉,ima56 
    SELECT ima08,ima59,ima60,ima601,ima61,ima50,ima48,ima49,ima491 #No.FUN-840194  #CHI-810015拿掉,ima56 
        INTO l_ima08,l_ima59,l_ima60,l_ima601,l_ima61,  #No.FUN-840194 add l_ima601
             l_ima50,l_ima48,l_ima49,l_ima491                 #CHI-810015拿掉,l_ima56 
        FROM ima_file WHERE ima01 = p_pn
      IF cl_null(l_ima59)  THEN LET l_ima59 = 0 END IF
      IF cl_null(l_ima60)  THEN LET l_ima60 = 0 END IF
      IF cl_null(l_ima61)  THEN LET l_ima61 = 0 END IF
      IF cl_null(l_ima50)  THEN LET l_ima50 = 0 END IF
      IF cl_null(l_ima48)  THEN LET l_ima48 = 0 END IF
      IF cl_null(l_ima49)  THEN LET l_ima49 = 0 END IF
      IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
     #IF cl_null(l_ima56)  THEN LET l_ima56 = 0 END IF      #CHI-810015 mark #FUN-710073 add
            
      IF l_ima08='M' THEN
        #FUN-710073---mod---str---
         #LET l_leadtime=l_ima59+l_ima60*p_qty+l_ima61  #No.FUN-840194  #CHI-810015 mark還原       
         LET l_leadtime=l_ima59+l_ima60/l_ima601*p_qty+l_ima61 #No.FUN-840194   #CHI-810015 mark還原       
        #LET l_leadtime=(l_ima59/l_ima56)+               #CHI-810015 mark
        #               (l_ima60/l_ima56)*p_qty+         #CHI-810015 mark
        #               (l_ima61/l_ima56)                #CHI-810015 mark
        #FUN-710073---mod---end---
      ELSE 
         LET l_leadtime=l_ima50+l_ima48+l_ima49+l_ima491
      END IF
    
      RETURN l_leadtime
 
END FUNCTION
 
# 由 p_item1 的 BOM 往回推至生產 p_item2 (非 MPS part)的 leadtime
FUNCTION q502_not_mps_leadtime(p_item1,p_item2)
DEFINE    p_item1  LIKE ima_file.ima01,
          p_item2  LIKE ima_file.ima01,
          l_flag   LIKE type_file.chr1,       #NO.FUN-680101 VARCHAR(1)
          l_leadtime  LIKE ima_file.ima50,
          l_leadtime_tot  LIKE ima_file.ima50,
          l_bmb01     LIKE bmb_file.bmb01,
          l_bmb03     LIKE bmb_file.bmb03,
          l_qty       LIKE mps_file.mps041    #NO.FUN-680101 DEC(15,3)
 
    LET l_flag = 'Y'
    LET l_leadtime_tot = 0   # 
 
    SELECT bmb01 INTO l_bmb01
      FROM bom_tmp2
     WHERE bmb03 = p_item1
 
    LET p_item1 = l_bmb01
 
    WHILE l_flag = 'Y'
        SELECT bmb01,bmb03,qty INTO l_bmb01,l_bmb03,l_qty
          FROM bom_tmp2
         WHERE bmb03 = p_item1
 
        LET l_leadtime = q502_leadtime(l_bmb03,l_qty)
        LET l_leadtime_tot = l_leadtime_tot + l_leadtime
 
        IF l_bmb03 = h_mps.partno
           THEN
           RETURN l_leadtime_tot
        ELSE
           LET p_item1 = l_bmb01
           CONTINUE WHILE
        END IF
 
    END WHILE
 
END FUNCTION
 
# 當現有 MPS 無法滿足訂購量時,應在依照產品製程所定義的資源項目,並考慮
# 每日的產能往後推算可達交日期
FUNCTION q502_cap(p_item,p_qty,p_begindate)  
 DEFINE  p_item       LIKE ima_file.ima01,
         p_qty        LIKE mps_file.mps041,    #NO.FUN-680101 DEC(15,3)
         p_begindate  LIKE type_file.dat,      #NO.FUN-680101 DATE
         l_unuse      LIKE type_file.chr50,    #LIKE cqa_file.cqa05,    #未耗用產能   #TQC-B90211
         l_cqty       LIKE mps_file.mps041,    #NO.FUN-680101 DEC(15,3)
         l_aqty       LIKE mps_file.mps041,    #NO.FUN-680101 DEC(15,3)
         l_i          LIKE type_file.num10,    #NO.FUN-680101 INTEGER 
         l_atpdate    LIKE type_file.dat,      #NO.FUN-680101 DATE
         l_ima94      LIKE ima_file.ima94,
         l_eco        RECORD LIKE eco_file.*,
         l_rqa        RECORD LIKE rqa_file.*,
         l_str        LIKE type_file.chr1000   #NO.FUN-680101 VARCHAR(80)
 
      #-->取料件主檔中的預設製程編號
       SELECT ima94 INTO l_ima94 FROM ima_file
        WHERE ima01=p_item
       IF SQLCA.sqlcode THEN 
       CALL cl_err('fetch ima',STATUS,1)  #No.FUN-660108
       CALL cl_err3("sel","ima_file",p_item,"",STATUS,"","fetch ima",1)        #No.FUN-660108
       RETURN '' END IF
      SELECT COUNT(*) INTO g_i FROM eco_file
        WHERE eco01=p_item
          AND eco02=l_ima94
      IF g_i = 0 
         THEN 
         LET l_str = p_item CLIPPED," 無產品製程資料,無法計算可達交日"
         CALL cl_err(l_str,'!',1)
         RETURN ''
      END IF
      
      #-->取產品製程資源資料
       DECLARE q502_eco_cur CURSOR FOR
       SELECT * FROM eco_file
        WHERE eco01=p_item
          AND eco02=l_ima94
       IF SQLCA.sqlcode THEN
          CALL cl_err('decl eco',STATUS,1)  #No.FUN-660108
          CALL cl_err3("sel","eco_file",p_item,l_ima94,STATUS,"","decl eco",1)        #No.FUN-660108
          RETURN ''
       END IF
 
       LET  l_atpdate = p_begindate
 
      #-->取產品製程資源資料
       FOREACH q502_eco_cur INTO l_eco.* 
          IF SQLCA.sqlcode THEN
             CALL cl_err('fetch eco',STATUS,1) RETURN ''
          END IF
 
          SELECT COUNT(*) INTO g_i FROM rqa_file
           WHERE rqa01 = l_eco.eco04  
             AND rqa02 = g_rqa02
             AND rqa03 > p_begindate
          IF g_i = 0 
             THEN 
             LET l_str = l_eco.eco04 CLIPPED," 找不到符合的每日資源資料,無法計算可達交日"
             CALL cl_err(l_str,'!',1)
             RETURN ''
          END IF
 
          DECLARE q502_rqa_cur CURSOR FOR SELECT * FROM rqa_file
                               WHERE rqa01 = l_eco.eco04  
                                 AND rqa02 = g_rqa02
                                 AND rqa03 > p_begindate
                               ORDER BY rqa03
 
          LET l_cqty = 0
 
          #抓取每日資源
          FOREACH q502_rqa_cur INTO l_rqa.*
          IF SQLCA.sqlcode THEN CALL cl_err('foreach sel_rqa',STATUS,1) END IF
 
          LET l_unuse = l_rqa.rqa05 - l_rqa.rqa06 #未耗產能=當日產能-已秏產能
 
          IF l_unuse = 0 OR l_unuse < l_eco.eco05  #未耗產能<固定秏用
             THEN
             CONTINUE FOREACH
          END IF
 
          # 當期可負荷產量 = (未耗產能-固定秏用)/變動秏用)*秏用批量
          LET l_aqty = ((l_unuse - l_eco.eco05)/l_eco.eco06)*l_eco.eco07
          LET l_i = l_aqty / l_eco.eco07   #
          LET l_aqty = l_i * l_eco.eco07   # 去除批量不足的尾數
          
          IF l_aqty>0 THEN LET l_cqty=l_cqty+l_aqty END IF
 
          IF l_cqty >= p_qty 
             THEN 
             IF l_rqa.rqa04 > l_atpdate
                THEN
                LET l_atpdate = l_rqa.rqa04      #atp date = 截止日期
             END IF
             EXIT FOREACH
          END IF
          END FOREACH 
 
          IF l_cqty < p_qty        # 該資源項目無法負荷p_qty產量
             THEN 
             CALL cl_err('依照每日資源產能推算無法滿足訂購量','!',1)
             RETURN ''
          END IF
 
       END FOREACH 
 
       IF l_atpdate = p_begindate
          THEN
          RETURN ''
       ELSE
          RETURN l_atpdate
       END IF
END FUNCTION 
