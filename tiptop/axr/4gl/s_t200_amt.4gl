# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-540057 05/05/10 By wujie 發票號碼調整 
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.MOD-5C0156 05/12/30 By Smapmin RETURN二個參數
# Modify.........: No.FUN-610020 06/01/18 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0042 06/12/19 By Smapmin 增加押匯資料查詢
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/07/06 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.MOD-C20215 12/03/02 By Polly 出貨含稅金額增加取位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_t200_amt(p_no,p_type)                        #可用餘額查詢
    DEFINE  l_sql   LIKE type_file.chr1000,             #No.FUN-680123 VARCHAR(300)
            p_row,p_col LIKE type_file.num5,            #No.FUN-680123 SMALLINT
            p_no    LIKE ola_file.ola04,
            p_type  LIKE type_file.chr1,                #No.FUN-680123 VARCHAR(01)
            l_oga   DYNAMIC ARRAY OF RECORD
	            pdate   LIKE type_file.dat,         #No.FUN-680123 DATE
   	            ptype   LIKE ze_file.ze03,         #No.FUN-680123 VARCHAR(10)
     	            amt     LIKE oga_file.oga50,
       	            net_amt LIKE oga_file.oga50
	            END RECORD,
            ls_tmp          STRING,
            l_oga23         LIKE oga_file.oga23,         #出貨通知單幣別
            l_olc12         LIKE olc_file.olc12,
            g_ola           RECORD LIKE ola_file.*,
            s_rate          LIKE oga_file.oga24,         #No:7952
            g_rate,m_rate   LIKE oga_file.oga24 ,        #No:7952
            l_ole02         LIKE ole_file.ole02,
            l_zero,l_sort   LIKE type_file.num5,         #No.FUN-680123 SMALLINT
#No.FUN540057--begin
     	    l_no            LIKE oea_file.oea01,         #No.FUN-680123 VARCHAR(16)
#No.FUN540057--end  
	    l_order         LIKE type_file.chr1,         # Prog. Version..: '5.30.06-13.03.12(01)  #判斷可用餘額是否已扣除出貨金額
            l_olc10         LIKE olc_file.olc10,
	    l_n,l_ac,l_sl   LIKE type_file.num5          #No.FUN-680123 SMALLINT
    DEFINE  t_azi04         LIKE azi_file.azi04          #MOD-C20215 add
    DEFINE  t_azi042        LIKE azi_file.azi04          #MOD-C20215 add 
 
   WHENEVER ERROR CONTINUE
   #IF cl_null(p_no) THEN RETURN END IF   #MOD-5C0156
   #-----FUN-6C0042---------
   #IF cl_null(p_no) THEN RETURN l_order,0 END IF   #MOD-5C0156
   IF p_type = 'y' THEN
      IF cl_null(p_no) THEN RETURN END IF
   ELSE
      IF cl_null(p_no) THEN RETURN l_order,0 END IF
   END IF
   #-----END FUN-6C0042-----
 
   SELECT * INTO g_ola.* FROM ola_file WHERE ola04=p_no
   LET l_order = 'N'
   CALL s_curr3(g_aza.aza17,g_today,g_ooz.ooz17) RETURNING g_rate #取得本幣匯率
   CALL s_curr3(g_ola.ola06,g_ola.ola02,g_ooz.ooz17) RETURNING m_rate #取得L/C幣別匯率
      #No.FUN-680123
   DROP TABLE x
   CREATE TEMP TABLE x
         (pdate LIKE type_file.dat,   
   	  ptype LIKE ze_file.ze03,
     	  amt LIKE type_file.num20_6,
       	  net_amt LIKE type_file.num20_6,
          oga23 LIKE oga_file.oga23,
          pno LIKE oea_file.oea01,
          zero LIKE type_file.num5)
      #No.FUN-550071  #No.FUN-680123 end
   
   INSERT INTO x
   SELECT ole09,'1',ole07,0,ola06,ole01,1
     FROM ole_file,ola_file
    WHERE ole01 = ola01 AND oleconf = 'Y' AND ola04 = p_no
      AND ole02 = 0 AND olaconf = 'Y' AND ola40 = 'N'
   IF STATUS THEN 
