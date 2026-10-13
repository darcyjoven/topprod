/*
================================================================================
檔案代號:type_file
檔案名稱:字段类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table type_file
(
chr1000     varchar2(1000),          /*l_wc, l_buf, l_cmd                     */
chr1        varchar2(1),             /*l_flag, l_choice, g_char               */
num5        number(5),               /*l_i, l_j, l_ac, g_rec_b                */
num20_6     number(20,6),            /*tot, amt                               */
dat         date,                    /*b_date, e_date                         */
chr18       varchar2(18),            /*rowid                                  */
num10       number(10),              /*g_jump                                 */
chr8        varchar2(8),             /*l_time                                 */
chr20       varchar2(20),            /*l_name                                 */
chr21       varchar2(21),            /*l_dbs, g_dbs                           */
num20       number(20),              /*l_btime, l_etime                       */
chr3        varchar2(3),             /*ps_sys 模组名称                        */
num26_10    number(26,10),           /*p_value                                */
chr2        varchar2(2),             /*跳页控制项,排序顺序,etc                */
chr4        varchar2(4),             /*跳页控制项,排序顺序,etc                */
chr5        varchar2(5),             /*跳页控制项,排序顺序,etc                */
chr6        varchar2(6),             /*print,etc                              */
chr50       varchar2(50),            /*print,etc                              */
chr37       varchar2(37),            /*l_str(cl_numfor)                       */
chr9        varchar2(9),             /*chr9                                   */
chr12       varchar2(12),            /*chr12                                  */
chr30       varchar2(30),            /*chr30                                  */
chr14       varchar2(14),            /*chr14                                  */
chr7        varchar2(7),             /*chr7                                   */
chr10       varchar2(10),            /*g_program,l_desc,l_str,l_prog,pmn16,l_pm*/
chr100      varchar2(100),           /*信息/g_msg/l_cmd/p_cron                */
chr200      varchar2(200),           /*p_wc/p_wc2/l_wc/l_wc2/g_msg/p_cron     */
chr300      varchar2(300),           /*p_wc/g_sql/讯息/备注/p_cron            */
chr500      varchar2(500),           /*l_sql/l_cmd/p_cron                     */
blob        blob,                    /*CR报表签核的签名文件                   */
num15_3     number(15,3),            /*num(15,3)                              */
row_id      varchar2(18)             /*row_id                                 */
);

grant select on type_file to tiptopgp;
grant update on type_file to tiptopgp;
grant delete on type_file to tiptopgp;
grant insert on type_file to tiptopgp;
grant index on type_file to public;
grant select on type_file to ods;
