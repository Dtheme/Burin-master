(function(exports){

    //当前调试的APP的bundle ID
    lookUpBundleId = [NSBundle mainBundle].bundleIdentifier;

    // 沙盒路径
	lookUpMainBundlePath = [NSBundle mainBundle].bundlePath;

	// 沙盒 document 
	lookUpDocumentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];

	// 沙盒 caches 
	lookUpCachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]; 

    //调试用的颜色
    redColor = function(){
        return [UIColor redColor];
    }

    blackColor = function(){
        return [UIColor blackColor];
    }

    whiteColor = (){
        return [UIColor whiteColor];
    }
    
    //隐藏显示 willhidden传 YES/NO （oc语法）
    hiddenOrNot = function(view,willHidden){
        return view.hidden = willHidden;
    }

    // CGPoint、CGRect
	CGPointMake = function(x, y) { 
		return {0 : x, 1 : y}; 
	};

	CGSizeMake = function(w, h) { 
		return {0 : w, 1 : h}; 
	};

	CGRectMake = function(x, y, w, h) { 
		return {0 : CGPointMake(x, y), 1 : CGSizeMake(w, h)}; 
    };
    
	// 根控制器
    lookUpKeyWindow = function() {
		return UIApp.keyWindow;
    };
    
	// 当前显示的控制器
	var _FrontVc = function(vc) {
		if (vc.presentedViewController) {
        	return _FrontVc(vc.presentedViewController);
	    }else if ([vc isKindOfClass:[UITabBarController class]]) {
	        return _FrontVc(vc.selectedViewController);
	    } else if ([vc isKindOfClass:[UINavigationController class]]) {
	        return _FrontVc(vc.visibleViewController);
	    } else {
	    	var count = vc.childViewControllers.count;
    		for (var i = count - 1; i >= 0; i--) {
    			var childVc = vc.childViewControllers[i];
    			if (childVc && childVc.view.window) {
    				vc = _FrontVc(childVc);
    				break;
    			}
    		}
	        return vc;
    	}
    };
    lookUpFrontVc = function() {
		return _FrontVc(UIApp.keyWindow.rootViewController);
    };
   
    //控制器层级结构
    lookupVCSubviews = function(vc) { 
		if (![vc isKindOfClass:[UIViewController class]]) throw new Error(invalidParamStr);
		return vc.view.recursiveDescription().toString(); 
    };
    
    //view的层级结构
	lookupViewSubviews = function(view) { 
		if (![view isKindOfClass:[UIView class]]) throw new Error(invalidParamStr);
		return view.recursiveDescription().toString(); 
    };
    
    var ClassInfo = function(className) {
		if (!className) throw new Error(missingParamStr);
		if (MJIsString(className)) {
			return NSClassFromString(className);
		} 
		if (!className) throw new Error(invalidParamStr);
		// 对象或者类
		return className.class();
	};

	// 打印所有的子类
	lookUpSubclasses = function(className, reg) {
		className = ClassInfo(className);

		return [c for each (c in ObjectiveC.classes) 
		if (c != className 
			&& class_getSuperclass(c) 
			&& [c isSubclassOfClass:className] 
			&& (!reg || reg.test(c)))
			];
	};

	// 打印所有的方法
	var GetMethods = function(className, reg, clazz) {
		className = ClassInfo(className);

		var count = new new Type('I');
		var classObj = clazz ? className.constructor : className;
		var methodList = class_copyMethodList(classObj, count);
		var methodsArray = [];
		var methodNamesArray = [];
		for(var i = 0; i < *count; i++) {
			var method = methodList[i];
			var selector = method_getName(method);
			var name = sel_getName(selector);
			if (reg && !reg.test(name)) continue;
			methodsArray.push({
				selector : selector, 
				type : method_getTypeEncoding(method)
			});
			methodNamesArray.push(name);
		}
		free(methodList);
		return [methodsArray, methodNamesArray];
	};

	var MethodsInfo = function(className, reg, clazz) {
		return GetMethods(className, reg, clazz)[0];
	};

	// 查询方法名
	var getMethodNames = function(className, reg, clazz) {
		return GetMethods(className, reg, clazz)[1];
	};

	// 查询实例方法信息
	lookUpInstanceMethods = function(className, reg) {
		return MethodsInfo(className, reg);
	};

	// 查询实例方法名字
	lookUpInstanceMethodNames = function(className, reg) {
		return getMethodNames(className, reg);
	};

	// 打印所有的类方法
	lookUpClassMethods = function(className, reg) {
		return MethodsInfo(className, reg, true);
	};

	// 打印所有的类方法名字
	lookUpClassMethodNames = function(className, reg) {
		return getMethodNames(className, reg, true);
	};

	// 打印所有的成员变量
	lookUpIvars = function(obj, reg){ 
		if (!obj) throw new Error(missingParamStr);
		var x = {}; 
		for(var i in *obj) { 
			try { 
				var value = (*obj)[i];
				if (reg && !reg.test(i) && !reg.test(value)) continue;
				x[i] = value; 
			} catch(e){} 
		} 
		return x; 
	};

	// 打印所有的成员变量名字
	lookUpIvarNames = function(obj, reg) {
		if (!obj) throw new Error(missingParamStr);
		var array = [];
		for(var name in *obj) { 
			if (reg && !reg.test(name)) continue;
			array.push(name);
		}
		return array;
	};
})(exports);