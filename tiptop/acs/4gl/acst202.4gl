# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acst202.4gl
# Descriptions...: 料件成本移轉作業
# Date & Author..: 92/01/15 By MAY
# Release 4.0....: 92/07/24 By Jones
# search % to modify
# Modify.........: No.FUN-680071 06/09/08 By chen 類型轉換
# Modify.........: No.FUN-6A0064 06/10/27 By king l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_imb   RECORD LIKE imb_file.*,  # 來源
    l_imb   RECORD
              imb111      LIKE imb_file.imb111,
              imb112      LIKE imb_file.imb112,
              imb1131     LIKE imb_file.imb1131,
              imb1132     LIKE imb_file.imb1132,
              imb114      LIKE imb_file.imb114,
              imb115      LIKE imb_file.imb115,
              imb116      LIKE imb_file.imb116,
              imb1171     LIKE imb_file.imb1171,
              imb1172     LIKE imb_file.imb1172,
              imb119      LIKE imb_file.imb119,
              imb118      LIKE imb_file.imb118,
              imb120      LIKE imb_file.imb120,
              imb121      LIKE imb_file.imb121,
              imb122      LIKE imb_file.imb122,
              imb1231     LIKE imb_file.imb1231,
              imb1232     LIKE imb_file.imb1232,
              imb124      LIKE imb_file.imb124,
              imb125      LIKE imb_file.imb125,
              imb126      LIKE imb_file.imb126,
              imb1271     LIKE imb_file.imb1271,
              imb1272     LIKE imb_file.imb1272,
              imb129      LIKE imb_file.imb129,
              imb130      LIKE imb_file.imb130
              END RECORD ,
    tm        RECORD
              wc          LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(300)
              a           LIKE type_file.chr1,    #No.FUN-680071 VARCHAR(01)
              b           LIKE type_file.chr1     #No.FUN-680071 VARCHAR(01)
              END RECORD,
    g_cmd                 LIKE type_file.chr1000, #No.FUN-680071 VARCHAR(60)
    l_chr                 LIKE type_file.chr8,    #No.FUN-680071 VARCHAR(8)  #No.TQC-6A0079
    p_key                 LIKE type_file.chr1     #No.FUN-680071 VARCHAR(1)
 
DEFINE   g_msg            LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(72)
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0064
   DEFINE p_row,p_col	LIKE type_file.num5    #No.FUN-680071 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
    LET p_row = 5 LET p_col = 13
    OPEN WINDOW acst202_w AT p_row,p_col
        WITH FORM "acs/42f/acst202"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    CALL cl_getmsg('mfg1016',0) RETURNING g_msg
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      MESSAGE g_msg
   ELSE
      DISPLAY g_msg AT 1,1
   END IF
    LET tm.a  = '1'
    LET tm.b  = '1'
    WHILE TRUE
    INITIALIZE g_imb.* TO NULL
    CONSTRUCT BY NAME tm.wc ON ima06,ima01
       ON IDLE g_idle_seconds
   ON ACTION locale
    CALL cl_dynamic_locale()
    CALL cl_show_fld_cont()   #FUN-550037(smin)
 
 
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          EXIT CONSTRUCT
 
    END CONSTRUCT
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW t202_w
       EXIT PROGRAM
    END IF
    INPUT BY NAME tm.a,tm.b WITHOUT DEFAULTS
   ON ACTION locale
    CALL cl_dynamic_locale()
    CALL cl_show_fld_cont()   #FUN-550037(smin)
 
 
 
          AFTER FIELD a
              IF tm.a IS NOT NULL THEN
                 CALL clsname(tm.a) RETURNING l_chr
                 DISPLAY l_chr TO FORMONLY.d01
              END IF
 
          AFTER FIELD b
              IF tm.b IS NOT NULL THEN
                 CALL clsname(tm.b) RETURNING l_chr
                 DISPLAY l_chr TO FORMONLY.d02
              END IF
              IF tm.a = tm.b THEN
                 CALL cl_err('','mfg6002',0)
                 NEXT FIELD a
              END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
    CALL acst202_cs()
    IF INT_FLAG THEN EXIT WHILE END IF
   END WHILE
    CLOSE WINDOW acst202_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0064
END MAIN
 
