/*
================================================================================
檔案代號:tc_bmj_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tc_bmj_file
(
tc_bmj01    varchar2(20) NOT NULL,   /*良率单号                               */
tc_bmj02    number(5) NOT NULL,      /*项次                                   */
tc_bmj03    varchar2(40),            /*料件编号                               */
tc_bmj031   varchar2(120),           /*品名                                   */
tc_bmj032   varchar2(120),           /*规格                                   */
tc_bmj04    varchar2(40),            /*主件料号                               */
tc_bmj05    varchar2(4),
tc_bmj06    number(20,6),            /*原良率                                 */
tc_bmj07    number(20,6),            /*新良率                                 */
tc_bmj08    date,                    /*原核准日                               */
tc_bmj09    date,                    /*新核准日                               */
tc_bmj10    varchar2(6) NOT NULL,    /*作业编号                               */
tc_bmj06t   number(20,6),
tc_bmj07t   number(20,6),
tc_bmj11    varchar2(10),
tc_bmj12    varchar2(1) NOT NULL,
tc_bmj13    varchar2(10) NOT NULL,
tc_bmjplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_bmjlegal varchar2(10) NOT NULL,   /*所属法人                               */
tc_bmj14    varchar2(500),
tc_bmjicd14 varchar2(1)
);

grant select on tc_bmj_file to tiptopgp;
grant update on tc_bmj_file to tiptopgp;
grant delete on tc_bmj_file to tiptopgp;
grant insert on tc_bmj_file to tiptopgp;
grant index on tc_bmj_file to public;
grant select on tc_bmj_file to ods;
