/*
================================================================================
檔案代號:gep_file
檔案名稱:自定义公式单头档
檔案目的:记录系统自定义公式内容
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gep_file
(
gep01       varchar2(20) NOT NULL,   /*公式编号                               */
gep02       varchar2(80),            /*公式名称                               */
gep03       varchar2(1),             /*审核否(y/n)                            */
gep04       date,                    /*审核日期                               */
gep05       varchar2(4000),          /*公式内容                               */
                                     /*Store The String Make Up Of Variable Name*/
gep06       varchar2(4000),          /*公式说明                               */
                                     /*Store The String Make Up Of Variable Corresponding Chinese Name*/
gep07       varchar2(10),            /*公式分类码                             */
gep08       varchar2(1),             /*No Use                                 */
gep09       varchar2(4),             /*No Use                                 */
gep10       varchar2(4),             /*No Use                                 */
gepacti     varchar2(1),             /*资料有效码                             */
                                     /*System Maintain                        */
gepuser     varchar2(10),            /*资料所有者                             */
                                     /*System Maintain                        */
gepgrup     varchar2(10),            /*资料所有群                             */
                                     /*System Maintain                        */
gepmodu     varchar2(10),            /*资料更改者                             */
                                     /*System Maintain                        */
gepdate     date,                    /*最近更改日                             */
                                     /*System Maintain                        */
gep11       varchar2(2000),          /*BOM辅助项                              */
geporig     varchar2(10),            /*资料建立部门                           */
geporiu     varchar2(10)             /*资料建立者                             */
);

alter table gep_file add  constraint gep_pk primary key  (gep01) enable validate;
grant select on gep_file to tiptopgp;
grant update on gep_file to tiptopgp;
grant delete on gep_file to tiptopgp;
grant insert on gep_file to tiptopgp;
grant index on gep_file to public;
grant select on gep_file to ods;