FUNCTION acst202_cs()
DEFINE   l_sql    LIKE type_file.chr1000 #No.FUN-680071 VARCHAR(300)
      IF cl_sure(18,18) THEN
         LET l_sql = " SELECT imb_file.* FROM imb_file,ima_file ",
                     " WHERE  imb01 = ima01 AND  ",tm.wc CLIPPED,
                     " AND imbacti = 'Y'"
         PREPARE acst202_prepare FROM l_sql
         DECLARE acst202_cs  CURSOR FOR
                 acst202_prepare
         FOREACH acst202_cs INTO g_imb.*
          IF tm.a = '1' THEN
             LET l_imb.imb111 = g_imb.imb111
             LET l_imb.imb112 = g_imb.imb112
             LET l_imb.imb1131= g_imb.imb1131
             LET l_imb.imb1132= g_imb.imb1132
             LET l_imb.imb114 = g_imb.imb114
             LET l_imb.imb115 = g_imb.imb115
             LET l_imb.imb116 = g_imb.imb116
             LET l_imb.imb1171= g_imb.imb1171
             LET l_imb.imb1172= g_imb.imb1172
             LET l_imb.imb119 = g_imb.imb119
             LET l_imb.imb118 = g_imb.imb118
             LET l_imb.imb120 = g_imb.imb120
             LET l_imb.imb121 = g_imb.imb121
             LET l_imb.imb122 = g_imb.imb122
             LET l_imb.imb1231= g_imb.imb1231
             LET l_imb.imb1232= g_imb.imb1232
             LET l_imb.imb124 = g_imb.imb124
             LET l_imb.imb125 = g_imb.imb125
             LET l_imb.imb126 = g_imb.imb126
             LET l_imb.imb1271= g_imb.imb1271
             LET l_imb.imb1272= g_imb.imb1272
             LET l_imb.imb129 = g_imb.imb129
             LET l_imb.imb130 = g_imb.imb130
           END IF
          IF tm.a = '2' THEN
             LET l_imb.imb111 = g_imb.imb211
             LET l_imb.imb112 = g_imb.imb212
             LET l_imb.imb1131= g_imb.imb2131
             LET l_imb.imb1132= g_imb.imb2132
             LET l_imb.imb114 = g_imb.imb214
             LET l_imb.imb115 = g_imb.imb215
             LET l_imb.imb116 = g_imb.imb216
             LET l_imb.imb1171= g_imb.imb2171
             LET l_imb.imb1172= g_imb.imb2172
             LET l_imb.imb119 = g_imb.imb219
             LET l_imb.imb118 = g_imb.imb218
             LET l_imb.imb120 = g_imb.imb220
             LET l_imb.imb121 = g_imb.imb221
             LET l_imb.imb122 = g_imb.imb222
             LET l_imb.imb1231= g_imb.imb2231
             LET l_imb.imb1232= g_imb.imb2232
             LET l_imb.imb124 = g_imb.imb224
             LET l_imb.imb125 = g_imb.imb225
             LET l_imb.imb126 = g_imb.imb226
             LET l_imb.imb1271= g_imb.imb2271
             LET l_imb.imb1272= g_imb.imb2272
             LET l_imb.imb129 = g_imb.imb229
             LET l_imb.imb130 = g_imb.imb230
           END IF
          IF tm.a = '3' THEN
             LET l_imb.imb111 = g_imb.imb311
             LET l_imb.imb112 = g_imb.imb312
             LET l_imb.imb1131= g_imb.imb3131
             LET l_imb.imb1132= g_imb.imb3132
             LET l_imb.imb114 = g_imb.imb314
             LET l_imb.imb115 = g_imb.imb315
             LET l_imb.imb116 = g_imb.imb316
             LET l_imb.imb1171= g_imb.imb3171
             LET l_imb.imb1172= g_imb.imb3172
             LET l_imb.imb119 = g_imb.imb319
             LET l_imb.imb118 = g_imb.imb318
             LET l_imb.imb120 = g_imb.imb320
             LET l_imb.imb121 = g_imb.imb321
             LET l_imb.imb122 = g_imb.imb322
             LET l_imb.imb1231= g_imb.imb3231
             LET l_imb.imb1232= g_imb.imb3232
             LET l_imb.imb124 = g_imb.imb324
             LET l_imb.imb125 = g_imb.imb325
             LET l_imb.imb126 = g_imb.imb326
             LET l_imb.imb1271= g_imb.imb3271
             LET l_imb.imb1272= g_imb.imb3272
             LET l_imb.imb129 = g_imb.imb329
             LET l_imb.imb130 = g_imb.imb330
           END IF
           CALL acst202_u()
 
      END FOREACH
     END IF
