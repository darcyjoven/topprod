/*
================================================================================
檔案代號:lma_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lma_file
(
lma01       varchar2(10) DEFAULT ' ' NOT NULL, /*No Use*/
lma02       varchar2(60),            /*No Use                                 */
lma03       varchar2(60),            /*No Use                                 */
lma04       varchar2(10),            /*No Use                                 */
lma05       varchar2(100),           /*No Use                                 */
lma06       varchar2(30),            /*No Use                                 */
lma060      varchar2(60),            /*No Use                                 */
lma061      varchar2(30),            /*No Use                                 */
lma062      varchar2(30),            /*No Use                                 */
lma063      varchar2(30),            /*No Use                                 */
lma07       number(20,2),            /*No Use                                 */
lma09       varchar2(5),             /*No Use                                 */
lma10       varchar2(10),            /*No Use                                 */
lma11       varchar2(30),            /*No Use                                 */
lma12       varchar2(30),            /*No Use                                 */
lma121      varchar2(30),            /*No Use                                 */
lma122      varchar2(60),            /*No Use                                 */
lma13       varchar2(10),            /*No Use                                 */
lma14       varchar2(30),            /*No Use                                 */
lma15       varchar2(30),            /*No Use                                 */
lma151      varchar2(30),            /*No Use                                 */
lma152      varchar2(60),            /*No Use                                 */
lma16       varchar2(10),            /*No Use                                 */
lma17       varchar2(30),            /*No Use                                 */
lma18       varchar2(30),            /*No Use                                 */
lma181      varchar2(30),            /*No Use                                 */
lma182      varchar2(60),            /*No Use                                 */
lma19       varchar2(10),            /*No Use                                 */
lma20       varchar2(30),            /*No Use                                 */
lma21       varchar2(30),            /*No Use                                 */
lma211      varchar2(30),            /*No Use                                 */
lma212      varchar2(60),            /*No Use                                 */
lma22       varchar2(11),            /*No Use                                 */
lma23       varchar2(30),            /*No Use                                 */
lma24       varchar2(80),            /*No Use                                 */
lma25       varchar2(1),             /*No Use                                 */
lma26       varchar2(10),            /*No Use                                 */
lma27       date,                    /*No Use                                 */
lma28       varchar2(100),           /*No Use                                 */
lma29       varchar2(1),             /*No Use                                 */
lma30       varchar2(80),            /*No Use                                 */
lma31       varchar2(10),            /*No Use                                 */
lma32       varchar2(10),            /*No Use                                 */
lma33       varchar2(10),            /*No Use                                 */
lma34       varchar2(80),            /*No Use                                 */
lma35       varchar2(20),            /*No Use                                 */
lma36       varchar2(60),            /*No Use                                 */
lma37       varchar2(100),           /*No Use                                 */
lma38       varchar2(30),            /*No Use                                 */
lma380      varchar2(60),            /*No Use                                 */
lma381      varchar2(30),            /*No Use                                 */
lma382      varchar2(30),            /*No Use                                 */
lma383      varchar2(30),            /*No Use                                 */
lma39       varchar2(11),            /*No Use                                 */
lma40       varchar2(30),            /*No Use                                 */
lma41       varchar2(80),            /*No Use                                 */
lma42       varchar2(100),           /*No Use                                 */
lmaacti     varchar2(1),             /*No Use                                 */
lmacrat     date,                    /*No Use                                 */
lmadate     date,                    /*No Use                                 */
lmagrup     varchar2(10),            /*No Use                                 */
lmamodu     varchar2(10),            /*No Use                                 */
lmauser     varchar2(10),            /*No Use                                 */
lma08       number(20,2),            /*No Use                                 */
lmaoriu     varchar2(10),            /*No Use                                 */
lmaorig     varchar2(10)             /*No Use                                 */
);

alter table lma_file add  constraint lma_pk primary key  (lma01) enable validate;
grant select on lma_file to tiptopgp;
grant update on lma_file to tiptopgp;
grant delete on lma_file to tiptopgp;
grant insert on lma_file to tiptopgp;
grant index on lma_file to public;
grant select on lma_file to ods;
