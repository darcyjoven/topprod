/*
================================================================================
檔案代號:shh_file
檔案名稱:质量异常处理记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shh_file
(
shh01       varchar2(20) NOT NULL,   /*登录单号                               */
                                     /*登錄單號                               */
shh02       date,                    /*登录日期                               */
                                     /*登錄日期                               */
shh021      varchar2(8),             /*开工时间                               */
                                     /*開工時間                               */
shh022      varchar2(10),            /*地点                                   */
                                     /*地點                                   */
shh03       varchar2(20),            /*工单编号                               */
                                     /*工單編號                               */
shh031      varchar2(23),            /*Run Card                               */
shh04       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
shh05       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
shh06       number(5),               /*工艺序                                 */
                                     /*製程序                                 */
shh061      varchar2(10),            /*留置码                                 */
                                     /*留置碼                                 */
shh07       varchar2(10),            /*机台编号                               */
                                     /*機台編號                               */
shh08       varchar2(1),             /*类型                                   */
                                     /*型態                                   */
                                     /* 1.Check in 留置取消                   */
                                     /* 2.Check out留置取消                   */
shh10       varchar2(10),            /*提出部门                               */
                                     /*提出部門                               */
shh101      varchar2(10),            /*提出人员                               */
                                     /*提出人員                               */
shh111      varchar2(80),            /*异常说明                               */
                                     /*異常說明                               */
shh112      varchar2(80),            /*异常说明                               */
                                     /*異常說明                               */
shh113      varchar2(80),            /*异常说明                               */
                                     /*異常說明                               */
shh12       varchar2(10),            /*初步责任判定                           */
                                     /*初步責任判定                           */
shh121      varchar2(10),            /*责任判定人员                           */
                                     /*責任判定人員                           */
shh131      varchar2(80),            /*责任判定说明                           */
                                     /*責任判定說明                           */
shh132      varchar2(80),            /*责任判定说明                           */
                                     /*責任判定說明                           */
shh14       varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N/X)                         */
shh141      varchar2(10),            /*审核人员                               */
                                     /*確認人員                               */
shh142      date,                    /*审核日期                               */
                                     /*確認日期                               */
shh143      varchar2(8),             /*审核时间                               */
                                     /*確認時間                               */
shh151      varchar2(80),            /*追踪审核说明                           */
                                     /*追蹤確認說明                           */
shh152      varchar2(80),            /*追踪审核说明                           */
                                     /*追蹤確認說明                           */
shh161      varchar2(80),            /*暂时对策                               */
                                     /*暫時對策                               */
shh162      varchar2(80),            /*暂时对策                               */
                                     /*暫時對策                               */
shh163      varchar2(80),            /*暂时对策                               */
                                     /*暫時對策                               */
shh164      varchar2(80),            /*暂时对策                               */
                                     /*暫時對策                               */
shh165      varchar2(80),            /*暂时对策                               */
                                     /*暫時對策                               */
shh171      varchar2(80),            /*防止对策                               */
                                     /*防止對策                               */
shh172      varchar2(80),            /*防止对策                               */
                                     /*防止對策                               */
shh173      varchar2(80),            /*防止对策                               */
                                     /*防止對策                               */
shh174      varchar2(80),            /*防止对策                               */
                                     /*防止對策                               */
shh175      varchar2(80),            /*防止对策                               */
                                     /*防止對策                               */
shbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
shhuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
shhgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
shhmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
shhdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
shhud01     varchar2(255),           /*自订字段-Textedit                      */
shhud02     varchar2(40),            /*自订字段-文字                          */
shhud03     varchar2(40),            /*自订字段-文字                          */
shhud04     varchar2(40),            /*自订字段-文字                          */
shhud05     varchar2(40),            /*自订字段-文字                          */
shhud06     varchar2(40),            /*自订字段-文字                          */
shhud07     number(15,3),            /*自订字段-数值                          */
shhud08     number(15,3),            /*自订字段-数值                          */
shhud09     number(15,3),            /*自订字段-数值                          */
shhud10     number(10),              /*自订字段-整数                          */
shhud11     number(10),              /*自订字段-整数                          */
shhud12     number(10),              /*自订字段-整数                          */
shhud13     date,                    /*自订字段-日期                          */
shhud14     date,                    /*自订字段-日期                          */
shhud15     date,                    /*自订字段-日期                          */
shhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
shhoriu     varchar2(10),            /*资料建立者                             */
shhorig     varchar2(10),            /*资料建立部门                           */
shh012      varchar2(10)             /*工艺段号                               */
);

alter table shh_file add  constraint shh_pk primary key  (shh01) enable validate;
grant select on shh_file to tiptopgp;
grant update on shh_file to tiptopgp;
grant delete on shh_file to tiptopgp;
grant insert on shh_file to tiptopgp;
grant index on shh_file to public;
grant select on shh_file to ods;