END FUNCTION
 
FUNCTION acst202_u()
         IF tm.b =  '1' THEN
           UPDATE imb_file SET
              imb111=l_imb.imb111,
              imb112=l_imb.imb112,
              imb1131=l_imb.imb1131,
              imb1132=l_imb.imb1132,
              imb114 =l_imb.imb114,
              imb115 =l_imb.imb115,
              imb116 =l_imb.imb116,
              imb1171=l_imb.imb1171,
              imb1172=l_imb.imb1172,
              imb119 =l_imb.imb119,
              imb118 =l_imb.imb118,
              imb120 =l_imb.imb120,
              imb121 =l_imb.imb121,
              imb122 =l_imb.imb122,
              imb1231=l_imb.imb1231,
              imb1232=l_imb.imb1232,
              imb124 =l_imb.imb124,
              imb125 =l_imb.imb125,
              imb126 =l_imb.imb126,
              imb1271=l_imb.imb1271,
              imb1272=l_imb.imb1272,
              imb129 =l_imb.imb129,
              imb130 =l_imb.imb130
           WHERE imb01  = g_imb.imb01
         END IF
         IF tm.b =  '2' THEN
           UPDATE imb_file SET
              imb211=l_imb.imb111,
              imb212=l_imb.imb112,
              imb2131=l_imb.imb1131,
              imb2132=l_imb.imb1132,
              imb214 =l_imb.imb114,
              imb215 =l_imb.imb115,
              imb216 =l_imb.imb116,
              imb2171=l_imb.imb1171,
              imb2172=l_imb.imb1172,
              imb219 =l_imb.imb119,
              imb218 =l_imb.imb118,
              imb220 =l_imb.imb120,
              imb221 =l_imb.imb121,
              imb222 =l_imb.imb122,
              imb2231=l_imb.imb1231,
              imb2232=l_imb.imb1232,
              imb224 =l_imb.imb124,
              imb225 =l_imb.imb125,
              imb226 =l_imb.imb126,
              imb2271=l_imb.imb1271,
              imb2272=l_imb.imb1272,
              imb229 =l_imb.imb129,
              imb230 =l_imb.imb130
           WHERE imb01  = g_imb.imb01
         END IF
         IF tm.b =  '3' THEN
           UPDATE imb_file SET
              imb311=l_imb.imb111,
              imb312=l_imb.imb112,
              imb3131=l_imb.imb1131,
              imb3132=l_imb.imb1132,
              imb314 =l_imb.imb114,
              imb315 =l_imb.imb115,
              imb316 =l_imb.imb116,
              imb3171=l_imb.imb1171,
              imb3172=l_imb.imb1172,
              imb319 =l_imb.imb119,
              imb318 =l_imb.imb118,
              imb320 =l_imb.imb120,
              imb321 =l_imb.imb121,
              imb322 =l_imb.imb122,
              imb3231=l_imb.imb1231,
              imb3232=l_imb.imb1232,
              imb324 =l_imb.imb124,
              imb325 =l_imb.imb125,
              imb326 =l_imb.imb126,
              imb3271=l_imb.imb1271,
              imb3272=l_imb.imb1272,
              imb329 =l_imb.imb129,
              imb330 =l_imb.imb130
           WHERE imb01  = g_imb.imb01
        END IF
{
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_imb.imb01,'mfg    ',0)
       END IF
}
END FUNCTION
FUNCTION clsname(p_key)
DEFINE   l_str   LIKE ze_file.ze03,      #No.FUN-680071 VARCHAR(08),
         p_key   LIKE type_file.chr1     #No.FUN-680071 VARCHAR(01)
    CASE p_key
         WHEN '1'  CALL cl_getmsg('mfg1315',g_lang) RETURNING l_str
         WHEN '2'  CALL cl_getmsg('mfg1316',g_lang) RETURNING l_str
         WHEN '3'  CALL cl_getmsg('mfg1317',g_lang) RETURNING l_str
         OTHERWISE EXIT CASE
    END CASE
    RETURN l_str
END FUNCTION
#Patch....NO.TQC-610035 <001> #