#     CALL cl_err('INTO #2',STATUS,1)   #No.FUN-660116
      CALL cl_err3("ins","x",p_no,"",STATUS,"","INTO #2",1)    #No.FUN-660116
   END IF
 
#FUN-A60056--mod--str--
#  INSERT INTO x
#  SELECT oga02,'2',oga50*(1+oga211/100)*-1,0,oga23,oga01,-1
#    FROM oga_file
#   WHERE oga908 = p_no AND oga09 IN ('2','8')
#     AND oga65='N'     #No.FUN-610020
#     AND ogaconf = 'Y' 
   LET l_sql = " INSERT INTO x ",
               " SELECT oga02,'2',oga50*(1+oga211/100)*-1,0,oga23,oga01,-1",
               "   FROM ",cl_get_target_table(g_plant,'oga_file'),
               " WHERE oga908 = '",p_no,"' AND oga09 IN ('2','8')",
               "   AND oga65='N' AND ogaconf = 'Y' " 
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql
   PREPARE ins_x_pre FROM l_sql
   EXECUTE ins_x_pre
#FUN-A60056--mod--end
   IF STATUS THEN 
#     CALL cl_err('INTO #1',STATUS,1)   #No.FUN-660116
      CALL cl_err3("ins","x",p_no,"",STATUS,"","INTO #1",1)    #No.FUN-660116
   END IF
 
   INSERT INTO x
   SELECT ole09,'3',ole10,0,ola06,ole01,1
     FROM ole_file,ola_file
    WHERE ole01 = ola01 AND oleconf = 'Y' AND ola04 = p_no
      AND ole02 != 0 AND olaconf = 'Y' AND ola40 = 'N'
   IF STATUS THEN 
