/*
================================================================================
檔案代號:agd_file
檔案名稱:属性适用值资料主档
檔案目的:记录多属性料件机制中定义的属性可选用值的资料
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table agd_file
(
agd01       varchar2(10) NOT NULL,   /*属性代码                               */
agd02       varchar2(20) NOT NULL,   /*属性值                                 */
agd03       varchar2(80) NOT NULL,   /*描述说明                               */
agd04       number(5)                /*顺序                                   */
);

alter table agd_file add  constraint agd_pk primary key  (agd01,agd02) enable validate;
grant select on agd_file to tiptopgp;
grant update on agd_file to tiptopgp;
grant delete on agd_file to tiptopgp;
grant insert on agd_file to tiptopgp;
grant index on agd_file to public;
grant select on agd_file to ods;
