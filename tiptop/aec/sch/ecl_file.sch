/*
================================================================================
檔案代號:ecl_file
檔案名稱:工作站投入/产出档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecl_file
(
ecl01       varchar2(10) NOT NULL,   /*工作站编号                             */
                                     /*Workstation No.Work Site# , Maybe Manufacture Work Center/Workshop/Work Site*/
ecl02       number(5) NOT NULL,      /*年                                     */
ecl03       number(5) NOT NULL,      /*月                                     */
ecl04       varchar2(10),            /*工作站所属部门                         */
ecl05       number(5),               /*周数                                   */
ecl06       number(15,3),            /*计算投入量或小时                       */
ecl07       number(15,3),            /*计算产出量或小时                       */
ecl08       varchar2(1),             /*控制时间                               */
eclacti     varchar2(1),             /*资料有效码                             */
ecluser     varchar2(10),            /*资料所有者                             */
eclgrup     varchar2(10),            /*资料所有群                             */
eclmodu     varchar2(10),            /*资料更改者                             */
ecldate     date,                    /*最近更改日                             */
eclorig     varchar2(10),            /*资料建立部门                           */
ecloriu     varchar2(10)             /*资料建立者                             */
);

alter table ecl_file add  constraint ecl_pk primary key  (ecl01,ecl02,ecl03) enable validate;
grant select on ecl_file to tiptopgp;
grant update on ecl_file to tiptopgp;
grant delete on ecl_file to tiptopgp;
grant insert on ecl_file to tiptopgp;
grant index on ecl_file to public;
grant select on ecl_file to ods;
