/*
================================================================================
檔案代號:vlj_file
檔案名稱:APS平行加工資料檔
檔案目的:建立平行加工資料
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vlj_file
(
vlj01       varchar2(20) NOT NULL,   /*工单编号                               */
vlj02       number(1) NOT NULL,      /*资源类型                               */
vlj03       number(5) NOT NULL,      /*工艺序号                               */
vlj05       number(5) NOT NULL,      /*项次                                   */
vlj06       varchar2(10),            /*资源编号                               */
vlj13       number(15,3),            /*NO USE                                 */
vlj14       number(15,3),            /*NO USE                                 */
vlj15       number(15,3),            /*NO USE                                 */
vlj16       number(15,3),            /*NO USE                                 */
vlj25       varchar2(5),             /*开工时间                               */
vlj26       varchar2(5),             /*完工时间                               */
vlj301      number(15,3),            /*NO USE                                 */
vlj302      number(15,3),            /*NO USE                                 */
vlj303      number(15,3),            /*NO USE                                 */
vlj311      number(15,3),            /*-良品转出                              */
vlj312      number(15,3),            /*-返工转出                              */
vlj313      number(15,3),            /*-当站报废                              */
vlj314      number(15,3),            /*-当站下线                              */
vlj315      number(15,3),            /*bonus                                  */
vlj316      number(15,3),            /*-工单转出                              */
vlj49       number(15,3),            /*NO USE                                 */
vlj50       date,                    /*预计开工日                             */
vlj51       date,                    /*预计完工日                             */
vljacti     varchar2(1),             /*资料有效码                             */
vljdate     date,                    /*最近更改日                             */
vljgrup     varchar2(10),            /*资料所有群                             */
vljmodu     varchar2(10),            /*资料更改者                             */
vljuser     varchar2(10),            /*资料所有者                             */
vljoriu     varchar2(10),            /*资料建立者                             */
vljorig     varchar2(10)             /*资料建立部门                           */
);

alter table vlj_file add  constraint vlj_pk primary key  (vlj01,vlj02,vlj03,vlj05) enable validate;
grant select on vlj_file to tiptopgp;
grant update on vlj_file to tiptopgp;
grant delete on vlj_file to tiptopgp;
grant insert on vlj_file to tiptopgp;
grant index on vlj_file to public;
grant select on vlj_file to ods;