#     CALL cl_err('INTO #3',STATUS,1)   #No.FUN-660116
      CALL cl_err3("ins","x",p_no,"",STATUS,"","INTO #3",1)    #No.FUN-660116
   END IF
 
   #-----FUN-6C0042---------
   INSERT INTO x
   SELECT olc12,'4',olc11,0,ola06,olc29,1
     FROM olc_file,ola_file
    WHERE olc29 = ola01 AND olcconf = 'Y' AND ola04 = p_no
      AND olaconf = 'Y' AND ola40 = 'N'
   IF STATUS THEN
      CALL cl_err3("ins","x",p_no,"",STATUS,"","INTO #4",1)
   END IF
   #-----END FUN-6C0042-----
 
   DECLARE oga_curs2 CURSOR FOR SELECT * FROM x ORDER BY pdate
 
   IF STATUS THEN
      CALL cl_err('oga_curs2',STATUS,1) 
      #RETURN   #MOD-5C0156
      #-----FUN-6C0042---------
      #RETURN l_order,0   #MOD-5C0156
      IF p_type = 'y' THEN
         RETURN
      ELSE
         RETURN l_order,0
      END IF
      #-----END FUN-6C0042-----
   END IF
 
   IF p_type = 'y' THEN
      LET p_row = 5 LET p_col = 5
      OPEN WINDOW t2002_w AT p_row,p_col WITH FORM "axr/42f/axrt2002" 
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axrt2002")
 
      CALL cl_opmsg('w')
   END IF
   CALL l_oga.clear()
 
   LET l_ac = 1
   FOREACH oga_curs2 INTO l_oga[l_ac].*,l_oga23,l_no,l_zero
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach #2:',SQLCA.sqlcode,1) EXIT FOREACH 
      END IF
      IF l_oga[l_ac].ptype = '1' THEN       #收狀
         CALL cl_getmsg('axr-317',g_lang) RETURNING l_oga[l_ac].ptype
      END IF
      IF l_oga[l_ac].ptype = '2' THEN       #出貨
         LET l_order = 'Y'
         SELECT olc10,olc12 INTO l_olc10,l_olc12 FROM olc_file
          WHERE olc01 = l_no AND olcconf='Y'
         IF STATUS THEN 
            CALL cl_getmsg('axr-318',g_lang) RETURNING l_oga[l_ac].ptype
         ELSE
            CALL cl_getmsg('axr-319',g_lang) RETURNING l_oga[l_ac].ptype
            LET l_oga[l_ac].pdate = l_olc12
            LET l_oga[l_ac].amt = l_oga[l_ac].amt + (l_olc10 * -1 )
         END IF
      END IF
      IF l_oga[l_ac].ptype = '3' THEN       #Amend
         LET l_oga[l_ac].ptype = 'Amend'
      END IF
      #-----FUN-6C0042---------
      IF l_oga[l_ac].ptype = '4' THEN       #押匯
         CALL cl_getmsg('axr-052',g_lang) RETURNING l_oga[l_ac].ptype
         LET l_oga[l_ac].amt = l_oga[l_ac].amt * -1
      END IF
      #-----END FUN-6C0042-----
      #----------------------------MOD-C20215----------------------------start
       SELECT azi04 INTO t_azi04 FROM azi_file
        WHERE azi01 = l_oga23
       SELECT azi04 INTO t_azi042 FROM azi_file
        WHERE azi01 = g_ola.ola06
       CALL cl_digcut(l_oga[l_ac].amt,t_azi04) RETURNING l_oga[l_ac].amt
      #----------------------------MOD-C20215-----------------------------end
      #若出貨單幣別不等於信用狀幣別,先將金額轉成本幣,再轉成信用狀幣別
      IF l_oga23 != g_ola.ola06 THEN      
         #-----97/08/27 modify
         CALL s_curr3(l_oga23,l_oga[l_ac].pdate,g_ooz.ooz17)
               RETURNING s_rate #取得出貨幣別匯率
        #LET l_oga[l_ac].amt = l_oga[l_ac].amt * g_rate 
         LET l_oga[l_ac].amt = l_oga[l_ac].amt * s_rate 
         LET l_oga[l_ac].amt = l_oga[l_ac].amt / m_rate
         CALL cl_digcut(l_oga[l_ac].amt,t_azi042) RETURNING l_oga[l_ac].amt    #MOD-C20215 add
      END IF
      IF l_ac = 1 THEN 
         LET l_oga[l_ac].net_amt = l_oga[l_ac].amt
      ELSE
         LET l_oga[l_ac].net_amt = l_oga[l_ac-1].net_amt + 
                                   l_oga[l_ac].amt
      END IF
      LET l_ac = l_ac + 1
      # TQC-630105----------start add by Joe
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      # TQC-630105----------end add by Joe
   END FOREACH 
   CALL l_oga.deleteElement(l_ac)
   LET l_ac=l_ac-1
 
   IF p_type = 'y' THEN
      DISPLAY ARRAY l_oga TO s_oga.* ATTRIBUTE(COUNT=l_ac)
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      END DISPLAY
      IF INT_FLAG THEN CLOSE WINDOW t2002_w LET INT_FLAG = 0 RETURN END IF   #MOD-5C0156   #FUN-6C0042 取消mark
      #IF INT_FLAG THEN CLOSE WINDOW t2002_w LET INT_FLAG = 0 RETURN l_order,0 END IF   #MOD-5C0156   #FUN-6C0042 mark
      CLOSE WINDOW t2002_w
   ELSE
      DISPLAY "STATUS3",status
      IF l_ac=0 THEN
         RETURN l_order,0
      ELSE
         IF cl_null(l_oga[l_ac].net_amt) THEN LET l_oga[l_ac].net_amt=0 END IF
         RETURN l_order,l_oga[l_ac].net_amt    
      END IF
   END IF
END FUNCTION
