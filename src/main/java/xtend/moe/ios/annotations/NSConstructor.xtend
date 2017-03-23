package xtend.moe.ios.annotations

import java.lang.annotation.Target
import org.eclipse.xtend.lib.macro.AbstractMethodProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableMethodDeclaration
import org.eclipse.xtend.lib.macro.declaration.Visibility

/**
 * Transforms a normal method into an NSObject constructor.
 * To work, your class must be annotated with Alloc and Init
 * <p>
 * It performs these steps:
 * <p>
 * - renames and makes private your method<br>
 * - adds a method with the same name, but static<br>
 * - the new method uses Alloc and Init to create a new instance<br>
 * - the new method calls your method to modify the instance<br>
 * - the new method then returns the new isntance<br>
 */
@Target(METHOD)
@Active(NSConstructorProcessor)
annotation NSConstructor {
	
}

class NSConstructorProcessor extends AbstractMethodProcessor {

	override doTransform(MutableMethodDeclaration originalMethod, extension TransformationContext context) {
		
		val newOriginalMethodName = '__' + originalMethod.simpleName
		val cls = originalMethod.declaringType 
		cls.addMethod(originalMethod.simpleName) [
			visibility = Visibility.PUBLIC
			static = true
			for(parameter : originalMethod.parameters) {
				addParameter(parameter.simpleName, parameter.type)
			}
			for(type : originalMethod.typeParameters) {
				addTypeParameter(type.simpleName)
			}
			returnType = cls.newTypeReference
			body = '''
				final «originalMethod.declaringType» instance = «originalMethod.declaringType».alloc().init();
				instance.«newOriginalMethodName»(«FOR parameter : originalMethod.parameters SEPARATOR ','»«parameter.simpleName»«ENDFOR»);
				return instance;
			'''
		]

		originalMethod => [
			simpleName = newOriginalMethodName
			visibility = Visibility.PROTECTED
		] 

		
	}	
	
}
