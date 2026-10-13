/*
================================================================================
檔案代號:tc_pmj_file
檔案名稱:採購核價單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_pmj_file
(
tc_pmj01    varchar2(20) NOT NULL,   /*核價單號                               */
tc_pmj02    number(5) NOT NULL,      /*項次                                   */
tc_pmj03    varchar2(40),            /*料件編號                               */
tc_pmj031   varchar2(120),           /*品名                                   */
                                     /*品名  00/04/06 add                     */
tc_pmj032   varchar2(120),           /*規格                                   */
tc_pmj04    varchar2(40),            /*廠商料件                               */
tc_pmj05    varchar2(4),             /*幣別                                   */
tc_pmj06    number(20,6),            /*原未稅單價                             */
tc_pmj07    number(20,6),            /*新未稅單價                             */
tc_pmj08    date,                    /*原核准日                               */
tc_pmj09    date,                    /*新核准日                               */
tc_pmj10    varchar2(6) NOT NULL,    /*作業編號                               */
tc_pmj06t   number(20,6),            /*成品良率                               */
tc_pmj07t   number(20,6),            /*新含稅單價                             */
tc_pmj11    varchar2(10),            /*良率类型                               */
tc_pmj12    varchar2(1) NOT NULL,    /*價格型態                               */
                                     /*1.採購  2. 委外                        */
tc_pmj13    varchar2(10) NOT NULL,   /*製程單元編號,為空代表此筆資            */
tc_pmjplant varchar2(10) NOT NULL,   /*所屬營運中心                           */
tc_pmjlegal varchar2(10) NOT NULL,   /*所屬法人                               */
tc_pmj14    varchar2(15),            /*電子採購序號                           */
tc_pmjicd14 varchar2(1),             /*等級                                   */
tc_pmj16    number(20,6),            /*受镀面积                               */
tc_pmj17    number(20,6),            /*金厚                                   */
tc_pmj18    number(20,6),            /*镍厚                                   */
tc_pmj19    number(20,6),            /*钯厚                                   */
tc_pmj20    number(20,6),            /*线速                                   */
tc_pmj15    varchar2(20),            /*尺寸                                   */
tc_pmj21    number(20,6)             /*铜厚                                   */
);

alter table tc_pmj_file add  constraint tpc_pmj_pk primary key  (tc_pmj01,tc_pmj02,tc_pmj10,tc_pmj12,tc_pmj13) enable validate;
grant select on tc_pmj_file to tiptopgp;
grant update on tc_pmj_file to tiptopgp;
grant delete on tc_pmj_file to tiptopgp;
grant insert on tc_pmj_file to tiptopgp;
grant index on tc_pmj_file to public;
grant select on tc_pmj_file to ods;
