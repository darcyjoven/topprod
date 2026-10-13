/*
================================================================================
檔案代號:icj_file
檔案名稱:ICD料件ASS资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icj_file
(
icj01       varchar2(40) NOT NULL,   /*主件料件编号                           */
icj02       varchar2(40) NOT NULL,   /*产品型号(part_no)                      */
icj03       varchar2(10) NOT NULL,   /*Vendor                                 */
icj04       varchar2(6),             /*Pkg Type                               */
icj05       varchar2(10),            /*Pin Count                              */
icj06       varchar2(20),            /*B/d No                                 */
icj07       varchar2(10),            /*B/d Ver                                */
icj08       varchar2(4),             /*B/d Dirgram                            */
icj09       varchar2(80),            /*Leadframe                              */
icj10       varchar2(80),            /*Epoxy                                  */
icj11       varchar2(80),            /*金线(gold wire)                        */
icj12       varchar2(80),            /*Compound                               */
icj13       varchar2(80),            /*Soldering                              */
icj14       varchar2(10),            /*Eqa Test Program                       */
icj15       varchar2(4),             /*Outline Dimension                      */
icj16       varchar2(10),            /*Ink Material 理由码                    */
icj17       varchar2(4),             /*Green                                  */
icj18       number(15,6),            /*Holding Yield (%)                      */
icj19       varchar2(1),             /*no use                                 */
icj20       varchar2(1),             /*no use                                 */
icjacti     varchar2(1),             /*资料有效码                             */
icjdate     date,                    /*最近更改日                             */
icjgrup     varchar2(10),            /*资料所有群                             */
icjmodu     varchar2(10),            /*资料更改者                             */
icjuser     varchar2(10),            /*资料所有者                             */
icjorig     varchar2(10),            /*资料建立部门                           */
icjoriu     varchar2(10)             /*资料建立者                             */
);

alter table icj_file add  constraint icj_pk primary key  (icj01,icj02,icj03) enable validate;
grant select on icj_file to tiptopgp;
grant update on icj_file to tiptopgp;
grant delete on icj_file to tiptopgp;
grant insert on icj_file to tiptopgp;
grant index on icj_file to public;
grant select on icj_file to ods;
