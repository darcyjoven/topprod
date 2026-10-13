/*
================================================================================
檔案代號:shr_file
檔案名稱:RUN CARD合并资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shr_file
(
shr01       varchar2(20) NOT NULL,   /*合并单号                               */
                                     /*合併單號                               */
shr02       date,                    /*合并日期                               */
                                     /*合併日期                               */
shr03       varchar2(23),            /*Run Card(母批)                         */
shr04       number(5),               /*工艺顺序                               */
                                     /*製程順序                               */
shr05       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
shr06       number(15,3),            /*WIP 数量                               */
                                     /*WIP 數量                               */
shr07       varchar2(10),            /*员工编号                               */
                                     /*員工編號                               */
shr09       varchar2(1),             /*WIP数量                                */
shr10       varchar2(1),             /*No Use                                 */
shrconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
shrtime     varchar2(5),             /*分割时间                               */
                                     /*分割時間                               */
shracti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
shruser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
shrgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
shrmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
shrdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
shrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shrlegal    varchar2(10) NOT NULL,   /*所属法人                               */
shroriu     varchar2(10),            /*资料建立者                             */
shrorig     varchar2(10),            /*资料建立部门                           */
shr012      varchar2(10)             /*工艺段号                               */
);

create        index shr_02 on shr_file (shr03);
alter table shr_file add  constraint shr_pk primary key  (shr01) enable validate;
grant select on shr_file to tiptopgp;
grant update on shr_file to tiptopgp;
grant delete on shr_file to tiptopgp;
grant insert on shr_file to tiptopgp;
grant index on shr_file to public;
grant select on shr_file to ods;
